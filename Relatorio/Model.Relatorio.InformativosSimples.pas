unit Model.Relatorio.InformativosSimples;

interface

uses Model.Relatorio.Interfaces;

type
   TModelInformacaoSimples = class(TInterfacedObject, iModelInformacaoSimples)
   private
      Ftitulo: string;
      FInformativo: string;
      Ftamanho: integer;
      FqtdMaxCaracteres: integer;
      //
      constructor Create(titulo, Informativo: string;
        tamanho, qtdMaxCaracteres: integer);
      function getInformativo: string;
      function getQtdMaxCaracteres: integer;
      function getTamanho: integer;
      function getTitulo: string;
   public
      class function New(titulo, Informativo: string;
        tamanho, qtdMaxCaracteres: integer): iModelInformacaoSimples;
      destructor Destroy; override;
      //
      property titulo: string read getTitulo;
      property tamanho: integer read getTamanho;
      property Informativo: string read getInformativo;
      property qtdMaxCaracteres: integer read getQtdMaxCaracteres;
   end;

implementation

{ TModelInformacaoSimples }

constructor TModelInformacaoSimples.Create(titulo, Informativo: string;
  tamanho, qtdMaxCaracteres: integer);
begin
   inherited Create;
   Ftitulo := titulo;
   FInformativo := Informativo;
   Ftamanho := tamanho;
   FqtdMaxCaracteres := qtdMaxCaracteres;
end;

destructor TModelInformacaoSimples.Destroy;
begin

   inherited;
end;

function TModelInformacaoSimples.getInformativo: string;
begin
   result := FInformativo;
end;

function TModelInformacaoSimples.getQtdMaxCaracteres: integer;
begin
   result := FqtdMaxCaracteres;
end;

function TModelInformacaoSimples.getTamanho: integer;
begin
   result := Ftamanho;
end;

function TModelInformacaoSimples.getTitulo: string;
begin
   result := Ftitulo;
end;

class function TModelInformacaoSimples.New(titulo, Informativo: string;
  tamanho, qtdMaxCaracteres: integer): iModelInformacaoSimples;
begin
   result := Self.Create(titulo, Informativo, tamanho, qtdMaxCaracteres);
end;

end.
