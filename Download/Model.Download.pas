unit Model.Download;

interface

uses
   Model.Download.Exceptions, IdHTTP, System.Classes,
   IdComponent, Winapi.ShellAPI, Winapi.Windows;

type
   TModelDownload = class(TThread)
   private

      FindyHTTP: TidHTTP;
      FarquivoDownload: string;
      FlocalSalvar: string;
      FTerminado: Boolean;
      FarquivoMemoria: TStream;
      FtamanhoTotal: Integer;
      Fabrir: Boolean;
      //

      procedure comecoDownload(ASender: TObject; AWorkMode: TWorkMode;
        AWorkCountMax: Int64);
      procedure Baixando(ASender: TObject; AWorkMode: TWorkMode;
        AWorkCount: Int64);
      procedure fimDownload(ASender: TObject; AWorkMode: TWorkMode);
      procedure abrirArquivo;
      procedure Execute; override;
   public
      destructor Destroy; override;
      procedure Baixar;
      constructor Create(arquivo, pasta: string; abrir: Boolean);
      //
   end;

implementation

uses
   System.SysUtils;

{ TModelDownload }

procedure TModelDownload.Baixando(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin

end;

procedure TModelDownload.Baixar;
begin
  try
      try
        if fileExists(FlocalSalvar) then
            DeleteFile(FlocalSalvar);

        FarquivoMemoria := TFileStream.Create(FlocalSalvar, fmCreate);
        
        FindyHTTP := TidHTTP.Create;
        FindyHTTP.OnWorkBegin := comecoDownload;
        FindyHTTP.OnWork := Baixando;
        FindyHTTP.OnWorkEnd := fimDownload;
        FindyHTTP.Head(FarquivoDownload);
        FindyHTTP.HandleRedirects := True;

        FtamanhoTotal := FindyHTTP.Response.ContentLength;

        if not Pos('bytes', FindyHTTP.Response.AcceptRanges) > 0 then
        begin
            raise EDownloadException.Create('N�o h� download disponiv�l');
        end;



        FindyHTTP.Get(FarquivoDownload, FarquivoMemoria);
      
      Except
        FarquivoDownload.Free;
        raise EDownloadException.Create('Erro ao baixar o arquivo');
      end;
  finally
          FindyHTTP.Disconnect;
          FindyHTTP.Free;
  end;

end;

procedure TModelDownload.comecoDownload(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
   FTerminado := false;
end;

constructor TModelDownload.Create(arquivo, pasta: string; abrir: Boolean);
begin
   inherited Create(false);

   if arquivo = '' then 
    raise EDownloadException.Create('link inválido'); 

  if pasta = '' then 
    raise EDownloadException.Create('destino inválido');

   FarquivoDownload := arquivo;
   FlocalSalvar := pasta;
   Fabrir := abrir;
end;

destructor TModelDownload.Destroy;
begin

   inherited;
end;

procedure TModelDownload.Execute;
begin
   inherited;
   FreeOnTerminate := True;
   Baixar;
   abrirArquivo;
end;

procedure TModelDownload.fimDownload(ASender: TObject; AWorkMode: TWorkMode);
begin
   FTerminado := True;
end;


procedure TModelDownload.abrirArquivo;
begin
   if Fabrir then
      ShellExecute(HInstance, 'open', PChar(FlocalSalvar), '', '',
        SW_SHOWNORMAL);

   FarquivoMemoria.Free;
end;

end.
