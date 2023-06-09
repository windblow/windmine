unit CompIITrab6NewRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfmNewRecord = class(TForm) // janela que pede o nome do recordista
    edNome: TEdit;
    btNROK: TButton;
    lbNRTexto: TLabel;
    procedure btNROKClick(Sender: TObject);
    procedure edNomeOnExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  { Mensagens de Erro }
  ErroTamNome = 'O nome não pode ser maior que 15 caracteres';

var
  fmNewRecord: TfmNewRecord;

implementation

{$R *.dfm}

procedure TfmNewRecord.btNROKClick(Sender: TObject);
{ Passa o nome para os recordes }
begin
  { Se nenhum nome tiver sido fornecido, entra com 'Anônimo' }
  if edNome.Text = '' then
    edNome.Text := 'Anônimo';
  fmNewRecord.Close
end;

procedure TfmNewRecord.edNomeOnExit(Sender: TObject);
{ Verifica validade do tamanho do nome }
begin
  if Length(edNome.Text) > 15 then
  begin
    ShowMessage(ErroTamNome);
    edNome.Text := ''
  end
end;

end.
