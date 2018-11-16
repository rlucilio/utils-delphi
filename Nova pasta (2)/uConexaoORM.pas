unit uConexaoORM;

interface

uses
  uConexao.interfaces,
  ormbr.factory.interfaces,
  ormbr.container.objectset.interfaces,
  ormbr.factory.firedac,
  FireDAC.Comp.Client;

type
  TConexaoORM = class(TInterfacedObject, IConexaoORM)
  private
    FConexaoORM: IDBConnection;
  public
    constructor Create(conexao: TFDConnection; driverName: TDriverName);
    destructor Destroy(); override;
    function Ref: IConexaoORM;
    function DAO<T: class, constructor>(const quantidadeRegistro: integer = -1): IContainerObjectSet<T>;
  end;

implementation

uses
  System.SysUtils, ormbr.container.objectset;

{ TConexaoORM }

constructor TConexaoORM.Create(conexao: TFDConnection; driverName: TDriverName);
begin
  if not Assigned(conexao) then
    raise Exception.Create('Conexão não instanciada');


  FConexaoORM:= TFactoryFireDAC.Create(conexao, driverName);

end;

function TConexaoORM.DAO<T>(const quantidadeRegistro: integer): IContainerObjectSet<T>;
begin
  Result:= TContainerObjectSet<T>.Create(FConexaoORM, quantidadeRegistro);
end;

destructor TConexaoORM.Destroy;
begin
  inherited;
end;

function TConexaoORM.Ref: IConexaoORM;
begin
  result:= self;
end;

end.
