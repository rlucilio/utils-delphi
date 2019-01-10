program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uRelatorio.InformacacaoImportante in '..\..\Documents\Projetos\Uteis\Relatorio\uRelatorio.InformacacaoImportante.pas',
  uRelatorio.InformacaoLista in '..\..\Documents\Projetos\Uteis\Relatorio\uRelatorio.InformacaoLista.pas',
  uRelatorio.InformacaoRodape in '..\..\Documents\Projetos\Uteis\Relatorio\uRelatorio.InformacaoRodape.pas',
  uRelatorio.InformativosSimples in '..\..\Documents\Projetos\Uteis\Relatorio\uRelatorio.InformativosSimples.pas',
  uRelatorio.Interfaces in '..\..\Documents\Projetos\Uteis\Relatorio\uRelatorio.Interfaces.pas',
  uRelatorio.Termica in '..\..\Documents\Projetos\Uteis\Relatorio\uRelatorio.Termica.pas',
  uRelatorio.Matricial in 'Model\uRelatorio.Matricial.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
