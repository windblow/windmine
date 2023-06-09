program Windmine;

uses
        Forms,
        CompIITrab6 in 'CompIITrab6.pas' {fmPrincipal} ,
        CompIITrab6Casa in 'CompIITrab6Casa.pas',
        CompIITrab6Records in 'CompIITrab6Records.pas' {fmRecordes} ,
        CompIITrab6Config in 'CompIITrab6Config.pas' {fmConfig} ,
        CompIITrab6Sobre in 'CompIITrab6Sobre.pas' {fmSobre} ,
        CompIITrab6NewRecord in 'CompIITrab6NewRecord.pas' {fmNewRecord} ,
        CompIITrab6Counter in 'CompIITrab6Counter.pas';

{$R *.res}

begin
        Application.Initialize;
        Application.CreateForm(TfmPrincipal, fmPrincipal);
        Application.CreateForm(TfmRecordes, fmRecordes);
        Application.CreateForm(TfmConfig, fmConfig);
        Application.CreateForm(TfmSobre, fmSobre);
        Application.CreateForm(TfmNewRecord, fmNewRecord);
        Application.Run;

end.
