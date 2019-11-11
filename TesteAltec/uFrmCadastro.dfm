object frmCadastro: TfrmCadastro
  Left = 0
  Top = 0
  Caption = 'Cadastro Cliente'
  ClientHeight = 341
  ClientWidth = 558
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 558
    Height = 341
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Dados'
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 544
        Height = 270
        Align = alClient
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 13
          Width = 27
          Height = 13
          Caption = 'Nome'
        end
        object Label2: TLabel
          Left = 424
          Top = 13
          Width = 52
          Height = 13
          Caption = 'Identidade'
        end
        object Label3: TLabel
          Left = 16
          Top = 59
          Width = 19
          Height = 13
          Caption = 'CPF'
        end
        object Label4: TLabel
          Left = 151
          Top = 59
          Width = 42
          Height = 13
          Caption = 'Telefone'
        end
        object Label5: TLabel
          Left = 263
          Top = 59
          Width = 28
          Height = 13
          Caption = 'E-mail'
        end
        object Label6: TLabel
          Left = 16
          Top = 109
          Width = 19
          Height = 13
          Caption = 'Cep'
        end
        object Label7: TLabel
          Left = 87
          Top = 109
          Width = 55
          Height = 13
          Caption = 'Logradouro'
        end
        object Label8: TLabel
          Left = 456
          Top = 109
          Width = 37
          Height = 13
          Caption = 'N'#250'mero'
        end
        object Label9: TLabel
          Left = 16
          Top = 159
          Width = 65
          Height = 13
          Caption = 'Complemento'
        end
        object Label10: TLabel
          Left = 151
          Top = 162
          Width = 28
          Height = 13
          Caption = 'Bairro'
        end
        object Label11: TLabel
          Left = 16
          Top = 207
          Width = 33
          Height = 13
          Caption = 'Cidade'
        end
        object Label12: TLabel
          Left = 311
          Top = 205
          Width = 33
          Height = 13
          Caption = 'Estado'
        end
        object Label13: TLabel
          Left = 350
          Top = 205
          Width = 19
          Height = 13
          Caption = 'Pais'
        end
        object edtNome: TEdit
          Left = 16
          Top = 32
          Width = 402
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'Nome'
          TabOrder = 0
        end
        object edtIdentidade: TEdit
          Left = 424
          Top = 32
          Width = 97
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'Identidade'
          TabOrder = 1
        end
        object edtEmail: TEdit
          Left = 258
          Top = 78
          Width = 258
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'Email'
          CharCase = ecLowerCase
          TabOrder = 4
        end
        object edtLougradrouro: TEdit
          Left = 87
          Top = 128
          Width = 363
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'Logradouro'
          TabOrder = 6
        end
        object edtNumero: TEdit
          Left = 456
          Top = 128
          Width = 65
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'Numero'
          TabOrder = 7
        end
        object edtComplemento: TEdit
          Left = 16
          Top = 178
          Width = 129
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'Complemento'
          TabOrder = 8
        end
        object edtBairro: TEdit
          Left = 151
          Top = 178
          Width = 370
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'Bairro'
          TabOrder = 9
        end
        object edtCidade: TEdit
          Left = 16
          Top = 226
          Width = 289
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'Localidade'
          TabOrder = 10
        end
        object edtEstado: TEdit
          Left = 311
          Top = 226
          Width = 33
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'UF'
          TabOrder = 11
        end
        object edtPais: TEdit
          Left = 350
          Top = 226
          Width = 171
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'Pais'
          TabOrder = 12
        end
        object edtCep: TMaskEdit
          Left = 16
          Top = 128
          Width = 59
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'CEP'
          EditMask = '99999\-999;1;_'
          MaxLength = 9
          TabOrder = 5
          Text = '     -   '
          OnExit = edtCepExit
        end
        object edtCPF: TMaskEdit
          Left = 16
          Top = 78
          Width = 123
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'CPF'
          EditMask = '999\.999\.999\-99;1;_'
          MaxLength = 14
          TabOrder = 2
          Text = '   .   .   -  '
          OnExit = edtCepExit
        end
        object edtTelefone: TMaskEdit
          Left = 149
          Top = 78
          Width = 99
          Height = 21
          HelpType = htKeyword
          HelpKeyword = 'Telefone'
          EditMask = '!\(99\)9999-9999;1;_'
          MaxLength = 13
          TabOrder = 3
          Text = '(  )    -    '
          OnExit = edtCepExit
        end
      end
      object TPanel
        AlignWithMargins = True
        Left = 3
        Top = 276
        Width = 544
        Height = 34
        Margins.Top = 0
        Align = alBottom
        TabOrder = 1
        object btnClean: TButton
          Left = 375
          Top = 3
          Width = 75
          Height = 25
          Caption = 'Novo'
          TabOrder = 0
          OnClick = btnCleanClick
        end
        object btnSalvar: TButton
          Left = 456
          Top = 3
          Width = 75
          Height = 25
          Caption = 'Salvar'
          TabOrder = 1
          OnClick = btnSalvarClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Config. Email'
      ImageIndex = 1
      object Panel2: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 544
        Height = 270
        Align = alClient
        TabOrder = 0
        object Label14: TLabel
          Left = 8
          Top = 40
          Width = 24
          Height = 13
          Caption = 'Email'
        end
        object Label15: TLabel
          Left = 8
          Top = 88
          Width = 69
          Height = 13
          Caption = 'Servidor SMTP'
        end
        object Label16: TLabel
          Left = 240
          Top = 88
          Width = 26
          Height = 13
          Caption = 'Porta'
        end
        object Label17: TLabel
          Left = 8
          Top = 130
          Width = 36
          Height = 13
          Caption = 'Usu'#225'rio'
        end
        object Label18: TLabel
          Left = 183
          Top = 129
          Width = 30
          Height = 13
          Caption = 'Senha'
        end
        object ckbTipo: TCheckBox
          Left = 8
          Top = 14
          Width = 145
          Height = 17
          Caption = 'Envio pelo Outlook'
          TabOrder = 0
        end
        object edtFrom: TEdit
          Left = 8
          Top = 59
          Width = 289
          Height = 21
          TabOrder = 1
        end
        object edtHost: TEdit
          Left = 8
          Top = 104
          Width = 217
          Height = 21
          TabOrder = 2
        end
        object edtPort: TEdit
          Left = 240
          Top = 104
          Width = 57
          Height = 21
          TabOrder = 3
        end
        object edtUser: TEdit
          Left = 8
          Top = 146
          Width = 169
          Height = 21
          TabOrder = 4
        end
        object edtPassword: TEdit
          Left = 183
          Top = 146
          Width = 114
          Height = 21
          PasswordChar = '*'
          TabOrder = 5
        end
      end
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 276
        Width = 544
        Height = 34
        Margins.Top = 0
        Align = alBottom
        TabOrder = 1
        object Salvar: TButton
          Left = 456
          Top = 3
          Width = 75
          Height = 25
          Caption = 'Salvar'
          TabOrder = 0
          OnClick = SalvarClick
        end
      end
    end
  end
end
