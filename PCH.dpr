program PCH;

uses
  Vcl.Forms,
  uFrmPrincipal in 'Form\uFrmPrincipal.pas' {frmPrincipal},
  uDtmPrincipal in 'uDtmPrincipal.pas' {dtmPrincipal: TDataModule},
  uDtmConnection in 'uDtmConnection.pas' {dtmConnection: TDataModule},
  uFrmImportFile in 'Form\uFrmImportFile.pas' {frmImportFile},
  uClassMedidas in 'Class\uClassMedidas.pas',
  uFrmConfig in 'Form\uFrmConfig.pas' {frmConfig},
  inserirMedicoesHomologacao in 'WS\inserirMedicoesHomologacao.pas',
  inserirMedicoesProducao in 'WS\inserirMedicoesProducao.pas',
  uTransmicao in 'WS\uTransmicao.pas',
  uProducao in 'WS\uProducao.pas',
  uClassLogs in 'Class\uClassLogs.pas',
  uHomologacao in 'WS\uHomologacao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdtmConnection, dtmConnection);
  Application.CreateForm(TdtmPrincipal, dtmPrincipal);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;

end.
