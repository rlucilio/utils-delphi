unit uConexao.SQLITE;

interface

uses uConexao, uConexao.interfaces, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs;

type
  TParamsSQLite = record
    Database : string;
    User_Name: string;
    Password : string;
    Exclusive: Boolean;
    Encrypt  : Boolean;
  end;

   TConexaoSQLITE = class(TConexao)
   private
   public
      constructor Create(const parametros: TParamsSQLite);
      class function New(const parametros: TParamsSQLite): iConexao;
      destructor Destroy; override;
   end;

implementation

uses
  System.SysUtils;

{ TConexaoSQLITE }

constructor TConexaoSQLITE.Create(const parametros: TParamsSQLite);
var
  _parametros: TStringBuilder;
begin
   inherited Create();

   _parametros:= TStringBuilder.Create;
   try
    _parametros
      .Append('DriverID=SQLite').Append(';')
      .Append('Database=')      .Append(parametros.Database) .Append(';')
      .Append('User_Name')      .Append(parametros.User_Name).Append(';')
      .Append('Password')       .Append(parametros.Password) .Append(';');

    if FileExists(parametros.Database) then
    begin
      _parametros.Append('OpenMode=ReadWrite;');
    end;

    if parametros.Exclusive then
    begin
      _parametros.Append('LockingMode=Normal');
    end;

    if parametros.Encrypt then
    begin
      _parametros.Append('Encrypt=aes-ecb-256');
    end;

     SetConfigOfConnection(_parametros.ToString);
   finally
    _parametros.Free;
   end;

end;


destructor TConexaoSQLITE.Destroy;
begin

  inherited;
end;

class function TConexaoSQLITE.New(const parametros: TParamsSQLite): iConexao;
begin
   Result:= Self.Create(parametros);

end;

end.

