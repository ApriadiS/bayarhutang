program BayarHutang;

uses
  Vcl.Forms,
  HutangData in 'HutangData.pas' {F_HutangData},
  HutangDataQuickReport in 'HutangDataQuickReport.pas' {F_HutangDataQuickReport};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TF_HutangData, F_HutangData);
  Application.CreateForm(TF_HutangDataQuickReport, F_HutangDataQuickReport);
  Application.Run;
end.
