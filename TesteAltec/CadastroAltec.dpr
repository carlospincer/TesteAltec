program CadastroAltec;

uses
  Vcl.Forms,
  uFrmCadastro in 'uFrmCadastro.pas' {frmCadastro},
  uEndereco in 'uEndereco.pas',
  uPessoa in 'uPessoa.pas',
  uFrmEnvioEmail in 'uFrmEnvioEmail.pas' {frmEnvioEmail};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCadastro, frmCadastro);
  Application.Run;
end.
