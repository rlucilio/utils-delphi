unit Conexao.interfaces;

interface

uses
   System.Classes,
   System.SysUtils,
   System.Rtti,
   System.Generics.Collections,
   Data.DB,
   ormbr.factory.interfaces,
   ormbr.container.objectset.interfaces;

type
   TProcDS = reference to procedure(dataSet: TDataSet);

   IConexao = interface
      ['{BCF11EBC-8927-4132-9F3C-65AE7C60D5BC}']
      function Connection: TCustomConnection;
      function SetConfigOfConnection(const params: TArray<string>): IConexao;
      function GetConnectionORM(driverName: TDriverName): IDBConnection;
   end;

   ICRUD<TEntidade: class, constructor> = interface
     ['{1B8C0077-3328-464F-B93F-16E369182C40}']
     function GetList: TObjectList<TEntidade>;
     procedure SetList(const value: TObjectList<TEntidade>);
     function DAO
      (conexao: IDBConnection; const CountRegister: integer):IContainerObjectSet<TEntidade>;
     property List: TObjectList<TEntidade> read GetList write SetList;
   end;

   ICriarBanco = interface
      ['{714B0940-056C-4AB1-AD93-7D346D3AF7D5}']
      function criarBanco(script: TStrings): IConexao;
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
