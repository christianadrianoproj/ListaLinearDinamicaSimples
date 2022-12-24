program Pprog;

uses
  Vcl.Forms,
  uProg in 'uProg.pas' {frmApp},
  unit_CadastroAlunos in '..\Fila\unit_CadastroAlunos.pas' {frm_CadastroAlunos},
  uEstruturaAlunos in '..\Fila\uEstruturaAlunos.pas',
  UListaLinearDinamica in '..\ListaLinearDinamica\UListaLinearDinamica.pas' {frmListaLinearDinamica};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmApp, frmApp);
  Application.CreateForm(Tfrm_CadastroAlunos, frm_CadastroAlunos);
  Application.CreateForm(TfrmListaLinearDinamica, frmListaLinearDinamica);
  Application.Run;
end.
