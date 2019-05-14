unit uCriadorJson.Interfaces;

interface

uses
  {Delphi}
    System.Json,
    RTTI;

type
  IPodeSerJson = interface
    ['{C77EC9A3-77F3-43BD-81F1-83D6588BE3BC}']
    function AsJson(): string;
  end;



implementation

end.
