unit uConexao;

interface

uses uConexao.interfaces, FireDAC.Stan.Intf,
   FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
   FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
   FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB,
   FireDAC.Comp.Client, FireDAC.Comp.UI, System.Classes;

type
   TConexao = class(TInterfacedObject, IConexao)
   private
      Fconexao: TFDConnection;
   protected
      constructor Create; reintroduce;
   public
      destructor Destroy; override;
      function Connection: TFDConnection;
      function SetConfigOfConnection(const params: TArray<string>): IConexao;

   end;

implementation

uses
  System.SysUtils;

{ TConexao }
function TConexao.Connection: TFDConnection;
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

  Fconexao.Connected:= true;
end;


end.
