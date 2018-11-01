unit Model.Conexao.Query;

interface

uses Model.Conexao.interfaces, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.SysUtils, System.Rtti, System.Classes;

type
  TTipoOperacaoCRUD = (tpcInsert, tpcUpdate, tpcDelete, tpcSelect);

  TQuery = class(TInterfacedObject, iModelQuery)
  private
    _TemWhere: Boolean;
    _TemOrder: Boolean;
    _TemGroupBy: Boolean;
    _LinhasAfetadas: integer;
    FDataSet: TFDQuery;
    FTipo: TTipoOperacaoCRUD;
    constructor Create(Conexao: TFDConnection; tipoOperacao: TTipoOperacaoCRUD);
  public
    destructor Destroy; override;
    class function New(Conexao: TFDConnection; tipoOperacao: TTipoOperacaoCRUD)
      : iModelQuery;
    function open: iModelQuery;
    procedure exec;
    function Table(const tableNome: string): iModelQuery;
    function FieldsNames(const campos: TArray<string>): iModelQuery;
    function Where(const whr: string): iModelQuery;
    function WhereAnd(const whr: string): iModelQuery;
    function WhereOR(const whr: string): iModelQuery;
    function ParamValue(const paramName: string; const value: Variant)
      : iModelQuery;
    function setField(const fieldName: string; const paramName: string)
      : iModelQuery;
    function DoQuery(proc: TProcDS): iModelQuery; overload;
    function DoQuery: TDataSet; overload;
    function Join(const tableName, codicaoJoin: string): iModelQuery;
    function FieldByName(const FieldByName: string): TField;
    function RowsAffected: integer;
    function GroupBy(const groupSQL: string): iModelQuery;
    function OrderBy(const orderSQL: string): iModelQuery;
    function ToJson: string;
    function getSQL: string;
  end;

implementation

uses
  Model.Conexao, System.Variants, DB.Helper;

{ TQuery }

constructor TQuery.Create(Conexao: TFDConnection;
  tipoOperacao: TTipoOperacaoCRUD);
begin
  inherited Create;
  FDataSet := TFDQuery.Create(nil);
  FDataSet.Connection := Conexao;
  FDataSet.Close;
  FTipo := tipoOperacao;
  _TemWhere := false;
  _TemOrder := false;
  _TemGroupBy := false;
  _LinhasAfetadas := 0;

  case FTipo of
    tpcInsert:
      FDataSet.SQL.Add('INSERT INTO &TABELA ');
    tpcUpdate:
      FDataSet.SQL.Add('UPDATE &TABELA ');
    tpcDelete:
      FDataSet.SQL.Add('DELETE FROM &TABELA ');
    tpcSelect:
      FDataSet.SQL.Add('SELECT &CAMPO FROM &TABELA ');
  end;
end;

destructor TQuery.Destroy;
begin
  FDataSet.Close;
  FreeAndNil(FDataSet);
  inherited;
end;

function TQuery.DoQuery(proc: TProcDS): iModelQuery;
begin
  Result := Self;

  if not Assigned(proc) or FDataSet.IsEmpty then
    Exit;

  proc(FDataSet);
end;

function TQuery.DoQuery: TDataSet;
begin
  Result := nil;
  if FDataSet.IsEmpty then
    Exit;

  Result := FDataSet;
end;

procedure TQuery.exec;
begin
  try
    if FDataSet.SQL.Text.Trim.IsEmpty or not FDataSet.IsEmpty or
      (FTipo = tpcSelect) then
      Exit;

    FDataSet.ExecSQL;
    _LinhasAfetadas := FDataSet.RowsAffected;
  except
    raise Exception.Create('Houve um erro ao executar a query de ação');
  end;
end;

function TQuery.FieldByName(const FieldByName: string): TField;
begin
  Result := nil;

  if FieldByName.Trim.IsEmpty or FDataSet.IsEmpty then
    Exit;

  Result := FDataSet.FieldByName(FieldByName.Trim);
end;

function TQuery.FieldsNames(const campos: TArray<string>): iModelQuery;
var
  _campos: string;
  item: string;
begin
  Result := Self;
  _campos := '';

  if (Length(campos) <= 0) or (FTipo <> tpcSelect) then
    Exit;

  for item in campos do
  begin
    if campos[pred(Length(campos))].Contains(item) then
      _campos := _campos + item.Trim + ', '
    else
      _campos := _campos + item.Trim;
  end;

  FDataSet.SQL.Text.Replace('&CAMPO', _campos.Trim);
end;

function TQuery.open: iModelQuery;
begin
  Result := Self;

  if FDataSet.SQL.Text.Trim.IsEmpty or not FDataSet.IsEmpty or
    (FTipo <> tpcSelect) then
    Exit;

  try
    FDataSet.open();
  except
    raise Exception.Create('Erro ao executar a query');
  end;
end;

function TQuery.OrderBy(const orderSQL: string): iModelQuery;
begin
  Result := Self;

  if orderSQL.Trim.IsEmpty or not _TemWhere or _TemOrder or _TemGroupBy then
    Exit;

  FDataSet.SQL.Add('ORDER BY');
  FDataSet.SQL.Add(orderSQL.Trim);
  _TemOrder := true;
end;

function TQuery.ParamValue(const paramName: string; const value: Variant)
  : iModelQuery;
begin
  Result := Self;

  if paramName.Trim.IsEmpty or VarIsClear(value) then
    Exit;

  FDataSet.ParamByName(paramName.Trim).value := value;
end;

function TQuery.RowsAffected: integer;
begin
  Result := _LinhasAfetadas;
end;

function TQuery.setField(const fieldName: string; const paramName: string)
  : iModelQuery;
begin
  Result := Self;

  if fieldName.Trim.IsEmpty or _TemWhere or _TemOrder or _TemGroupBy or
    not(FTipo in [tpcInsert, tpcUpdate]) then
    Exit;

  if FDataSet.SQL.Text.Contains('SET') then
  begin
    FDataSet.SQL.Add(Concat(', ', fieldName.Trim, ' = ', ':', paramName.Trim));
  end
  else
  begin
    FDataSet.SQL.Add('SET');
    FDataSet.SQL.Add(Concat(fieldName.Trim, ' = ', ':', paramName.Trim));
  end;

end;

function TQuery.getSQL: string;
begin
  Result := FDataSet.SQL.Text;
end;

function TQuery.GroupBy(const groupSQL: string): iModelQuery;
begin
  Result := Self;

  if groupSQL.Trim.IsEmpty or not _TemWhere or _TemOrder or _TemGroupBy then
    Exit;

  FDataSet.SQL.Add('GROUP BY');
  FDataSet.SQL.Add(groupSQL.Trim);
  _TemGroupBy := true;
end;

function TQuery.Join(const tableName, codicaoJoin: string): iModelQuery;
begin
  Result := Self;

  if tableName.Trim.IsEmpty or codicaoJoin.Trim.IsEmpty or _TemWhere or
    _TemOrder or _TemGroupBy then
    Exit;

  FDataSet.SQL.Add('JOIN');
  FDataSet.SQL.Add(Concat(tableName.Trim, ' ON '));
  FDataSet.SQL.Add(codicaoJoin.Trim);
end;

class function TQuery.New(Conexao: TFDConnection;
  tipoOperacao: TTipoOperacaoCRUD): iModelQuery;
begin
  Result := Self.Create(Conexao, tipoOperacao);
end;

function TQuery.Table(const tableNome: string): iModelQuery;
var
  I: Integer;
begin
  Result := Self;

  if tableNome.Trim.IsEmpty then
    Exit;

  FDataSet.SQL.Text.Replace('&TABELA', tableNome.Trim);
end;

function TQuery.ToJson: string;
begin
  Result := '';

  if FDataSet.IsEmpty then
    Exit;

  Result := FDataSet.ToJson();
end;

function TQuery.Where(const whr: string): iModelQuery;
begin
  Result := Self;
  if whr.Trim.IsEmpty or _TemWhere then
    Exit;

  _TemWhere := true;
  FDataSet.SQL.Add(' WHERE ');
  FDataSet.SQL.Add(whr.Trim);
end;

function TQuery.WhereAnd(const whr: string): iModelQuery;
begin
  Result := Self;
  if whr.Trim.IsEmpty or not _TemWhere or _TemOrder or _TemGroupBy then
    Exit;

  FDataSet.SQL.Add(' AND ');
  FDataSet.SQL.Add(whr.Trim);
end;

function TQuery.WhereOR(const whr: string): iModelQuery;
begin
  Result := Self;
  if whr.Trim.IsEmpty or not _TemWhere or _TemOrder or _TemGroupBy then
    Exit;

  FDataSet.SQL.Add(' OR ');
  FDataSet.SQL.Add(whr.Trim);
end;

end.
