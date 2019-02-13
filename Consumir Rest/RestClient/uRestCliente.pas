unit uRestCliente;

interface

uses
  REST.Client,
  uRestCliente.Interfaces,
  REST.Authenticator.Basic,
  System.Classes,
  REST.Types,
  IPPeerClient,
  System.Json;

type
  TRestCliente = class(TInterfacedObject, IRestClient)
  private
    FURL: string;
    FURI: string;
    FRest: TRESTClient;
    FRequest: TRESTRequest;
    FBasicAutheticator: THTTPBasicAuthenticator;
    procedure SetURL(const Value: string);
  public
    function Ref: IRestClient;
    class function New(_url,_uri: string; typeRequest :TRESTRequestMethod = rmGET): IRestClient; overload;
    class function New(_url,_uri, _user, _pass: string; typeRequest :TRESTRequestMethod = rmGET): IRestClient; overload;
    constructor Create(_url,_uri: string; typeRequest :TRESTRequestMethod = rmGET); overload;
    constructor Create(_url,_uri, _user, _pass: string; typeRequest :TRESTRequestMethod = rmGET); overload;
    destructor Destroy; override;

    property URL:  string      read FURL write SetURL;
    property URI:  string      read FURI;
    property Rest: TRESTClient read FRest write FRest;

    function AddParametro(const parametro: string; const value: Variant): IRestClient;
    function AddHeader(const parametro: string; const value: Variant): IRestClient;
    function AddCockie(const parametro: string; const value: Variant): IRestClient;
    function AddObj(const obj: TObject; const propriedades: TStrings= nil): IRestClient;
    function AddItem(const nome: string; const value: TStream;
       tipoRequisicao: TRESTRequestParameterKind = pkGETorPOST;
       opcoes: TRESTRequestParameterOptions = [];
       tipo: TRESTContentType = ctNone): IRestClient;

    function GetResponse(const contentType: string): string; overload;
    function GetResponse(): TJSONObject; overload;

    function SetTypeRequest(typeRequest :TRESTRequestMethod): IRestClient;
    { TODO : Adicionar método async }
  end;

implementation

uses
  System.SysUtils,
  System.Variants,
  ormbr.json.utils;

{ TRestCliente }

function TRestCliente.AddObj(const obj: TObject; const propriedades: TStrings= nil): IRestClient;
begin
  Result:= self;
  FRequest
    .Params
      .AddObject(obj, propriedades);
end;

function TRestCliente.AddCockie(const parametro: string; const value: Variant): IRestClient;
begin
  Result:= Self;
  FRequest
    .Params
      .AddCookie(parametro, VarToStr(value));

end;

function TRestCliente.AddHeader(const parametro: string; const value: Variant): IRestClient;
begin
  Result:= self;
  FRequest
    .Params
      .AddHeader(parametro, VarToStr(value));
end;

function TRestCliente.AddItem(const nome: string; const value: TStream;
       tipoRequisicao: TRESTRequestParameterKind;
       opcoes: TRESTRequestParameterOptions;
       tipo: TRESTContentType): IRestClient;
begin
  Result:= self;
  FRequest
    .Params
      .AddItem(
      {AName} nome,
      {AValue} value,
      {AKind} tipoRequisicao,
      {AOptions} opcoes,
      {AContentType} tipo
      );
end;

function TRestCliente.AddParametro(const parametro: string; const value: Variant): IRestClient;
begin
  result:= self;
  FRequest
    .Params
      .AddUrlSegment(parametro, VarToStr(value));

end;

constructor TRestCliente.Create(_url,_uri, _user, _pass: string; typeRequest :TRESTRequestMethod);
begin
  Create(_url, _uri, typeRequest);
  FBasicAutheticator:= THTTPBasicAuthenticator.Create(_user, _pass);
  FRest.Authenticator:= FBasicAutheticator;
end;

constructor TRestCliente.Create(_url,_uri: string; typeRequest :TRESTRequestMethod);
begin
  FURL:= _url;
  FURI:= _uri;

  FRest     := TRESTClient.Create(nil);
  FRequest  := TRESTRequest.Create(nil);

  FRest.ResetToDefaults;
  FRequest.ResetToDefaults;

  FRest.BaseURL       := URL;
  FRest.AcceptCharset := 'utf-8, iso-8859-1;q=0.5';
  FRest.AcceptEncoding:= 'br;q=1.0, gzip;q=0.8, *;q=0.1';
  FRest.Accept        := 'application/json, text/plain, text/html, application/xml; q=0.9,*/*;q=0.8';

  FRequest.Client  := FRest;
  FRequest.Method  := typeRequest;

  if not(URI.IsEmpty) then
    FRequest.Resource:= URI;

end;

destructor TRestCliente.Destroy;
begin
  FreeAndNil(FRest);
  FreeAndNil(FRequest);

  if Assigned(FBasicAutheticator) then
  begin
    FreeAndNil(FBasicAutheticator);
  end;
  inherited;
end;

function TRestCliente.GetResponse: TJSONObject;
begin
    try
      FRequest.Execute();
      FRequest.Response.ContentType:= 'application/json';
      Result:= TORMBrJSONUtil.JSONStringToJSONObject(FRequest.Response.Content);
    except
      result:= TJSONObject.Create();
    end;
end;


function TRestCliente.GetResponse(const contentType: string): string;
begin
  try
    FRequest.Execute();
    FRequest.Response.ContentType:= contentType;
    result:= FRequest.Response.Content;
  except
    result:= FRequest.Response.StatusText;
  end;
end;

class function TRestCliente.New(_url,_uri, _user, _pass: string; typeRequest :TRESTRequestMethod): IRestClient;
begin
  Result:= self.Create(_url, _uri, _user, _pass, typeRequest);
end;

class function TRestCliente.New(_url,_uri: string; typeRequest :TRESTRequestMethod): IRestClient;
begin
  result:= self.Create(_url, _uri, typeRequest);
end;

function TRestCliente.Ref: IRestClient;
begin
  Result:= self;
end;

function TRestCliente.SetTypeRequest(
  typeRequest: TRESTRequestMethod): IRestClient;
begin
  Result:= self;
  FRequest.Method:= typeRequest;
end;

procedure TRestCliente.SetURL(const Value: string);
begin
  FURL := Value;
  FRest.BaseURL:= FURL;
end;



end.
