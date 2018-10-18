unit Model.Conexao.Query;

interface

uses Model.Conexao.interfaces, FireDAC.Stan.Intf,
   FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
   FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
   FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
   System.SysUtils;

type
   TModelQuery = class(TInterfacedObject, iModelQuery)
   private
      fconexao: TFDConnection;
      Fquery: TStringBuilder;
      constructor Create(Conexao: iModelConexao);
      function getQuery: TStringBuilder;
      procedure setQuery(const Value: TStringBuilder);
   public
      destructor Destroy; override;
      class function New(Conexao: iModelConexao): iModelQuery;
      function execQueryComRetorno(var dados: TDataSet): iModelQuery;
      function execQuery: iModelQuery;
      property Query: TStringBuilder read getQuery write setQuery;
   end;

implementation

uses
   Model.Conexao;

{ TModelQuery }

constructor TModelQuery.Create(Conexao: iModelConexao);
begin
   inherited Create;
   fconexao := TModelConexao(Conexao).Conexao;
   Fquery := TStringBuilder.Create;
end;

destructor TModelQuery.Destroy;
begin
   FreeAndNil(Fquery);
   inherited;
end;

function TModelQuery.execQuery: iModelQuery;
var
   qry: TFDQuery;
begin
   result := self;

   qry := TFDQuery.Create(nil);
   try
      try
         qry.Connection := fconexao;
         qry.SQL.Text := Query.ToString;
         qry.ExecSQL;
      except
         raise Exception.Create('Houve um erro ao executar a query de ação');
      end;

   finally
      FreeAndNil(qry);
   end;
end;

function TModelQuery.execQueryComRetorno(var dados: TDataSet): iModelQuery;
var
   qry: TFDQuery;
begin
   result := self;
   qry := TFDQuery.Create(nil);
   try
      qry.Connection := fconexao;
      qry.Close;
      qry.SQL.Add(Query.ToString);
      qry.Open();
      dados := qry;
   except
      FreeAndNil(qry);
      raise Exception.Create('Erro ao executar a querty');
   end;
end;

function TModelQuery.getQuery: TStringBuilder;
begin
   result := Fquery;
end;

class function TModelQuery.New(Conexao: iModelConexao): iModelQuery;
begin
   result := self.Create(Conexao);
end;

procedure TModelQuery.setQuery(const Value: TStringBuilder);
begin
   Fquery := Value;
end;

end.
