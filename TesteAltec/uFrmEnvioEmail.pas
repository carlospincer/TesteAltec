unit uFrmEnvioEmail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Mapi,
  IdMessage, IdText, IdSSLOpenSSL, IdAttachmentFile, IdBaseComponent, IniFiles,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTP;

type
  TfrmEnvioEmail = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnEnviar: TButton;
    edtDest: TEdit;
    Label1: TLabel;
    procedure btnEnviarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FOutlook: Boolean;
    FAnexo: String;
  public
    { Public declarations }
    procedure SendEmailOutlook(AAnexo, ADestino: string);
    function SendEmailConf(AAnexo, ADestino: string): Boolean;
  end;

procedure SendEmail(AAnexo: String; AOutlook: Boolean);

var
  frmEnvioEmail: TfrmEnvioEmail;

implementation

{$R *.dfm}

procedure SendEmail(AAnexo: String; AOutlook: Boolean);
begin
  Application.CreateForm(TfrmEnvioEmail, frmEnvioEmail);
  try
    frmEnvioEmail.FOutlook := AOutlook;
    frmEnvioEmail.FAnexo := AAnexo;
    frmEnvioEmail.ShowModal;
  finally
    FreeAndNil(frmEnvioEmail);
  end;
end;

procedure TfrmEnvioEmail.SendEmailOutlook(AAnexo, ADestino: string);
type
  TMapiFileDescArray = array [0 .. 0] of TMapiFileDesc;
  PMapiFileDescArray = ^TMapiFileDescArray;

  TMapiRecipArray = array [0 .. 0] of TMapiRecipDesc;
  PMapiRecipArray = ^TMapiRecipArray;

const
  MAPI_ERROR: array [0 .. 26] of string = ('Successo', 'Abortado pelo usuário', 'Erro Mapi',
    'Falha de login', 'Disco cheio', 'Memória Insuficiente', 'Access denied', 'Undocumented',
    'To many sessions', 'To many files', 'To many recipients', 'Attachment not found',
    'Attachement open error', 'Attachement write error', 'Unknown recipient',
    'Illegal recipient type', 'No Message error', 'Invalid Message', 'Text to large',
    'Invalid session', 'type not supported', 'Ambiguos recipient', 'Message in use',
    'Mapi Network error', 'Invalid edit fields', 'Invalid recipient', 'not supported');
var
  MAPIMessage: TMAPIMessage;
  pRecips: PMapiRecipArray;
  pMapiFiles: PMapiFileDescArray;
  MError: Integer;
begin
  FillChar(MAPIMessage, sizeof(MAPIMessage), 0);

  GetMem(pRecips, sizeof(TMapiRecipDesc));
  FillChar(pRecips^, sizeof(TMapiRecipDesc), 0);

  pRecips^[0].ulReserved := 0;
  pRecips^[0].ulRecipClass := MAPI_TO;
  pRecips^[0].lpszAddress := PAnsiChar(AnsiString(ADestino));
  pRecips^[0].lpszName := PAnsiChar(AnsiString(ADestino));
  pRecips^[0].ulEIDSize := 0;
  pRecips^[0].lpEntryID := nil;

  GetMem(pMapiFiles, sizeof(TMapiFileDesc));
  FillChar(pMapiFiles^, sizeof(TMapiFileDesc), 0);
  pMapiFiles^[0].lpszPathName := PAnsiChar(AnsiString(AAnexo));
  pMapiFiles^[0].nPosition := Cardinal(-1);

  MAPIMessage.ulReserved := 0;
  MAPIMessage.lpszSubject := 'Email de cadastro de cliente da Altec';
  MAPIMessage.lpszNoteText := 'Email de cadastro de cliente da Altec';
  MAPIMessage.lpszMessageType := nil;
  MAPIMessage.lpszDateReceived := nil;
  MAPIMessage.lpszConversationID := nil;
  MAPIMessage.flFlags := 0;
  MAPIMessage.lpOriginator := nil;
  MAPIMessage.nRecipCount := 1;
  MAPIMessage.lpRecips := @pRecips^;
  MAPIMessage.nFileCount := 1;
  if (MAPIMessage.nFileCount > 0) then
    MAPIMessage.lpFiles := @pMapiFiles^
  else
    MAPIMessage.lpFiles := nil;

  MError := 0;
  try
    MError := MapiSendMail(0, Application.Handle, MAPIMessage, MAPI_DIALOG or MAPI_LOGON_UI or MAPI_NEW_SESSION, 0);
  finally
    if (MError <> SUCCESS_SUCCESS) and (MError <> MAPI_E_USER_ABORT) then
      MessageDlg(Format('Erro enviando e-mail: #%d, %s', [MError, MAPI_ERROR[MError]]), mtError, [mbOK], 0);

    FreeMem(pRecips, sizeof(TMapiRecipDesc));
    FreeMem(pMapiFiles, sizeof(TMapiFileDesc));
  end;
end;

procedure TfrmEnvioEmail.btnEnviarClick(Sender: TObject);
begin
  try
    if FOutlook then
      SendEmailOutlook(FAnexo, edtDest.Text)
    else
      SendEmailConf(FAnexo, edtDest.Text);
  finally
    Close;
  end;
end;

procedure TfrmEnvioEmail.FormShow(Sender: TObject);
begin
  edtDest.SetFocus;
end;

function TfrmEnvioEmail.SendEmailConf(AAnexo, ADestino: string): Boolean;
var
  IniFile: TIniFile;
  sFrom: String;
  sHost: String;
  iPort: Integer;
  sUserName: String;
  sPassword: String;

  idMsg: TIdMessage;
  IdText: TIdText;
  IdSMTP: TIdSMTP;
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    try
      IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
      sFrom := IniFile.ReadString('Email', 'From', sFrom);
      sHost := IniFile.ReadString('Email', 'Host', sHost);
      iPort := IniFile.ReadInteger('Email', 'Port', iPort);
      sUserName := IniFile.ReadString('Email', 'UserName', sUserName);
      sPassword := IniFile.ReadString('Email', 'Password', sPassword);

      IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
      IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
      IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

      // Variável referente a mensagem
      idMsg := TIdMessage.Create(Self);
      idMsg.CharSet := 'utf-8';
      idMsg.Encoding := meMIME;
      idMsg.From.Name := 'Teste Altec';
      idMsg.From.Address := sFrom;
      idMsg.Priority := mpNormal;
      idMsg.Subject := 'Email de cadastro de cliente da Altec';

      // Add Destinatário(s)
      idMsg.Recipients.Add;
      idMsg.Recipients.EMailAddresses := ADestino;

      // Variável do texto
      IdText := TIdText.Create(idMsg.MessageParts);
      IdText.Body.Add('Email de cadastro de cliente da Altec');
      IdText.ContentType := 'text/html; text/plain; charset=iso-8859-1';

      // Prepara o Servidor
      IdSMTP := TIdSMTP.Create(Self);
      IdSMTP.IOHandler := IdSSLIOHandlerSocket;
      IdSMTP.UseTLS := utUseImplicitTLS;
      IdSMTP.AuthType := satDefault;
      IdSMTP.Host := sHost;
      IdSMTP.AuthType := satDefault;
      IdSMTP.Port := iPort;
      IdSMTP.Username := sUserName;
      IdSMTP.Password := sPassword;

      // Conecta e Autentica
      IdSMTP.Connect;
      IdSMTP.Authenticate;

      if FileExists(AAnexo) then
        TIdAttachmentFile.Create(idMsg.MessageParts, AAnexo);

      // Se a conexão foi bem sucedida, envia a mensagem
      if IdSMTP.Connected then
      begin
        try
          IdSMTP.Send(idMsg);
        except
          on E: Exception do
          begin
            ShowMessage('Erro ao tentar enviar: ' + E.Message);
          end;
        end;
      end;

      // Depois de tudo pronto, desconecta do servidor SMTP
      if IdSMTP.Connected then
        IdSMTP.Disconnect;

      Result := True;
    finally
      IniFile.Free;

      UnLoadOpenSSLLibrary;

      FreeAndNil(idMsg);
      FreeAndNil(IdSSLIOHandlerSocket);
      FreeAndNil(IdSMTP);
    end;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;

end;

end.
