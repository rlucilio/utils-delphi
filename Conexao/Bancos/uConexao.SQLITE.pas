unit uConexao.SQLITE;

interface

uses
  uConexao,
  uConexao.interfaces,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  ormbr.dml.generator.sqlite;

type
   TParamsSQLite = record
     Database: string;
     User_Name: string;
     Password: string;
     Exclusive: Boolean;
     Encrypt: Boolean;
   end;

   TConexaoSQLITE = class(TConexao)
   private
   public
      constructor Create(const parametros:TParamsSQLite);
      class function New(const parametros:TParamsSQLite): iConexao;
      destructor Destroy; override;
   end;

implementation

uses
  System.SysUtils;

{ TConexaoSQLITE }

constructor TConexaoSQLITE.Create(const parametros:TParamsSQLite);
var
  _parametros: TStringBuilder;
begin
   inherited Create();
   _parametros:= TStringBuilder.Create;
   try


    _parametros
      .Append('DriverID=') .Append('SQLite')            .Append(';')
      .Append('Database=') .Append(parametros.Database) .Append(';');

    if not parametros.User_Name.IsEmpty then
    begin
      _parametros.Append('User_Name=').Append(parametros.User_Name).Append(';')
    end;

    if not parametros.Password.IsEmpty then
    begin
      _parametros.Append('Password=').Append(parametros.Password) .Append(';')
    end;

    if parametros.Exclusive then
      _parametros.Append('LockingMode=Exclusive;')
    else
      _parametros.Append('LockingMode=Normal;');

    if parametros.Encrypt then
      _parametros.Append('Encrypt=aes-ecb-256;')
    else
      _parametros.Append('Encrypt=No;');

    if FileExists(parametros.Database) then
      _parametros.Append('OpenMode=ReadWrite;')
    else
      _parametros.Append('OpenMode=CreateUTF8;');

    SetConfigOfConnection(_parametros.ToString);
   finally
    _parametros.Free
   end;
end;


destructor TConexaoSQLITE.Destroy;
begin

  inherited;
end;

class function TConexaoSQLITE.New(
  const parametros: TParamsSQLite): iConexao;
begin
  result:= self.Create(parametros);
end;

end.
