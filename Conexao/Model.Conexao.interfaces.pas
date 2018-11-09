unit Model.Conexao.interfaces;

interface

uses
   System.Classes, Data.DB, System.SysUtils, System.Rtti, ormbr.factory.interfaces;

type
   TProcDS = reference to procedure(dataSet: TDataSet);
   iModelConexao = interface
      ['{BCF11EBC-8927-4132-9F3C-65AE7C60D5BC}']
      function Conn: IDBConnection;
      function Conexao: TCustomConnection;
   end;

   iModelCriarBanco = interface
      ['{714B0940-056C-4AB1-AD93-7D346D3AF7D5}']
      function criarBanco(script: TStrings): iModelConexao;
   end;

   iModelQuery = interface
      ['{5D00397F-E1E6-47B0-BC4F-337EA2E01602}']
      function open: iModelQuery;
      procedure exec;
      function Table(const tableNome: string): IModelQuery;
      function FieldsNames(const campos: TArray<string>): iModelQuery;
      function Where(const whr: string): iModelQuery;
      function WhereAnd(const whr: string): iModelQuery;
      function WhereOR(const whr: string): iModelQuery;
      function ParamValue(const paramName: string; const value: TValue): IModelQuery;
      function DoQuery(proc: TProcDS):IModelQuery; overload;
      function DoQuery:TDataSet; overload;
      function Join(const tableName, codicaoJoin :string): iModelQuery;
      function FieldByName(const fieldByName: string): TField;
      function RowsAffected: integer;
      function GroupBy(const groupSQL: string): iModelQuery;
      function OrderBy(const orderSQL: string): iModelQuery;
      function setField(const fieldName: string; const paramName: string): ImodelQuery;
      function ToJson(alias: string = ''): string;
      function getSQL: string;
   end;

implementation

end.
