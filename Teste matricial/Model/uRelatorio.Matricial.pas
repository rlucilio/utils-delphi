unit uRelatorio.Matricial;

interface

uses
  uRelatorio.Interfaces, System.Classes;

type
  TRelatorioMatricial = class(TInterfacedObject, iRelatorio)
  private
    FArquivoTxt: TStrings;
  public
    constructor Create();
    destructor Destroy; override;
    function Ref: iRelatorio;
    function addInformacaoImportante(informacaoImportante: IInformacaoImportante): iRelatorio;
    function addInformacaoSimples(informacaoSimples: IInformacaoSimples): iRelatorio;
    function addInformacaoRodape(informacaoRodape: IInformacaoRodape): iRelatorio;
    function addInformacoesLista(informacaoLista: IInformacaoLista): iRelatorio;
    function imprimir(nomeImpressao, nomeComputador, nomeImpressora: string;const preview: boolean): iRelatorio;
  end;

implementation

{ TRelatorioMatricial }

function TRelatorioMatricial.addInformacaoImportante(
  informacaoImportante: IInformacaoImportante): iRelatorio;
begin

end;

function TRelatorioMatricial.addInformacaoRodape(
  informacaoRodape: IInformacaoRodape): iRelatorio;
begin

end;

function TRelatorioMatricial.addInformacaoSimples(
  informacaoSimples: IInformacaoSimples): iRelatorio;
begin

end;

function TRelatorioMatricial.addInformacoesLista(
  informacaoLista: IInformacaoLista): iRelatorio;
begin

end;

constructor TRelatorioMatricial.Create;
begin
  FArquivoTxt:= TStringList.Create();
end;

destructor TRelatorioMatricial.Destroy;
begin
  FArquivoTxt.Free;
  inherited;
end;

function TRelatorioMatricial.imprimir(nomeImpressao, nomeComputador,
  nomeImpressora: string; const preview: boolean): iRelatorio;
begin

end;

function TRelatorioMatricial.Ref: iRelatorio;
begin
  Result:= self;
end;

end.
