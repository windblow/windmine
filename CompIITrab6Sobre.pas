unit CompIITrab6Sobre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfmSobre = class(TForm) // janela de About do programa
    imSmiley: TImage;
    lbSobreTitulo: TLabel;
    lbNomeAluno: TLabel;
    lbNomeProf: TLabel;
    lbNomeTrab: TLabel;
    btOK: TButton;
    procedure CarregaImagem(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSobre: TfmSobre;

implementation

{$R *.dfm}

procedure TfmSobre.CarregaImagem(Sender: TObject);
{ Carrega a imagem do smiley na janela }
begin
  imSmiley.Picture.Bitmap.LoadFromResourceName(hInstance, 'RESBT_0')
end;

procedure TfmSobre.btOKClick(Sender: TObject);
{ Fecha a janela }
begin
  fmSobre.Close
end;

end.
