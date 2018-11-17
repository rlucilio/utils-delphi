unit uConexao.interfaces;

interface

uses
   System.Classes,
   System.SysUtils,
   System.Rtti,
   System.Generics.Collections,
   Data.DB,
   FireDAC.Comp.Client;

type
   TProcDS = reference to procedure(dataSet: TDataSet);

   IConexao = interface
      ['{BCF11EBC-8927-4132-9F3C-65AE7C60D5BC}']
      function Connection: TFDConnection;
      function SetConfigOfConnection(const params: string): IConexao;
   end;

   IDefCon = interface
    ['{0B887F5C-5932-4560-88CF-6C5FE046CE71}']
    function GetConexao: IConexao;
    procedure SetConexao(const Value: IConexao);
    property Conexao: IConexao read GetConexao write SetConexao;
    function Ref: IDefCon;
   end;

   IConexaoORM= interface
     ['{2FE8D173-E39D-4065-B359-0ECC7B064CBA}']
     function Ref: IConexaoORM;
   end;

   IQuery = interface
      ['{5D00397F-E1E6-47B0-BC4F-337EA2E01602}']
      function open: IQuery;
      procedure exec;
      function Table(const tableNome: string): IQuery;
      function FieldsNames(const campos: TArray<string>): IQuery;
      function Where(const whr: string): IQuery;
      function WhereAnd(const whr: string): IQuery;
      function WhereOR(const whr: string): IQuery;
      function ParamValue(const paramName: string; const value: TValue): IQuery;
      function DoQuery(proc: TProcDS):IQuery; overload;
      function DoQuery:TDataSet; overload;
      function Join(const tableName, codicaoJoin :string): IQuery;
      function FieldByName(const fieldByName: string): TField;
      function RowsAffected: integer;
      function GroupBy(const groupSQL: string): IQuery;
      function OrderBy(const orderSQL: string): IQuery;
      function setField(const fieldName: string; const paramName: string): IQuery;
      function ToJson(alias: string = ''): string;
      function getSQL: string;
   end;

implementation

end.
