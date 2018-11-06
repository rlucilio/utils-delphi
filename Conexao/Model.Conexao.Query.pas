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
    FSQL: TStringBuilder;
    FTipo: TTipoOperacaoCRUD;
    constructor Create(Conexao: TFDConnection; tipoOperacao: TTipoOperacaoCRUD);
    procedure ValueToStr(const value: TValue; var valueStr: string);
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
    function ParamValue(const paramName: string; const value: TValue)
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
    function ToJson(alias: string = ''): string;
    function getSQL(): string;
  end;

implementation

uses
  Model.Conexao, System.Variants, Rtti.Helper, DB.Helper;

{ TQuery }

constructor TQuery.Create(Conexao: TFDConnection;
  tipoOperacao: TTipoOperacaoCRUD);
begin
  inherited Create;
  FDataSet := TFDQuery.Create(nil);
  FDataSet.Connection := Conexao;
  FSQL:= TStringBuilder.Create();
  FDataSet.Close;
  FTipo := tipoOperacao;
  _TemWhere := false;
  _TemOrder := false;
  _TemGroupBy := false;
  _LinhasAfetadas := 0;

  case FTipo of
    tpcInsert:
      FSQL.Append('INSERT INTO &TABELA ');
    tpcUpdate:
      FSQL.Append('UPDATE &TABELA ');
    tpcDelete:
      FSQL.Append('DELETE FROM &TABELA ');
    tpcSelect:
      FSQL.Append('SELECT &CAMPO FROM &TABELA ');
  end;
end;

destructor TQuery.Destroy;
begin
  FDataSet.Close;
  FreeAndNil(FDataSet);
  FreeAndNil(FSQL);
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
    if getSQL().Trim.IsEmpty or not FDataSet.IsEmpty or
      (FTipo = tpcSelect) then
      Exit;

    FDataSet.SQL.Text:= getSQL();
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
    if not campos[pred(Length(campos))].Contains(item) then
      _campos := _campos + item.Trim + ', '
    else
      _campos := _campos + item.Trim;
  end;

  FSQL.Replace('&CAMPO', _campos.Trim);
end;

function TQuery.open: iModelQuery;
begin
  Result := Self;

  if getSQL().Trim.IsEmpty or not FDataSet.IsEmpty or
    (FTipo <> tpcSelect) then
    Exit;

  try
    FDataSet.SQL.Text:= getSQL();
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

  FSQL
    .AppendLine()
    .Append('ORDER BY')
    .AppendLine()
    .Append(orderSQL.Trim);

  _TemOrder := true;
end;

function TQuery.ParamValue(const paramName: string; const value: TValue)
  : iModelQuery;
var
  valueStr: string;
begin
  Result := Self;

  if paramName.Trim.IsEmpty or value.IsEmpty then
    Exit;

  ValueToStr(value, valueStr);

  FSQL.Replace(paramName.Trim, valueStr);
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
    FSQL.Append(Concat(', ', fieldName.Trim, ' = ', ':', paramName.Trim));
  end
  else
  begin
    FSQL.Append('SET');
    FSQL.Append(Concat(fieldName.Trim, ' = ', ':', paramName.Trim));
  end;

end;

function TQuery.getSQL(): string;
begin
  Result := FSQL.ToString();
end;

procedure TQuery.ValueToStr(const value: TValue; var valueStr: string);
begin
  if value.IsDateTime then
    valueStr := FormatDateTime('yyyy-mm-dd hh:nn:ss', value.AsType<TDateTime>).QuotedString;

  if value.IsDate then
    valueStr := FormatDateTime('yyyy-mm-dd', value.AsType<TDate>).QuotedString;

  if value.IsTime then
    valueStr := FormatDateTime('hh:nn:ss', value.AsType<TTime>).QuotedString;

  if value.IsType<string> then
    valueStr := value.ToString.QuotedString
  else
    valueStr:= value.ToString;

end;

function TQuery.GroupBy(const groupSQL: string): iModelQuery;
begin
  Result := Self;

  if groupSQL.Trim.IsEmpty or not _TemWhere or _TemOrder or _TemGroupBy then
    Exit;

  FSQL
    .AppendLine()
    .Append('GROUP BY')
    .AppendLine()
    .Append(groupSQL.Trim);

  _TemGroupBy := true;
end;

function TQuery.Join(const tableName, codicaoJoin: string): iModelQuery;
begin
  Result := Self;

  if tableName.Trim.IsEmpty or codicaoJoin.Trim.IsEmpty or _TemWhere or
    _TemOrder or _TemGroupBy then
    Exit;

  FSQL
    .AppendLine()
    .Append('JOIN')
    .AppendLine()
    .Append(Concat(tableName.Trim, ' ON '))
    .AppendLine()
    .Append(codicaoJoin.Trim);
end;

class function TQuery.New(Conexao: TFDConnection;
  tipoOperacao: TTipoOperacaoCRUD): iModelQuery;
begin
  Result := Self.Create(Conexao, tipoOperacao);
end;

function TQuery.Table(const tableNome: string): iModelQuery;
begin
  Result := Self;

  if tableNome.Trim.IsEmpty then
    Exit;

  FSQL.Replace('&TABELA', tableNome.Trim);
end;

function TQuery.ToJson(alias: string): string;
begin
  Result := '';

  if FDataSet.IsEmpty then
    Exit;

  Result := FDataSet.ToJson(alias);

end;

function TQuery.Where(const whr: string): iModelQuery;
begin
  Result := Self;
  if whr.Trim.IsEmpty or _TemWhere then
    Exit;

  _TemWhere := true;
  FSQL
    .AppendLine()
    .Append(' WHERE ')
    .AppendLine()
    .Append(whr.Trim);
end;

function TQuery.WhereAnd(const whr: string): iModelQuery;
begin
  Result := Self;
  if whr.Trim.IsEmpty or not _TemWhere or _TemOrder or _TemGroupBy then
    Exit;

  FSQL
    .AppendLine()
    .Append(' AND ')
    .AppendLine()
    .Append(whr.Trim);
end;

function TQuery.WhereOR(const whr: string): iModelQuery;
begin
  Result := Self;
  if whr.Trim.IsEmpty or not _TemWhere or _TemOrder or _TemGroupBy then
    Exit;

  FSQL
    .AppendLine()
    .Append(' OR ')
    .AppendLine()
    .Append(whr.Trim);
end;

end.
