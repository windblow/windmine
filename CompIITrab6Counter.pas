unit CompIITrab6Counter;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, ExtCtrls;

type
  TCounter = class(TObject) // Contadores numéricos digitais
  private
    FCentena: TBitmap;
    FDezena: TBitmap;
    FValor: LongInt;
    FUnidade: TBitmap;
    procedure AtualizaDigito(Pos: string; Dig: char); overload;
    procedure AtualizaDigito(Pos: string; Dig: integer); overload;
    procedure SetValor(NovoValor: LongInt);
  public
    constructor Create;
    procedure DecrementaValor; overload;
    procedure DecrementaValor(Num: LongInt); overload;
    procedure DesligaContador;
    procedure IncrementaValor; overload;
    procedure IncrementaValor(Num: LongInt); overload;
    procedure Inicializa;
    property Valor: LongInt read FValor write SetValor;
    property Centena: TBitmap read FCentena write FCentena;
    property Dezena: TBitmap read FDezena write FDezena;
    property Unidade: TBitmap read FUnidade write FUnidade;
  end;

implementation

{
  *********************************** TCounter ***********************************
}
constructor TCounter.Create;
begin
  Inherited;
  Inicializa
end;

procedure TCounter.AtualizaDigito(Pos: string; Dig: char);
{ Altera o dígito correspondente à posição Pos. Versão que aceita Char }
begin
  { Altera a Unidade }
  if (Pos = 'Und') then
  begin
    Unidade.Free;
    Unidade := TBitmap.Create;
    Unidade.LoadFromResourceName(hInstance, 'COUNT_' + Dig)
  end;
  { Altera a Dezena }
  if (Pos = 'Dez') then
  begin
    Dezena.Free;
    Dezena := TBitmap.Create;
    Dezena.LoadFromResourceName(hInstance, 'COUNT_' + Dig)
  end;
  { Altera a Centena }
  if (Pos = 'Cen') then
  begin
    Centena.Free;
    Centena := TBitmap.Create;
    Centena.LoadFromResourceName(hInstance, 'COUNT_' + Dig)
  end
end;

procedure TCounter.AtualizaDigito(Pos: string; Dig: integer);
{ Altera o dígito correspondente à posição Pos. Versão que aceita Integers }
begin
  { Altera a Unidade }
  if (Pos = 'Und') then
  begin
    Unidade.Free;
    Unidade := TBitmap.Create;
    Unidade.LoadFromResourceName(hInstance, 'COUNT_' + IntToStr(Dig))
  end;
  if (Pos = 'Dez') then
  { Altera a Dezena }
  begin
    Dezena.Free;
    Dezena := TBitmap.Create;
    Dezena.LoadFromResourceName(hInstance, 'COUNT_' + IntToStr(Dig))
  end;
  { Altera a Centena }
  if (Pos = 'Cen') then
  begin
    Centena.Free;
    Centena := TBitmap.Create;
    Centena.LoadFromResourceName(hInstance, 'COUNT_' + IntToStr(Dig))
  end
end;

procedure TCounter.DecrementaValor;
{ Diminui o valor em 1 }
begin
  if Valor = 0 then
    exit;
  Valor := Valor - 1
end;

procedure TCounter.DecrementaValor(Num: LongInt);
{ Diminui o valor em Num }
begin
  if (Valor - Num) < 0 then
    exit;
  Valor := Valor - 1
end;

procedure TCounter.DesligaContador;
{ Deixa o contador como se estivesse 'desligado' }
begin
  AtualizaDigito('Und', 'X');
  AtualizaDigito('Dez', 'X');
  AtualizaDigito('Cen', 'X')
end;

procedure TCounter.IncrementaValor;
{ Aumenta o valor em 1 }
begin
  if (Valor = 999) then
    exit;
  Valor := Valor + 1
end;

procedure TCounter.IncrementaValor(Num: LongInt);
{ Aumenta o valor em Num }
begin
  if (Valor + Num) > 999 then
    exit;
  Valor := Valor + Num
end;

procedure TCounter.Inicializa;
{ Inicializa as variáveis }
begin
  Centena := TBitmap.Create;
  Dezena := TBitmap.Create;
  Unidade := TBitmap.Create;
  DesligaContador;
end;

procedure TCounter.SetValor(NovoValor: LongInt);
{ Altera o Valor do Counter }
begin
  { Escapa se o número não puder ser exibido }
  if (NovoValor < 0) or (NovoValor > 999) then
    exit;
  { Calcula se há ou não centena, e qual seu dígito, e atualiza }
  if (NovoValor div 100 = 0) then
    AtualizaDigito('Cen', 'X')
  else
    AtualizaDigito('Cen', Valor div 100);
  { Calcula se há ou não dezena, e qual seu dígito, e atualiza }
  if ((NovoValor mod 100) div 10 = 0) and (NovoValor div 100 = 0) then
    AtualizaDigito('Dez', 'X')
  else
    AtualizaDigito('Dez', (NovoValor mod 100) div 10);
  { Calcula e atualiza o dígito da unidade }
  AtualizaDigito('Und', NovoValor mod 10);
  { Por fim, altera o valor do Field }
  FValor := NovoValor
end;

end.
