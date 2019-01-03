program Project2;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit3 in '..\..\..\Embarcadero\Studio\Projects\Unit3.pas' {Form3},
  uConexao.interfaces in 'uConexao.interfaces.pas',
  uConexao in 'uConexao.pas',
  uConexao.Query in 'uConexao.Query.pas',
  uConexaoORM in 'uConexaoORM.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
