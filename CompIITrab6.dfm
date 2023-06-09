object fmPrincipal: TfmPrincipal
  Left = 191
  Top = 111
  AutoSize = True
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Windmine'
  ClientHeight = 164
  ClientWidth = 132
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mmPrincipal
  OnClose = OnClose
  OnCreate = OnCreate
  TextHeight = 13
  object sbReset: TSpeedButton
    Left = 53
    Top = 0
    Width = 27
    Height = 27
    OnClick = sbResetClick
  end
  object imTimeCounter: TImage
    Left = 83
    Top = 2
    Width = 45
    Height = 22
  end
  object imBombCounter: TImage
    Left = 3
    Top = 2
    Width = 45
    Height = 22
  end
  object dgCampo: TDrawGrid
    Left = 0
    Top = 32
    Width = 132
    Height = 132
    TabStop = False
    ColCount = 8
    DefaultColWidth = 15
    DefaultRowHeight = 15
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = dgCampoOnDrawCell
    OnMouseDown = dgCampoMouseDown
    OnMouseMove = dgCampoMouseMove
    OnMouseUp = dgCampoMouseUp
  end
  object mmPrincipal: TMainMenu
    object Arquivo1: TMenuItem
      Caption = '&Arquivo'
      object NovoJogo1: TMenuItem
        Caption = '&Novo Jogo'
        ShortCut = 113
        OnClick = NovoJogo1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Iniciante1: TMenuItem
        Caption = 'Beginner'
        GroupIndex = 1
        RadioItem = True
        OnClick = Iniciante1Click
      end
      object Intermediario1: TMenuItem
        Caption = 'Intermediate'
        GroupIndex = 1
        RadioItem = True
        OnClick = Intermediario1Click
      end
      object Experiente1: TMenuItem
        Caption = 'Expert'
        GroupIndex = 1
        RadioItem = True
        OnClick = Experiente1Click
      end
      object Personalizado1: TMenuItem
        Caption = 'Custom...'
        GroupIndex = 1
        RadioItem = True
        OnClick = Personalizado1Click
      end
      object N2: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object MelhoresTempos1: TMenuItem
        Caption = 'Best Times'
        GroupIndex = 2
        OnClick = MelhoresTempos1Click
      end
      object Interrogacoes1: TMenuItem
        Caption = 'Use '#39'?'#39' Marks'
        GroupIndex = 3
        OnClick = Interrogacoes1Click
      end
      object N3: TMenuItem
        Caption = '-'
        GroupIndex = 3
      end
      object Sair1: TMenuItem
        Caption = '&Sair'
        GroupIndex = 4
        OnClick = Sair1Click
      end
    end
    object Ajuda1: TMenuItem
      Caption = 'A&juda'
      object Sobre1: TMenuItem
        Caption = 'Sob&re'
        OnClick = Sobre1Click
      end
    end
  end
  object tmTimer: TTimer
    Enabled = False
    OnTimer = tmTimerOnTimer
    Left = 104
  end
end
