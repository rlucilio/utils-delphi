unit Model.LibUtil;

interface

uses
  System.Win.Registry, System.Classes;

type
  TAlignTexto = (atCenter, atLeft, atRigth);

procedure instalarFontes(nomeRecurso, nomeArquivo: string);

function getIP: string;

function temInternet: Boolean;

procedure iniciaComWindows(nomePrograma: string); overload;
procedure iniciaComWindows(nomePrograma: string; localPrograma: string); overload;

function compactarArquivo(arquivos: TArray<string>;
  nomeArquivoZip: string): string;

function compactarPasta(pasta, nomeArquivoZip: string): string;

function DescompactarZip(const arquivoZip, localSalvamento: string): TArray<string>;

procedure limpaArquivosZip;

function alinhaTextoADireita(Texto: string; Qtd: Integer; Ch: Char): string;

function alinhaTextoAEsquerda(Texto: string; Qtd: Integer; Ch: Char): string;

function addDelimitador(const AText: String; const ADelimiter: Char;
  AStringList: TStrings; const AQuoteChar: Char = '"'): Integer;

procedure AbrePastaDeLogs();

function getListaPastas(dir: string): TArray<string>;

function GetVersaoPrograma(const programa: string): string;

function AlinhaString(texto, caracter: String; tamanho: Word; alinhamento: TAlignTexto): String;

function RemoveAcento(aText : string) : string;

implementation

uses
  System.SysUtils, Winapi.Windows, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms
{$ENDIF},
  System.Zip, System.IOUtils, WinSock, Winapi.WinInet, System.StrUtils,
  Model.PowerCMD, System.Generics.Collections, System.Types;

function RemoveAcento(aText : string) : string;
const
  ComAcento = 'àâêôûãõáéíóúçüñýÀÂÊÔÛÃÕÁÉÍÓÚÇÜÑÝ';
  SemAcento = 'aaeouaoaeioucunyAAEOUAOAEIOUCUNY';
var
  x: Cardinal;
begin;
  for x := 1 to Length(aText) do
  try
    if (Pos(aText[x], ComAcento) <> 0) then
      aText[x] := SemAcento[ Pos(aText[x], ComAcento) ];
  except on E: Exception do
    raise Exception.Create('Erro no processo.');
  end;

  Result := aText;
end;


function AlinhaString(texto, caracter: String; tamanho: Word; alinhamento: TAlignTexto): String;
var
  X: Integer;
begin
  if alinhamento = atCenter then
    texto:= Trim(texto);

  Result := Copy(texto, 1, tamanho);
  for X := Length(texto) to tamanho - 1 do
  begin
    case alinhamento of
      atLeft: Result := Caracter + Result;
      atRigth: Result := Result + Caracter;
      atCenter: if (X mod 2) = 0 then
                  Result := Result + Caracter
                else
                  Result := Caracter + Result;
    end;
  end;

end;

function GetVersaoPrograma(const programa: string): string;
var
  size, hand: DWORD;
  buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
begin
  result:= '';
  size := GetFileVersionInfoSize(PChar(programa), hand);

  if size = 0 then
    RaiseLastOSError;

  SetLength(buffer, size);

  if not GetFileVersionInfo(PChar(programa), Hand, size, buffer) then
    RaiseLastOSError;

  if not VerQueryValue(buffer, '\', Pointer(FixedPtr), size) then
    RaiseLastOSError;

  Result := Format('%d.%d.%d.%d',
    [LongRec(FixedPtr.dwFileVersionMS).Hi,  //major
     LongRec(FixedPtr.dwFileVersionMS).Lo,  //minor
     LongRec(FixedPtr.dwFileVersionLS).Hi,  //release
     LongRec(FixedPtr.dwFileVersionLS).Lo]) //build
end;

procedure iniciaComWindows(nomePrograma: string; localPrograma: string);
var
  reg: TRegIniFile;
  sKey: string;
begin
  try
    sKey := '';
    reg := TRegIniFile.Create('');
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.WriteString('Software\Microsoft\Windows\CurrentVersion\Run' + sKey + #0,
      nomePrograma, localPrograma);
  finally
    FreeAndNil(reg);
  end;
end;


function DescompactarZip(const arquivoZip, localSalvamento: string): TArray<string>;
var
  zipFile: TZipFile;
  arquivosList: TList<string>;
  item: string;
begin
  result:= [];
  arquivosList:= TList<string>.Create;
  zipFile:= TZipFile.Create;
  try
    try
      if not FileExists(arquivoZip) then
        raise Exception.Create('Arquivo Zip não foi encontrado');

      if not DirectoryExists(localSalvamento) then
        ForceDirectories(localSalvamento);

      if not DirectoryExists(localSalvamento) then
        raise Exception.Create('Não foi possível criar o local do salvamento');

      zipFile.Open(arquivoZip, zmRead);
      zipFile.ExtractAll(localSalvamento);
      zipFile.Close();

      for item in TDirectory.GetFiles(localSalvamento) do
      begin
        arquivosList.Add(item);
      end;

      Result:= arquivosList.ToArray();

    except
      raise Exception.Create('Erro ao Descompactar o arquivo');
    end;
  finally
    FreeAndNil(arquivosList);
    FreeAndNil(zipFile);
  end;
end;

function getListaPastas(dir: string): TArray<string>;
var
  resultado: TList<string>;
  item: string;
begin
  resultado := TList<string>.Create();
  try
    if DirectoryExists(dir) then
    begin
      for item in TDirectory.GetDirectories(dir) do
      begin
        resultado.Add(item)
      end;

      Result := resultado.ToArray;
    end;
  finally
    FreeAndNil(resultado);
  end;
end;

procedure AbrePastaDeLogs();
begin
  if not DirectoryExists(tpath.GetDocumentsPath + '\SICLOP\') then
    ForceDirectories(tpath.GetDocumentsPath + '\SICLOP\');

  TModelPowerCMD.new(HInstance).ExecDir(tpath.GetDocumentsPath + '\SICLOP\');
end;

function addDelimitador(const AText: String; const ADelimiter: Char;
  AStringList: TStrings; const AQuoteChar: Char): Integer;
var
  SL: TStringList;
{$IFNDEF HAS_STRICTDELIMITER}
  L, Pi, Pf, Pq: Integer;
{$ENDIF}
begin
  Result := 0;
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
    Result := SL.Count;

    AStringList.AddStrings(SL);
  finally
    SL.Free;
  end;
end;

function alinhaTextoAEsquerda(Texto: string; Qtd: Integer; Ch: Char): string;
var
  x: Integer;
begin

  if Length(Texto) > Qtd then
    Result := Copy(Texto, 0, Qtd)
  else
  begin
    x := Length(Texto);
    for Qtd := x to Qtd - 1 do
    begin
      Texto := Texto + Ch;
    end;
    Result := Texto;
  end

end;

function alinhaTextoADireita(Texto: string; Qtd: Integer; Ch: Char): string;
var
  x: Integer;
  str: string;
begin
  if Length(Texto) > Qtd then
    Result := Copy(Texto, (Length(Texto) - Qtd) + 1, Length(Texto))
  else
  begin
    str := '';
    for x := Length(Texto) to Qtd - 1 do
    begin
      str := str + Ch;
    end;
    Result := str + Texto;
  end

end;

function compactarPasta(pasta, nomeArquivoZip: string): string;
var
  Zip: TZipFile;
begin
  Zip := TZipFile.Create;
  Result := ExtractFilePath(ParamStr(0)) + nomeArquivoZip + '.zip';
  if FileExists(Result) then
    TFile.Delete(Result);

  try
    Zip.ZipDirectoryContents(Result, pasta);
  finally
    FreeAndNil(Zip);
  end;

end;

function compactarArquivo(arquivos: TArray<string>;
  nomeArquivoZip: string): string;
var
  Zip: TZipFile;
  item: string;
begin
  Zip := TZipFile.Create;
  try
    Result := ExtractFilePath(ParamStr(0)) + nomeArquivoZip + '.zip';
      Zip.open(Result, zmWrite);
      for item in arquivos do
      begin
        if FileExists(item) then
          Zip.Add(item);
      end;
  finally
    FreeAndNil(Zip);
  end;

end;

procedure limpaArquivosZip;
var
  item: string;
begin
  for item in TDirectory.GetFiles(ExtractFilePath(ParamStr(0)), '*.zip') do
  begin
    deletefile(PWideChar(item));
  end;
end;

function temInternet: Boolean;
var
  I: Integer;
begin
  try
    if InternetGetConnectedState(@I, 0) then
      Result := True
    else
      Result := False;
  except
    raise Exception.Create('Erro ao verificar a internet');

  end;

end;

procedure iniciaComWindows(nomePrograma: string);
begin
  iniciaComWindows(nomePrograma,
   ParamStr(0));
end;

function getIP: string;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name: string;
begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PAnsiChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := gethostbyname(PAnsiChar(Name));
  with HostEnt^ do
  begin
    Result := Format('%d.%d.%d.%d', [Byte(h_addr^[0]), Byte(h_addr^[1]),
      Byte(h_addr^[2]), Byte(h_addr^[3])]);
  end;
  WSACleanup;
end;

procedure instalarFontes(nomeRecurso, nomeArquivo: string);
var
  arquivobinario: TFileStream;
  localDoArquivo: string;
  recurso: TResourceStream;
begin
  try
    if not FileExists(GetCurrentDir + '\' + nomeArquivo) then
    begin
      try
        recurso := TResourceStream.Create(HInstance, nomeRecurso, RT_RCDATA);
        localDoArquivo := GetCurrentDir + '\' + nomeArquivo;
        arquivobinario := TFileStream.Create(GetCurrentDir + '\' + nomeArquivo,
          fmCreate);
        recurso.SaveToStream(arquivobinario);

        AddFontResource(PChar(localDoArquivo));
      finally
        if Assigned(recurso) then
          FreeAndNil(recurso);
        if Assigned(arquivobinario) then
          FreeAndNil(arquivobinario);
      end;

    end
    else
    begin

      AddFontResource(PChar(localDoArquivo));
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('erro ao instar as fontes');
      Application.Terminate;
    end;
  end;

end;

end.
