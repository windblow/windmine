unit CompIITrab6;

interface

uses
        Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
        Forms,
        Dialogs, Grids, Menus, CompIITrab6Casa, CompIITrab6Config,
        CompIITrab6Sobre,
        CompIITrab6Records, CompIITrab6NewRecord, Buttons, CompIITrab6Counter,
        ExtCtrls;

const
        MaxCols = 30; // Max Grid columns
        MaxLins = 16; // Max Grid lines
        NomeArqConf = 'windmine.cfg';
        // Name of the config file
        { Error Messages }
        ChamInv = 'Invalid Function Call';
        ErroArqCria = 'Error creating config file!';
        ErroArqLe = 'Error reading config file!';
        ErroArqSalva = 'Error saving to config file!';

type
        TGameType = string[5];

type
        TPlayerName = string[15];

type
        TConfigEntry = record
                PersBombs, PersCols, PersLins: integer;
                // holds the size of custom mode board
                QuestOn: boolean; // whether or not to use Question Marks
                GameType: TGameType; // Game mode description String
                MTIniciNome, MTInterNome, MTExperNome: TPlayerName;
                // holds the names of best players
                MTIniciTempo, MTInterTempo, MTExperTempo: longint;
                // holds the best times
        end;

        TfmPrincipal = class(TForm)
                Ajuda1: TMenuItem;
                Arquivo1: TMenuItem;
                dgCampo: TDrawGrid;
                Experiente1: TMenuItem;
                Iniciante1: TMenuItem;
                Intermediario1: TMenuItem;
                Interrogacoes1: TMenuItem;
                MelhoresTempos1: TMenuItem;
                mmPrincipal: TMainMenu;
                N1: TMenuItem;
                N2: TMenuItem;
                N3: TMenuItem;
                NovoJogo1: TMenuItem;
                Personalizado1: TMenuItem;
                Sair1: TMenuItem;
                sbReset: TSpeedButton;
                Sobre1: TMenuItem;
                tmTimer: TTimer;
                imTimeCounter: TImage;
                imBombCounter: TImage;
                procedure AjustaGrid;
                procedure CalculaVizinhos(X, Y: integer);
                procedure CarregaConfigDeArquivo;
                procedure ComparaTempos;
                procedure dgCampoMouseDown(Sender: TObject;
                  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
                procedure dgCampoMouseMove(Sender: TObject; Shift: TShiftState;
                  X, Y: integer);
                procedure dgCampoMouseUp(Sender: TObject; Button: TMouseButton;
                  Shift: TShiftState; X, Y: integer);
                procedure dgCampoOnDrawCell(Sender: TObject;
                  ACol, ARow: integer; Rect: TRect; State: TGridDrawState);
                procedure Experiente1Click(Sender: TObject);
                procedure GameOver;
                procedure InicializaJogo;
                procedure Iniciante1Click(Sender: TObject);
                procedure Intermediario1Click(Sender: TObject);
                procedure Interrogacoes1Click(Sender: TObject);
                procedure LimpaRecordes;
                procedure MelhoresTempos1Click(Sender: TObject);
                procedure NovoJogo1Click(Sender: TObject);
                procedure OnClose(Sender: TObject; var Action: TCloseAction);
                procedure OnCreate(Sender: TObject);
                procedure Personalizado1Click(Sender: TObject);
                procedure PlantaBombas(X, Y: longint);
                procedure Sair1Click(Sender: TObject);
                procedure SalvaPreferencias(Modo: string);
                procedure sbResetClick(Sender: TObject);
                procedure Sobre1Click(Sender: TObject);
                procedure tmTimerOnTimer(Sender: TObject);
                procedure TimeCtRefresh;
                procedure BombCtRefresh;
                function ZeroFlood(X, Y: longint): integer;
        private
                FColunas: integer;
                FLinhas: integer;
                FQuantasBombas: integer;
                FRecordExperNome: TPlayerName;
                FRecordExperTempo: longint;
                FRecordIniciNome: TPlayerName;
                FRecordIniciTempo: longint;
                FRecordInterNome: TPlayerName;
                FRecordInterTempo: longint;
                FTipoJogo: TGameType;
                FUsarQuestoes: boolean;
                procedure AtualizaRecordes;
                procedure ConfiguraJogo(Bombas, X, Y: integer); overload;
                procedure ConfiguraJogo(ConfID: TGameType); overload;
                function ConfiguraPadrao: TConfigEntry;
                procedure CriaCounters;
                function ModificaConfig(Config: TConfigEntry): boolean;
        public
                ctTimeCounter: TCounter;
                ctBombCounter: TCounter;
                property Colunas: integer read FColunas write FColunas;
                property Linhas: integer read FLinhas write FLinhas;
                property QuantasBombas: integer read FQuantasBombas
                  write FQuantasBombas;
                property RecordExperNome: TPlayerName read FRecordExperNome
                  write FRecordExperNome;
                property RecordExperTempo: longint read FRecordExperTempo
                  write FRecordExperTempo;
                property RecordIniciNome: TPlayerName read FRecordIniciNome
                  write FRecordIniciNome;
                property RecordIniciTempo: longint read FRecordIniciTempo
                  write FRecordIniciTempo;
                property RecordInterNome: TPlayerName read FRecordInterNome
                  write FRecordInterNome;
                property RecordInterTempo: longint read FRecordInterTempo
                  write FRecordInterTempo;
                property TipoJogo: TGameType read FTipoJogo write FTipoJogo;
                property UsarQuestoes: boolean read FUsarQuestoes
                  write FUsarQuestoes;
        end;

        TCampo = array [0 .. MaxCols, 0 .. MaxLins] of TCasa;

var
        fmPrincipal: TfmPrincipal;
        Grid: TCampo;
        FirstClick: boolean;
        Jogando: boolean;
        CasasCertas: integer;
        // Number of mineless cells yet unopened
        OldX, OldY: longint; // Hold the last Mouse pointer coords
        MyRect: TRect; // Used to update the DrawGrid

implementation

{$R *.dfm}
{$R CompIITRab6Graph.res}

{
  ********************************* TfmPrincipal *********************************
}
procedure TfmPrincipal.AjustaGrid;
{ Adjust window components on resize }
var
        SBNewLeft, TCNewLeft: integer;
begin
        dgCampo.ColCount := Colunas;
        dgCampo.RowCount := Linhas;
        dgCampo.Width := (Colunas * 16) + 4;
        dgCampo.Height := (Linhas * 16) + 4;
        SBNewLeft := ((dgCampo.Width div 2) - 13);
        sbReset.Left := SBNewLeft;
        TCNewLeft := dgCampo.Width - 48;
        imTimeCounter.Left := TCNewLeft;
        TimeCtRefresh;
        BombCtRefresh
end;

procedure TfmPrincipal.AtualizaRecordes;
{ Update record times just before invoking the records form }
begin
        with fmRecordes do
        begin
                lbInicianteNome.Caption := string(RecordIniciNome);
                lbIntermediarioNome.Caption := string(RecordInterNome);
                lbExperienteNome.Caption := string(RecordExperNome);
                lbInicianteTempo.Caption := IntToStr(RecordIniciTempo) + 's';
                lbIntermediarioTempo.Caption :=
                  IntToStr(RecordInterTempo) + 's';
                lbExperienteTempo.Caption := IntToStr(RecordExperTempo) + 's'
        end
end;

procedure TfmPrincipal.CalculaVizinhos(X, Y: integer);
{ Computes the number of neighboring mines of a cell }
var
        i, j: integer;
begin
        with Grid[X, Y] do
                for i := (X - VizinhosEsquerda) to (X + VizinhosDireita) do
                        for j := (Y - VizinhosAcima) to (Y + VizinhosAbaixo) do
                        begin
                                if (i = X) and (j = Y) then
                                        continue;
                                if (Grid[i, j].Bomba) then
                                        Vizinhos := Vizinhos + 1
                        end
end;

procedure TfmPrincipal.CarregaConfigDeArquivo;
{ Load the settings from the config file }
var
        ConfigFile: TStream;
        ConfigTemp: TConfigEntry;
begin
        if FileExists(NomeArqConf) then
                try
                        ConfigFile := TFileStream.Create(NomeArqConf,
                          fmOpenRead or fmShareDenyWrite);
                        ConfigFile.Read(ConfigTemp, SizeOf(ConfigTemp));
                        ConfigFile.Free;
                except
                        ShowMessage(ErroArqLe);
                        ConfigTemp := ConfiguraPadrao;
                end
        else // if not FlieExists(NomeArqConf)
        begin
                ConfigTemp := ConfiguraPadrao;
                try
                        ConfigFile := TFileStream.Create(NomeArqConf,
                          fmCreate or fmOpenWrite);
                        ConfigFile.WriteBuffer(ConfigTemp, SizeOf(ConfigTemp));
                        ConfigFile.Free;
                except
                        ShowMessage(ErroArqCria)
                end
        end;
        { Tries to update settings, falling back to defaults on failure }
        if (not ModificaConfig(ConfigTemp)) then
        begin
                ShowMessage(ErroArqLe);
                ModificaConfig(ConfiguraPadrao)
        end
end;

procedure TfmPrincipal.ComparaTempos;
{ Compares the final time with the current record time for the board mode }
var
        i: integer;
begin
        { Runs when in Beginner mode }
        if TipoJogo = 'Inici' then
                if ctTimeCounter.Valor < RecordIniciTempo then
                begin
                        fmNewRecord.ShowModal;
                        RecordIniciNome := TPlayerName(fmNewRecord.edNome.Text);
                        if Length(RecordIniciNome) < 15 then
                                for i := (Length(RecordIniciNome) + 1) to 15 do
                                        RecordIniciNome :=
                                        RecordIniciNome + ' ';
                        RecordIniciTempo := ctTimeCounter.Valor;
                        { Chama a janela dos recordes }
                        MelhoresTempos1Click(fmPrincipal)
                end;
        { Runs when in Intermediate mode }
        if TipoJogo = 'Inter' then
                if ctTimeCounter.Valor < RecordInterTempo then
                begin
                        fmNewRecord.ShowModal;
                        RecordInterNome := TPlayerName(fmNewRecord.edNome.Text);
                        if Length(RecordInterNome) < 15 then
                                for i := (Length(RecordInterNome) + 1) to 15 do
                                        RecordInterNome :=
                                        RecordInterNome + ' ';
                        RecordInterTempo := ctTimeCounter.Valor;
                        MelhoresTempos1Click(fmPrincipal)
                end;
        { Runs when in Expert mode }
        if TipoJogo = 'Exper' then
                if ctTimeCounter.Valor < RecordExperTempo then
                begin
                        fmNewRecord.ShowModal;
                        RecordExperNome := TPlayerName(fmNewRecord.edNome.Text);
                        if Length(RecordExperNome) < 15 then
                                for i := (Length(RecordExperNome) + 1) to 15 do
                                        RecordExperNome :=
                                        RecordExperNome + ' ';
                        RecordExperTempo := ctTimeCounter.Valor;
                        MelhoresTempos1Click(fmPrincipal)
                end;
end;

procedure TfmPrincipal.ConfiguraJogo(Bombas, X, Y: integer);
{ Sets up the game in Custom mode }
begin
        TipoJogo := 'Perso';
        Personalizado1.Checked := true;
        Colunas := X;
        Linhas := Y;
        QuantasBombas := Bombas;
        AjustaGrid
end;

procedure TfmPrincipal.ConfiguraJogo(ConfID: TGameType);
{ Sets up the game in predefined modes }
begin
        if (ConfID <> 'Inici') and (ConfID <> 'Inter') and (ConfID <> 'Exper')
        then
        begin
                ShowMessage(ChamInv);
                exit
        end;
        TipoJogo := ConfID;
        if TipoJogo = 'Inici' then
        begin
                Iniciante1.Checked := true;
                Colunas := 8;
                Linhas := 8;
                QuantasBombas := 10
        end;
        if TipoJogo = 'Inter' then
        begin
                Intermediario1.Checked := true;
                Colunas := 16;
                Linhas := 16;
                QuantasBombas := 40
        end;
        if TipoJogo = 'Exper' then
        begin
                Experiente1.Checked := true;
                Colunas := 30;
                Linhas := 16;
                QuantasBombas := 99
        end;
        AjustaGrid;
end;

function TfmPrincipal.ConfiguraPadrao: TConfigEntry;
{ Generates standard settings when the config file is absent }
var
        Config: TConfigEntry;
begin
        Config.MTIniciNome := 'Anonymous      ';
        Config.MTInterNome := 'Anonymous      ';
        Config.MTExperNome := 'Anonymous      ';
        Config.MTIniciTempo := 999;
        Config.MTInterTempo := 999;
        Config.MTExperTempo := 999;
        Config.QuestOn := true;
        Config.GameType := 'Inici';
        Config.PersBombs := 10;
        Config.PersCols := 8;
        Config.PersLins := 8;
        Result := Config
end;

procedure TfmPrincipal.CriaCounters;
{ Creates the Counters and binds them to the Image components }
begin
        ctTimeCounter := TCounter.Create;
        ctBombCounter := TCounter.Create;
        imTimeCounter.Picture.Bitmap.LoadFromResourceName(hInstance, 'COUNBAS');
        TimeCtRefresh;
        imBombCounter.Picture.Bitmap.LoadFromResourceName(hInstance, 'COUNBAS');
        BombCtRefresh;
end;

procedure TfmPrincipal.dgCampoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
{ Run the standard actions on mouse button down event }
var
        Col, Row: longint;
        i, j: integer;
begin
        { Escapes if not in a game }
        if (not Jogando) then
                exit;

        { Captures Mouse coordinates }
        dgCampo.MouseToCell(X, Y, Col, Row);

        { Runs when both left and right mouse buttons are down simultaneously }
        if ((Button = mbLeft) and (ssRight in Shift)) or
          ((Button = mbRight) and (ssLeft in Shift)) then
        begin
                { Change the reset button emoji }
                sbReset.Invalidate;
                sbReset.Glyph.LoadFromResourceName(hInstance, 'RESBT_1');
                sbReset.Update;
                { Calls press method on the clicked cell and its unflagged adjacent ones }
                for i := (Col - Grid[Col, Row].VizinhosEsquerda)
                  to (Col + Grid[Col, Row].VizinhosDireita) do
                        for j := (Row - Grid[Col, Row].VizinhosAcima)
                          to (Row + Grid[Col, Row].VizinhosAbaixo) do
                                if (not Grid[i, j].Aberto) and
                                  (not Grid[i, j].Marcado) then
                                begin
                                        MyRect := dgCampo.CellRect(i, j);
                                        InvalidateRect(dgCampo.Handle,
                                        @MyRect, false);
                                        Grid[i, j].Press
                                end
        end
        else
        begin

                { Runs when right mouse button is down }
                if Button = mbRight then
                begin
                        MyRect := dgCampo.CellRect(Col, Row);
                        InvalidateRect(dgCampo.Handle, @MyRect, false);
                        { Flags, Unflags, Adds or Removes QuestionMark mark from cell }
                        with Grid[Col, Row] do
                        begin
                                if Aberto then
                                        exit;
                                if Marcado then
                                        if UsarQuestoes then
                                        QuestionaCasa
                                        else // if not UsarQuestoes
                                        begin
                                        DesmarcaCasa;
                                        ctBombCounter.IncrementaValor;
                                        end
                                else // if not Marcado
                                        if QuestMark then
                                        DesQuestionaCasa
                                        else
                                        begin
                                        MarcaCasa;
                                        ctBombCounter.DecrementaValor
                                        end
                        end;
                        BombCtRefresh
                end;

                { Runs when left mouse button is down }
                if Button = mbLeft then
                begin
                        { Change the reset button emoji }
                        sbReset.Invalidate;
                        sbReset.Glyph.LoadFromResourceName(hInstance,
                          'RESBT_1');
                        sbReset.Update;
                        OldX := Col;
                        OldY := Row;
                        { Presses the cell if it's not flagged }
                        if (not Grid[Col, Row].Marcado) then
                        begin
                                MyRect := dgCampo.CellRect(Col, Row);
                                InvalidateRect(dgCampo.Handle, @MyRect, false);
                                Grid[Col, Row].Press
                        end
                end
        end;

        { Re-renders altered elements of the grid }
        dgCampo.Update
end;

procedure TfmPrincipal.dgCampoMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
{ Presses the closed cells under the mouse pointer when moving it with LMB pressed }
var
        Col, Row: longint;
        i, j: integer;
begin
        { Escapes if not in a game }
        if (not Jogando) then
                exit;

        { Captures Mouse coordinates }
        dgCampo.MouseToCell(X, Y, Col, Row);

        { Unpress every pressed cell if the pointer moves outside the boundaries }
        if (Col < 0) or (Col >= Colunas) or (Row < 0) or (Row >= Linhas) then
        begin
                for i := (OldX - Grid[OldX, OldY].VizinhosEsquerda)
                  to (OldX + Grid[OldX, OldY].VizinhosDireita) do
                        for j := (OldY - Grid[OldX, OldY].VizinhosAcima)
                          to (OldY + Grid[OldX, OldY].VizinhosAbaixo) do
                        begin
                                MyRect := dgCampo.CellRect(i, j);
                                InvalidateRect(dgCampo.Handle, @MyRect, false);
                                Grid[i, j].Unpress
                        end;
                dgCampo.Update;
                exit
        end;

        { Runs when both left and right mouse buttons are down simultaneously }
        if (ssLeft in Shift) and (ssRight in Shift) then
        begin
                { Unpress the cell from which the mouse pointer moved away and all its adjacent cells }
                if (Col <> OldX) or (Row <> OldY) then
                begin
                        for i := (OldX - Grid[OldX, OldY].VizinhosEsquerda)
                          to (OldX + Grid[OldX, OldY].VizinhosDireita) do
                                for j := (OldY - Grid[OldX, OldY].VizinhosAcima)
                                  to (OldY + Grid[OldX, OldY].VizinhosAbaixo) do
                                begin
                                        MyRect := dgCampo.CellRect(i, j);
                                        InvalidateRect(dgCampo.Handle,
                                        @MyRect, false);
                                        Grid[i, j].Unpress
                                end;
                        { Presses the cell which the mouse pointer moved over and all its adacent cells }
                        for i := (Col - Grid[Col, Row].VizinhosEsquerda)
                          to (Col + Grid[Col, Row].VizinhosDireita) do
                                for j := (Row - Grid[Col, Row].VizinhosAcima)
                                  to (Row + Grid[Col, Row].VizinhosAbaixo) do
                                        if (not Grid[i, j].Aberto) and
                                        (not Grid[i, j].Marcado) then
                                        begin
                                        MyRect := dgCampo.CellRect(i, j);
                                        InvalidateRect(dgCampo.Handle,
                                        @MyRect, false);
                                        Grid[i, j].Press
                                        end;
                        { Registers the current cell coordinates }
                        OldX := Col;
                        OldY := Row
                end
        end
        { Runs when only left mouse button is down }
        else // if ssRight not in Shift
                if (ssLeft in Shift) then
                        if (Col <> OldX) or (Row <> OldY) then
                        begin
                                { Unpress the cell the pointer moved away from }
                                MyRect := dgCampo.CellRect(OldX, OldY);
                                InvalidateRect(dgCampo.Handle, @MyRect, false);
                                Grid[OldX, OldY].Unpress;
                                { Presses the cell the pointer moved over, if it's closed and unflagged }
                                if (not Grid[Col, Row].Aberto) and
                                  (not Grid[Col, Row].Marcado) then
                                begin
                                        MyRect := dgCampo.CellRect(Col, Row);
                                        InvalidateRect(dgCampo.Handle,
                                        @MyRect, false);
                                        Grid[Col, Row].Press
                                end;
                                { Registers the current cell coordinates }
                                OldX := Col;
                                OldY := Row
                        end;

        { Re-renders altered elements of the grid }
        dgCampo.Update
end;

procedure TfmPrincipal.dgCampoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
{ Run the standard actions on mouse button up event }
var
        Col, Row: longint;
        i, j: integer;
        MarcaCount: integer;
begin
        { Escapes if not in a game }
        if (not Jogando) then
                exit;

        { Captures Mouse coordinates }
        dgCampo.MouseToCell(X, Y, Col, Row);

        { Unpress any pressed cells if the pointer is outside the boundaries of the form }
        if (Col < 0) or (Col >= Colunas) or (Row < 0) or (Row >= Linhas) then
        begin
                for i := (OldX - Grid[OldX, OldY].VizinhosEsquerda)
                  to (OldX + Grid[OldX, OldY].VizinhosDireita) do
                        for j := (OldY - Grid[OldX, OldY].VizinhosAcima)
                          to (OldY + Grid[OldX, OldY].VizinhosAbaixo) do
                        begin
                                MyRect := dgCampo.CellRect(i, j);
                                InvalidateRect(dgCampo.Handle, @MyRect, false);
                                Grid[i, j].Unpress
                        end;
                dgCampo.Update;
                { Change the reset button emoji }
                sbReset.Invalidate;
                sbReset.Glyph.LoadFromResourceName(hInstance, 'RESBT_0');
                sbReset.Update;
                exit
        end;

        { Runs when both left and right mouse buttons are up simultaneously }
        if ((Button = mbLeft) and (ssRight in Shift)) or
          ((Button = mbRight) and (ssLeft in Shift)) then
        begin
                { Counts how many flagged adjacent cells the current cell has and unpresses them }
                MarcaCount := 0;
                for i := (Col - Grid[Col, Row].VizinhosEsquerda)
                  to (Col + Grid[Col, Row].VizinhosDireita) do
                        for j := (Row - Grid[Col, Row].VizinhosAcima)
                          to (Row + Grid[Col, Row].VizinhosAbaixo) do
                        begin
                                MyRect := dgCampo.CellRect(i, j);
                                InvalidateRect(dgCampo.Handle, @MyRect, false);
                                Grid[i, j].Unpress;
                                if (not Grid[Col, Row].Marcado) then
                                        if Grid[i, j].Marcado then
                                        MarcaCount := MarcaCount + 1
                        end;
                { Change the reset button emoji }
                sbReset.Invalidate;
                sbReset.Glyph.LoadFromResourceName(hInstance, 'RESBT_0');
                { If the number of flagged neighbors is equal to the number of adjacent mines,
                  opens all closed and unflagged adjacent cells simultaneously }
                if (Grid[Col, Row].Aberto) and
                  (MarcaCount = Grid[Col, Row].Vizinhos) then
                        CasasCertas := CasasCertas - ZeroFlood(Col, Row);
        end
        else // if only one of the mouse buttons went up

                { Runs when only left mouse button is up }
                if (Button = mbLeft) then
                begin
                        { Unpress the cell }
                        MyRect := dgCampo.CellRect(Col, Row);
                        InvalidateRect(dgCampo.Handle, @MyRect, false);
                        Grid[Col, Row].Unpress;
                        { If it's the first cell being opened on the board, plants the mines on the grid,
                          counts the number of neighboring mines of every cell, and starts the timer }
                        if (FirstClick) then
                        begin
                                PlantaBombas(Col, Row);
                                // Plant the mines on random cells excluding the current one, so the first clicked cell is never a mine
                                ctTimeCounter.Valor := 1;
                                TimeCtRefresh;
                                tmTimer.Enabled := true;
                                FirstClick := false
                        end;
                        { If the cell is already opened, just restores the reset button emoji }
                        if (Grid[Col, Row].Aberto) then
                        begin
                                sbReset.Invalidate;
                                sbReset.Glyph.LoadFromResourceName(hInstance,
                                  'RESBT_0');
                                sbReset.Update;
                                exit
                        end;
                        { If the cell is closed and unflagged }
                        if (not Grid[Col, Row].Marcado) then
                                { If the cell has a mine, the game is over }
                                if (Grid[Col, Row].Bomba) then
                                begin
                                        Grid[Col, Row].AbreCasa;
                                        GameOver
                                end
                                { If the cell doesn't have a mine, open it }
                                else // if not Grid[Col,Row].Bomba
                                begin
                                        { If the cell has no adjacent mines, open every adjacent cell,
                                        propagating the behavior to all neighbors with no adjacent mines,
                                        until every open cell has at least one adjacent mine }
                                        if (Grid[Col, Row].Vizinhos = 0) then
                                        begin
                                        sbReset.Invalidate;
                                        sbReset.Glyph.LoadFromResourceName
                                        (hInstance, 'RESBT_0');
                                        CasasCertas := CasasCertas -
                                        ZeroFlood(Col, Row)
                                        end
                                        { If the cell has at least one neighboring mine, open only the clicked one }
                                        else // if Grid[Col,Row].Vizinhos > 0
                                        begin
                                        MyRect := dgCampo.CellRect(Col, Row);
                                        InvalidateRect(dgCampo.Handle,
                                        @MyRect, false);
                                        Grid[Col, Row].AbreCasa;
                                        CasasCertas := CasasCertas - 1;
                                        { If the game is not won, restore the reset button emoji }
                                        if CasasCertas > 0 then
                                        begin
                                        sbReset.Invalidate;
                                        sbReset.Glyph.LoadFromResourceName
                                        (hInstance, 'RESBT_0');
                                        end
                                        end
                                end
                end;

        { Runs if there are no mine-free cells left unopened on the board, i.e.,
          the game win condition }
        if (CasasCertas = 0) then
        begin
                { Stops the timer }
                tmTimer.Enabled := false;
                { Updates the emoji on the reset button to the game won face }
                sbReset.Invalidate;
                sbReset.Glyph.LoadFromResourceName(hInstance, 'RESBT_3');
                sbReset.Update;
                { Turns off the game running flag }
                Jogando := false;
                { Compares the current time with the record }
                ComparaTempos
        end;

        { If the game is over, whether lost or won }
        if (not Jogando) then
                { Flags every cell with a mine }
                for i := 0 to Colunas - 1 do
                        for j := 0 to Linhas - 1 do
                                if Grid[i, j].Bomba then
                                begin
                                        MyRect := dgCampo.CellRect(i, j);
                                        InvalidateRect(dgCampo.Handle,
                                        @MyRect, false);
                                        Grid[i, j].MarcaCasa;
                                end;

        { Re-renders the invalidated graphic elements }
        dgCampo.Update;
        sbReset.Update
end;

procedure TfmPrincipal.dgCampoOnDrawCell(Sender: TObject; ACol, ARow: integer;
  Rect: TRect; State: TGridDrawState);
{ Paints the DrawGrid cell with the corresponding sprite }
begin
        dgCampo.Canvas.Draw(Rect.Left, Rect.Top, Grid[ACol, ARow].Figura)
end;

procedure TfmPrincipal.Experiente1Click(Sender: TObject);
{ Sets game mode to Expert }
begin
        ConfiguraJogo('Exper');
        InicializaJogo
end;

procedure TfmPrincipal.GameOver;
{ Runs in case of game loss }
var
        i, j: integer;
begin
        { Stops the timer }
        tmTimer.Enabled := false;
        TimeCtRefresh;
        { Turns off the game running flag }
        Jogando := false;
        { Shows every mine on the grid, and highlights the cells erroneously flagged as mines }
        for i := 0 to Colunas - 1 do
                for j := 0 to Linhas - 1 do
                        if (Grid[i, j].Bomba) or
                          ((Grid[i, j].Marcado) and (not Grid[i, j].Bomba)) then
                                Grid[i, j].MostraConteudo;
        { Updates the emoji on the reset button to the game lost face }
        sbReset.Invalidate;
        sbReset.Glyph.LoadFromResourceName(hInstance, 'RESBT_2');
        dgCampo.Repaint
end;

procedure TfmPrincipal.InicializaJogo;
{ Start up a new game }
var
        i, j: integer;
begin
        { Stop the timer if it is running }
        tmTimer.Enabled := false;
        { Sends the number of mines to the corresponding Counter }
        ctBombCounter.Valor := QuantasBombas;
        BombCtRefresh;
        { Resets the timer }
        ctTimeCounter.DesligaContador;
        TimeCtRefresh;
        { Restores the reset button emoji }
        sbReset.Glyph.LoadFromResourceName(hInstance, 'RESBT_0');
        { Marks the Use Question Marks menu item in case this setting is enabled }
        if (UsarQuestoes) then
                Interrogacoes1.Checked := true;
        { Puts the game in Stand By for First Click state }
        FirstClick := true;
        { Turns on the game running flag }
        Jogando := true;
        { Counts the number of mineless cells in the board }
        CasasCertas := (Linhas * Colunas) - QuantasBombas;

        { Destroys and recreates the grid with the new settings }
        for i := 0 to Colunas - 1 do
                for j := 0 to Linhas - 1 do
                begin
                        { If there is a previous grid, release its memory }
                        try
                                Grid[i, j].LiberaMemoria;
                                Grid[i, j].Free;
                        except
                        end;
                        { Creates, initializes, and calculates the number of neighboring cells for each position of the grid }
                        Grid[i, j] := TCasa.Create;
                        Grid[i, j].Inicializa;
                        if i = 0 then
                                Grid[i, j].VizinhosEsquerda := 0;
                        if i = (Colunas - 1) then
                                Grid[i, j].VizinhosDireita := 0;
                        if j = 0 then
                                Grid[i, j].VizinhosAcima := 0;
                        if j = (Linhas - 1) then
                                Grid[i, j].VizinhosAbaixo := 0
                end;

        { Repaint the DrawGrid }
        dgCampo.Repaint;
end;

procedure TfmPrincipal.Iniciante1Click(Sender: TObject);
{ Sets game mode to Beginner }
begin
        ConfiguraJogo('Inici');
        InicializaJogo
end;

procedure TfmPrincipal.Intermediario1Click(Sender: TObject);
{ Sets game mode to Intermediate }
begin
        ConfiguraJogo('Inter');
        InicializaJogo
end;

procedure TfmPrincipal.Interrogacoes1Click(Sender: TObject);
{ Enables/disables QuestionMarks }
var
        i, j: integer;
begin
        if UsarQuestoes then
        begin
                Interrogacoes1.Checked := false;
                UsarQuestoes := false;
                for i := 0 to Colunas - 1 do
                        for j := 0 to Linhas - 1 do
                                if Grid[i, j].QuestMark then
                                        Grid[i, j].DesQuestionaCasa;
                dgCampo.Repaint
        end
        else
        begin
                Interrogacoes1.Checked := true;
                UsarQuestoes := true
        end
end;

procedure TfmPrincipal.LimpaRecordes;
{ Clears up the records for best times }
begin
        RecordIniciNome := 'Anonymous      ';
        RecordInterNome := 'Anonymous      ';
        RecordExperNome := 'Anonymous      ';
        RecordIniciTempo := 999;
        RecordInterTempo := 999;
        RecordExperTempo := 999;
        fmRecordes.Limpar := false
end;

procedure TfmPrincipal.MelhoresTempos1Click(Sender: TObject);
{ Opens the high scores form }
begin
        AtualizaRecordes;
        fmRecordes.ShowModal;
        { Se o usuário tiver limpado os recordes no form, ele limpa também no principal }
        if fmRecordes.Limpar then
                LimpaRecordes;
end;

function TfmPrincipal.ModificaConfig(Config: TConfigEntry): boolean;
{ Changes the game's preferences and high scores }
begin
        RecordIniciNome := Config.MTIniciNome;
        RecordInterNome := Config.MTInterNome;
        RecordExperNome := Config.MTExperNome;
        RecordIniciTempo := Config.MTIniciTempo;
        RecordInterTempo := Config.MTInterTempo;
        RecordExperTempo := Config.MTExperTempo;
        UsarQuestoes := Config.QuestOn;
        if Config.GameType = 'Perso' then
        begin
                ConfiguraJogo(Config.PersBombs, Config.PersCols,
                  Config.PersLins);
                Result := true
        end
        else if (Config.GameType = 'Inici') or (Config.GameType = 'Inter') or
          (Config.GameType = 'Exper') then
        begin
                ConfiguraJogo(Config.GameType);
                Result := true
        end
        else
                Result := false;
end;

procedure TfmPrincipal.NovoJogo1Click(Sender: TObject);
{ Begins a new game }
begin
        InicializaJogo;
end;

procedure TfmPrincipal.OnClose(Sender: TObject; var Action: TCloseAction);
{ Save settings to file when exiting the application }
begin
        SalvaPreferencias('Atual')
end;

procedure TfmPrincipal.OnCreate(Sender: TObject);
{ Runs when main form is created }
begin
        CriaCounters;
        CarregaConfigDeArquivo;
        InicializaJogo
end;

procedure TfmPrincipal.Personalizado1Click(Sender: TObject);
{ Opens the customization form and restarts the game with the returned configuration }
begin
        Personalizado1.Checked := true;
        fmConfig.ApanhaValores(Colunas, Linhas, QuantasBombas, MaxCols,
          MaxLins);
        fmConfig.ShowModal;
        ConfiguraJogo(fmConfig.Bombas, fmConfig.X, fmConfig.Y);
        InicializaJogo
end;

procedure TfmPrincipal.PlantaBombas(X, Y: longint);
{ Plants the mines on the grid }
var
        i, j, k: integer;
begin
        for k := 1 to QuantasBombas do
        begin
                Randomize;
                repeat
                        i := Round(Random(Colunas));
                        j := Round(Random(Linhas));
                until (((i <> X) or (j <> Y)) and (Grid[i, j].Bomba = false));
                Grid[i, j].Bomba := true
        end;
        { Calculates the number of adjacent mines to every cell }
        for i := 0 to Colunas - 1 do
                for j := 0 to Linhas - 1 do
                        CalculaVizinhos(i, j);
end;

procedure TfmPrincipal.Sair1Click(Sender: TObject);
{ Exits the application }
begin
        fmPrincipal.Close
end;

procedure TfmPrincipal.SalvaPreferencias(Modo: string);
{ Saves settings to the config file }
var
        EntradaTemp: TConfigEntry;
        ArqTemp: TStream;
begin
        { Use default values when creating the file }
        if Modo = 'Novo' then
                EntradaTemp := ConfiguraPadrao
        else
                { Use current values when exiting the application }
                if (Modo = 'Atual') then
                begin
                        EntradaTemp.PersCols := Colunas;
                        EntradaTemp.PersLins := Linhas;
                        EntradaTemp.PersBombs := QuantasBombas;
                        EntradaTemp.GameType := TipoJogo;
                        EntradaTemp.QuestOn := UsarQuestoes;
                        EntradaTemp.MTIniciNome := RecordIniciNome;
                        EntradaTemp.MTInterNome := RecordInterNome;
                        EntradaTemp.MTExperNome := RecordExperNome;
                        EntradaTemp.MTIniciTempo := RecordIniciTempo;
                        EntradaTemp.MTInterTempo := RecordInterTempo;
                        EntradaTemp.MTExperTempo := RecordExperTempo
                end
                { Show error message if selected game mode is invalid }
                else
                begin
                        ShowMessage(ChamInv);
                        exit
                end;
        { Write the settings to file }
        try
                ArqTemp := TFileStream.Create(NomeArqConf,
                  fmCreate or fmOpenWrite);
                ArqTemp.WriteBuffer(EntradaTemp, SizeOf(EntradaTemp));
                ArqTemp.Free;
        except
                { Show error message if file cannot be written to }
                ShowMessage(ErroArqSalva)
        end;
end;

procedure TfmPrincipal.sbResetClick(Sender: TObject);
{ Resets the game }
begin
        InicializaJogo
end;

procedure TfmPrincipal.Sobre1Click(Sender: TObject);
{ Opens the About form }
begin
        fmSobre.ShowModal
end;

procedure TfmPrincipal.tmTimerOnTimer(Sender: TObject);
{ Increments the time counter every click of the timer }
begin
        ctTimeCounter.IncrementaValor;
        TimeCtRefresh
end;

function TfmPrincipal.ZeroFlood(X, Y: longint): integer;
{ Automatically opens up every cell that is presumed to contain no mines }
var
        CasasPorAbrir: boolean;
        // Indicates if there are still any cells left to process
        CasasAbertas, i, j, l, m: integer;
        AmbitoEsq, AmbitoDir, AmbitoCima, AmbitoBaixo: integer;
        // The bounds of the range of the grid which the function will scan
begin
        { Schedule the current cell for opening }
        Grid[X, Y].Agendado := true;
        { Initialize variables }
        CasasAbertas := 0;
        AmbitoEsq := 0;
        AmbitoDir := 0;
        AmbitoCima := 0;
        AmbitoBaixo := 0;

        { Main grid scan loop }
        repeat
                { Once inside the loop, every scheduled cell will be opened, so,
                  presumably, there are no remaining cells to process }
                CasasPorAbrir := false;

                { Runs for every scheduled cell within the range }
                for i := (X - AmbitoEsq) to (X + AmbitoDir) do
                        for j := (Y - AmbitoCima) to (Y + AmbitoBaixo) do
                                if Grid[i, j].Agendado then
                                begin

                                        { Opens up closed cells }
                                        if (not Grid[i, j].Aberto) then
                                        begin
                                        MyRect := dgCampo.CellRect(i, j);
                                        InvalidateRect(dgCampo.Handle,
                                        @MyRect, false);
                                        Grid[i, j].AbreCasa;
                                        CasasAbertas := CasasAbertas + 1
                                        end;

                                        { Unschedule the current cell since it has just been opened }
                                        Grid[i, j].Agendado := false;

                                        { Opens the unflagged neighbors of the recently opened cell }
                                        for l := (i - Grid[i,
                                        j].VizinhosEsquerda)
                                        to (i + Grid[i, j].VizinhosDireita) do
                                        for m := (j - Grid[i, j].VizinhosAcima)
                                        to (j + Grid[i, j].VizinhosAbaixo) do
                                        if (not Grid[l, m].Aberto) and
                                        (not Grid[l, m].Marcado) then
                                        begin
                                        MyRect := dgCampo.CellRect(l, m);
                                        InvalidateRect(dgCampo.Handle,
                                        @MyRect, false);
                                        Grid[l, m].AbreCasa;

                                        { In case this neighbor is a mine, the game is over.
                                        Note that, even with the game being over, the remaining scheduled cells
                                        will still be opened }
                                        if Grid[l, m].Bomba then
                                        GameOver

                                        { If this neighbor is not a mine, increment the opened cells counter }
                                        else // if not Grid[l,m].Bomba
                                        CasasAbertas := CasasAbertas + 1;

                                        { If this neighbor also has no adjacent mines, schedule it to be
                                        processed by the next loop iteration }
                                        if (Grid[l, m].Vizinhos = 0) and
                                        (not Grid[l, m].Bomba) then
                                        begin
                                        Grid[l, m].Agendado := true;

                                        { Since there are new scheduled cells to open, the loop's exit condition is no longer met }
                                        CasasPorAbrir := true
                                        end
                                        end
                                end;

                { If there are still any cells to open after the scan, increase the scope
                  by one in every valid direction, culled by the boundaries of the grid,
                  in order to reach the newly scheduled cells }
                if (CasasPorAbrir) then
                begin
                        AmbitoEsq := AmbitoEsq + Grid[X - AmbitoEsq, Y]
                          .VizinhosEsquerda;
                        AmbitoDir := AmbitoDir + Grid[X + AmbitoDir, Y]
                          .VizinhosDireita;
                        AmbitoCima := AmbitoCima + Grid[X, Y - AmbitoCima]
                          .VizinhosAcima;
                        AmbitoBaixo := AmbitoBaixo + Grid[X, Y + AmbitoBaixo]
                          .VizinhosAbaixo
                end;

                { When every scheduled cell has been opened, exit the loop }
        until (not CasasPorAbrir);

        { Returns the number of opened cells }
        Result := CasasAbertas
end;

procedure TfmPrincipal.TimeCtRefresh;
{ Updates the time counter }
begin
        imTimeCounter.Invalidate;
        imTimeCounter.Picture.Bitmap.Canvas.Draw(0, 0, ctTimeCounter.Centena);
        imTimeCounter.Picture.Bitmap.Canvas.Draw(15, 0, ctTimeCounter.Dezena);
        imTimeCounter.Picture.Bitmap.Canvas.Draw(30, 0, ctTimeCounter.Unidade);
        imTimeCounter.Refresh
end;

procedure TfmPrincipal.BombCtRefresh;
{ Updates the mine counter }
begin
        imBombCounter.Invalidate;
        imBombCounter.Picture.Bitmap.Canvas.Draw(0, 0, ctBombCounter.Centena);
        imBombCounter.Picture.Bitmap.Canvas.Draw(15, 0, ctBombCounter.Dezena);
        imBombCounter.Picture.Bitmap.Canvas.Draw(30, 0, ctBombCounter.Unidade);
        imBombCounter.Refresh
end;

end.
