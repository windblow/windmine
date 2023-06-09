object fmConfig: TfmConfig
  Left = 211
  Top = 146
  BorderStyle = bsSingle
  Caption = 'Customize...'
  ClientHeight = 195
  ClientWidth = 261
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  TextHeight = 13
  object lbNumBombas: TLabel
    Left = 24
    Top = 136
    Width = 79
    Height = 13
    Caption = 'Number of mines'
  end
  object lbTitulo: TLabel
    Left = 32
    Top = 8
    Width = 106
    Height = 13
    Caption = 'Custom Mode Settings'
  end
  object pnDimensoes: TPanel
    Left = 8
    Top = 24
    Width = 249
    Height = 97
    TabOrder = 0
    object lbDimensoes: TLabel
      Left = 8
      Top = 8
      Width = 43
      Height = 13
      Caption = 'Field size'
    end
    object lbDimX: TLabel
      Left = 115
      Top = 19
      Width = 28
      Height = 13
      Caption = 'Width'
    end
    object lbDimY: TLabel
      Left = 115
      Top = 59
      Width = 31
      Height = 13
      Caption = 'Height'
    end
    object edDimX: TEdit
      Left = 160
      Top = 16
      Width = 65
      Height = 21
      TabOrder = 0
      OnExit = edDimXOnExit
    end
    object edDimY: TEdit
      Left = 160
      Top = 56
      Width = 65
      Height = 21
      TabOrder = 1
      OnExit = edDimYOnExit
    end
  end
  object edNumBombas: TEdit
    Left = 152
    Top = 128
    Width = 73
    Height = 21
    TabOrder = 1
    OnExit = edNumBombasOnExit
  end
  object btOK: TButton
    Left = 168
    Top = 160
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = btOKClick
  end
  object btCancel: TButton
    Left = 88
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btCancelClick
  end
end
