unit Util.Helper;

interface

uses
  System.SysUtils;

type
  THelperDouble = record helper for Double
  function formataDinheiro: string;


  end;

implementation

{ THelperDouble }

function THelperDouble.formataDinheiro: string;
begin
  Result:= FormatFloat('R$ ###,###,##0.00', Self);
end;

end.
