unit Model.Conexao.Construtor;

interface

uses
   Model.Conexao.interfaces, FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util,
   FireDAC.Comp.Script,
   FireDAC.Comp.Client, System.Classes;

type
   TModelConstrutor = class(TInterfacedObject, iModelCriarBanco)
   private
      constructor Create(Conexao: TFDConnection; sql: tstrings);
   public
      class function New(Conexao: TFDConnection; sql: tstrings): iModelCriarBanco;
      destructor Destroy; override;
   end;

implementation
uses
   System.SysUtils;

{ TModelConstrutor }

constructor TModelConstrutor.Create(Conexao: TFDConnection; sql: tstrings);
var
   Script: TFDScript;
begin
   inherited Create;
   try
      Script := TFDScript.Create(nil);
      try
         Script.Connection:= Conexao;
         Script.ExecuteScript(sql);
      except
         raise Exception.Create('Erro ao criar o banco de dados');
      end;
   finally
      FreeAndNil(Script);
   end;
end;

destructor TModelConstrutor.Destroy;
begin

   inherited;
end;

class function TModelConstrutor.New(Conexao: TFDConnection; sql: tstrings): iModelCriarBanco;
begin
   Result := Self.Create(Conexao, sql);
end;

end.
