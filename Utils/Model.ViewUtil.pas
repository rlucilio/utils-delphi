unit Model.ViewUtil;

interface

function ResultadoDaPergunta(titulo, pergunta: string): string;
function SelecionarCaminhoDoArquivo(filtro, titulo: string): string;

implementation

uses
  FMX.Dialogs, System.SysUtils, FMX.Platform;

function SelecionarCaminhoDoArquivo(filtro, titulo: string): string;
var
   openDialog: TOpenDialog;
begin
   openDialog := TOpenDialog.Create(nil);
   openDialog.Title := titulo;
   openDialog.InitialDir := 'C:\';
   openDialog.Filter := filtro;
   try
      if openDialog.Execute then
      begin
         if openDialog.FileName <> '' then
         begin
            Result := openDialog.FileName;
         end
         else
            ShowMessage('Arquivo Inválido');
      end;
   finally
      FreeAndNil(openDialog);
   end;
end;

function ResultadoDaPergunta(titulo, pergunta: string): string;
var
   dialog: IFMXDialogServiceSync;
   resposta: array [1 .. 1] of string;
begin
   resposta[1] := '';
   TPlatformServices.Current.SupportsPlatformService(IFMXDialogServiceSync,
     IInterface(dialog));

   dialog.InputQuerySync(titulo, [pergunta], resposta);
   Result := resposta[1];
end;

end.
