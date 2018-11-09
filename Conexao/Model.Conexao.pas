unit Model.Conexao;

interface

uses Model.Conexao.interfaces, FireDAC.Stan.Intf,
   FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
   FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
   FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB,
   FireDAC.Comp.Client, FireDAC.Comp.UI, System.Classes, ormbr.factory.interfaces;

type
   TModelConexao = class(TInterfacedObject, iModelConexao)
   private
      Fconexao: TFDConnection;
   protected
      constructor Create;
      function Conn: IDBConnection;
      function Conexao: TCustomConnection;
   public
      destructor Destroy; override;
   end;

implementation

{ TModelConexao }

function TModelConexao.Conexao: TCustomConnection;
begin

end;

function TModelConexao.Conn: IDBConnection;
begin

end;

constructor TModelConexao.Create;
begin
   inherited Create;
   Fconexao := TFDConnection.Create(nil);
   Fconexao.ResourceOptions.SilentMode:= true;
end;

destructor TModelConexao.Destroy;
begin
   Conexao.Free;
   inherited;
end;

end.
