unit uConexao;

interface

uses Conexao.interfaces, FireDAC.Stan.Intf,
   FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
   FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
   FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB,
   FireDAC.Comp.Client, FireDAC.Comp.UI, System.Classes, ormbr.factory.interfaces;

type
   TConexao = class(TInterfacedObject, IConexao)
   private
      Fconexao: TFDConnection;
      FconexaoDAO: IDBConnection;
   protected
      constructor Create;
   public
      destructor Destroy; override;
      function Connection: TCustomConnection;
      function SetConfigOfConnection(const params: TArray<string>): IConexao;
      function GetConnectionORM(driverName: TDriverName): IDBConnection;
   end;

implementation

uses
  ormbr.factory.firedac;

{ TConexao }
function TConexao.Connection: TCustomConnection;
begin
  result:= Fconexao;
end;

constructor TConexao.Create;
begin
   inherited Create;
   Fconexao := TFDConnection.Create(nil);
   Fconexao.ResourceOptions.SilentMode:= true;
end;

destructor TConexao.Destroy;
begin
   Fconexao.Free;
   inherited;
end;

function TConexao.GetConnectionORM(driverName: TDriverName): IDBConnection;
begin
  if Assigned(FconexaoDAO) then
    result:= FconexaoDAO
  else if Fconexao.Params.Count > 0 then
  begin
    FconexaoDAO:= TFactoryFireDAC.Create(Fconexao, driverName);
    Result:= FconexaoDAO;
  end;
end;

function TConexao.SetConfigOfConnection(
  const params: TArray<string>): IConexao;
var
  item: string;
begin
  result:= self;
  for item in params do
  begin
    Fconexao.Params.Add(item);
  end;
end;

end.
