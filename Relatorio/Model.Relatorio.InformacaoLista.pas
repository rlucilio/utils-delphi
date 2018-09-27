unit Model.Relatorio.InformacaoLista;

interface

uses Model.Relatorio.Interfaces, System.Generics.Collections;

type
   TModelInformacaoLista = class(TInterfacedObject, iModelInformacaoLista)
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
        qtdMaxCaracteres: Tlist<integer>): iModelInformacaoLista;
      destructor Destroy; override;
      //
      property qtdMaxCaracteres: Tlist<integer> read getQtdMaxCaracteres;
      property colunas: Tlist<string> read getColunas;
   end;

implementation

{ TModelInformacaoLista }

constructor TModelInformacaoLista.Create(colunas: Tlist<string>;
  qtdMaxCaracteres: Tlist<integer>);
begin
   inherited Create;
   Fcolunas := colunas;
   FqtdMaxCaracteres := qtdMaxCaracteres;
end;

destructor TModelInformacaoLista.Destroy;
begin
   inherited;
end;

function TModelInformacaoLista.getColunas: Tlist<string>;
begin
   result := Fcolunas;
end;

function TModelInformacaoLista.getQtdMaxCaracteres: Tlist<integer>;
begin
   result := FqtdMaxCaracteres;
end;

class function TModelInformacaoLista.New(colunas: Tlist<string>;
  qtdMaxCaracteres: Tlist<integer>): iModelInformacaoLista;
begin
   result := Self.Create(colunas, qtdMaxCaracteres);
end;

end.
