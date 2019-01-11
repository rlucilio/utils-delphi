unit
  uRelatorio.Matricial;

interface

uses
  uRelatorio.Interfaces,
  System.Classes;

type
  TRelatorioMatricial = class(TInterfacedObject, iRelatorio)
  private
    FArquivoTxt: TStringList;
    procedure Modificado(Sender: TObject);
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

uses
  Model.LibUtil,
  System.SysUtils,
  uRelatorio.Linhas;

{ TRelatorioMatricial }

function TRelatorioMatricial.addInformacaoImportante(
  informacaoImportante: IInformacaoImportante): iRelatorio;
var
  tratamentoLinhas: ITratamentoLinhas;
  titulo, informacoes: TArray<string>;
begin
  Result:= self;
  tratamentoLinhas:= TTratamentoLinhas.New();
  if Assigned(informacaoImportante) then
  begin
    if not(informacaoImportante.Titulo.IsEmpty) then
    begin
      titulo:= tratamentoLinhas.TratarLinha(informacaoImportante.Titulo, 24);
      titulo:= tratamentoLinhas.AlinharLinhas(titulo, 24, atCenter);

      tratamentoLinhas.AddLinhas(titulo, FArquivoTxt, EXPANDIR_ATIVA);
    end;

    if informacaoImportante.Informacoes.Count > 0 then
    begin
      informacoes:= tratamentoLinhas.TratarLinhas(informacaoImportante.Informacoes.ToArray, 48);
      informacoes:= tratamentoLinhas.AlinharLinhas(informacoes, 28, atLeft);
      tratamentoLinhas.AddLinhas(informacoes, FArquivoTxt);
    end;
  end;
end;

function TRelatorioMatricial.addInformacaoRodape(
  informacaoRodape: IInformacaoRodape): iRelatorio;
var
  tratamentoLinhas: ITratamentoLinhas;
  linhas: TArray<string>;
begin
  Result:= self;
  tratamentoLinhas:= TTratamentoLinhas.New();
  if Assigned(informacaoRodape) then
  begin
    if informacaoRodape.Linhas.Count > 0 then
    begin
      linhas:= tratamentoLinhas.TratarLinhas(informacaoRodape.Linhas.ToArray, 60);
      linhas:= tratamentoLinhas.AlinharLinhas(linhas, 60, atCenter);
      tratamentoLinhas.AddLinhas(linhas, FArquivoTxt, CONDESADO_ATIVA);
    end;
  end;
end;

function TRelatorioMatricial.addInformacaoSimples(
  informacaoSimples: IInformacaoSimples): iRelatorio;
var
  tratamentoLinhas: ITratamentoLinhas;
  titulo, informativo: TArray<string>;
begin
  Result:= self;
  tratamentoLinhas:= TTratamentoLinhas.New();
  if Assigned(informacaoSimples) then
  begin
    if not(informacaoSimples.Titulo.IsEmpty) and not(informacaoSimples.Informativo.IsEmpty)then
    begin
      titulo:= tratamentoLinhas.TratarLinha(informacaoSimples.Titulo, 24);
      informativo:= tratamentoLinhas.TratarLinha(informacaoSimples.Informativo, 24);
      tratamentoLinhas.AddLinhasKeyValue(titulo, informativo, 48, FArquivoTxt, NEGRITO_ATIVA);
      Exit(self);
    end;

    if not(informacaoSimples.Titulo.IsEmpty) then
    begin
      titulo:= tratamentoLinhas.TratarLinha(informacaoSimples.Titulo, 48);
      tratamentoLinhas.AddLinhas(titulo, FArquivoTxt, NEGRITO_ATIVA);
      Exit(self);
    end;

    if not(informacaoSimples.Informativo.IsEmpty) then
    begin
      informativo:= tratamentoLinhas.TratarLinha(informacaoSimples.Titulo, 48);
      tratamentoLinhas.AddLinhas(titulo, FArquivoTxt);
      Exit(self);
    end;
  end;
  Result:= self;
end;

function TRelatorioMatricial.addInformacoesLista(
  informacaoLista: IInformacaoLista): iRelatorio;
var
  tratamentoLinhas: ITratamentoLinhas;
begin
  Result:= self;
  tratamentoLinhas:= TTratamentoLinhas.New();
  if Assigned(informacaoLista) then
  begin
    if (informacaoLista.Colunas.Count > 0) and (informacaoLista.QtdMaxCaracteres.Count > 0) then
      tratamentoLinhas.AddLinhasColunadas(informacaoLista.Colunas.ToArray,
        informacaoLista.QtdMaxCaracteres.ToArray, FArquivoTxt);
  end;

  Result:= self;
end;

constructor TRelatorioMatricial.Create;
begin
  FArquivoTxt:= TStringList.Create();
  FArquivoTxt.OnChange:= Modificado;
end;

destructor TRelatorioMatricial.Destroy;
begin
  FArquivoTxt.Free;
  inherited;
end;

function TRelatorioMatricial.imprimir(nomeImpressao, nomeComputador,
  nomeImpressora: string; const preview: boolean): iRelatorio;
var
  printer: TextFile;
  nomeDaImpressora: string;
  it: string;
begin
  Result:= self;
  nomeDaImpressora:= Concat('\\', nomeComputador, '\',nomeDaImpressora);
  try
    try
      AssignFile(printer, nomeDaImpressora);
      for it in FArquivoTxt do
      begin
        Writeln(printer, it);
      end;
    except
      raise Exception.Create('Impressora Não encontrada');
    end;
  finally
    CloseFile(printer);
  end;
end;

//var
//  nomeComputadorLocal: string;
//begin
//  result := self;
//  fRelatorio.Title := UpperCase(nomeImpressao);
//
//  nomeComputadorLocal := UpperCase(GetLocalComputerName);
//  if (nomeComputador.IsEmpty) or (nomeImpressora.IsEmpty) then
//    raise Exception.Create('Nome do computador ou da impressora inválido');
//
//  nomeComputador := UpperCase(nomeComputador);
//  nomeImpressora := UpperCase(nomeImpressora);
//
//  if nomeComputador = nomeComputadorLocal then
//    RLPrinter.PrinterName := nomeImpressora
//  else
//    RLPrinter.PrinterName := '\\' + nomeComputador + '\' + nomeImpressora;
//
//  if preview then
//  begin
//    fRelatorio.preview();
//  end
//  else
//  begin
//    fRelatorio.Print;
//  end;
//
//
//  FreeAndNil(fRelatorio);
//
//end;

procedure TRelatorioMatricial.Modificado(Sender: TObject);
var
  it: string;
begin
  for it in FArquivoTxt do
  begin
    if it.IsEmpty then
      FArquivoTxt.Delete(FArquivoTxt.IndexOf(it));
  end;

end;

function TRelatorioMatricial.Ref: iRelatorio;
begin
  Result:= self;
end;

end.
