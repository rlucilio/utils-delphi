unit Model.LibUtil;


interface

uses
  System.Classes, System.Win.Registry;

procedure instalarFontes(nomeRecurso, nomeArquivo: string);

function getIP: string;

function temInternet: Boolean;

procedure iniciaComWindows(nomePrograma: string);

function compactarArquivo(arquivos: TArray<string>;
  nomeArquivoZip: string): string;

function compactarPasta(pasta, nomeArquivoZip: string): string;

procedure limpaArquivosZip;

implementation

uses
  System.SysUtils, Winapi.Windows, VCL.Forms,
  System.Zip, System.IOUtils, WinSock, Winapi.WinInet;

function compactarPasta(pasta, nomeArquivoZip: string): string;
var
  Zip: TZipFile;
begin
  Zip := TZipFile.create;
  result := GetCurrentDir + '\' + nomeArquivoZip + '.zip';
  try
    Zip.ZipDirectoryContents(result, pasta);
  finally
    freeandnil(Zip);
  end;

end;

function compactarArquivo(arquivos: TArray<string>;
  nomeArquivoZip: string): string;
var
  Zip: TZipFile;
  item: string;
begin
  Zip := TZipFile.create;
  try
    result := GetCurrentDir + '\' + nomeArquivoZip + '.zip';
    Zip.open(result, zmWrite);
    for item in arquivos do
    begin
      if fileExists(item) then
        Zip.add(item);
    end;
  finally
    freeandnil(Zip);
  end;

end;

procedure limpaArquivosZip;
var
  item: string;
begin
  for item in TDirectory.GetFiles(GetCurrentDir, '*.zip') do
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
      result := True
    else
      result := False;
  except
    raise Exception.create('Erro ao verificar a internet');

  end;

end;

procedure iniciaComWindows(nomePrograma: string);
var
  reg: TRegIniFile;
  sKey: string;
begin
  try
    sKey := '';
    reg := TRegIniFile.create('');
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.WriteString('Software\Microsoft\Windows\CurrentVersion\Run' + sKey + #0,
      nomePrograma, ExtractFilePath(ParamStr(0)) +
      ExtractFileName(ParamStr(0)));
  finally
    freeandnil(reg);
  end;
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
    result := Format('%d.%d.%d.%d', [Byte(h_addr^[0]), Byte(h_addr^[1]),
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
    if not fileExists(GetCurrentDir + '\' + nomeArquivo) then
    begin
      try
        recurso := TResourceStream.create(HInstance, nomeRecurso, RT_RCDATA);
        localDoArquivo := GetCurrentDir + '\' + nomeArquivo;
        arquivobinario := TFileStream.create(GetCurrentDir + '\' + nomeArquivo,
          fmCreate);
        recurso.SaveToStream(arquivobinario);

        AddFontResource(PChar(localDoArquivo));
      finally
        if Assigned(recurso) then
          freeandnil(recurso);
        if Assigned(arquivobinario) then
          freeandnil(arquivobinario);
      end;

    end
    else
    begin

      AddFontResource(PChar(localDoArquivo));
    end;
  except
    on E: Exception do
    begin
      raise Exception.create('erro ao instar as fontes');
      Application.Terminate;
    end;
  end;

end;

end.

