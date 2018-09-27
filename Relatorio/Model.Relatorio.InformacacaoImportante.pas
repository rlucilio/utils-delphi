unit Model.Relatorio.InformacacaoImportante;

interface

uses Model.Relatorio.Interfaces, System.Generics.Collections;

type
   TModelInformacaoImportante = class(TInterfacedObject,
     iModelInformacaoImportante)
   private
      Ftitulo: string;
      FtamanhaoTitulo: integer;
      Finformacoes: TList<string>;
      FtamanhoInformacoes: integer;
      FqtdMaxCaracteres: integer;
      //
      constructor Create(titulo: string; tamanhoTitulo, qtdMaxCaracteres,
        tamanhoInformacoes: integer; informacoes: TList<string>);
      function getInformacoes: TList<string>;
      function getQtdMaxCaracteres: integer;
      function getTamanhaoTitulo: integer;
      function getTamanhoInformacoes: integer;
      function getTitulo: string;
   public
      class function New(titulo: string; tamanhoTitulo, qtdMaxCaracteres,
        tamanhoInformacoes: integer; informacoes: TList<string>)
        : iModelInformacaoImportante;
      destructor Destroy; override;
      //
      property titulo: string read getTitulo;
      property tamanhaoTitulo: integer read getTamanhaoTitulo;
      property informacoes: TList<string> read getInformacoes;
      property tamanhoInformacoes: integer read getTamanhoInformacoes;
      property qtdMaxCaracteres: integer read getQtdMaxCaracteres;
   end;

implementation

{ TModelInformacaoImportante }

constructor TModelInformacaoImportante.Create(titulo: string;
  tamanhoTitulo, qtdMaxCaracteres, tamanhoInformacoes: integer;
  informacoes: TList<string>);
begin
   inherited Create;
   Ftitulo := titulo;
   FtamanhaoTitulo := tamanhoTitulo;
   Finformacoes := informacoes;
   FtamanhoInformacoes := tamanhoInformacoes;
   FqtdMaxCaracteres := qtdMaxCaracteres;
end;

destructor TModelInformacaoImportante.Destroy;
begin

   inherited;
end;

function TModelInformacaoImportante.getInformacoes: TList<string>;
begin
   result := Finformacoes;
end;

function TModelInformacaoImportante.getQtdMaxCaracteres: integer;
begin
   result := FqtdMaxCaracteres;
end;

function TModelInformacaoImportante.getTamanhaoTitulo: integer;
begin
   result := FtamanhaoTitulo;
end;

function TModelInformacaoImportante.getTamanhoInformacoes: integer;
begin
   result := FtamanhoInformacoes;
end;

function TModelInformacaoImportante.getTitulo: string;
begin
   result := Ftitulo;
end;

class function TModelInformacaoImportante.New(titulo: string;
  tamanhoTitulo, qtdMaxCaracteres, tamanhoInformacoes: integer;
  informacoes: TList<string>): iModelInformacaoImportante;
begin
   result := Self.Create(titulo, tamanhoTitulo, qtdMaxCaracteres,
     tamanhoInformacoes, informacoes);
end;

end.
