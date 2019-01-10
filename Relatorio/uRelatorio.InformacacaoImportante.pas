unit uRelatorio.InformacacaoImportante;


interface

uses
  uRelatorio.Interfaces,
  System.Generics.Collections;

type
   TInformacaoImportante = class(TInterfacedObject,
     IInformacaoImportante)
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
        : IInformacaoImportante;
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

constructor TInformacaoImportante.Create(titulo: string;
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

destructor TInformacaoImportante.Destroy;
begin

   inherited;
end;

function TInformacaoImportante.getInformacoes: TList<string>;
begin
   result := Finformacoes;
end;

function TInformacaoImportante.getQtdMaxCaracteres: integer;
begin
   result := FqtdMaxCaracteres;
end;

function TInformacaoImportante.getTamanhaoTitulo: integer;
begin
   result := FtamanhaoTitulo;
end;

function TInformacaoImportante.getTamanhoInformacoes: integer;
begin
   result := FtamanhoInformacoes;
end;

function TInformacaoImportante.getTitulo: string;
begin
   result := Ftitulo;
end;

class function TInformacaoImportante.New(titulo: string;
  tamanhoTitulo, qtdMaxCaracteres, tamanhoInformacoes: integer;
  informacoes: TList<string>): IInformacaoImportante;
begin
   result := Self.Create(titulo, tamanhoTitulo, qtdMaxCaracteres,
     tamanhoInformacoes, informacoes);
end;

end.

