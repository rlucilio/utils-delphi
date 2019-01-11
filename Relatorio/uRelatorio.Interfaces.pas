unit uRelatorio.Interfaces;

interface

uses
   System.Generics.Collections,
   RLReport,
   System.Classes;

type

   IInformacaoImportante = interface
      ['{C351587B-EB1F-4593-B89F-F7F538259905}']
      function GetInformacoes: TList<string>;
      function GetQtdMaxCaracteres: integer;
      function GetTamanhaoTitulo: integer;
      function GetTamanhoInformacoes: integer;
      function GetTitulo: string;
      property Titulo: string read getTitulo;
      property TamanhaoTitulo: integer read getTamanhaoTitulo;
      property Informacoes: TList<string> read getInformacoes;
      property TamanhoInformacoes: integer read getTamanhoInformacoes;
      property QtdMaxCaracteres: integer read getQtdMaxCaracteres;
   end;

   IInformacaoSimples = interface
      ['{44011A0D-65A7-4C0F-BC30-DF46E14379A4}']
      function GetInformativo: string;
      function GetQtdMaxCaracteres: integer;
      function GetTamanho: integer;
      function GetTitulo: string;
      property Titulo: string read getTitulo;
      property Tamanho: integer read getTamanho;
      property Informativo: string read getInformativo;
      property QtdMaxCaracteres: integer read getQtdMaxCaracteres;
   end;

   IInformacaoLista = interface
      ['{2AD54442-C887-4EB8-BAAE-1C481F0962B3}']
      function GetColunas: TList<string>;
      function GetQtdMaxCaracteres: TList<integer>;
      property QtdMaxCaracteres: TList<integer> read getQtdMaxCaracteres;
      property Colunas: TList<string> read getColunas;
   end;

   IInformacaoRodape = interface
      ['{CCC2AE5F-CF60-46EA-9392-4F330B813143}']
      function GetLinhas: TList<string>;
      function GetTamanho: integer;
      function GetQtdMaxCaracteres: integer;
      property Linhas: TList<string> read GetLinhas;
      property Tamanho: integer read GetTamanho;
      property QtdMaxCaracteres: integer read GetQtdMaxCaracteres;
   end;

   iRelatorio = interface
      ['{459BA5FD-3809-4690-A3E5-E4337BDEEA42}']
//      procedure setAlturaPapel(const Value: integer);
//      procedure setLarguraPapel(const Value: integer);
//      procedure setMargeDireita(const Value: integer);
//      procedure setMargeEsquerda(const Value: integer);
//      procedure setMargeInferior(const Value: integer);
//      procedure setMargeSuperior(const Value: integer);
//      property margeDireita: integer write setMargeDireita;
//      property margeEsquerda: integer write setMargeEsquerda;
//      property margeSuperior: integer write setMargeSuperior;
//      property margeInferior: integer write setMargeInferior;
//      property larguraPapel: integer write setLarguraPapel;
//      property alturaPapel: integer write setAlturaPapel;
      function Ref: iRelatorio;
      procedure AddLinhaColunas(memo: Tstrings; colunas: TArray<string>; CaracteresPorColuna: TArray<integer>);
      procedure addLinha(memo: Tstrings; linhas: TArray<string>; CaracteresPorColuna: integer);
      function AddInformacaoImportante(informacaoImportante: IInformacaoImportante): iRelatorio;
      function AddInformacaoSimples(informacaoSimples: IInformacaoSimples): iRelatorio;
      function AddInformacaoRodape(informacaoRodape: IInformacaoRodape): iRelatorio;
      function AddInformacoesLista(informacaoLista: IInformacaoLista): iRelatorio;
      function Imprimir(nomeImpressao, nomeComputador, nomeImpressora: string;const preview: boolean): iRelatorio;
   end;

implementation

end.
