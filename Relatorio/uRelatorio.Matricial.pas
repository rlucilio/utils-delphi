unit
  uRelatorio.Matricial;

interface

uses
  uRelatorio.Interfaces,
  System.Classes;

const
      DELAY                           = #27+'X';
      AVANCAR_BOBINA                  = #13;
      ESPACAMENTO                     = #27+'M';
      CONDESADO_ATIVA                 = #15;
      CONDESADO_DESATIVA              = #18;
      EXPANDIR_ATIVA                  = #27+'W'+'1';
      EXPANDIR_DESATIVA               = #27+'W'+'0';
      SOBRESCRITO_ATIVA               = #27+'S0';
      SUBESCRITO_ATIVA                = #27+'S1';
      SOBRESCRITO_SUBESCRITO_DESATIVA = #27+'T';
      SUBLINHADO_ATIVA                = #27+'-'+'1';
      SUBLINHADO_DESATIVA             = #27+'-'+'0';
      NEGRITO_ATIVA                   = #27+'E';
      NEGRITO_DESATIVA                = #27+'F';

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
    function imprimir(nomeImpressao, nomeComputador, nomeImpressora: string): iRelatorio;

    property ArquivoTxt: TStringList read FArquivoTxt;
  end;

implementation

uses
  Model.LibUtil,
  System.SysUtils,
  uRelatorio.Linhas,
  ACBrUtil;

{ TRelatorioMatricial }

function TRelatorioMatricial.addInformacaoImportante(
  informacaoImportante: IInformacaoImportante): iRelatorio;
var
  tratamentoLinhas: ITratamentoLinhas;
  titulo, informacoes: TArray<string>;
  _arquivo: TStrings;
begin
  _arquivo:= FArquivoTxt;
  Result:= self;
  tratamentoLinhas:= TTratamentoLinhas.New();
  if Assigned(informacaoImportante) then
  begin
    if not(informacaoImportante.Titulo.IsEmpty) then
    begin
      titulo:= tratamentoLinhas.TratarLinha(informacaoImportante.Titulo, 24);
      titulo:= tratamentoLinhas.AlinharLinhas(titulo, 24, atCenter);

      tratamentoLinhas.AddLinhas(titulo, _arquivo, EXPANDIR_ATIVA,EXPANDIR_DESATIVA);
    end;

    if informacaoImportante.Informacoes.Count > 0 then
    begin
      informacoes:= tratamentoLinhas.TratarLinhas(informacaoImportante.Informacoes.ToArray, 48);
      informacoes:= tratamentoLinhas.AlinharLinhas(informacoes, 48, atLeft);
      tratamentoLinhas.AddLinhas(informacoes, _arquivo);
    end;
  end;
end;

function TRelatorioMatricial.addInformacaoRodape(
  informacaoRodape: IInformacaoRodape): iRelatorio;
var
  tratamentoLinhas: ITratamentoLinhas;
  linhas: TArray<string>;
  _arquivo: TStrings;
begin
  _arquivo:= FArquivoTxt;
  Result:= self;
  tratamentoLinhas:= TTratamentoLinhas.New();
  if Assigned(informacaoRodape) then
  begin
    if informacaoRodape.Linhas.Count > 0 then
    begin
      linhas:= tratamentoLinhas.TratarLinhas(informacaoRodape.Linhas.ToArray, 60);
      linhas:= tratamentoLinhas.AlinharLinhas(linhas, 60, atCenter);
      tratamentoLinhas.AddLinhas(linhas, _arquivo, CONDESADO_ATIVA, CONDESADO_DESATIVA);
    end;
  end;
end;

function TRelatorioMatricial.addInformacaoSimples(
  informacaoSimples: IInformacaoSimples): iRelatorio;
var
  tratamentoLinhas: ITratamentoLinhas;
  titulo, informativo: TArray<string>;
  _arquivo: TStrings;
begin
  _arquivo:= FArquivoTxt;
  Result:= self;
  tratamentoLinhas:= TTratamentoLinhas.New();
  if Assigned(informacaoSimples) then
  begin
    if not(informacaoSimples.Titulo.IsEmpty) and not(informacaoSimples.Informativo.IsEmpty)then
    begin
      titulo:= tratamentoLinhas.TratarLinha(informacaoSimples.Titulo, 12);
      informativo:= tratamentoLinhas.TratarLinha(informacaoSimples.Informativo, 12);
      tratamentoLinhas.AddLinhasKeyValue(titulo, informativo, 24, _arquivo, NEGRITO_ATIVA+EXPANDIR_ATIVA, NEGRITO_DESATIVA+EXPANDIR_DESATIVA);
      Exit(self);
    end;

    if not(informacaoSimples.Titulo.IsEmpty) then
    begin
      titulo:= tratamentoLinhas.TratarLinha(informacaoSimples.Titulo, 48);
      tratamentoLinhas.AddLinhas(titulo, _arquivo, NEGRITO_ATIVA, NEGRITO_DESATIVA);
    end;

    if not(informacaoSimples.Informativo.IsEmpty) then
    begin
      informativo:= tratamentoLinhas.TratarLinha(informacaoSimples.Titulo, 48);
      tratamentoLinhas.AddLinhas(titulo, _arquivo);
    end;
  end;
end;

function TRelatorioMatricial.addInformacoesLista(
  informacaoLista: IInformacaoLista): iRelatorio;
var
  tratamentoLinhas: ITratamentoLinhas;
  _arquivo: TStrings;
begin
  _arquivo:= FArquivoTxt;
  Result:= self;
  tratamentoLinhas:= TTratamentoLinhas.New();
  if Assigned(informacaoLista) then
  begin
    if (informacaoLista.Colunas.Count > 0) and (informacaoLista.QtdMaxCaracteres.Count > 0) then
      tratamentoLinhas.AddLinhasColunadas(_arquivo, informacaoLista.Colunas.ToArray,
        informacaoLista.QtdMaxCaracteres.ToArray);
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

function TRelatorioMatricial.imprimir(nomeImpressao, nomeComputador, nomeImpressora: string): iRelatorio;
var
  print: TextFile;
  ondeVaiImprimir: string;
  it: string;
begin
  Result:= self;
  ondeVaiImprimir:= Concat('\\', nomeComputador, '\',nomeImpressora);
  try
    try
      AssignFile(print, ondeVaiImprimir);
      Rewrite(print);
      for it in ArquivoTxt do
      begin
        Writeln(print, RemoveAcento(it));
      end;

      Writeln(print, AVANCAR_BOBINA);
      Writeln(print, AVANCAR_BOBINA);
      Writeln(print, AVANCAR_BOBINA);
      Writeln(print, AVANCAR_BOBINA);
      Writeln(print, AVANCAR_BOBINA);
      Writeln(print, AVANCAR_BOBINA);
      Writeln(print, AVANCAR_BOBINA);

    except
      raise Exception.Create('Impressora Não encontrada');
    end;
  finally
    CloseFile(print);
  end;
end;

procedure TRelatorioMatricial.Modificado(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Pred(FArquivoTxt.Count) do
  begin
    if FArquivoTxt[I].IsEmpty then
      FArquivoTxt.Delete(I);
  end;
end;

function TRelatorioMatricial.Ref: iRelatorio;
begin
  Result:= self;
end;

end.
