object fmRecordes: TfmRecordes
  Left = 191
  Top = 115
  BorderStyle = bsSingle
  Caption = 'Best Times'
  ClientHeight = 195
  ClientWidth = 285
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OnCreate = fmRecordesOnCreate
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 273
    Height = 145
    TabOrder = 0
    object lbIniciante: TLabel
      Left = 8
      Top = 24
      Width = 42
      Height = 13
      Caption = 'Beginner'
    end
    object lbIntermediario: TLabel
      Left = 8
      Top = 64
      Width = 58
      Height = 13
      Caption = 'Intermediate'
    end
    object lbExperiente: TLabel
      Left = 8
      Top = 104
      Width = 49
      Height = 13
      Caption = 'Advanced'
    end
    object lbInicianteNome: TLabel
      Left = 64
      Top = 40
      Width = 41
      Height = 13
      Caption = 'An'#244'nimo'
    end
    object lbIntermediarioNome: TLabel
      Left = 64
      Top = 80
      Width = 41
      Height = 13
      Caption = 'An'#244'nimo'
    end
    object lbExperienteNome: TLabel
      Left = 64
      Top = 120
      Width = 41
      Height = 13
      Caption = 'An'#244'nimo'
    end
    object lbNome: TLabel
      Left = 72
      Top = 8
      Width = 29
      Height = 13
      Caption = 'Player'
    end
    object lbTempo: TLabel
      Left = 216
      Top = 8
      Width = 23
      Height = 13
      Caption = 'Time'
    end
    object lbInicianteTempo: TLabel
      Left = 224
      Top = 40
      Width = 23
      Height = 13
      Caption = '999s'
    end
    object lbIntermediarioTempo: TLabel
      Left = 224
      Top = 80
      Width = 23
      Height = 13
      Caption = '999s'
    end
    object lbExperienteTempo: TLabel
      Left = 224
      Top = 120
      Width = 23
      Height = 13
      Caption = '999s'
    end
  end
  object btOK: TButton
    Left = 200
    Top = 160
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = btOKClick
  end
  object btLimpar: TButton
    Left = 120
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 2
    OnClick = btLimparClick
  end
end
