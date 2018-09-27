unit Model.LibUtil;

interface

uses
   System.Classes;

function addDelimitador(const AText: String; const ADelimiter: Char;
  AStringList: TStrings; const AQuoteChar: Char = '"'): Integer;

function AjustaLinhas(const Texto: string; Colunas: Integer;
  NumMaxLinhas: Integer; PadLinhas: Boolean): string;

function alinhaDireita(const AString: String; const nLen: Integer;
  const Caracter: Char): String;

function alinhaEsquerda(const AString: String; const nLen: Integer;
  const Caracter: Char): String;

function AddEspaco(Tamanho: Integer): string;

function LenghtUTF(const AString: String): Integer;

function alinhaTextoADireita(Texto: string; Qtd: Integer; Ch: Char): string;

function alinhaTextoAEsquerda(Texto: string; Qtd: Integer; Ch: Char): string;

function temInternet: Boolean;

procedure iniciaComWindows(nomePrograma: string);

implementation

uses
   System.StrUtils, System.SysUtils, System.Math, Winapi.WinInet,
   System.Win.Registry,
   Winapi.Windows, Vcl.Forms;

function alinhaTextoAEsquerda(Texto: string; Qtd: Integer; Ch: Char): string;
var
   x: Integer;
begin

   if Length(Texto) > Qtd then
      result := Copy(Texto, 0, Qtd)
   else
   begin
      x := Length(Texto);
      for Qtd := x to Qtd - 1 do
      begin
         Texto := Texto + Ch;
      end;
      result := Texto;
   end

end;

function alinhaTextoADireita(Texto: string; Qtd: Integer; Ch: Char): string;
var
   x: Integer;
   str: string;
begin
   if Length(Texto) > Qtd then
      result := Copy(Texto, (Length(Texto) - Qtd) + 1, Length(Texto))
   else
   begin
      str := '';
      for x := Length(Texto) to Qtd - 1 do
      begin
         str := str + Ch;
      end;
      result := str + Texto;
   end

end;

{ ------------------------------------------------------------------------------
  Quebra a String "AText", em v�rias linhas, separando-a de acordo com a ocorr�ncia
  de "ADelimiter", e adiciona os Itens encontrados em "AStringList".
  Retorna o n�mero de Itens Inseridos.
  Informe #0 em "AQuoteChar", para que as Aspas Duplas sejam ignoradas na divis�o
  Se AQuoteChar for diferente de #0, ele ser� considerado, para evitar os delimitadores
  que est�o dentro de um contexto do QuoteChar...
  Veja exemplos de uso e retorno em: "ACBrUtilTeste"
  ------------------------------------------------------------------------------ }
function addDelimitador(const AText: String; const ADelimiter: Char;
  AStringList: TStrings; const AQuoteChar: Char): Integer;
var
   SL: TStringList;
{$IFNDEF HAS_STRICTDELIMITER}
   L, Pi, Pf, Pq: Integer;
{$ENDIF}
begin
   result := 0;
   if (AText = '') then
      Exit;

   SL := TStringList.Create;
   try
{$IFDEF HAS_STRICTDELIMITER}
      SL.Delimiter := ADelimiter;
      SL.QuoteChar := AQuoteChar;
      SL.StrictDelimiter := True;
      SL.DelimitedText := AText;
{$ELSE}
      L := Length(AText);
      Pi := 1;
      if (ADelimiter = AQuoteChar) then
         Pq := L + 1
      else
      begin
         Pq := Pos(AQuoteChar, AText);
         if Pq = 0 then
            Pq := L + 1;
      end;

      while Pi <= L do
      begin
         if (Pq = Pi) then
         begin
            Inc(Pi); // Pula o Quote
            Pf := PosEx(AQuoteChar, AText, Pi);
            Pq := Pf;
         end
         else
            Pf := PosEx(ADelimiter, AText, Pi);

         if Pf = 0 then
            Pf := L + 1;

         SL.Add(Copy(AText, Pi, Pf - Pi));

         if (Pq = Pf) then
         begin
            Pq := PosEx(AQuoteChar, AText, Pq + 1);
            Inc(Pf);
         end;

         Pi := Pf + 1;
      end;
{$ENDIF}
      result := SL.Count;

      AStringList.AddStrings(SL);
   finally
      SL.Free;
   end;
end;

{ -----------------------------------------------------------------------------
  Quebra Linhas grandes no m�ximo de Colunas especificado, ou caso encontre
  uma quebra de Linha (CR ou CR+LF)
  Retorna uma String usando o #10 como separador de Linha
  Se <NumMaxLinhas> for especificado, para ao chegar no Limite de Linhas
  Se <PadLinhas> for True, Todas as linhas ter�o o mesmo tamanho de Colunas
  com espa�os a esquerda se necess�rio.
  ---------------------------------------------------------------------------- }
function AjustaLinhas(const Texto: string; Colunas: Integer;
  NumMaxLinhas: Integer; PadLinhas: Boolean): string;
Var
   Count, P, I: Integer;
   Linha, CurrLineBreak, VTexto: String;
begin
   VTexto := String(Texto);
   { Trocando todos os #13+#10 por #10 }
   CurrLineBreak := sLineBreak;
   if (CurrLineBreak <> #13 + #10) then
      VTexto := StringReplace(VTexto, #13 + #10, #10, [rfReplaceAll]);

   if (CurrLineBreak <> #10) then
      VTexto := StringReplace(VTexto, CurrLineBreak, #10, [rfReplaceAll]);

   { Ajustando a largura das Linhas para o m�ximo permitido em  "Colunas"
     e limitando em "NumMaxLinhas" o total de Linhas }
   Count := 0;
   result := '';
   while ((Count < NumMaxLinhas) or (NumMaxLinhas = 0)) and
     (Length(VTexto) > 0) do
   begin
      P := Pos(#10, VTexto);
      if P > (Colunas + 1) then
         P := Colunas + 1;

      if P = 0 then
         P := min(Length(VTexto), Colunas) + 1;

      // somar 2 quando encontrar uma tag para n�o quebrar ela
      if (Copy(VTexto, P - 1, 1) = '<') or (Copy(VTexto, P - 2, 2) = '</') then
         Inc(P, 2);

      I := 0;
      if Copy(VTexto, P, 1) = #10 then // Pula #10 ?
         I := 1;

      Linha := Copy(VTexto, 1, P - 1); // Remove #10 (se hover)

      if PadLinhas then
         result := result + alinhaDireita(Linha, Colunas, ' ') + #10
      else
         result := result + Linha + #10;

      Inc(Count);
      VTexto := Copy(VTexto, P + I, Length(VTexto));
   end;

   { Permitir impress�o de uma linha em branco }
   if result = '' then
   begin
      if PadLinhas then
         result := AddEspaco(Colunas) + #10
      else
         result := #10;
   end;
end;

{ -----------------------------------------------------------------------------
  Completa <AString> com <Caracter> a direita, at� o tamanho <nLen>, Alinhando
  a <AString> a Esquerda. Se <AString> for maior que <nLen>, ela ser� truncada
  ---------------------------------------------------------------------------- }
function alinhaDireita(const AString: String; const nLen: Integer;
  const Caracter: Char): String;
var
   Tam: Integer;
begin
   Tam := LenghtUTF(AString);
   if Tam < nLen then
      result := AString + StringOfChar(Caracter, (nLen - Tam))
   else
      result := LeftStr(AString, nLen);
end;

{ -----------------------------------------------------------------------------
  Completa <AString> com <Caracter> a esquerda, at� o tamanho <nLen>, Alinhando
  a <AString> a Direita. Se <AString> for maior que <nLen>, ela ser� truncada
  ---------------------------------------------------------------------------- }
function alinhaEsquerda(const AString: String; const nLen: Integer;
  const Caracter: Char): String;
var
   Tam: Integer;
begin
   Tam := LenghtUTF(AString);
   if Tam < nLen then
      result := StringOfChar(Caracter, (nLen - Tam)) + AString
   else
      result := LeftStr(AString, nLen); // RightStr(AString,nLen) ;
end;

{ -----------------------------------------------------------------------------
  Retorna o numero de caracteres dentro de uma String, semelhante a Length()
  Por�m Lenght() n�o funciona corretamente em FPC com UTF8 e acentos
  ---------------------------------------------------------------------------- }
function LenghtUTF(const AString: String): Integer;
begin
{$IFDEF FPC}
   result := UTF8Length(AString);
{$ELSE}
   result := Length(AString);
{$ENDIF}
end;

function AddEspaco(Tamanho: Integer): string;
begin
   result := StringOfChar(' ', Tamanho);
end;

function temInternet: Boolean;
var
   I: Integer;
begin
   try
      if InternetGetConnectedState(@I, 0) then
         result := True
      else
         result := False;
   except
      raise Exception.Create('Erro ao verificar a internet');

   end;

end;

procedure iniciaComWindows(nomePrograma: string);
var
   reg: TRegIniFile;
   sKey: string;
begin
   try
      sKey := '';
      reg := TRegIniFile.Create('');
      reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.WriteString('Software\Microsoft\Windows\CurrentVersion\Run' + sKey +
        #0, nomePrograma, ExtractFilePath(ParamStr(0)) +
        ExtractFileName(ParamStr(0)));
   finally
      FreeAndNil(reg);
   end;
end;

end.
