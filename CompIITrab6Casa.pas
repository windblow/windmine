unit CompIITrab6Casa;

interface

uses
  SysUtils, Graphics;

type
  TCasa = class(TObject) // são as casas do campo minado.
  private
    FAberto: Boolean;
    FAgendado: Boolean;
    FBomba: Boolean;
    FFigura: TBitmap;
    FMarcado: Boolean;
    FPressionado: Boolean;
    FQuestMark: Boolean;
    FVisivel: Boolean;
    FVizinhos: Integer;
    FVizinhosAbaixo: Integer;
    FVizinhosAcima: Integer;
    FVizinhosDireita: Integer;
    FVizinhosEsquerda: Integer;
  protected
    procedure DefineImagem;
  public
    procedure AbreCasa;
    procedure DesmarcaCasa;
    procedure DesQuestionaCasa;
    procedure Inicializa;
    procedure LiberaMemoria;
    procedure MarcaCasa;
    procedure MostraConteudo;
    procedure Press;
    procedure QuestionaCasa;
    procedure Unpress;
    property Aberto: Boolean read FAberto write FAberto;
    property Agendado: Boolean read FAgendado write FAgendado;
    property Bomba: Boolean read FBomba write FBomba;
    property Figura: TBitmap read FFigura write FFigura;
    property Marcado: Boolean read FMarcado write FMarcado;
    property Pressionado: Boolean read FPressionado write FPressionado;
    property QuestMark: Boolean read FQuestMark write FQuestMark;
    property Visivel: Boolean read FVisivel write FVisivel;
    property Vizinhos: Integer read FVizinhos write FVizinhos;
    property VizinhosAbaixo: Integer read FVizinhosAbaixo write FVizinhosAbaixo;
    property VizinhosAcima: Integer read FVizinhosAcima write FVizinhosAcima;
    property VizinhosDireita: Integer read FVizinhosDireita
      write FVizinhosDireita;
    property VizinhosEsquerda: Integer read FVizinhosEsquerda
      write FVizinhosEsquerda;
  end;

implementation

{
  ************************************ TCasa *************************************
}
procedure TCasa.AbreCasa;
{ Abre a casa }
begin
  if (Marcado) then
    exit;
  Aberto := true;
  DefineImagem
end;

procedure TCasa.DefineImagem;
{ Define a identidade gráfica da casa em seus vários estados }
var
  Nome: string;
begin
  { libera a memória usada para a imagem anterior e recria o bitmap }
  LiberaMemoria;
  FFigura := TBitmap.Create;
  { Carrega o nome da imagem de acordo com o estado da casa }
  if (not Visivel) then
    if (not Aberto) then
      if (Marcado) then
        Nome := 'MARCADO'
      else // if not Marcado
        if (Pressionado) then
          Nome := 'PRESSIO'
        else // if not Pressionado
          if (QuestMark) then
            Nome := 'QUESTAO'
          else // if not QuestMark
            Nome := 'FECHADO'
    else // if Aberto
      Nome := 'VIZIN_' + IntToStr(Vizinhos)
  else // if Visivel
    if (not Bomba) then
      if (Marcado) then
        Nome := 'MERRADO'
      else // if not Marcado
        Nome := 'VIZIN_' + IntToStr(Vizinhos)
    else // if Bomba
      if (not Aberto) then
        Nome := 'BMB_DES'
      else // if Aberto
        Nome := 'BMB_EXP';
  { Carrega a imagem propriamente dita }
  FFigura.LoadFromResourceName(HInstance, Nome)
end;

procedure TCasa.DesmarcaCasa;
{ Desmarca a casa }
begin
  if Aberto then
    exit;
  Marcado := false;
  DefineImagem
end;

procedure TCasa.DesQuestionaCasa;
{ Tira a QuestionMark da casa }
begin
  if (not QuestMark) then
    exit;
  QuestMark := false;
  DefineImagem
end;

procedure TCasa.Inicializa;
{ Inicializa as variáveis padrão }
begin
  FFigura := TBitmap.Create;
  Bomba := false;
  Visivel := false;
  Aberto := false;
  Marcado := false;
  Agendado := false;
  Pressionado := false;
  QuestMark := false;
  Vizinhos := 0;
  VizinhosAcima := 1;
  VizinhosAbaixo := 1;
  VizinhosEsquerda := 1;
  VizinhosDireita := 1;
  DefineImagem
end;

procedure TCasa.LiberaMemoria;
{ Libera a memória da imagem }
begin
  Figura.Free;
end;

procedure TCasa.MarcaCasa;
{ Marca a casa }
begin
  if (Aberto) then
    exit;
  Marcado := true;
  DefineImagem
end;

procedure TCasa.MostraConteudo;
{ Exibe o conteúdo da casa sem abrí-la }
begin
  Visivel := true;
  DefineImagem
end;

procedure TCasa.Press;
{ Pressiona a casa }
begin
  if (Pressionado) then
    exit;
  Pressionado := true;
  DefineImagem
end;

procedure TCasa.QuestionaCasa;
{ Coloca uma QuestionMark na casa }
begin
  if (not Marcado) then
    exit;
  Marcado := false;
  QuestMark := true;
  DefineImagem
end;

procedure TCasa.Unpress;
{ Despressiona a casa }
begin
  if (not Pressionado) then
    exit;
  Pressionado := false;
  DefineImagem
end;

end.
