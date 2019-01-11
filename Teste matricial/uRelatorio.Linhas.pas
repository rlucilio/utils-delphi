unit uRelatorio.Linhas;

interface

uses
  Model.LibUtil,
  System.Classes,
  System.SysUtils,
  uRelatorio.Interfaces;

type
  TTratamentoLinhas = class(TInterfacedObject, ITratamentoLinhas)
  private
  public
    function TratarLinha(linha: string; quantidadeCaracteres: integer): TArray<string>;
    function TratarLinhas(linhas: TArray<string>; quantidadeCaracteres: integer): TArray<string>;

    function AlinharLinha(linha: string; tamanho: integer ; align: TAlignTexto): string;
    function AlinharLinhas(linhas: TArray<string>;tamanho: integer ; align: TAlignTexto): TArray<string>;

    procedure AddLinha(linha: string; outLinhas: TStrings; caracterEspecial: string = '');
    procedure AddLinhas(linhas: TArray<string>; outLinhas: TStrings; caracterEspecial: string = '');

    procedure AddLinhasColunadas(linhas: TArray<string>;TamanhoColunas: TArray<integer>;
       outLinhas: tstrings; caracterEspecial: string = '');

    procedure AddLinhaKeyValue(key, value: string;quantidadeMaximaCaracteres: integer;
             outLinhas: tstrings; caracterEspecial: string = '');
    procedure AddLinhasKeyValue(key, value: TArray<string>;quantidadeMaximaCaracteres: integer;
             outLinhas: tstrings; caracterEspecial: string = '');

    class function New: ITratamentoLinhas;
  end;

implementation

uses
  ACBrUtil, System.Generics.Collections;

{ TTratamentoLinhas }

procedure TTratamentoLinhas.AddLinha(linha: string; outLinhas: TStrings; caracterEspecial: string = '');
begin
  if (outLinhas.IndexOf(linha) = -1) and not(string.IsNullOrWhiteSpace(linha)) then
    outLinhas.Add(Concat(caracterEspecial, linha));
end;


procedure TTratamentoLinhas.AddLinhaKeyValue(key, value: string;quantidadeMaximaCaracteres: integer;
             outLinhas: tstrings; caracterEspecial: string = '');
var
  tamanhoDivido: integer;
  keyAjustado, valueAjutado, linha: string;
begin
  tamanhoDivido:= trunc(quantidadeMaximaCaracteres / 2);

  keyAjustado:= AlinharLinha(key, tamanhoDivido, atLeft);
  valueAjutado:= AlinharLinha(key, tamanhoDivido, atRigth);
  linha:= Concat(keyAjustado, valueAjutado);
  outLinhas.Add(Concat(caracterEspecial, linha));
end;

procedure TTratamentoLinhas.AddLinhas(linhas: TArray<string>; outLinhas: TStrings; caracterEspecial: string = '');
var
  it: string;
begin
  for it in linhas do
  begin
      AddLinha(it, outLinhas, caracterEspecial);
  end;
end;

procedure TTratamentoLinhas.AddLinhasColunadas(linhas: TArray<string>;TamanhoColunas: TArray<integer>;
       outLinhas: tstrings; caracterEspecial: string = '');
var
  linhasNovas: TArray<string>;
  resultado: TStringList;
  _linha, linha, espacoEmBranco: string;
  I, J, quantidadeEspacoEmBranco: integer;
begin
  resultado := TStringList.Create;
  quantidadeEspacoEmBranco := 0;
  try
    for I := 0 to Length(linhas) - 1 do
    begin
      // ajusta a linha
      linhasNovas := TratarLinha(linhas[I], TamanhoColunas[I]);

      // verifica se qtd de linhas da linhas ajustada é maior que a quantidade de resultado
      // se for vai deixa os dois com a mesma quantidade
      if resultado.Count - 1 < Length(linhasNovas) - 1 then
      begin
        if I = 0 then
          for J := 0 to Length(linhasNovas) - 1 do
            resultado.Add('')
        else
        for J := 0 to Length(linhasNovas) - 1 do
        begin
          espacoEmBranco:= alinhaTextoADireita('', quantidadeEspacoEmBranco - 1, ' ');
          resultado.Add(espacoEmBranco);
        end;
      end;

      // adiciona as novas linhas ajustadas no resultado
      for J := 0 to Length(linhasNovas) - 1 do
      begin
        if (linhasNovas[J] = sLineBreak) or not(linhasNovas[J].IsEmpty) then
        begin
          if I = 0 then
          begin
            _linha := resultado[J];

            Insert(linhasNovas[J] + ' ', _linha, 0);

            quantidadeEspacoEmBranco := TamanhoColunas[I] + 2;

            resultado[J] := _linha;
          end
          else
          begin
            _linha := resultado[J];

            if resultado[J] = '' then
              resultado[J] := padright('', quantidadeEspacoEmBranco - TamanhoColunas[I], ' ');

            quantidadeEspacoEmBranco := quantidadeEspacoEmBranco + TamanhoColunas[I];

            linha := trim(linhasNovas[J]);

            if I > 1 then
              linha := alinhaTextoADireita(linha, TamanhoColunas[I], ' ')
            else
              linha := alinhaTextoAEsquerda(linha, TamanhoColunas[I], ' ');

            Insert(linha + ' ', _linha, quantidadeEspacoEmBranco);
            resultado[J] := _linha;
          end;
        end;
      end;
    end;

    // adiciona no memo destino
    for I := 0 to resultado.Count - 1 do
        if trim(resultado[I]) <> '' then
          outLinhas.Add(Concat(caracterEspecial, resultado[I]));

  finally
    FreeAndNil(resultado);
  end;
end;

procedure TTratamentoLinhas.AddLinhasKeyValue(key, value: TArray<string>;quantidadeMaximaCaracteres: integer;
             outLinhas: tstrings; caracterEspecial: string = '');
var
  I: Integer;
  keys, values: TList<string>;
begin
  keys:= TList<string>.Create;
  keys.AddRange(key);
  values:=  TList<string>.Create;
  values.AddRange(value);
  try
    if values.Count > keys.Count then
      for I := Pred(keys.Count) to Pred(values.Count) do
        keys.Add('');

    if keys.Count >= values.Count then
      for I := Pred(values.Count) to Pred(keys.Count) do
        values.Add('');

    for I := 0 to Pred(keys.Count) do
    begin
      AddLinhaKeyValue(key[I], value[I], quantidadeMaximaCaracteres, outLinhas, caracterEspecial);
    end;
  finally
    keys.Free;
    values.Free;
  end;
end;

function TTratamentoLinhas.AlinharLinha(linha: string; tamanho: integer ; align: TAlignTexto): string;
begin
  Result:= AlinhaString(linha, ' ', tamanho, align);
end;

function TTratamentoLinhas.AlinharLinhas(linhas: TArray<string>;tamanho: integer ; align: TAlignTexto): TArray<string>;
var
  it, _linha: string;
  resultado: TStringList;
begin
  resultado:= TStringList.Create();
  try
    for it in linhas do
    begin
      _linha:= AlinharLinha(it, tamanho, align);
      resultado.Add(_linha);
    end;
    Result:= resultado.ToStringArray();
  finally
    resultado.Free;
  end;
end;

class function TTratamentoLinhas.New: ITratamentoLinhas;
begin
  result:= self.Create();
end;

function TTratamentoLinhas.TratarLinha(linha: string; quantidadeCaracteres: integer): TArray<string>;
var
  resultado: TStringList;
  linhasNovas: TStringList;
  it, it2, linhaAjustada: string;
  I: integer;
begin
  resultado:= TStringList.Create();
  linhasNovas := TStringList.Create();
  try
    linhaAjustada := String(AjustaLinhas(AnsiString(it), quantidadeCaracteres, 1000, true));

    addDelimitador(linhaAjustada, #10, linhasNovas);

    for I := 0 to linhasNovas.Count - 1 do
    begin
      if (linhasNovas[I] = sLineBreak) or not(trim(linhasNovas[I]).IsEmpty)
      then
      begin
        for it2 in resultado do
        begin
          if trim(linhasNovas[I]).contains(trim(it2)) then
          begin
            linhasNovas[I] := '';
            break;
          end;
        end;

        if not String.IsNullOrWhiteSpace(linhasNovas[I]) then
          resultado.Add(linhasNovas[I]);
      end;
    end;

    Result:= resultado.ToStringArray();
  finally
    resultado.Free;
    linhasNovas.Free;
  end;
end;

function TTratamentoLinhas.TratarLinhas(linhas: TArray<string>; quantidadeCaracteres: integer): TArray<string>;
var
  it, it2: string;
  _linhas: TArray<string>;
  resultado: TStringList;
begin
  resultado:= TStringList.Create();
  try
    for it in linhas do
    begin
      _linhas:=  TratarLinha(it, quantidadeCaracteres);
      for it2 in _linhas do
      begin
        if not string.IsNullOrWhiteSpace(it2) then
          resultado.Add(it2);
      end;
    end;

    Result:= resultado.ToStringArray();
  finally
    resultado.Free();
  end;
end;

end.





