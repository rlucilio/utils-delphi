program melhorando;

uses
  System.StartUpCopy,
  FMX.Forms,
  view in 'view.pas' {Form1},
  Model.Conexao.interfaces in '..\Model.Conexao.interfaces.pas',
  Model.Conexao in '..\Model.Conexao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
