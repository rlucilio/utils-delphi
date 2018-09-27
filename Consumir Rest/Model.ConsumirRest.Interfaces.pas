unit Model.ConsumirRest.Interfaces;

interface

type
   iModelConsumirRest = interface
      ['{83B7CB14-8BA6-4DB2-9239-A133B7F2D0A7}']
      function SetCodigo(pValue: string): iModelConsumirRest;
      function GetJSON: string;
   end;

implementation

end.
