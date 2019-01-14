unit uRelatorio.InformativosSimples;


interface

uses
  uRelatorio.Interfaces;

type
   TInformacaoSimples = class(TInterfacedObject, IInformacaoSimples)
   private
      Ftitulo: string;
      FInformativo: string;
      Ftamanho: integer;
      FqtdMaxCaracteres: integer;
      //

      function getInformativo: string;
      function getQtdMaxCaracteres: integer;
      function getTamanho: integer;
      function getTitulo: string;
   public
      class function New(titulo, Informativo: string;
        tamanho, qtdMaxCaracteres: integer): IInformacaoSimples;
      constructor Create(titulo, Informativo: string;
        tamanho, qtdMaxCaracteres: integer);
      destructor Destroy; override;
      //
      property titulo: string read getTitulo;
      property tamanho: integer read getTamanho;
      property Informativo: string read getInformativo;
      property qtdMaxCaracteres: integer read getQtdMaxCaracteres;
   end;

implementation

{ TInformacaoSimples }

constructor TInformacaoSimples.Create(titulo, Informativo: string;
  tamanho, qtdMaxCaracteres: integer);
begin
   inherited Create;
   Ftitulo := titulo;
   FInformativo := Informativo;
   Ftamanho := tamanho;
   FqtdMaxCaracteres := qtdMaxCaracteres;
end;

destructor TInformacaoSimples.Destroy;
begin

   inherited;
end;

function TInformacaoSimples.getInformativo: string;
begin
   result := FInformativo;
end;

function TInformacaoSimples.getQtdMaxCaracteres: integer;
begin
   result := FqtdMaxCaracteres;
end;

function TInformacaoSimples.getTamanho: integer;
begin
   result := Ftamanho;
end;

function TInformacaoSimples.getTitulo: string;
begin
   result := Ftitulo;
end;

class function TInformacaoSimples.New(titulo, Informativo: string;
  tamanho, qtdMaxCaracteres: integer): IInformacaoSimples;
begin
   result := Self.Create(titulo, Informativo, tamanho, qtdMaxCaracteres);
end;

end.

