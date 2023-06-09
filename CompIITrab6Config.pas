unit CompIITrab6Config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfmConfig = class(TForm) // janela de configuração dos parametros do jogo
    pnDimensoes: TPanel;
    lbDimensoes: TLabel;
    lbDimX: TLabel;
    lbDimY: TLabel;
    lbNumBombas: TLabel;
    edDimX: TEdit;
    edDimY: TEdit;
    edNumBombas: TEdit;
    btOK: TButton;
    btCancel: TButton;
    lbTitulo: TLabel;
    procedure ApanhaValores(XAtual, YAtual, BombasAtuais: integer;
      MaxX, MaxY: integer);
    procedure ExibeValores;
    procedure edDimXOnExit(Sender: TObject);
    procedure edDimYOnExit(Sender: TObject);
    procedure edNumBombasOnExit(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
    FX: integer;
    FY: integer;
    FBombas: integer;
  public
    { Public declarations }
    property X: integer read FX write FX;
    property Y: integer read FY write FY;
    property Bombas: integer read FBombas write FBombas;
  end;

const
  MenorX = 8; // Menor número de colunas permitido
  MenorY = 8; // Menor número de linhas permitido
  { Mensagens de Erro }
  ValorPequeno = 'O valor digitado é menor que o mínimo permitido';
  ValorGrande = 'O valor digitado é maior que o máximo permitido';
  MuitasBombas = 'Não se pode botar mais bombas do que o número de casas';
  PoucasBombas = 'Não se pode fazer um campo sem bombas.';

var
  fmConfig: TfmConfig;
  MaiorX, MaiorY: integer;

implementation

{$R *.dfm}

procedure TfmConfig.ApanhaValores(XAtual, YAtual, BombasAtuais: integer;
  MaxX, MaxY: integer);
{ Captura os valores atuais e exibe }
begin
  X := XAtual;
  Y := YAtual;
  Bombas := BombasAtuais;
  MaiorX := MaxX;
  MaiorY := MaxY;
  ExibeValores
end;

procedure TfmConfig.ExibeValores;
{ Passa para os campos do form os valores atuais }
begin
  edDimX.Text := IntToStr(X);
  edDimY.Text := IntToStr(Y);
  edNumBombas.Text := IntToStr(Bombas)
end;

procedure TfmConfig.edDimXOnExit(Sender: TObject);
{ Verifica se o número de Colunas fornecido é válido }
begin
  if (StrToInt(edDimX.Text) < MenorX) then
  begin
    ShowMessage(ValorPequeno);
    edDimX.Text := IntToStr(MenorX)
  end
  else if (StrToInt(edDimX.Text) > MaiorX) then
  begin
    ShowMessage(ValorGrande);
    edDimX.Text := IntToStr(MaiorX)
  end
end;

procedure TfmConfig.edDimYOnExit(Sender: TObject);
{ Verifica se o número de Linhas fornecido é válido }
begin
  if (StrToInt(edDimY.Text) < MenorY) then
  begin
    ShowMessage(ValorPequeno);
    edDimY.Text := IntToStr(MenorY)
  end
  else if (StrToInt(edDimY.Text) > MaiorY) then
  begin
    ShowMessage(ValorGrande);
    edDimY.Text := IntToStr(MaiorY)
  end
end;

procedure TfmConfig.edNumBombasOnExit(Sender: TObject);
{ Verifica se o número de Bombas fornecido é válido }
begin
  if (StrToInt(edNumBombas.Text) >= (X * Y)) then
  begin
    ShowMessage(MuitasBombas);
    edNumBombas.Text := IntToStr((X * Y) - 1)
  end
  else if (StrToInt(edNumBombas.Text) < 1) then
  begin
    ShowMessage(PoucasBombas);
    edNumBombas.Text := '1'
  end
end;

procedure TfmConfig.btCancelClick(Sender: TObject);
{ Restaura os valores antes de fechar }
begin
  fmConfig.Close
end;

procedure TfmConfig.btOKClick(Sender: TObject);
{ Fecha a janela }
begin
  X := StrToInt(edDimX.Text);
  Y := StrToInt(edDimY.Text);
  Bombas := StrToInt(edNumBombas.Text);
  fmConfig.Close
end;

end.
