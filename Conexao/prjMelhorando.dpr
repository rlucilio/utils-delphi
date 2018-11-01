program prjMelhorando;

uses
  System.StartUpCopy,
  FMX.Forms,
  FormPrincipal in '..\..\..\..\Desktop\MelhorandoQuery\FormPrincipal.pas' {Form4},
  Model.Conexao.Query in 'Model.Conexao.Query.pas',
  DB.Helper in '..\Helpers\DB.Helper.pas',
  System.uJSON in '..\Helpers\System.uJSON.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
