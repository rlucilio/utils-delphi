unit Model.Relatorio.InformacaoRodape;

interface

uses Model.Relatorio.Interfaces, System.Generics.Collections;

type
   TModelInformacaoRodape = class(TInterfacedObject, iModelInformacaoRodape)
   private
      Flinhas: TList<string>;
      Ftamanho: integer;
      FqtdMaxCaracteres: integer;
      //
      constructor Create(linhas: TList<string>;
        tamanho, qtdMaxCaracteres: integer);
      function getLinhas: TList<string>;
      function getTamanho: integer;
      function getQtdMaxCaracteres: integer;
   public
      class function New(linhas: TList<string>;
        tamanho, qtdMaxCaracteres: integer): iModelInformacaoRodape;
      destructor Destroy; override;
      //
      property linhas: TList<string> read getLinhas;
      property tamanho: integer read getTamanho;
      property qtdMaxCaracteres: integer read getQtdMaxCaracteres;
   end;

implementation

{ TModelInformacaoRodape }

constructor TModelInformacaoRodape.Create(linhas: TList<string>;
  tamanho, qtdMaxCaracteres: integer);
begin
   inherited Create;
   Flinhas := linhas;
   Ftamanho := tamanho;
   FqtdMaxCaracteres := qtdMaxCaracteres;
end;

destructor TModelInformacaoRodape.Destroy;
begin

   inherited;
end;

function TModelInformacaoRodape.getLinhas: TList<string>;
begin
   result := Flinhas;
end;

function TModelInformacaoRodape.getQtdMaxCaracteres: integer;
begin
   result := FqtdMaxCaracteres;
end;

function TModelInformacaoRodape.getTamanho: integer;
begin
   result := Ftamanho;
end;

class function TModelInformacaoRodape.New(linhas: TList<string>;
  tamanho, qtdMaxCaracteres: integer): iModelInformacaoRodape;
begin
   result := Self.Create(linhas, tamanho, qtdMaxCaracteres);

end;

end.
