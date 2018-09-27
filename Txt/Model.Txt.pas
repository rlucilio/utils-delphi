unit Model.Txt;

interface

uses
   System.SysUtils, System.ioUtils;

type
   TModelTxt = class
   public
      class procedure GravarTxt(nomeDoArquivo, pasta, textoASerSalvo: string);
   end;

implementation

{ TModelTxt }

class procedure TModelTxt.GravarTxt(nomeDoArquivo, pasta,
  textoASerSalvo: string);
var
   txtFile: TextFile;
   localENomeDoArquivo: string;
begin
   if not(DirectoryExists(pasta)) then
      ForceDirectories(pasta);

   localENomeDoArquivo := pasta + nomeDoArquivo;

   AssignFile(txtFile, localENomeDoArquivo);

   if fileexists(localENomeDoArquivo) then
      Append(txtFile)
   else
      Rewrite(txtFile);

   writeln(txtFile, textoASerSalvo);
   CloseFile(txtFile);

end;

end.
