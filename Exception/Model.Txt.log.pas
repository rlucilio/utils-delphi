unit Model.Txt.log;

interface

uses Model.Txt.Interfaces;

type
   TModelLogTxt = class(TInterfacedObject, iModelLogTxt)
   private
      Fpasta: string;
      Constructor Create;
   public
      Destructor Destroy; override;
      class function New: iModelLogTxt;
      function Gravar(arquivo, value: string): iModelLogTxt;
      function AbrirPastaLog: iModelLogTxt;
      function delataLogs: iModelLogTxt;
   end;

implementation

uses
   System.ioUtils, System.Sysutils, Winapi.ShellAPI, Winapi.Windows,
   Model.Txt, System.DateUtils;

{ TModelLogTxt }

function TModelLogTxt.AbrirPastaLog: iModelLogTxt;
begin
   result := self;

   if not DirectoryExists(Fpasta) then
      ForceDirectories(Fpasta);

   ShellExecute(HInstance, 'open', PChar(ExtractFilePath(Fpasta)), nil, nil,
     SW_SHOWNORMAL)
end;

constructor TModelLogTxt.Create;
begin
   inherited;
   Fpasta := TPath.GetDocumentsPath + '\SICLOP\ServidorImpressao\';
end;

function TModelLogTxt.delataLogs: iModelLogTxt;
var
   item: string;
   dataArquivo: TDateTime;
begin
   result := self;
   if DirectoryExists(Fpasta) then
   begin
      for item in TDirectory.GetFiles(Fpasta, '*.log') do
      begin
         FileAge(item, dataArquivo);

         if (DayOf(dataArquivo) <> DayOf(Now)) then
            DeleteFile(PWideChar(item));
      end;
   end;
end;

destructor TModelLogTxt.Destroy;
begin

   inherited;
end;

function TModelLogTxt.Gravar(arquivo, value: string): iModelLogTxt;
begin
   result := self;
   TModelTxt.GravarTxt(arquivo, Fpasta, value);
end;

class function TModelLogTxt.New: iModelLogTxt;
begin
   result := self.Create;
end;

end.
