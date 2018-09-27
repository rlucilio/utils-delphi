unit Model.Conexao.SQLLite;

interface

uses Model.Conexao, Model.Conexao.interfaces, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, System.Classes, Model.Conexao.Construtor;

type
   TModelConexaoSQLITE = class(TModelConexao)
   private
      constructor Create(parametrosConexao: TStrings);
   public
      class function New(parametrosConexao: TStrings = nil): iModelConexao;
      function criarBanco(script: TStrings): iModelConexao;override;
      destructor Destroy; override;
   end;

implementation

{ TModelConexaoSQLITE }

constructor TModelConexaoSQLITE.Create(parametrosConexao: TStrings);
begin
   inherited Create;

   if Assigned(parametrosConexao) then
   begin
      Conexao.Params.Clear;
      Conexao.Connected:= false;
      Conexao.Params.AddStrings(parametrosConexao);
      Conexao.Connected:= true;
   end;
end;




function TModelConexaoSQLITE.criarBanco(script: TStrings): iModelConexao;
begin
   result:= self;
   TModelConstrutor.New(Conexao, script);
end;

destructor TModelConexaoSQLITE.Destroy;
begin

  inherited;
end;

class function TModelConexaoSQLITE.New(parametrosConexao: TStrings = nil): iModelConexao;
begin
   Result:= Self.Create(parametrosConexao);

end;

end.
