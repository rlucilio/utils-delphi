unit uRelatorio.Termica;

interface
uses
  uRelatorio.Interfaces,
  {$IFDEF FMX}
    FMX.Printers,
  {$ELSE}
    VCL.Printers,
  {$ENDIF}
  uRelatorio.Bloco,
  System.Generics.Collections,
  System.UITypes,
  Model.LibUtil,
  System.Classes;

type

  TRelatorioTermica = class(TInterfacedObject, iRelatorio)
  private
    FImpressora: TPrinter;
    FBlocosImpressao: TObjectList<TBlocoRelatorio>;
    FMargeEsquerda: integer;
    procedure ZerarConfiguracoes();
    procedure SetBloco(bloco: TBlocoRelatorio;var linhas: integer);
  public
    constructor Create(margeEsquerda: integer);
    destructor Destroy; override;

    property MargeEsquerda: integer read FMargeEsquerda write FMargeEsquerda;

    function addInformacaoImportante(informacaoImportante: IInformacaoImportante): iRelatorio;
    function addInformacaoSimples(informacaoSimples: IInformacaoSimples): iRelatorio;
    function addInformacaoRodape(informacaoRodape: IInformacaoRodape):iRelatorio;
    function addInformacoesLista(informacaoLista: IInformacaoLista): iRelatorio;
    function imprimir(nomeImpressao, nomeComputador, nomeImpressora: string): iRelatorio;
    function Ref: iRelatorio;
  end;

implementation

uses
  JclSysInfo,
  System.SysUtils,
  uRelatorio.Linhas;

{ TRelatorioTermica }

function TRelatorioTermica.addInformacaoImportante(informacaoImportante
  : iInformacaoImportante): iRelatorio;
var
  blocoTitulo: TBlocoRelatorio;
  blocoInformacoes: TBlocoRelatorio;
begin
  result := self;
  if Assigned(informacaoImportante) then
  begin

    if not(informacaoImportante.Titulo.IsEmpty) then
    begin
      blocoTitulo:= TBlocoRelatorio.Create;

      blocoTitulo.NomeBloco:= 'blocoTitulo';
      blocoTitulo.NomeFont:= 'Arial';
      blocoTitulo.TamanhoFont:= informacaoImportante.TamanhaoTitulo;
      blocoTitulo.StylesFont:= [TFontStyle.fsBold];
      blocoTitulo.OrientacaoTexto:= atRigth;
      blocoTitulo.QuantidadeCaracteres:= Trunc(informacaoImportante.QtdMaxCaracteres/2);
      blocoTitulo.Linhas:= [informacaoImportante.Titulo];
      FBlocosImpressao.Add(blocoTitulo);
    end;

    if Assigned(informacaoImportante.Informacoes) then
    begin
      blocoInformacoes:= TBlocoRelatorio.Create;

      blocoInformacoes.NomeBloco:= 'blocoInformacoes';
      blocoInformacoes.NomeFont:= 'Arial';
      blocoInformacoes.TamanhoFont:= informacaoImportante.TamanhoInformacoes;
      blocoInformacoes.StylesFont:= [TFontStyle.fsBold];
      blocoInformacoes.OrientacaoTexto:= atRigth;
      blocoInformacoes.QuantidadeCaracteres:= informacaoImportante.QtdMaxCaracteres;
      blocoInformacoes.Linhas:= informacaoImportante.Informacoes.ToArray;

      FBlocosImpressao.Add(blocoInformacoes);
    end;
  end;
end;

function TRelatorioTermica.addInformacaoRodape(informacaoRodape
  : iInformacaoRodape): iRelatorio;
var
  blocoRodape: TBlocoRelatorio;
begin
  result := self;
  if Assigned(informacaoRodape) then
  begin
    blocoRodape:= TBlocoRelatorio.Create();
    if informacaoRodape.Linhas.Count > 0 then
    begin
      blocoRodape.NomeBloco:= 'blocoRodape';
      blocoRodape.NomeFont:= 'Arial';
      blocoRodape.TamanhoFont:= informacaoRodape.Tamanho;
      blocoRodape.StylesFont:= [];
      blocoRodape.OrientacaoTexto:= atCenter;
      blocoRodape.QuantidadeCaracteres:= informacaoRodape.QtdMaxCaracteres;
      blocoRodape.Linhas:= informacaoRodape.Linhas.ToArray;
    end;
    FBlocosImpressao.Add(blocoRodape);
  end;
end;

function TRelatorioTermica.addInformacaoSimples(informacaoSimples
  : IinformacaoSimples): iRelatorio;
var
  _linhas: TStringList;
  titulo, informativo: TArray<string>;
  tratamentoLinhas: ITratamentoLinhas;
  blocoSimples: TBlocoRelatorio;
begin
  result := self;
  tratamentoLinhas:= TTratamentoLinhas.New();
  if Assigned(informacaoSimples) then
  begin
    blocoSimples:= TBlocoRelatorio.Create();
    if not(informacaoSimples.Titulo.IsEmpty) and not(informacaoSimples.Informativo.IsEmpty)then
    begin
      _linhas:= TStringList.Create();
      try
        titulo:= tratamentoLinhas.TratarLinha(informacaoSimples.Titulo, Trunc(informacaoSimples.QtdMaxCaracteres/2));
        informativo:= tratamentoLinhas.TratarLinha(informacaoSimples.Informativo, Trunc(informacaoSimples.QtdMaxCaracteres/2));
        blocoSimples.NomeBloco:= 'blocoSimples';
        blocoSimples.NomeFont:= 'Lucida Console';
        blocoSimples.TamanhoFont:= informacaoSimples.Tamanho;
        blocoSimples.StylesFont:= [TFontStyle.fsBold];
        blocoSimples.OrientacaoTexto:= atCenter;
        blocoSimples.QuantidadeCaracteres:= informacaoSimples.QtdMaxCaracteres;

        tratamentoLinhas.AddLinhasKeyValue(titulo, informativo,
           informacaoSimples.QtdMaxCaracteres, _linhas);

        blocoSimples.Linhas:= _linhas.ToStringArray;
        FBlocosImpressao.Add(blocoSimples);
        Exit(self);
      finally
        _linhas.Free;
      end;
    end;

    if not(informacaoSimples.Titulo.IsEmpty) then
    begin
      blocoSimples.NomeBloco:= 'blocoSimples';
      blocoSimples.NomeFont:= 'Arial';
      blocoSimples.TamanhoFont:= informacaoSimples.Tamanho;
      blocoSimples.StylesFont:= [TFontStyle.fsBold];
      blocoSimples.OrientacaoTexto:= atRigth;
      blocoSimples.QuantidadeCaracteres:= informacaoSimples.QtdMaxCaracteres;
      blocoSimples.Linhas:= [informacaoSimples.Titulo]
    end;

    if not(informacaoSimples.Informativo.IsEmpty) then
    begin
      blocoSimples.NomeBloco:= 'blocoSimples';
      blocoSimples.NomeFont:= 'Arial';
      blocoSimples.TamanhoFont:= informacaoSimples.Tamanho;
      blocoSimples.StylesFont:= [];
      blocoSimples.OrientacaoTexto:= atRigth;
      blocoSimples.QuantidadeCaracteres:= informacaoSimples.QtdMaxCaracteres;
      blocoSimples.Linhas:= [informacaoSimples.Informativo];
    end;
    FBlocosImpressao.Add(blocoSimples);
  end;
end;

function TRelatorioTermica.addInformacoesLista(informacaoLista
  : iInformacaoLista): iRelatorio;
var
  memo: TStringList;
  blocoLista: TBlocoRelatorio;
  tratamentoLinhas: ITratamentoLinhas;
begin
  result := self;
  tratamentoLinhas:= TTratamentoLinhas.New();
  memo:= TStringList.Create();
  try
    blocoLista:= TBlocoRelatorio.Create();
    if Assigned(informacaoLista) then
    begin
      blocoLista.NomeBloco:= 'blocoLista';
      blocoLista.NomeFont:= 'Lucida Console';
      blocoLista.TamanhoFont:= 9;
      blocoLista.StylesFont:= [TFontStyle.fsBold];
      blocoLista.OrientacaoTexto:= atRigth;
      blocoLista.QuantidadeCaracteres:= 42;

      if (informacaoLista.Colunas.Count > 0) and (informacaoLista.QtdMaxCaracteres.Count > 0) then
        tratamentoLinhas.AddLinhasColunadas(memo, informacaoLista.Colunas.ToArray,
          informacaoLista.QtdMaxCaracteres.ToArray);

      blocoLista.Linhas:= memo.ToStringArray
    end;
    FBlocosImpressao.Add(blocoLista);
  finally
    memo.Free;
  end;
end;


constructor TRelatorioTermica.Create(margeEsquerda: integer);
begin
  FmargeEsquerda:= margeEsquerda;
  FImpressora:= TPrinter.Create();
  FBlocosImpressao:= TObjectList<TBlocoRelatorio>.Create();
end;

destructor TRelatorioTermica.Destroy;
begin
  FBlocosImpressao.Clear;
  FBlocosImpressao.Free;
  FImpressora.Free;
  inherited;
end;

function TRelatorioTermica.imprimir(nomeImpressao, nomeComputador, nomeImpressora: string): iRelatorio;
var
  nomeComputadorLocal, ondeVaiImprimir: string;
  indice: Integer;
  it: TBlocoRelatorio;
  linhas: Integer;
begin
  result := self;
  linhas:= 0;
  nomeComputadorLocal := UpperCase(GetLocalComputerName);

  if (nomeComputador.IsEmpty) or (nomeImpressora.IsEmpty) then
    raise Exception.Create('Nome do computador ou da impressora inválido');

  nomeComputador := UpperCase(nomeComputador);
  nomeImpressora := UpperCase(nomeImpressora);

  if nomeComputador = nomeComputadorLocal then
    ondeVaiImprimir := nomeImpressora
  else
    ondeVaiImprimir := '\\' + nomeComputador + '\' + nomeImpressora;

  indice := FImpressora.Printers.IndexOf(ondeVaiImprimir);

  if indice > -1 then
  begin
    FImpressora.PrinterIndex:= indice;
    FImpressora.BeginDoc;
    FImpressora.Title:= nomeImpressao;

    for it in FBlocosImpressao do
    begin
      SetBloco(it, linhas);
    end;

    FImpressora.EndDoc;
  end
  else
    raise Exception.Create('Impressora não existe');

end;

function TRelatorioTermica.Ref: iRelatorio;
begin
  result:= self;
end;


procedure TRelatorioTermica.SetBloco(bloco: TBlocoRelatorio;var linhas: integer);
var
  it: string;
begin
  if Assigned(bloco) then
  begin
    try
      FImpressora.Canvas.Font.Size:= bloco.TamanhoFont;
      FImpressora.Canvas.Font.Name:= bloco.NomeFont;
      FImpressora.Canvas.Font.Style:= bloco.StylesFont;

      for it in bloco.Linhas do
      begin
        if not it.IsEmpty then
        begin
          if linhas = 0 then
            FImpressora.Canvas.TextOut(MargeEsquerda,linhas*50, it)
          else
            FImpressora.Canvas.TextOut(MargeEsquerda,linhas*35, it);

          Inc(linhas);
        end;
      end;

      ZerarConfiguracoes;
    except
    end;
  end;
end;

procedure TRelatorioTermica.ZerarConfiguracoes;
begin
  FImpressora.Canvas.Font.Size:= 8;
  FImpressora.Canvas.Font.Style:= [];
  FImpressora.Canvas.Font.Name:= 'Arial';
end;

end.
