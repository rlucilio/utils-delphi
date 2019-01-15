program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uRelatorio.InformacacaoImportante in '..\Relatorio\uRelatorio.InformacacaoImportante.pas',
  uRelatorio.InformacaoLista in '..\Relatorio\uRelatorio.InformacaoLista.pas',
  uRelatorio.InformacaoRodape in '..\Relatorio\uRelatorio.InformacaoRodape.pas',
  uRelatorio.InformativosSimples in '..\Relatorio\uRelatorio.InformativosSimples.pas',
  uRelatorio.Interfaces in '..\Relatorio\uRelatorio.Interfaces.pas',
  uRelatorio.Linhas in '..\Relatorio\uRelatorio.Linhas.pas',
  uRelatorio.Matricial in '..\Relatorio\uRelatorio.Matricial.pas',
  uRelatorio.Termica in '..\Relatorio\uRelatorio.Termica.pas',
  uRelatorio.Bloco in '..\Relatorio\uRelatorio.Bloco.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
