unit uRelatorio.Bloco;

interface

uses
  System.UITypes,
  System.Classes,
  Model.LibUtil;

type
  TBlocoRelatorio = class
  private
    FNomeFonte:            string;
    FTamanhoFont:          Integer;
    FStylesFont:           TFontStyles;
    FOrientacaoTexto:      TAlignTexto;
    FLinhas:               TArray<string>;
    FQuantidadeCaracteres: Integer;
    FNomeBloco:            string;
    function GetLinhas: TArray<string>;
  public
    constructor Create();
    destructor Destroy; override;

    property NomeBloco:            string      read FNomeBloco            write FNomeBloco;
    property NomeFont:             string      read FNomeFonte            write FNomeFonte;
    property TamanhoFont:          Integer     read FTamanhoFont          write FTamanhoFont;
    property StylesFont:           TFontStyles read FStylesFont           write FStylesFont;
    property OrientacaoTexto:      TAlignTexto read FOrientacaoTexto      write FOrientacaoTexto;
    property Linhas:               TArray<string> read GetLinhas             write FLinhas;
    property QuantidadeCaracteres: Integer     read FQuantidadeCaracteres write FQuantidadeCaracteres;
  end;

implementation

uses
  uRelatorio.Linhas,
  uRelatorio.Interfaces;

{ TBlocoRelatorio }

constructor TBlocoRelatorio.Create;
begin
  FNomeFonte:= 'Arial';
  FTamanhoFont:= 8;
  FStylesFont:= [];
  FOrientacaoTexto:= atRigth;
  FLinhas:= [];
  FQuantidadeCaracteres:= 45;
end;

destructor TBlocoRelatorio.Destroy;
begin
  inherited;
end;

function TBlocoRelatorio.GetLinhas: TArray<string>;
var
  resultado: TStringList;
  it: string;
  _texto: TArray<string>;
  trataLinhas: ITratamentoLinhas;
begin
  resultado:= TStringList.Create;
  trataLinhas:= TTratamentoLinhas.New;
  try
    for it in FLinhas do
    begin
      _texto:= trataLinhas.TratarLinha(it, QuantidadeCaracteres);
      _texto:= trataLinhas.AlinharLinhas(_texto, QuantidadeCaracteres, OrientacaoTexto);
      trataLinhas.AddLinhas(_texto, resultado);
    end;
  finally
    Result := resultado.ToStringArray;
    resultado.Free;
  end;
end;

end.

    
