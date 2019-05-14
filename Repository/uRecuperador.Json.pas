unit uRecuperador.Json;

interface

uses
  {Delphi}
    System.Json,
    System.Generics.Collections,
    RTTI,
  {RestClient}
    uRestCliente.Interfaces,
    uRestCliente,
  {Repositorio}
    uRepositorio.Interfaces,
  {Resource}
    uResource.Strings,
  {Helper}
    System.uJson;

type
  TRecuperadorJson<T: class, constructor> = class(TInterfacedObject, IRecuperador<T>)
  private
    Frest: IRestClient;
    FJson: string;
  public
    constructor Create(aRota, aAPI: string);
    destructor Destroy; override;

    procedure AddParam(const param: string);
    function GetJsonObject: TJSONObject;
    function GetJsonString: string;
    function GetDado: T;
    function GetDadoSimples(nome: string): TValue;
    function GetDados: TObjectList<T>;
  end;

implementation

uses
  {Delphi}
    System.SysUtils,
    Rest.JSON,
  {ORMBr}
    ormbr.json.utils;

{ TRecuperadorJson }

procedure TRecuperadorJson<T>.AddParam(const param: string);
begin
  Frest.AddParametro('params', param);
end;

constructor TRecuperadorJson<T>.Create(aRota, aAPI: string);
begin
  if aRota.IsEmpty then
    raise Exception.Create(MsgErroSemRota);

  aAPI:= '/'+ aAPI;

  if aRota.EndsWith('/') then
    Delete(aRota, Pred(Length(aRota)), 1);

//  Frest:= TRestCliente.Create(aRota, aAPI, USER_JSON, PASS_JSON);
  Frest:= TRestCliente.Create(aRota, aAPI);
  Frest.Ref;

  FJson:= Frest.GetResponse('application/Json');
end;

destructor TRecuperadorJson<T>.Destroy;
begin

  inherited;
end;

function TRecuperadorJson<T>.GetDado: T;
begin
  result:= TJson.JsonToObject<T>(FJson)
end;

function TRecuperadorJson<T>.GetDados: TObjectList<T>;
begin
  TORMBrJSONUtil.JSONObjectListToJSONArray<T>(result);
end;

function TRecuperadorJson<T>.GetDadoSimples(nome: string): TValue;
var
  json: TJSONObject;
begin
  json:= GetJsonObject;
  try
    Result:= json.GetValue(nome);
  finally
    json.Free;
  end;
end;

function TRecuperadorJson<T>.GetJsonObject: TJSONObject;
begin
  result:= TJSONObject.Parse(FJson);
end;

function TRecuperadorJson<T>.GetJsonString: string;
begin
  result:= FJson;
end;

end.
