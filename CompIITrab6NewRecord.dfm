object fmNewRecord: TfmNewRecord
  Left = 271
  Top = 198
  BorderStyle = bsSingle
  Caption = 'New record!'
  ClientHeight = 114
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  TextHeight = 13
  object lbNRTexto: TLabel
    Left = 24
    Top = 8
    Width = 188
    Height = 39
    Caption = 
      'Congratulations! You beat the best time. Please, enter your name' +
      ' into the Hall of Fame!!'
    WordWrap = True
  end
  object edNome: TEdit
    Left = 8
    Top = 48
    Width = 249
    Height = 21
    TabOrder = 0
    OnExit = edNomeOnExit
  end
  object btNROK: TButton
    Left = 176
    Top = 80
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = btNROKClick
  end
end
