program Project1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uConexaoORM in 'uConexaoORM.pas',
  Entidade.cliente in 'Entidades\Entidade.cliente.pas',
  Entidade.log in 'Entidades\Entidade.log.pas',
  Entidade.programa in 'Entidades\Entidade.programa.pas',
  Entidade.programa_cliente in 'Entidades\Entidade.programa_cliente.pas',
  Entidade.programa_foto in 'Entidades\Entidade.programa_foto.pas',
  Entidade.programa_link in 'Entidades\Entidade.programa_link.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:= true;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
