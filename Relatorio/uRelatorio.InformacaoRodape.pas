unit uRelatorio.InformacaoRodape;


interface

uses
  uRelatorio.Interfaces,
  System.Generics.Collections;

type
   TInformacaoRodape = class(TInterfacedObject, IInformacaoRodape)
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
        tamanho, qtdMaxCaracteres: integer): IInformacaoRodape;
      destructor Destroy; override;
      //
      property linhas: TList<string> read getLinhas;
      property tamanho: integer read getTamanho;
      property qtdMaxCaracteres: integer read getQtdMaxCaracteres;
   end;

implementation

{ TInformacaoRodape }

constructor TInformacaoRodape.Create(linhas: TList<string>;
  tamanho, qtdMaxCaracteres: integer);
begin
   inherited Create;
   Flinhas := linhas;
   Ftamanho := tamanho;
   FqtdMaxCaracteres := qtdMaxCaracteres;
end;

destructor TInformacaoRodape.Destroy;
begin

   inherited;
end;

function TInformacaoRodape.getLinhas: TList<string>;
begin
   result := Flinhas;
end;

function TInformacaoRodape.getQtdMaxCaracteres: integer;
begin
   result := FqtdMaxCaracteres;
end;

function TInformacaoRodape.getTamanho: integer;
begin
   result := Ftamanho;
end;

class function TInformacaoRodape.New(linhas: TList<string>;
  tamanho, qtdMaxCaracteres: integer): IInformacaoRodape;
begin
   result := Self.Create(linhas, tamanho, qtdMaxCaracteres);

end;

end.

