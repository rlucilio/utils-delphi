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
      constructor Create(Conexao: TFDConnection);
   public
      class function New(Conexao: TFDConnection): iModelQuery;
      function execQueryComRetorno(var dados:TDataSet): iModelQuery;
      function execQuery:iModelQuery;
      destructor Destroy; override;
      property Query: TStringBuilder read Fquery write Fquery;
   end;

implementation

{ TModelQuery }

constructor TModelQuery.Create(Conexao: TFDConnection);
begin
   inherited Create;
   fconexao := Conexao;
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
   result:= self;

   qry:= TFDQuery.Create(nil);
   try
      try
         qry.Connection:= fconexao;
         qry.SQL:= Query.ToString;
         qry.ExecSQL;
      except
         raise Exception.Create('Houve um erro ao executar a query de ação');

      end;

   finally
      FreeAndNil(qry);
   end;
end;

function TModelQuery.execQueryComRetorno(var dados:TDataSet): iModelQuery;
var
   qry: TFDQuery;
begin
   result:= self;
   qry := TFDQuery.Create(nil);
   try
      qry.Connection := fconexao;
      qry.Close;
      qry.SQL.Add(Query.ToString);
      dados := qry;
   except
      FreeAndNil(qry);
      raise Exception.Create('Erro ao executar a querty');
   end;
end;

class function TModelQuery.New(Conexao: TFDConnection): iModelQuery;
begin
   Result := Self.Create(Conexao);
end;

end.
