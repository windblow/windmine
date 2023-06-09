unit CompIITrab6Records;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfmRecordes = class(TForm) // janela que exibe os melhores tempos
    Panel1: TPanel;
    lbIniciante: TLabel;
    lbIntermediario: TLabel;
    lbExperiente: TLabel;
    lbInicianteNome: TLabel;
    lbIntermediarioNome: TLabel;
    lbExperienteNome: TLabel;
    lbNome: TLabel;
    lbTempo: TLabel;
    lbInicianteTempo: TLabel;
    lbIntermediarioTempo: TLabel;
    lbExperienteTempo: TLabel;
    btOK: TButton;
    btLimpar: TButton;
    procedure fmRecordesOnCreate(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
  private
    { Private declarations }
    FLimpar: boolean;
  public
    { Public declarations }
    property Limpar: boolean read FLimpar write FLimpar;
  end;

var
  fmRecordes: TfmRecordes;

implementation

{$R *.dfm}

procedure TfmRecordes.fmRecordesOnCreate(Sender: TObject);
{ Inicializa a variável }
begin
  Limpar := false;
end;

procedure TfmRecordes.btOKClick(Sender: TObject);
{ Fecha a janela }
begin
  fmRecordes.Close
end;

procedure TfmRecordes.btLimparClick(Sender: TObject);
{ Limpa os recordes na janela e deixa marcado para o form principal excluí-los }
begin
  lbInicianteNome.Caption := 'Anônimo        ';
  lbInicianteTempo.Caption := '999s';
  lbIntermediarioNome.Caption := 'Anônimo        ';
  lbIntermediarioTempo.Caption := '999s';
  lbExperienteNome.Caption := 'Anônimo        ';
  lbExperienteTempo.Caption := '999s';
  Limpar := true
end;

end.
