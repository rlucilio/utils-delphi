unit Model.Ini.Interfaces;

interface

type
   iModelIni = interface
      ['{C1CE90E9-32EA-457E-AF71-AB24ECA51384}']
      function salva(obj: TObject): iModelIni;
      function carrega(obj: TObject): iModelIni;
   end;

implementation

end.
