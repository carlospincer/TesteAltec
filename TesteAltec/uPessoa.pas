unit uPessoa;

interface

uses uEndereco, IdHTTP, IdSSLOpenSSL, RTTI, XMLDoc;

type

  TPessoa = class
  private
    FEmail: string;
    FCPF: string;
    FIdentidade: string;
    FNome: string;
    FTelefone: string;
    FEndereco: TEndereco;
    function GetEndereco: TEndereco;
  public
    procedure SaveToXML;
    procedure AddItemXML(AClass: TObject; AXML: TXMLDocument);
    function LoadEndereco(const ACep: string): boolean;
    destructor destroy;
    [TDescricao('Nome')]
    property Nome: string read FNome write FNome;
    [TDescricao('Identidade')]
    property Identidade: string read FIdentidade write FIdentidade;
    [TDescricao('CPF')]
    property CPF: string read FCPF write FCPF;
    [TDescricao('Telefone')]
    property Telefone: string read FTelefone write FTelefone;
    [TDescricao('Email')]
    property Email: string read FEmail write FEmail;

    property Endereco: TEndereco read GetEndereco;
  end;

implementation

uses System.Classes, REST.Json, System.SysUtils;

{ TPessoa }

destructor TPessoa.destroy;
begin
  if Assigned(FEndereco) then
    FEndereco.Free;
end;

function TPessoa.GetEndereco: TEndereco;
begin
  if FEndereco = nil then
    FEndereco := TEndereco.Create;
  Result := FEndereco;
end;

function TPessoa.LoadEndereco(const ACep: string): boolean;
var
  LResponse: TStringStream;
  LIdHTTP: TIdHTTP;
  LIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := false;
  LResponse := TStringStream.Create;
  LIdHTTP := TIdHTTP.Create;
  LIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create;
  LIdHTTP.IOHandler := LIdSSLIOHandlerSocketOpenSSL;
  try
    try
      LIdHTTP.Get('https://viacep.com.br/ws/' + ACep.Replace('-', '').Trim + '/json', LResponse);
    except
      on e: exception do
        Result := false;
    end;
    if (LIdHTTP.ResponseCode = 200) and (not(LResponse.DataString).Equals('{'#$A'  "erro": true'#$A'}')) then
    begin
      FEndereco := TJson.JsonToObject<TEndereco>(UTF8ToString(PAnsiChar(AnsiString(LResponse.DataString))));
      Result := True;
    end;

  finally
    LResponse.Free;
    LIdSSLIOHandlerSocketOpenSSL.Free;
    LIdHTTP.Free;
  end;
end;

procedure TPessoa.AddItemXML(AClass: TObject; AXML: TXMLDocument);
var
  lRtti: TRttiContext;
  typeRtti: TRttiType;
  propRtti: TRttiProperty;
  Atributo: TCustomAttribute;
begin
  lRtti := TRttiContext.Create;
  try
    typeRtti := lRtti.GetType(AClass.ClassType);

    for propRtti in typeRtti.GetProperties do
    begin
      if propRtti.GetValue(AClass).IsObject then
        AddItemXML(propRtti.GetValue(AClass).AsObject, AXML);

      for Atributo in propRtti.GetAttributes do
        AXML.ChildNodes[0].AddChild(TDescricao(Atributo).Descricao).NodeValue := propRtti.GetValue(AClass).AsString;

    end;

  finally
    lRtti.Free;
  end;
end;

procedure TPessoa.SaveToXML;
var
  XMLEnvio: TXMLDocument;
  Atributo: TCustomAttribute;
  I: Integer;
begin
  try
    XMLEnvio := TXMLDocument.Create(nil);
    XMLEnvio.Active := True;
    XMLEnvio.AddChild('cliente');
    AddItemXML(Self, XMLEnvio);
    XMLEnvio.SaveToFile('cliente.xml');
  finally
    XMLEnvio.Free;
  end;
end;

end.
