unit
  uRelatorio.Matricial;

interface

uses
  uRelatorio.Interfaces,
  System.Classes;

type
  TRelatorioMatricial = class(TInterfacedObject, iRelatorio)
  private
    FArquivoTxt: TStrings;
    procedure GerarImpressao();
    procedure AddLinhaColunas(memo: Tstrings; colunas: TArray<string>; CaracteresPorColuna: TArray<integer>);
    procedure addLinha(memo: Tstrings; linhas: TArray<string>; CaracteresPorColuna: integer);
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
  System.SysUtils,
  Model.LibUtil,
  ACBrUtil;

{ TRelatorioMatricial }

function TRelatorioMatricial.addInformacaoImportante(
  informacaoImportante: IInformacaoImportante): iRelatorio;
var
  linhas: TStringBuilder;

begin
  Result:= self;

  if Assigned(informacaoImportante) then
  begin
    try
      if not(informacaoImportante.Titulo.IsEmpty) or
         (informacaoImportante.Informacoes.Count > 0) then
        linhas:= TStringBuilder.Create();

      if not(informacaoImportante.Titulo.IsEmpty) then

    finally
      FreeAndNil(linhas);
    end;

  end;

end;

//var
//  band: TRLBand;
//  memoTitulo, memoInformacao: TRLMemo;
//begin
//  result := self;
//
//  if not(informacaoImportante.titulo.IsEmpty) or
//    (informacaoImportante.informacoes.Count > 0) then
//  begin
//    band := TRLBand.Create(fRelatorio);
//    band.Parent := fRelatorio;
//    band.Margins.BottomMargin := 1;
//    band.AutoSize := true;
//    band.BandType := btHeader;
//  end;
//
//  if not(informacaoImportante.titulo.IsEmpty) then
//  begin
//    memoTitulo := TRLMemo.Create(band);
//    memoTitulo.Parent := band;
//    memoTitulo.Align := faTop;
//    memoTitulo.Alignment := taJustify;
//    memoTitulo.Behavior := [beSiteExpander];
//    memoTitulo.Font.Charset := DEFAULT_CHARSET;
//    memoTitulo.Font.Color := $000000;
//    memoTitulo.Font.Size := informacaoImportante.tamanhaoTitulo;
//    memoTitulo.Font.Name := 'Arial';
//    memoTitulo.Font.Style := [TFontStyle.fsBold];
//    memoTitulo.Layout := tlCenter;
//
//    addLinha(memoTitulo.Lines, [informacaoImportante.titulo],
//      informacaoImportante.qtdMaxCaracteres);
//  end;
//
//  if (informacaoImportante.informacoes.Count > 0) then
//  begin
//    memoInformacao := TRLMemo.Create(band);
//    memoInformacao.Parent := band;
//    memoInformacao.Align := faTop;
//    memoInformacao.Alignment := taJustify;
//    memoInformacao.Behavior := [beSiteExpander];
//    memoInformacao.Font.Charset := DEFAULT_CHARSET;
//    memoInformacao.Font.Color := $000000;
//    memoInformacao.Font.Size := informacaoImportante.tamanhoInformacoes;
//    memoInformacao.Font.Name := 'Arial';
//    memoInformacao.Font.Style := [TFontStyle.fsBold];
//    memoInformacao.Layout := tlCenter;
//
//    addLinha(memoInformacao.Lines, informacaoImportante.informacoes.ToArray,
//      informacaoImportante.qtdMaxCaracteres);
//  end;
//
//end;


function TRelatorioMatricial.addInformacaoRodape(
  informacaoRodape: IInformacaoRodape): iRelatorio;
begin
  Result:= self;
end;

function TRelatorioMatricial.addInformacaoSimples(
  informacaoSimples: IInformacaoSimples): iRelatorio;
begin
  Result:= self;
end;

function TRelatorioMatricial.addInformacoesLista(
  informacaoLista: IInformacaoLista): iRelatorio;
begin
  Result:= self;
end;

procedure TRelatorioMatricial.addLinha(memo: Tstrings;
  linhas: TArray<string>; CaracteresPorColuna: integer);
var
  linhaAjustada: TStringList;
  item, linha: string;
  I: integer;
  item2: string;
begin
  try
    linhaAjustada := TStringList.Create;
    for item in linhas do
    begin
      linha := AjustaLinhas(item, CaracteresPorColuna, 1000, true);

      addDelimitador(linha, #10, linhaAjustada);

      for I := 0 to linhaAjustada.Count - 1 do
      begin
        if (linhaAjustada[I] = sLineBreak) or not(trim(linhaAjustada[I]).IsEmpty)
        then
        begin

          for item2 in memo do
          begin
            if trim(linhaAjustada[I]).contains(trim(item2)) then
            begin
              linhaAjustada[I] := '';
              break;
            end;

          end;

          if fRelatorio.PageSetup.PaperWidth <> 145 then
          begin

            if not(linhaAjustada[I].IsEmpty) then
              if linhaAjustada[I].contains('|') then
              begin
                memo.Add(' ');
              end
              else
                memo.Add(trim(linhaAjustada[I]));
          end
          else
            memo.Add(trim(linhaAjustada[I]));
        end;
      end;

    end;
  finally
    FreeAndNil(linhaAjustada);
  end;

end;

procedure TRelatorioMatricial.AddLinhaColunas(memo: Tstrings;
  colunas: TArray<string>; CaracteresPorColuna: TArray<integer>);
var
  linhaAjustada: TStringList;
  memoTemporario: TStringList;
  linha, antigaLinha, alinha: string;
  I, J, espacoEmBranco: integer;
begin
  try
    memoTemporario := TStringList.Create;
    espacoEmBranco := 0;

    for I := 0 to Length(colunas) - 1 do
    begin
      try

        linhaAjustada := TStringList.Create;

        // ajusta a linha
        linha := AjustaLinhas(colunas[I], CaracteresPorColuna[I], 1000, true);

        // adiciona a linha ajustada em um tstringlist
        addDelimitador(linha, #10, linhaAjustada);

        // verifica se qtd de linhas da linhas ajustada � maior que a quantidade de memo tempor�rio
        // se for vai deixa os dois com a mesma quantidade
        if memoTemporario.Count - 1 < linhaAjustada.Count - 1 then
        begin
          if I = 0 then
          begin
            for J := 0 to linhaAjustada.Count - 1 do
              memoTemporario.Add('')
          end
          else
          begin
            for J := 0 to linhaAjustada.Count - 1 do
              memoTemporario.Add(alinhaTextoADireita('',
                espacoEmBranco - 1, ' '));

          end;

        end;

        // adiciona a linha ajusta no memo temporario
        for J := 0 to linhaAjustada.Count - 1 do
        begin
          if (linhaAjustada[J] = sLineBreak) or not(linhaAjustada[J].IsEmpty)
          then
          begin
            if I = 0 then
            begin
              antigaLinha := memoTemporario[J];
              Insert(linhaAjustada[J] + ' ', antigaLinha, 0);
              espacoEmBranco := CaracteresPorColuna[I] + 2;
              memoTemporario[J] := antigaLinha;
            end
            else
            begin
              if memoTemporario[J] = '' then
                memoTemporario[J] :=
                  padright('', espacoEmBranco - CaracteresPorColuna[I], ' ');

              antigaLinha := memoTemporario[J];
              espacoEmBranco := espacoEmBranco + CaracteresPorColuna[I];
              alinha := trim(linhaAjustada[J]);
              if I > 1 then
                alinha := alinhaTextoADireita(alinha,
                  CaracteresPorColuna[I], ' ')
              else
                alinha := alinhaTextoAEsquerda(alinha,
                  CaracteresPorColuna[I], ' ');
              Insert(alinha + ' ', antigaLinha, espacoEmBranco);
              memoTemporario[J] := antigaLinha;
            end;
          end;
        end;

      finally
        FreeAndNil(linhaAjustada);
      end;

    end;

    // adiciona no memo destino
    for I := 0 to memoTemporario.Count - 1 do
      if (memoTemporario[I] = sLineBreak) or not(memoTemporario[I].IsEmpty) then
        if trim(memoTemporario[I]) <> '' then
          memo.Add(memoTemporario[I]);

  finally
    FreeAndNil(memoTemporario);
  end;

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

procedure TRelatorioMatricial.GerarImpressao;
begin

end;

function TRelatorioMatricial.imprimir(nomeImpressao, nomeComputador,
  nomeImpressora: string; const preview: boolean): iRelatorio;
begin
  GerarImpressao();
  Result:= self;
end;

function TRelatorioMatricial.Ref: iRelatorio;
begin
  Result:= self;
end;

end.
