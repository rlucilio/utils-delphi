unit Model.Relatorio.Interfaces;

interface

uses
   System.Generics.Collections, RLReport, System.Classes;

type

   iModelInformacaoImportante = interface
      ['{C351587B-EB1F-4593-B89F-F7F538259905}']
      function getInformacoes: TList<string>;
      function getQtdMaxCaracteres: integer;
      function getTamanhaoTitulo: integer;
      function getTamanhoInformacoes: integer;
      function getTitulo: string;
      property titulo: string read getTitulo;
      property tamanhaoTitulo: integer read getTamanhaoTitulo;
      property informacoes: TList<string> read getInformacoes;
      property tamanhoInformacoes: integer read getTamanhoInformacoes;
      property qtdMaxCaracteres: integer read getQtdMaxCaracteres;
   end;

   iModelInformacaoSimples = interface
      ['{44011A0D-65A7-4C0F-BC30-DF46E14379A4}']
      function getInformativo: string;
      function getQtdMaxCaracteres: integer;
      function getTamanho: integer;
      function getTitulo: string;
      property titulo: string read getTitulo;
      property tamanho: integer read getTamanho;
      property Informativo: string read getInformativo;
      property qtdMaxCaracteres: integer read getQtdMaxCaracteres;
   end;

   iModelInformacaoLista = interface
      ['{2AD54442-C887-4EB8-BAAE-1C481F0962B3}']
      function getColunas: TList<string>;
      function getQtdMaxCaracteres: TList<integer>;
      property qtdMaxCaracteres: TList<integer> read getQtdMaxCaracteres;
      property colunas: TList<string> read getColunas;
   end;

   iModelInformacaoRodape = interface
      ['{CCC2AE5F-CF60-46EA-9392-4F330B813143}']
      function getLinhas: TList<string>;
      function getTamanho: integer;
      function getQtdMaxCaracteres: integer;
      property linhas: TList<string> read getLinhas;
      property tamanho: integer read getTamanho;
      property qtdMaxCaracteres: integer read getQtdMaxCaracteres;
   end;

   iModelRelatorio = interface
      ['{459BA5FD-3809-4690-A3E5-E4337BDEEA42}']
      procedure setAlturaPapel(const Value: integer);
      procedure setLarguraPapel(const Value: integer);
      procedure setMargeDireita(const Value: integer);
      procedure setMargeEsquerda(const Value: integer);
      procedure setMargeInferior(const Value: integer);
      procedure setMargeSuperior(const Value: integer);
      property margeDireita: integer write setMargeDireita;
      property margeEsquerda: integer write setMargeEsquerda;
      property margeSuperior: integer write setMargeSuperior;
      property margeInferior: integer write setMargeInferior;
      property larguraPapel: integer write setLarguraPapel;
      property alturaPapel: integer write setAlturaPapel;
      function addInformacaoImportante(informacaoImportante
        : iModelInformacaoImportante): iModelRelatorio;
      function addInformacaoSimples(informacaoSimples: iModelInformacaoSimples)
        : iModelRelatorio;
      function addInformacaoRodape(informacaoRodape: iModelInformacaoRodape)
        : iModelRelatorio;
      function addInformacoesLista(informacaoLista: iModelInformacaoLista)
        : iModelRelatorio;
      function imprimir(nomeImpressao, nomeComputador, nomeImpressora: string;
        const preview: boolean): iModelRelatorio;
   end;

implementation

end.
