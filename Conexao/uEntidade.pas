unit uEntidade;

interface

uses
  SimpleInterface,
  SimpleDAO,
  SimpleQueryFiredac,
  FireDAC.Comp.Client;

type
  TEntidadeHelper = class helper for TObject
    function SetDAO<T: class, constructor>(const connction: TFDConnection): iSimpleDAO<T>;
  end;


implementation

uses
  System.SysUtils;


{ TEntidadeHelper }

function TEntidadeHelper.SetDAO<T>(const connction: TFDConnection): iSimpleDAO<T>;
begin
  if Assigned(connction) then
  begin
    result:= TSimpleDAO<T>
              .new(TSimpleQueryFiredac.New(connction));
  end
  else
    raise Exception.Create('Conexão inválida');
end;

end.
