unit Model.PowerCMD.Interfaces;

interface

uses
   System.Classes;

type
   iModelPowerCMD = interface
      ['{07027192-1DEE-4184-9EA8-82AF3C85D7E4}']
      function ExecComando(pComando: string; var pResultado: string)
        : iModelPowerCMD;
      function ExecLink(pLink: string): iModelPowerCMD;
      function ExecDir(pDir: string): Boolean;
   end;

implementation

end.
