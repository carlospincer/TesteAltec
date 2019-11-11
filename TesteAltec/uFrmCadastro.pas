unit uFrmCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, XMLDoc, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, uPessoa, Vcl.ComCtrls, Xml.xmldom,
  Xml.XmlTransform, IniFiles;

type
  TfrmCadastro = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edtNome: TEdit;
    edtIdentidade: TEdit;
    edtEmail: TEdit;
    edtLougradrouro: TEdit;
    edtNumero: TEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtEstado: TEdit;
    edtPais: TEdit;
    edtCep: TMaskEdit;
    edtCPF: TMaskEdit;
    edtTelefone: TMaskEdit;
    btnClean: TButton;
    Panel2: TPanel;
    btnSalvar: TButton;
    Panel3: TPanel;
    Salvar: TButton;
    ckbTipo: TCheckBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    edtFrom: TEdit;
    edtHost: TEdit;
    edtPort: TEdit;
    edtUser: TEdit;
    edtPassword: TEdit;
    procedure btnCleanClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtCepExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSalvarClick(Sender: TObject);
    procedure SalvarClick(Sender: TObject);
  private
    { Private declarations }
    FPessoa: TPessoa;
    IniFile: TIniFile;
    procedure MappObjToForm(AClass: TObject);
    procedure MappFormToObj(AClass: TObject);
    procedure OnClearForm;
    procedure LoadConfigIni;
  public
    { Public declarations }
  end;

var
  frmCadastro: TfrmCadastro;

implementation

uses REST.Json.Types, RTTI, uFrmEnvioEmail;

{$R *.dfm}

procedure TfrmCadastro.btnCleanClick(Sender: TObject);
begin
  OnClearForm;
  if Assigned(FPessoa) then
    FPessoa.Free;
  FPessoa := TPessoa.Create;
  edtPais.Text := 'Brasil';
  edtNome.SetFocus;
end;

procedure TfrmCadastro.btnSalvarClick(Sender: TObject);
begin
  try
    MappFormToObj(FPessoa);
    FPessoa.SaveToXML;
    if MessageDlg('Registro Salvo com Sucesso!' + #10#13 + 'Deseja enviar o registro por email?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      if (not ckbTipo.Checked) and (edtHost.Text = '') and (edtFrom.Text = '') then
      begin
        MessageDlg('Não existe configurações do servidor de email validas', mtWarning, [mbOK], 0);
        Exit;
      end;

      SendEmail(ExtractFilePath(ParamStr(0)) + 'cliente.xml', ckbTipo.Checked);
    end;

  except
    on E: Exception do
      MessageDlg('Erro ao salvar o Registro. Erro:' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmCadastro.SalvarClick(Sender: TObject);
begin
  IniFile.WriteString('Email', 'From', edtFrom.Text);
  IniFile.WriteString('Email', 'Host', edtHost.Text);
  IniFile.WriteInteger('Email', 'Port', StrToInt(edtPort.Text));
  IniFile.WriteString('Email', 'UserName', edtUser.Text);
  IniFile.WriteString('Email', 'Password', edtPassword.Text);
  IniFile.WriteBool('Email', 'Envio', ckbTipo.Checked);

  MessageDlg('Configurações salvas com sucesso', mtInformation, [mbOK], 0);
end;

procedure TfrmCadastro.edtCepExit(Sender: TObject);
begin
  if Length(trim(edtCep.Text)) = 9 then
  begin
    FPessoa.LoadEndereco(edtCep.Text);
    MappObjToForm(FPessoa.Endereco);
    edtPais.Text := 'Brasil';
  end;
end;

procedure TfrmCadastro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FPessoa) then
    FPessoa.Free;

  IniFile.Free;
end;

procedure TfrmCadastro.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    Perform(Wm_NextDlgCtl, 0, 0);
end;

procedure TfrmCadastro.FormShow(Sender: TObject);
begin
  FPessoa := TPessoa.Create;
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  LoadConfigIni;
end;

procedure TfrmCadastro.LoadConfigIni;
begin
  edtFrom.Text := IniFile.ReadString('Email', 'From', '');
  edtHost.Text := IniFile.ReadString('Email', 'Host', '');
  edtPort.Text := IntToStr(IniFile.ReadInteger('Email', 'Port', 465));
  edtUser.Text := IniFile.ReadString('Email', 'UserName', '');
  edtPassword.Text := IniFile.ReadString('Email', 'Password', '');
  ckbTipo.Checked :=  IniFile.ReadBool('Email', 'Envio', False);
end;

procedure TfrmCadastro.MappFormToObj(AClass: TObject);
var
  lRtti: TRttiContext;
  typeRtti: TRttiType;
  propRtti: TRttiProperty;
  I: Integer;
begin
  lRtti := TRttiContext.Create;
  try
    typeRtti := lRtti.GetType(AClass.ClassType);

    for propRtti in typeRtti.GetProperties do
    begin
      if propRtti.GetValue(AClass).IsObject then
        MappFormToObj(propRtti.GetValue(AClass).AsObject);

      for I := 0 to ComponentCount - 1 do
      begin
        if (Components[I] is TCustomEdit) and (propRtti.Name = TCustomEdit(Components[I]).HelpKeyword) then
        begin
          propRtti.SetValue(AClass, TCustomEdit(Components[I]).Text);
          Break;
        end;
      end;
    end;
  finally
    lRtti.Free;
  end;

end;

procedure TfrmCadastro.MappObjToForm(AClass: TObject);
var
  lRtti: TRttiContext;
  typeRtti: TRttiType;
  propRtti: TRttiProperty;
  I: Integer;
begin
  lRtti := TRttiContext.Create;
  try
    typeRtti := lRtti.GetType(AClass.ClassType);

    for propRtti in typeRtti.GetProperties do
    begin
      for I := 0 to ComponentCount - 1 do
      begin
        if (Components[I] is TCustomEdit) and
           (propRtti.Name <> 'CEP') and
           (propRtti.Name = TCustomEdit(Components[I]).HelpKeyword) then
        begin
          TCustomEdit(Components[I]).Text := propRtti.GetValue(AClass).AsString;
          Break;
        end;
      end;
    end;
  finally
    lRtti.Free;
  end;
end;

procedure TfrmCadastro.OnClearForm;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if (Components[I] is TCustomEdit) then
      TCustomEdit(Components[I]).Clear;
  end;

end;

end.
