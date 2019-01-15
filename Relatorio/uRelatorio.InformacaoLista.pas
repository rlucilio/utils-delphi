unit uRelatorio.InformacaoLista;


interface

uses
  uRelatorio.Interfaces,
  System.Generics.Collections;

type
   TInformacaoLista = class(TInterfacedObject, IInformacaoLista)
   private
      FqtdMaxCaracteres: Tlist<integer>;
      Fcolunas: Tlist<string>;
      //
      constructor Create(colunas: Tlist<string>;
        qtdMaxCaracteres: Tlist<integer>);
      function getColunas: Tlist<string>;
      function getQtdMaxCaracteres: Tlist<integer>;
   public
      class function New(colunas: Tlist<string>;
        qtdMaxCaracteres: Tlist<integer>): IInformacaoLista;
      destructor Destroy; override;
      //
      property qtdMaxCaracteres: Tlist<integer> read getQtdMaxCaracteres;
      property colunas: Tlist<string> read getColunas;
   end;

implementation

{ TInformacaoLista }

constructor TInformacaoLista.Create(colunas: Tlist<string>;
  qtdMaxCaracteres: Tlist<integer>);
begin
   Fcolunas := colunas;
   FqtdMaxCaracteres := qtdMaxCaracteres;
end;

destructor TInformacaoLista.Destroy;
begin
   inherited;
end;

function TInformacaoLista.getColunas: Tlist<string>;
begin
   result := Fcolunas;
end;

function TInformacaoLista.getQtdMaxCaracteres: Tlist<integer>;
begin
   result := FqtdMaxCaracteres;
end;

class function TInformacaoLista.New(colunas: Tlist<string>;
  qtdMaxCaracteres: Tlist<integer>): IInformacaoLista;
begin
   result := Self.Create(colunas, qtdMaxCaracteres);
end;

end.

