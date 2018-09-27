unit ServidorImpressao.Model.ConsumirRest.Interfaces;

interface

type
     iModelConsumirRest=interface
     ['{08027C55-5D38-47C3-A235-3A55456F445F}']
          function SetURL(pValue: string): iModelConsumirRest;
          function SetURI(pValue: string): iModelConsumirRest;
          function GetJSON: string;
     end;

implementation

end.
