unit uConexao.MySQL;

interface

uses
   FireDAC.Phys.MySQL,
   FireDAC.Phys.MySQLDef,
   uConexao,
   uConexao.interfaces,
   ormbr.dml.generator.mysql;

type
  TParamsMySQL = record
    Database: string;
    User_name: string;
    Password: string;
    Server: string;
    Port: string;
  end;

  TConexaoMySQL = class(TConexao)
  private
  public
    constructor Create(const parametros: TParamsMySQL);
    class function New(const parametros: TParamsMySQL): iConexao;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TConexaoMySQL }

constructor TConexaoMySQL.Create(const parametros: TParamsMySQL);
var
  _parametros: TStringBuilder;
begin
  inherited Create();

  _parametros:= TStringBuilder.Create();
  try
   _parametros
    .Append('DriverID=').Append('MySQL').Append(';')
    .Append('Database=').Append(parametros.Database).Append(';')
    .Append('User_Name=').Append(parametros.User_name).Append(';')
    .Append('Password=').Append(parametros.Password).Append(';')
    .Append('Server=').Append(parametros.Server).Append(';')
    .Append('Port=').Append(parametros.Port).Append(';');

   SetConfigOfConnection(_parametros.ToString);
  finally
    FreeAndNil(_parametros);
  end;
end;

destructor TConexaoMySQL.Destroy;
begin

  inherited;
end;

class function TConexaoMySQL.New(const parametros: TParamsMySQL): iConexao;
begin
  Result:= Self.Create(parametros);
end;

end.
