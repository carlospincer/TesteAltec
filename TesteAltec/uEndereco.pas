unit uEndereco;

interface

type

  TDescricao = class(TCustomAttribute)
  private
    FDescricao: string;
  public
    constructor Create(const Descricao: string);
    property Descricao: string read FDescricao;
  end;

  TEndereco = class
  private
    FLogradouro: string;
    FIBGE: string;
    FBairro: string;
    FUF: string;
    FCEP: string;
    FLocalidade: string;
    FUnidade: string;
    FComplemento: string;
    FGia: string;
    FNumero: string;
    FPais: string;
  public
    [TDescricao('CEP')]
    property CEP: string read FCEP write FCEP;
    [TDescricao('Logradouro')]
    property Logradouro: string read FLogradouro write FLogradouro;
    [TDescricao('Número')]
    property Numero: string read FNumero write FNumero;
    [TDescricao('Complemento')]
    property Complemento: string read FComplemento write FComplemento;
    [TDescricao('Bairro')]
    property Bairro: string read FBairro write FBairro;
    [TDescricao('Cidade')]
    property Localidade: string read FLocalidade write FLocalidade;
    [TDescricao('Estado')]
    property UF: string read FUF write FUF;
    [TDescricao('Pais')]
    property Pais: string read FPais write FPais;
    property Unidade: string read FUnidade write FUnidade;
    property IBGE: string read FIBGE write FIBGE;
    property Gia: string read FGia write FGia;
  end;

implementation

{ TDescricao }

constructor TDescricao.Create(const Descricao: string);
begin
  FDescricao := Descricao;
end;

end.
