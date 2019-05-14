unit uConexao.Query;

interface

uses
  uConexao.interfaces,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Data.DB, ormbr.criteria;

type

  TQuery = class(TInterfacedObject, iQuery)
  private
    FDataSet: TFDQuery;
    FSQL: ICriteria;
  public
    destructor Destroy; override;
    constructor Create(conexao: TFDConnection);
    class function New(conexao: TFDConnection): iQuery;
    function Ref: iQuery;

    property DataSet: TFDQuery read FDataSet write FDataSet;
    property SQL: ICriteria read FSQL write FSQL;

    function Exec(): IQuery;
    function Open(): IQuery;
    function Clear(): IQuery;

    function ToJson(alias: string = ''): string;
  end;

implementation

uses
  DB.Helper;



{ TQuery }

function TQuery.Clear: IQuery;
begin
  result := self;

  sql.Clear();
end;

constructor TQuery.Create(conexao: TFDConnection);
begin
  FDataSet:= TFDQuery.Create(nil);
  FDataSet.Connection:= conexao;
  FSQL:= CreateCriteria;
end;

destructor TQuery.Destroy;
begin
  FDataSet.Close;
  FDataSet.Free;
  inherited;
end;

function TQuery.Exec: IQuery;
begin
  result:= Self;

  if SQL.IsEmpty then
    Exit;

  DataSet.Close;
  DataSet.SQL.Clear;
  DataSet.ExecSQL(sql.AsString);

end;

class function TQuery.New(conexao: TFDConnection): iQuery;
begin
  result:= self.Create(conexao);
end;

function TQuery.Open: IQuery;
begin
  result:= Self;

  if SQL.IsEmpty then
    Exit;

  DataSet.Close;
  DataSet.SQL.Clear;
  DataSet.Open(sql.AsString);
end;

function TQuery.Ref: iQuery;
begin
  result:= self;
end;

function TQuery.ToJson(alias: string): string;
begin
  Result:= FDataSet.ToJSON();
end;

end.
