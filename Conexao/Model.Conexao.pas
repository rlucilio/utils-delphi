unit Model.Conexao;

interface

uses Model.Conexao.interfaces, FireDAC.Stan.Intf,
   FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
   FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
   FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB,
   FireDAC.Comp.Client, FireDAC.Comp.UI, System.Classes,
   Model.Conexao.Construtor;

type
   TModelConexao = class(TInterfacedObject, iModelConexao)
   private
      Fconexao: TFDConnection;
   protected
      constructor Create;
      property Conexao: TFDConnection read Fconexao write Fconexao;
      function criarBanco(script: TStrings): iModelConexao; virtual;abstract;
   public
      destructor Destroy; override;
   end;

implementation

{ TModelConexao }

constructor TModelConexao.Create;
begin
   inherited Create;
   Conexao := TFDConnection.Create(nil);
end;

destructor TModelConexao.Destroy;
begin
   Conexao.Free;
   inherited;
end;

end.
