unit uPersistencia.Json;

interface

uses
  {Delphi}
    System.Json,
    System.Generics.Collections,
    RTTI,
    REST.Types,
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
  TPersistenciaJson = class(TInterfacedObject, IPersistencia)
  private
    Frest: IRestClient;
    FConfirmacao: Boolean;
  public
    constructor Create(aRota, aAPI: string);
    destructor Destroy; override;

    property Confirmacao: Boolean read FConfirmacao;

    function SetDadoSimples(aKey: string; aValue: TValue): IPersistencia;
    function SetDados(aKey: string ;Obj: TObject): IPersistencia;
    function SetListaDados(aKey: string; ListaDados: TObjectList<TObject>): IPersistencia;

    function DeleteDado(aKey: string; aValue: TValue): IPersistencia;
    function GetConfirmacao: boolean;
  end;

implementation

uses
  {Delphi}
    System.SysUtils,
    REST.JSON,
  {ORMBr}
    ormbr.rest.json;

{ TPersistenciaJson<T> }

constructor TPersistenciaJson.Create(aRota, aAPI: string);
begin
    if aRota.IsEmpty then
    raise Exception.Create(MsgErroSemRota);

  aAPI:= '/'+ aAPI;

  if aRota.EndsWith('/') then
    Delete(aRota, Pred(Length(aRota)), 1);

  Frest:= TRestCliente.Create(aRota, aAPI, USER_JSON, PASS_JSON, rmPOST);
  Frest.Ref;
end;

function TPersistenciaJson.DeleteDado(aKey: string;
  aValue: TValue): IPersistencia;
var
  json: TJSONObject;
begin
  result:= self;
  Frest.SetTypeRequest(rmDELETE);

  Frest.AddParametro(aKey, aValue.AsVariant);
  json:=Frest.GetResponse;

  try
    FConfirmacao:= json.GetValue<Boolean>('result', false);
  finally
    json.Free;
  end;

end;

destructor TPersistenciaJson.Destroy;
begin

  inherited;
end;

function TPersistenciaJson.GetConfirmacao: boolean;
begin
  result:= FConfirmacao;
end;

function TPersistenciaJson.SetDados(aKey: string ;Obj: TObject):IPersistencia;
var
  json: TJSONObject;
  jsonString: string;
begin
  result:= self;
  jsonString:= TJson.ObjectToJsonString(obj);
  Frest.AddParametro(aKey, jsonString);
  json:=Frest.GetResponse;

  try
    FConfirmacao:= json.GetValue<Boolean>('result', false);
  finally
    json.Free;
  end;

end;

function TPersistenciaJson.SetDadoSimples(aKey: string;
  aValue: TValue): IPersistencia;
var
  json: TJSONObject;
begin
  result:= self;
  Frest.AddParametro(aKey, aValue.AsVariant);
  json:=Frest.GetResponse;
  try
    FConfirmacao:= json.GetValue<Boolean>('result', false);
  finally
    json.Free;
  end;

end;

function TPersistenciaJson.SetListaDados(aKey: string; ListaDados: TObjectList<TObject>): IPersistencia;
var
  json: TJSONObject;
  jsonString: string;
begin
  result:= self;
  jsonString:= TORMBrJson.ObjectListToJsonString(ListaDados);
  Frest.AddParametro(aKey, jsonString);
  json:=Frest.GetResponse;

  try
    FConfirmacao:= json.GetValue<Boolean>('result', false);
  finally
    json.Free;
  end;

end;

end.
