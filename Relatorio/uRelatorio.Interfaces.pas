unit uRelatorio.Interfaces;

interface

uses
   System.Generics.Collections,
   RLReport,
   Model.LibUtil,
   System.Classes;

const
      DELAY                           = #27+'X';
      AVANCAR_BOBINA                  = #13;
      ESPACAMENTO                     = #27+'M';
      CONDESADO_ATIVA                 = #15;
      CONDESADO_DESATIVA              = #18;
      EXPANDIR_ATIVA                  = #27+'W'+'1';
      EXPANDIR_DESATIVA               = #27+'W'+'0';
      SOBRESCRITO_ATIVA               = #27+'S0';
      SUBESCRITO_ATIVA                = #27+'S1';
      SOBRESCRITO_SUBESCRITO_DESATIVA = #27+'T';
      SUBLINHADO_ATIVA                = #27+'-'+'1';
      SUBLINHADO_DESATIVA             = #27+'-'+'0';
      NEGRITO_ATIVA                   = #27+'E';
      NEGRITO_DESATIVA                = #27+'F';

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

   IRelatorio = interface
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
      function AddInformacaoImportante(informacaoImportante: IInformacaoImportante): iRelatorio;
      function AddInformacaoSimples(informacaoSimples: IInformacaoSimples): iRelatorio;
      function AddInformacaoRodape(informacaoRodape: IInformacaoRodape): iRelatorio;
      function AddInformacoesLista(informacaoLista: IInformacaoLista): iRelatorio;
      function Imprimir(nomeImpressao, nomeComputador, nomeImpressora: string;const preview: boolean): iRelatorio;
   end;

   ITratamentoLinhas = interface
   ['{0DAFA764-5EB8-4CBE-AB63-A597B577DD60}']
    function TratarLinha(linha: string; quantidadeCaracteres: integer): TArray<string>;
    function TratarLinhas(linhas: TArray<string>; quantidadeCaracteres: integer): TArray<string>;

    function AlinharLinha(linha: string; tamanho: integer ; align: TAlignTexto): string;
    function AlinharLinhas(linhas: TArray<string>;tamanho: integer ; align: TAlignTexto): TArray<string>;

    procedure AddLinha(linha: string;var outLinhas: TStrings; caracterEspecialAntes:string = ''; caracterEspecialDepois: string = '');
    procedure AddLinhas(linhas: TArray<string>;var outLinhas: TStrings; caracterEspecialAntes: string = ''; caracterEspecialDepois: string = '');

    procedure AddLinhasColunadas(var outLinhas: Tstrings; colunas: TArray<string>; quantidadeCaracteres: TArray<integer>);

    procedure AddLinhaKeyValue(key, value: string;quantidadeMaximaCaracteres: integer;
            var outLinhas: tstrings; caracterEspecialAntes:string = ''; caracterEspecialDepois: string = '');
    procedure AddLinhasKeyValue(key, value: TArray<string>;quantidadeMaximaCaracteres: integer;
            var outLinhas: tstrings; caracterEspecialAntes:string = ''; caracterEspecialDepois: string = '');
   end;

implementation

end.
