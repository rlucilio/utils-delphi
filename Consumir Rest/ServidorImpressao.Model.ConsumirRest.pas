unit ServidorImpressao.Model.ConsumirRest;

interface

uses
   IPPeerClient, REST.Client, System.SysUtils,
   ServidorImpressao.Model.Interfaces,
   REST.Types;

type
   TModelConsumirRest = class(TInterfacedObject, iModelConsumirRest)
   private
      FRESTClient: TRESTClient;
      FRESTRequest: TRESTRequest;
      FRESTResponse: TRESTResponse;
      FURL: string;
      FURI: string;
      FJSON: string;
      FCodigoServidor: string;
      constructor Create;
   protected
      property JSON: string read FJSON write FJSON;
   public
      destructor Destroy; override;
      function SetCodigo(pValue: string): iModelConsumirRest;
      function GetJSON: string;
      class function New: iModelConsumirRest;
   end;

implementation

{ TModelConsumirRest }

constructor TModelConsumirRest.Create;
begin
   inherited Create;

   FRESTClient := TRESTClient.Create(nil);
   FRESTRequest := TRESTRequest.Create(nil);
   FRESTResponse := TRESTResponse.Create(nil);
   FRESTClient.ResetToDefaults;
   FRESTRequest.ResetToDefaults;

   FRESTClient.Accept :=
     'application/json, text/plain; q=0.9, text/html;q=0.8,';
   FRESTClient.AcceptCharset := 'UTF-8, *;q=0.8';

   FRESTRequest.Client := FRESTClient;
   FURI := '/?chaveCliente={CODIGO}&random={RANDOM}';
   FURL := 'http://siclopadm.com.br/pizzaWeb/wbl_json_impressoes';
   JSON := '';
end;

destructor TModelConsumirRest.Destroy;
begin
   FRESTClient.Free;
   FRESTRequest.Free;
   FRESTResponse.Free;
   inherited;
end;

function TModelConsumirRest.GetJSON: string;
var
   vValida: Boolean;
   vRandom: string;
begin
   vValida := (FURL <> '') and (FURI <> '');
   if vValida then
   begin

      FRESTRequest.Method := rmGET;
      FRESTClient.BaseURL := FURL;
      FRESTRequest.Resource := FURI;

      Randomize;
      vRandom := IntToStr(Random(1000000));

      FRESTRequest.Params.AddUrlSegment('CODIGO', FCodigoServidor);
      FRESTRequest.Params.AddUrlSegment('RANDOM', vRandom);
      FRESTRequest.Execute;
      FRESTRequest.Response.ContentType := 'application/json';

      if FRESTRequest.Response.StatusCode = 200 then
      begin
         Result := FRESTRequest.Response.Content;
      end
      else
         raise Exception.Create('Erro no HTTP' +
           FRESTRequest.Response.StatusText);

   end
   else
      raise Exception.Create('Falta preencher a URL e o URI do serviço');

end;

class function TModelConsumirRest.New: iModelConsumirRest;
begin
   Result := self.Create;
end;

function TModelConsumirRest.SetCodigo(pValue: string): iModelConsumirRest;
begin
   FCodigoServidor := pValue;
end;

end.
