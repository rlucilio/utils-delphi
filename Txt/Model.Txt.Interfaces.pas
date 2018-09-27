unit Model.Txt.Interfaces;

interface

type
   iModelLogTxt = interface
      ['{7C01BD1C-91A2-42B8-AE42-30F121FEF4D6}']
      function Gravar(pArquivo, pValue: string): iModelLogTxt;
      function AbrirPastaLog: iModelLogTxt;
   end;

implementation

end.
