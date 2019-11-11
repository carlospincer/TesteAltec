object frmEnvioEmail: TfrmEnvioEmail
  Left = 0
  Top = 0
  Caption = 'Envio Email'
  ClientHeight = 129
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 85
    Width = 365
    Height = 41
    Margins.Top = 0
    Align = alBottom
    TabOrder = 0
    ExplicitLeft = 56
    ExplicitTop = 32
    ExplicitWidth = 185
    object btnEnviar: TButton
      Left = 281
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Enviar'
      TabOrder = 0
      OnClick = btnEnviarClick
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 365
    Height = 79
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 56
    ExplicitTop = 32
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Label1: TLabel
      Left = 16
      Top = 13
      Width = 85
      Height = 13
      Caption = 'Email Destinat'#225'rio'
    end
    object edtDest: TEdit
      Left = 16
      Top = 32
      Width = 329
      Height = 21
      TabOrder = 0
    end
  end
end
