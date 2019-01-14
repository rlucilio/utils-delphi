unit uRelatorio.Termica;


interface

uses
  uRelatorio.Interfaces,
  System.Classes,
  RLReport,
  ACBrUtil;

type

  TRelatorioTermica = class(TInterfacedObject, iRelatorio)
  private
    fRelatorio: TRLReport;
    FmargeDireita: integer;
    FmargeEsquerda: integer;
    FmargeSuperior: integer;
    FmargeInferior: integer;
    FlarguraPapel: integer;
    FalturaPapel: integer;

    procedure setAlturaPapel(const Value: integer);
    procedure setLarguraPapel(const Value: integer);
    procedure setMargeDireita(const Value: integer);
    procedure setMargeEsquerda(const Value: integer);
    procedure setMargeInferior(const Value: integer);
    procedure setMargeSuperior(const Value: integer);
  public
    class function New(margeDireita, margeEsquerda, margeSuperior,
      margeInferior, larguraPapel, alturaPapel: integer): iRelatorio;

    constructor Create(margeDireita, margeEsquerda, margeSuperior,
      margeInferior, larguraPapel, alturaPapel: integer);
    destructor Destroy; override;

    property margeDireita: integer write setMargeDireita;
    property margeEsquerda: integer write setMargeEsquerda;
    property margeSuperior: integer write setMargeSuperior;
    property margeInferior: integer write setMargeInferior;
    property larguraPapel: integer write setLarguraPapel;
    property alturaPapel: integer write setAlturaPapel;

    function addInformacaoImportante(informacaoImportante: IInformacaoImportante): iRelatorio;
    function addInformacaoSimples(informacaoSimples: IInformacaoSimples): iRelatorio;
    function addInformacaoRodape(informacaoRodape: IInformacaoRodape): iRelatorio;
    function addInformacoesLista(informacaoLista: IInformacaoLista): iRelatorio;
    function imprimir(nomeImpressao, nomeComputador, nomeImpressora: string;const preview: boolean): iRelatorio;

    function Ref: iRelatorio;
  end;

implementation

uses
  Winapi.Windows,
  RLTypes,
  JclSysInfo,
  System.SysUtils,
  RLPrinters,
  RLConsts,
  System.UITypes,
  Model.LibUtil,
  uRelatorio.Linhas;

{ TRelatorioTermica }

function TRelatorioTermica.addInformacaoImportante(informacaoImportante
  : IInformacaoImportante): iRelatorio;
var
  band: TRLBand;                        
  memoTitulo, memoInformacao: TRLMemo;
  titulo, informacoes: TArray<string>;
  tratamentoLinhas: ITratamentoLinhas;
begin
  tratamentoLinhas:= TTratamentoLinhas.New();
  result := self;

  if not(informacaoImportante.titulo.IsEmpty) or
    (informacaoImportante.informacoes.Count > 0) then
  begin
    band := TRLBand.Create(fRelatorio);
    band.Parent := fRelatorio;
    band.Margins.BottomMargin := 1;
    band.AutoSize := true;
    band.BandType := btHeader;
  end;

  if not(informacaoImportante.titulo.IsEmpty) then
  begin
    memoTitulo := TRLMemo.Create(band);
    memoTitulo.Parent := band;
    memoTitulo.Align := faTop;
    memoTitulo.Alignment := taJustify;
    memoTitulo.Behavior := [beSiteExpander];
    memoTitulo.Font.Charset := DEFAULT_CHARSET;
    memoTitulo.Font.Color := $000000;
    memoTitulo.Font.Size := informacaoImportante.tamanhaoTitulo;
    memoTitulo.Font.Name := 'Arial';
    memoTitulo.Font.Style := [TFontStyle.fsBold];
    memoTitulo.Layout := tlCenter;

    titulo:= tratamentoLinhas.TratarLinha(informacaoImportante.titulo, informacaoImportante.qtdMaxCaracteres);
    tratamentoLinhas.AddLinhas(titulo, memoTitulo.Lines);
  end;

  if (informacaoImportante.informacoes.Count > 0) then
  begin
    memoInformacao := TRLMemo.Create(band);
    memoInformacao.Parent := band;
    memoInformacao.Align := faTop;
    memoInformacao.Alignment := taJustify;
    memoInformacao.Behavior := [beSiteExpander];
    memoInformacao.Font.Charset := DEFAULT_CHARSET;
    memoInformacao.Font.Color := $000000;
    memoInformacao.Font.Size := informacaoImportante.tamanhoInformacoes;
    memoInformacao.Font.Name := 'Arial';
    memoInformacao.Font.Style := [TFontStyle.fsBold];
    memoInformacao.Layout := tlCenter;

    informacoes:= tratamentoLinhas.TratarLinhas(informacaoImportante.Informacoes.ToArray, informacaoImportante.QtdMaxCaracteres);
    tratamentoLinhas.AddLinhas(informacoes, memoInformacao.Lines);
  end;

end;

function TRelatorioTermica.addInformacaoRodape(informacaoRodape
  : IInformacaoRodape): iRelatorio;
var
  band: TRLBand;
  pnlEspacoFinal: TRLPanel;
  memo: TRLMemo;
  linhas: TArray<string>;
  tratamentoLinhas: ITratamentoLinhas;
begin
  tratamentoLinhas:= TTratamentoLinhas.New();

  result := self;
  if informacaoRodape.linhas.Count > 0 then
  begin
    band := TRLBand.Create(fRelatorio);
    band.Parent := fRelatorio;
    band.AutoSize := true;
    band.BandType := btFooter;
    band.Margins.BottomMargin := 6;

    pnlEspacoFinal := TRLPanel.Create(band);
    pnlEspacoFinal.Parent := band;
    pnlEspacoFinal.Align := faBottom;
    pnlEspacoFinal.Color := $FFFFFF;
    pnlEspacoFinal.ParentFont := False;
    pnlEspacoFinal.Transparent := False;

    memo := TRLMemo.Create(band);
    memo.Parent := band;
    memo.Align := faBottom;
    memo.Alignment := taCenter;
    memo.Behavior := [beSiteExpander];
    memo.Font.Charset := DEFAULT_CHARSET;
    memo.Font.Color := $000000;
    memo.Font.Size := informacaoRodape.tamanho;
    memo.Font.Name := 'Arial';
    memo.ParentFont := False;

    linhas:= tratamentoLinhas.TratarLinhas(informacaoRodape.Linhas.ToArray, informacaoRodape.QtdMaxCaracteres);
    tratamentoLinhas.AddLinhas(linhas, memo.Lines);
  end;
end;

function TRelatorioTermica.addInformacaoSimples(informacaoSimples
  : IInformacaoSimples): iRelatorio;
var
  band: TRLBand;
  memoInformacaoSimples: TRLMemo;
  tratamentoLinhas: ITratamentoLinhas;
  titulo, informacoes: TArray<string>;
begin
  tratamentoLinhas:= TTratamentoLinhas.New();
  result := self;

  if not(informacaoSimples.titulo.IsEmpty) or
    not(informacaoSimples.Informativo.IsEmpty) then
  begin
    band := TRLBand.Create(fRelatorio);
    band.Parent := fRelatorio;
    band.AutoSize := true;
    band.BandType := btHeader;
    band.Margins.BottomMargin := 0;
    band.Font.Charset := DEFAULT_CHARSET;
    band.Font.Color := $000000;
    band.Font.Size := informacaoSimples.tamanho;
    band.Font.Name := 'Arial';
    band.Font.Style := [TFontStyle.fsBold];
    band.ParentFont := False;

    memoInformacaoSimples := TRLMemo.Create(band);
    memoInformacaoSimples.Parent:= band;
    memoInformacaoSimples.Align:= faTop;
    memoInformacaoSimples.Alignment:= taJustify;
    memoInformacaoSimples.Behavior:=[beSiteExpander];
    memoInformacaoSimples.Layout:= tlCenter;
  end;

  if not(informacaoSimples.Titulo.IsEmpty) and not(informacaoSimples.Informativo.IsEmpty)then
  begin
    memoInformacaoSimples.Font.Style:= [TFontStyle.fsBold];
    memoInformacaoSimples.Alignment:= taCenter;

    titulo:= tratamentoLinhas.TratarLinha(informacaoSimples.Titulo, informacaoSimples.QtdMaxCaracteres);
    informacoes:= tratamentoLinhas.TratarLinha(informacaoSimples.Informativo, informacaoSimples.QtdMaxCaracteres);
    tratamentoLinhas.AddLinhasKeyValue(titulo, informacoes, informacaoSimples.QtdMaxCaracteres, memoInformacaoSimples.Lines);
    Exit(self);
  end;

  if not(informacaoSimples.titulo.IsEmpty) then
  begin
    memoInformacaoSimples.Font.Style:= [TFontStyle.fsBold];
    memoInformacaoSimples.Alignment:= taCenter;
    
    if not informacaoSimples.titulo.contains('-') then
    begin
      memoInformacaoSimples.AutoSize := False;
      memoInformacaoSimples.Width := 150;
    end;

    titulo:= tratamentoLinhas.TratarLinha(informacaoSimples.Titulo, informacaoSimples.QtdMaxCaracteres);
    tratamentoLinhas.AddLinhas(titulo, memoInformacaoSimples.Lines);
  end;

  if not(informacaoSimples.Informativo.IsEmpty) then
  begin
    if not informacaoSimples.titulo.contains('-') then
    begin
      memoInformacaoSimples.AutoSize := False;
      memoInformacaoSimples.Width := 120;
    end;

    informacoes:= tratamentoLinhas.TratarLinha(informacaoSimples.Informativo, informacaoSimples.QtdMaxCaracteres);
    tratamentoLinhas.AddLinhas(titulo, memoInformacaoSimples.Lines);
  end;

end;

function TRelatorioTermica.addInformacoesLista(informacaoLista
  : IInformacaoLista): iRelatorio;
var
  band: TRLBand;
  memo: TRLMemo;
  tratamentoLinhas: ITratamentoLinhas;
begin
  tratamentoLinhas:= TTratamentoLinhas.New();
  result := self;
  if (informacaoLista.qtdMaxCaracteres.Count > 0) and
    (informacaoLista.colunas.Count > 0) then
  begin
    band := TRLBand.Create(fRelatorio);
    band.Parent := fRelatorio;
    band.Margins.BottomMargin := 1;
    band.AutoSize := true;
    band.BandType := btHeader;

    memo := TRLMemo.Create(band);
    memo.Parent := band;
    memo.Align := faTop;
    memo.Alignment := taJustify;
    memo.Behavior := [beSiteExpander];
    memo.Font.Charset := DEFAULT_CHARSET;
    memo.Font.Color := $000000;
    memo.Font.Size := 9;
    memo.Font.Name := 'Lucida Console';
    memo.Font.Style := [TFontStyle.fsBold];
    memo.ParentFont := False;

    tratamentoLinhas.AddLinhasColunadas(memo.Lines, informacaoLista.Colunas.ToArray, informacaoLista.QtdMaxCaracteres.ToArray);
  end;
end;

constructor TRelatorioTermica.Create(margeDireita, margeEsquerda, margeSuperior,
  margeInferior, larguraPapel, alturaPapel: integer);
begin
  inherited Create;

  setAlturaPapel(alturaPapel);
  setLarguraPapel(larguraPapel);
  setMargeDireita(margeDireita);
  setMargeEsquerda(margeEsquerda);
  setMargeInferior(margeInferior);
  setMargeSuperior(margeSuperior);

  fRelatorio := TRLReport.Create(nil);
  fRelatorio.AllowedBands := [btHeader, btDetail, btSummary, btFooter];

  fRelatorio.Font.Charset := DEFAULT_CHARSET;
  fRelatorio.Font.Color := $000000;
  fRelatorio.Font.Size := 11;
  fRelatorio.Font.Name := 'Arial';
  fRelatorio.Font.Style := [];

  fRelatorio.PageSetup.PaperSize := fpCustom;

  fRelatorio.PrintDialog := False;
  fRelatorio.PageBreaking := pbNone;
  fRelatorio.ShowProgress := False;
  fRelatorio.Visible := False;
  fRelatorio.UnlimitedHeight := true;

  fRelatorio.Margins.TopMargin := FmargeSuperior;
  fRelatorio.Margins.BottomMargin := FmargeInferior;
  fRelatorio.Margins.RightMargin := FmargeDireita;
  fRelatorio.Margins.LeftMargin := FmargeEsquerda;

  fRelatorio.PageSetup.PaperWidth := round(FlarguraPapel / MMAsPixels);
  fRelatorio.PageSetup.PaperHeight := FalturaPapel;
end;

destructor TRelatorioTermica.Destroy;
begin
  inherited;
end;

function TRelatorioTermica.imprimir(nomeImpressao, nomeComputador,
  nomeImpressora: string; const preview: boolean): iRelatorio;
var
  nomeComputadorLocal: string;
begin
  result := self;
  fRelatorio.Title := UpperCase(nomeImpressao);

  nomeComputadorLocal := UpperCase(GetLocalComputerName);
  if (nomeComputador.IsEmpty) or (nomeImpressora.IsEmpty) then
    raise Exception.Create('Nome do computador ou da impressora inválido');

  nomeComputador := UpperCase(nomeComputador);
  nomeImpressora := UpperCase(nomeImpressora);

  if nomeComputador = nomeComputadorLocal then
    RLPrinter.PrinterName := nomeImpressora
  else
    RLPrinter.PrinterName := '\\' + nomeComputador + '\' + nomeImpressora;

  if preview then
  begin
    fRelatorio.preview();
  end
  else
  begin
    fRelatorio.Print;
  end;


  FreeAndNil(fRelatorio);

end;

class function TRelatorioTermica.New(margeDireita, margeEsquerda, margeSuperior,
  margeInferior, larguraPapel, alturaPapel: integer): iRelatorio;
begin
  result := self.Create(
    margeDireita,
    margeEsquerda,
    margeSuperior,
    margeInferior,
    larguraPapel,
    alturaPapel);
end;

function TRelatorioTermica.Ref: iRelatorio;
begin
  result:= self;
end;

procedure TRelatorioTermica.setAlturaPapel(const Value: integer);
begin
  FalturaPapel := Value;
end;

procedure TRelatorioTermica.setLarguraPapel(const Value: integer);
begin
  FlarguraPapel := Value;
end;

procedure TRelatorioTermica.setMargeDireita(const Value: integer);
begin
  FmargeDireita := Value;
end;

procedure TRelatorioTermica.setMargeEsquerda(const Value: integer);
begin
  FmargeEsquerda := Value;
end;

procedure TRelatorioTermica.setMargeInferior(const Value: integer);
begin
  FmargeInferior := Value;
end;

procedure TRelatorioTermica.setMargeSuperior(const Value: integer);
begin
  FmargeSuperior := Value;
end;

end.

