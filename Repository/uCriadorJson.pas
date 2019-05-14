unit uCriadorJson;

interface

uses
  {Delphi}
    System.SysUtils,
    System.Classes,
    System.JSON,
    System.JSON.Types,
    System.JSON.Writers,
    System.JSON.Builders,
    RTTI,
  {Criador Json}
    uCriadorJson.Interfaces;

type
  TCriadorJson = class
  private
    _aberto: Boolean;
    Fbuilder:       TJSONObjectBuilder;
    Fwriter:        TJsonTextWriter;
    FstringWriter:  TStringWriter;
    FstringBuilter: TStringBuilder;

    FObjPrincipal:  TJSONCollectionBuilder.TPairs;
    procedure TratarJson(var resultado: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Inicio;
    procedure Fim;
    procedure AddObj(const aKey: string;const obj: TObject); overload;
    procedure AddObj<T: IPodeSerJson>(const aKey: string; const obj: T); overload;
    procedure AddValue(const aKey: string; const value: TValue);
    procedure AddArray(const aKey: string; const value: TArray<TObject>); overload;
    procedure AddArray<T: IPodeSerJson>(const aKey: string; const value: TArray<T>); overload;
    procedure AddArrayValue<T>(const aKey: string; const value: TArray<T>);
    function AsJsonObj: TJSONObject;
    function AsJsonStr: string;
  end;

implementation

{ TCriadorJson }

uses
  {delphi}
    Rest.JSON;


procedure TCriadorJson.AddArrayValue<T>(const aKey: string; const value: TArray<T>);
var
  it: T;
  FArray: TJSONCollectionBuilder.TElements;
  valor: TValue;
begin
  FArray:= FObjPrincipal.BeginArray(aKey);
  for it in value do
  begin
    valor:= TValue.From<T>(it);
    FArray.Add(valor.AsString);
  end;
  FArray.EndArray;
end;

procedure TCriadorJson.AddObj<T>(const aKey: string; const obj: T);
var
  objJsonStr: string;
begin

  objJsonStr:= obj.AsJson;

  FObjPrincipal.Add(aKey, objJsonStr);
end;

procedure TCriadorJson.AddArray(const aKey: string; const value: TArray<TObject>);
var
  objJsonStr: string;
  it: TObject;
  FArray: TJSONCollectionBuilder.TElements;
begin
  FArray:= FObjPrincipal.BeginArray(aKey);
  for it in value do
  begin
    objJsonStr:= TJson.ObjectToJsonString(it);

    FArray.Add(objJsonStr);
  end;
  FArray.EndArray;
end;

procedure TCriadorJson.AddArray<T>(const aKey: string;const value: TArray<T>);
var
  objJsonStr: string;
  it: T;
  FArray: TJSONCollectionBuilder.TElements;
begin
  FArray:= FObjPrincipal.BeginArray(aKey);
  for it in value do
  begin
    objJsonStr:= it.AsJson;

    FArray.Add(objJsonStr);
  end;
  FArray.EndArray;
end;

procedure TCriadorJson.AddObj(const aKey: string;const obj: TObject);
var
  objJsonStr: string;
begin
  objJsonStr:= TJson.ObjectToJsonString(obj);

  FObjPrincipal.Add(aKey, objJsonStr);
end;

procedure TCriadorJson.AddValue(const aKey: string; const value: TValue);
begin
  FObjPrincipal.Add(aKey, value);
end;

function TCriadorJson.AsJsonObj: TJSONObject;
begin
  result:= nil;
  if not _aberto then
  begin
    result:= TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(FstringBuilter.ToString()), 0) as TJSONObject;
  end;
end;

function TCriadorJson.AsJsonStr: string;
var
  resultado: string;
begin
  result:= '';
  if not _aberto then
  begin
    TratarJson(resultado);
    result:= resultado;
  end;
end;

procedure TCriadorJson.TratarJson(var resultado: string);
begin
  resultado := StringReplace(FstringBuilter.ToString, '\r', '', [rfReplaceAll]);
  resultado := StringReplace(resultado, '\n', '', [rfReplaceAll]);
  resultado := StringReplace(resultado, '\', '', [rfReplaceAll]);
  resultado := StringReplace(resultado, '"{"', '{"', [rfReplaceAll]);
  resultado := StringReplace(resultado, '"}"', '"}', [rfReplaceAll]);
  resultado := StringReplace(resultado, '"}]}"', '}]}', [rfReplaceAll]);
  resultado := StringReplace(resultado, '"},{', '},{', [rfReplaceAll]);
  resultado := StringReplace(resultado, '",{"', ',{"', [rfReplaceAll]);
  resultado := StringReplace(resultado, '"]}', ']}', [rfReplaceAll]);
  resultado := StringReplace(resultado, '"],', '],', [rfReplaceAll]);
end;

constructor TCriadorJson.Create;
begin
  FstringBuilter    := TStringBuilder.Create();
  FstringWriter     := TStringWriter.Create(FstringBuilter);
  Fwriter           := TJsonTextWriter.Create(FstringWriter);
  Fwriter.Formatting:= TJsonFormatting.None;
  Fbuilder          := TJSONObjectBuilder.Create(Fwriter);
end;

destructor TCriadorJson.Destroy;
begin
  FreeAndNil(fbuilder);
  FreeAndNil(fwriter);
  FreeAndNil(fstringWriter);
  FreeAndNil(fstringBuilter);
  inherited;
end;

procedure TCriadorJson.Fim;
begin
  if _aberto then
  begin
    FObjPrincipal.EndAll;

    _aberto:= false;
  end;
end;

procedure TCriadorJson.Inicio;
begin
  _aberto:= true;
  FObjPrincipal:= Fbuilder.BeginObject;
end;

end.
