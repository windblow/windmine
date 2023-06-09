object fmSobre: TfmSobre
  Left = 296
  Top = 230
  BorderStyle = bsSingle
  Caption = 'Windmine v. 1.00'
  ClientHeight = 173
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poMainFormCenter
  OnCreate = CarregaImagem
  TextHeight = 13
  object imSmiley: TImage
    Left = 8
    Top = 32
    Width = 105
    Height = 105
    Proportional = True
    Stretch = True
    Transparent = True
  end
  object lbSobreTitulo: TLabel
    Left = 104
    Top = 8
    Width = 80
    Height = 13
    Caption = 'Windmine v 1.00'
  end
  object lbNomeAluno: TLabel
    Left = 128
    Top = 72
    Width = 158
    Height = 13
    Caption = 'Author: Rafael Pagani Savastano'
  end
  object lbNomeProf: TLabel
    Left = 128
    Top = 96
    Width = 134
    Height = 13
    Caption = 'Developed in 2003 @ UFRJ'
  end
  object lbNomeTrab: TLabel
    Left = 128
    Top = 48
    Width = 128
    Height = 13
    Caption = 'Classic Minesweeper clone'
  end
  object btOK: TButton
    Left = 240
    Top = 144
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = btOKClick
  end
end
