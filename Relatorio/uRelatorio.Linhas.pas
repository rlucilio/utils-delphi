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

    procedure AddLinha(linha: string; outLinhas: TStrings; caracterEspecialAntes:string = ''; caracterEspecialDepois: string = '');
    procedure AddLinhas(linhas: TArray<string>; outLinhas: TStrings; caracterEspecialAntes: string = ''; caracterEspecialDepois: string = '');

    procedure AddLinhasColunadas(outLinhas: Tstrings; colunas: TArray<string>; quantidadeCaracteres: TArray<integer>);

    procedure AddLinhaKeyValue(key, value: string;quantidadeMaximaCaracteres: integer;
             outLinhas: tstrings; caracterEspecialAntes:string = ''; caracterEspecialDepois: string = '');

    procedure AddLinhasKeyValue(key, value: TArray<string>;quantidadeMaximaCaracteres: integer;
             outLinhas: tstrings; caracterEspecialAntes:string = ''; caracterEspecialDepois: string = '');

    class function New: ITratamentoLinhas;
  end;

implementation

uses
  ACBrUtil, System.Generics.Collections;

{ TTratamentoLinhas }

procedure TTratamentoLinhas.AddLinha(linha: string; outLinhas: TStrings; caracterEspecialAntes:string = ''; caracterEspecialDepois: string = '');
begin
  if not string.IsNullOrWhiteSpace(linha) then
    outLinhas.Add(Concat(caracterEspecialAntes, linha, caracterEspecialDepois));
end;


procedure TTratamentoLinhas.AddLinhaKeyValue(key, value: string;quantidadeMaximaCaracteres: integer;
             outLinhas: tstrings; caracterEspecialAntes:string = ''; caracterEspecialDepois: string = '');
var
  tamanhoDivido: integer;
  keyAjustado, valueAjustado, linha: string;
begin
  tamanhoDivido:= trunc(quantidadeMaximaCaracteres/2);
  key:= trim(key);
  value:= Trim(value);
  keyAjustado:= AlinharLinha(key, tamanhoDivido, atRigth);
  valueAjustado:= AlinharLinha(value, tamanhoDivido, atLeft);
  linha:= Concat(keyAjustado, valueAjustado);
  outLinhas.Add(Concat(caracterEspecialAntes, linha, caracterEspecialDepois));
end;

procedure TTratamentoLinhas.AddLinhas(linhas: TArray<string>; outLinhas: TStrings; caracterEspecialAntes: string = ''; caracterEspecialDepois: string = '');
var
  it: string;
begin
  for it in linhas do
  begin
      AddLinha(it, outLinhas, caracterEspecialAntes, caracterEspecialDepois);
  end;
end;

procedure TTratamentoLinhas.AddLinhasColunadas(outLinhas: Tstrings; colunas: TArray<string>; quantidadeCaracteres: TArray<integer>);
var
  resultado: TStringList;
  linhasAjustadas: TList<string>;
  _texto: string;
  colunaAtual, I, indice: Integer;
begin
  resultado:= TStringList.Create;
  linhasAjustadas:= TList<string>.Create;
  try
    if ((Length(colunas)>0) and (Length(quantidadeCaracteres)>0)) and
        (Length(colunas) = Length(quantidadeCaracteres)) then
    begin
      for colunaAtual := 0 to Pred(Length(colunas)) do
      begin
        linhasAjustadas.Clear;
        linhasAjustadas.AddRange(TratarLinha(colunas[colunaAtual], quantidadeCaracteres[colunaAtual]));

        if resultado.Count < linhasAjustadas.Count then
        begin
          {Linhas ajusdatadas maior}
          if colunaAtual = 0 then
          begin
            for I := 0 to Pred(linhasAjustadas.Count) do
              resultado.Add(_texto)
          end
          else 
          begin   
            if resultado.Count > -1 then
            begin
              if Pred(resultado.Count) > -1 then
              begin
                if  resultado[Pred(resultado.Count)].IsEmpty then
                  _texto:= ''
                else
                  _texto:= AlinharLinha('', Length(resultado[Pred(resultado.Count)]), atCenter);
              end;
              
              for I := Pred(resultado.Count) to Pred(linhasAjustadas.Count) do
              begin
                resultado.Add(_texto);
              end;
            end;
          end;
        end
        else
        begin
          {resultado maior}
          _texto:= AlinharLinha('', quantidadeCaracteres[colunaAtual], atCenter);
          for I := Pred(linhasAjustadas.Count) to Pred(resultado.Count)-1 do
          begin
            linhasAjustadas.Add(_texto);
          end;
        end;

        for I := 0 to Pred(linhasAjustadas.Count) do
        begin
          if colunaAtual = 0 then
          begin
            resultado[I]:= AlinharLinha(linhasAjustadas[I], quantidadeCaracteres[colunaAtual], atRigth);
          end
          else
          begin
            if colunaAtual > 1 then
              _texto:= Concat(resultado[I], ' ', AlinharLinha(linhasAjustadas[I], quantidadeCaracteres[colunaAtual], atRigth))
            else
              _texto:= Concat(resultado[I], ' ', AlinharLinha(linhasAjustadas[I], quantidadeCaracteres[colunaAtual], atLeft));

            resultado[I]:= _texto;
          end;
        end;
      end;
    end;

   for I := 0 to Pred(resultado.Count) do
    if not(trim(resultado[I]).IsEmpty) then
      outLinhas.Add(resultado[I]);

  finally
    linhasAjustadas.Free;
    resultado.Free;
  end;
end;

procedure TTratamentoLinhas.AddLinhasKeyValue(key, value: TArray<string>;quantidadeMaximaCaracteres: integer;
             outLinhas: tstrings; caracterEspecialAntes:string = ''; caracterEspecialDepois: string = '');
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
      for I := Pred(keys.Count) to Pred(values.Count)-1 do
        keys.Add('');

    if keys.Count > values.Count then
      for I := Pred(values.Count) to Pred(keys.Count)-1 do
        values.Add('');

    for I := 0 to Pred(keys.Count) do
    begin
      AddLinhaKeyValue(keys[I], values[I], quantidadeMaximaCaracteres, outLinhas, caracterEspecialAntes, caracterEspecialDepois);
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
  it, linhaAjustada: string;
  I: integer;
begin
  resultado:= TStringList.Create();
  linhasNovas := TStringList.Create();
  try
    linhaAjustada := String(AjustaLinhas(AnsiString(linha), quantidadeCaracteres, 1000, true));

    addDelimitador(linhaAjustada, #10, linhasNovas);

    for I := 0 to linhasNovas.Count - 1 do
    begin
      if (linhasNovas[I] = sLineBreak) or not(trim(linhasNovas[I]).IsEmpty)
      then
      begin
        for it in resultado do
        begin
          if trim(linhasNovas[I]).contains(trim(it)) then
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





