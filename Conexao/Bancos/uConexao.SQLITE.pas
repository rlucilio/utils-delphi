unit uConexao.SQLITE;

interface

uses uConexao, uConexao.interfaces, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs;

type
   TConexaoSQLITE = class(TConexao)
   private
      constructor Create(parametros: TArray<string>);
   public
      class function New(parametros: TArray<string>): iConexao;
      destructor Destroy; override;
   end;

implementation

uses
  System.SysUtils;

{ TConexaoSQLITE }

constructor TConexaoSQLITE.Create(parametros: TArray<string>);
begin
   inherited Create();

   if Length(parametros) <= 0 then
    raise Exception.Create('Parâmetros inválidos');


   SetConfigOfConnection(parametros);
end;


destructor TConexaoSQLITE.Destroy;
begin

  inherited;
end;

class function TConexaoSQLITE.New(parametros: TArray<string>): iConexao;
begin
   Result:= Self.Create(parametros);

end;

end.

