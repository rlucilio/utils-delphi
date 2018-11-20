unit uRestCliente.Interfaces;

interface

uses
  System.Classes, REST.Types;

type
  IRestClient = interface
    ['{24B11D4C-02C6-42E6-8F09-CFEFCCD273FE}']
    function Ref: IRestClient;

    function AddParametro(const parametro: string; const value: Variant): IRestClient;
    function AddHeader(const parametro: string; const value: Variant): IRestClient;
    function AddCockie(const parametro: string; const value: Variant): IRestClient;
    function AddObj(const obj: TObject; const propriedades: TStrings= nil): IRestClient;
    function AddItem(const nome: string; const value: TStream;
       tipoRequisicao: TRESTRequestParameterKind = pkGETorPOST;
       opcoes: TRESTRequestParameterOptions = [];
       tipo: TRESTContentType = ctNone): IRestClient;

    function GetResponse(const contentType: string): string;
  end;

implementation

end.
