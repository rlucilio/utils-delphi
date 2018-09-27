unit Model.Relatorio;

interface

uses Model.Relatorio.Interfaces, System.Classes, RLReport;

type

   TModelRelatorio = class(TInterfacedObject, iModelRelatorio)
   private
      fRelatorio: TRLReport;
      FmargeDireita: integer;
      FmargeEsquerda: integer;
      FmargeSuperior: integer;
      FmargeInferior: integer;
      FlarguraPapel: integer;
      FalturaPapel: integer;
      //
      constructor Create(margeDireita, margeEsquerda, margeSuperior,
        margeInferior, larguraPapel, alturaPapel: integer);
      procedure setAlturaPapel(const Value: integer);
      procedure setLarguraPapel(const Value: integer);
      procedure setMargeDireita(const Value: integer);
      procedure setMargeEsquerda(const Value: integer);
      procedure setMargeInferior(const Value: integer);
      procedure setMargeSuperior(const Value: integer);
      procedure AddLinhaColunas(memo: Tstrings; colunas: TArray<string>;
        CaracteresPorColuna: TArray<integer>);
      procedure addLinha(memo: Tstrings; linhas: TArray<string>;
        CaracteresPorColuna: integer);
   public
      class function New(margeDireita, margeEsquerda, margeSuperior,
        margeInferior, larguraPapel, alturaPapel: integer): iModelRelatorio;
      destructor Destroy; override;
      //

      property margeDireita: integer write setMargeDireita;
      property margeEsquerda: integer write setMargeEsquerda;
      property margeSuperior: integer write setMargeSuperior;
      property margeInferior: integer write setMargeInferior;
      property larguraPapel: integer write setLarguraPapel;
      property alturaPapel: integer write setAlturaPapel;
      function addInformacaoImportante(informacaoImportante
        : iModelInformacaoImportante): iModelRelatorio;
      function addInformacaoSimples(informacaoSimples: iModelInformacaoSimples)
        : iModelRelatorio;
      function addInformacaoRodape(informacaoRodape: iModelInformacaoRodape)
        : iModelRelatorio;
      function addInformacoesLista(informacaoLista: iModelInformacaoLista)
        : iModelRelatorio;
      function imprimir(nomeImpressao, nomeComputador, nomeImpressora: string;
        const preview: boolean): iModelRelatorio;
   end;

implementation

uses
   Winapi.Windows, RLTypes, JclSysInfo, System.SysUtils, RLPrinters, RLConsts,
   System.UITypes, Model.LibUtil;

{ TModelRelatorio }

function TModelRelatorio.addInformacaoImportante(informacaoImportante
  : iModelInformacaoImportante): iModelRelatorio;
var
   band: TRLBand;
   memoTitulo, memoInformacao: TRLMemo;
begin
   result := self;

   if not(informacaoImportante.titulo.IsEmpty) or
     (informacaoImportante.informacoes.Count > 0) then
   begin
      band := TRLBand.Create(fRelatorio);
      band.Parent := fRelatorio;
      band.Margins.BottomMargin := 2;
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

      addLinha(memoTitulo.Lines, [informacaoImportante.titulo],
        informacaoImportante.qtdMaxCaracteres);
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

      addLinha(memoInformacao.Lines, informacaoImportante.informacoes.ToArray,
        informacaoImportante.qtdMaxCaracteres);
   end;

end;

function TModelRelatorio.addInformacaoRodape(informacaoRodape
  : iModelInformacaoRodape): iModelRelatorio;
var
   band: TRLBand;
   pnlEspacoFinal: TRLPanel;
   memo: TRLMemo;
begin

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

      addLinha(memo.Lines, informacaoRodape.linhas.ToArray,
        informacaoRodape.qtdMaxCaracteres);
   end;
end;

function TModelRelatorio.addInformacaoSimples(informacaoSimples
  : iModelInformacaoSimples): iModelRelatorio;
var
   band: TRLBand;
   lblTitulo, lblInformacao: TRLLabel;
begin
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
   end;

   if not(informacaoSimples.titulo.IsEmpty) then
   begin
      lblTitulo := TRLLabel.Create(band);
      lblTitulo.Parent := band;
      lblTitulo.Align := faLeft;
      lblTitulo.Caption := informacaoSimples.titulo;
      lblTitulo.Layout := tlCenter;
   end;

   if not(informacaoSimples.Informativo.IsEmpty) then
   begin
      lblInformacao := TRLLabel.Create(band);
      lblInformacao.Parent := band;
      lblInformacao.Align := faLeft;
      lblInformacao.Caption := informacaoSimples.Informativo;
      lblTitulo.Layout := tlCenter;
   end;

end;

function TModelRelatorio.addInformacoesLista(informacaoLista
  : iModelInformacaoLista): iModelRelatorio;
var
   band: TRLBand;
   memo: TRLMemo;
begin
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
      memo.Font.Size := 8;
      memo.Font.Name := 'Lucida Console';
      memo.Font.Style := [];
      memo.ParentFont := False;
      AddLinhaColunas(memo.Lines, informacaoLista.colunas.ToArray,
        informacaoLista.qtdMaxCaracteres.ToArray);
   end;
end;

procedure TModelRelatorio.addLinha(memo: Tstrings; linhas: TArray<string>;
  CaracteresPorColuna: integer);
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
            if (linhaAjustada[I] = sLineBreak) or
              not(trim(linhaAjustada[I]).IsEmpty) then
            begin

               for item2 in memo do
               begin
                  if trim(linhaAjustada[I]).Contains(trim(item2)) then
                  begin
                     linhaAjustada[I] := '';
                     break;
                  end;

               end;

               if not(linhaAjustada[I].IsEmpty) then
                  if linhaAjustada[I].Contains('|') then
                  begin
                     memo.Add(' ');
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

procedure TModelRelatorio.AddLinhaColunas(memo: Tstrings;
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
            linha := AjustaLinhas(colunas[I], CaracteresPorColuna[I],
              1000, true);

            // adiciona a linha ajustada em um tstringlist
            addDelimitador(linha, #10, linhaAjustada);

            // verifica se qtd de linhas da linhas ajustada é maior que a quantidade de memo temporário
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
               if (linhaAjustada[J] = sLineBreak) or
                 not(linhaAjustada[J].IsEmpty) then
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
                          alinhaDireita('',
                          espacoEmBranco - CaracteresPorColuna[I], ' ');

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
         if (memoTemporario[I] = sLineBreak) or not(memoTemporario[I].IsEmpty)
         then
            if trim(memoTemporario[I]) <> '' then
               memo.Add(memoTemporario[I]);

   finally
      FreeAndNil(memoTemporario);
   end;

end;

constructor TModelRelatorio.Create(margeDireita, margeEsquerda, margeSuperior,
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

destructor TModelRelatorio.Destroy;
begin
   inherited;
end;

function TModelRelatorio.imprimir(nomeImpressao, nomeComputador,
  nomeImpressora: string; const preview: boolean): iModelRelatorio;
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

class function TModelRelatorio.New(margeDireita, margeEsquerda, margeSuperior,
  margeInferior, larguraPapel, alturaPapel: integer): iModelRelatorio;
begin
   result := self.Create(margeDireita, margeEsquerda, margeSuperior,
     margeInferior, larguraPapel, alturaPapel);
end;

procedure TModelRelatorio.setAlturaPapel(const Value: integer);
begin
   FalturaPapel := Value;
end;

procedure TModelRelatorio.setLarguraPapel(const Value: integer);
begin
   FlarguraPapel := Value;
end;

procedure TModelRelatorio.setMargeDireita(const Value: integer);
begin
   FmargeDireita := Value;
end;

procedure TModelRelatorio.setMargeEsquerda(const Value: integer);
begin
   FmargeEsquerda := Value;
end;

procedure TModelRelatorio.setMargeInferior(const Value: integer);
begin
   FmargeInferior := Value;
end;

procedure TModelRelatorio.setMargeSuperior(const Value: integer);
begin
   FmargeSuperior := Value;
end;

end.
