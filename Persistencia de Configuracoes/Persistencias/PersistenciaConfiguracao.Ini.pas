unit PersistenciaConfiguracao.Ini;

interface

uses
  PersistenciaConfiguracao.Interfaces,
  System.SysUtils,
  System.iniFiles,
  System.Rtti,
  System.Generics.Collections;

type
  TPersistenciaIni = class(TInterfacedObject, iSalvaCarregaConfiguracao)
  private
    Farquivo: string;
    arquioIni: TIniFile;
    _resultado: TDictionary<string, string>;
    constructor Create;
    procedure PropListStrToStr(obj: TObject; propriedade: TRttiProperty);
    procedure PropToStr(obj: TObject; propriedade: TRttiProperty);
    procedure PropTStringsToStr(obj: TObject; propriedade: TRttiProperty);
  public
    class function New: iSalvaCarregaConfiguracao;
    destructor Destroy; override;
    function salva(obj: TObject): iSalvaCarregaConfiguracao;
    function carrega(obj: TObject): iSalvaCarregaConfiguracao;
    function getResultado: TDictionary<string, string>;
    property arquivo: string read Farquivo;
  end;

implementation

uses
  System.Variants,
  System.Classes;

{ TPersistenciaIni }

function TPersistenciaIni.carrega(obj: TObject): iSalvaCarregaConfiguracao;
var
  propriedade: TRttiProperty;
  contexto: TRttiContext;
  tipo: TRttiType;
  valor, atributo: string;
begin
  result := self;
  _resultado.Clear;
  contexto := TRttiContext.Create;
  try
    tipo := contexto.GetType(obj.ClassInfo);

    for propriedade in tipo.GetProperties do
    begin
      atributo := propriedade.Name;
      valor := arquioIni.ReadString(obj.ClassName, propriedade.Name, '');
      _resultado.Add(atributo, valor);
    end;

  finally
    FreeAndNil(tipo);
  end;
end;

constructor TPersistenciaIni.Create;
begin
  inherited Create;
  _resultado := TDictionary<string, string>.Create;
  Farquivo := ExtractFilePath(ParamStr(0)) + '\config.ini';
  arquioIni := TIniFile.Create(Farquivo);
end;

destructor TPersistenciaIni.Destroy;
begin
  if Assigned(arquioIni) then
     FreeAndNil(arquioIni);

  if Assigned(_resultado) then
      FreeAndNil(_resultado);
  inherited;
end;

function TPersistenciaIni.getResultado: TDictionary<string, string>;
begin
  Result:= _resultado;
end;


procedure TPersistenciaIni.PropTStringsToStr(obj: TObject; propriedade: TRttiProperty);
var
  valor: string;
  lista: TStringList;
  it: string;
begin
  valor := '';
  propriedade.GetValue(obj).TryAsType<TStringList>(lista);

  for it in lista do
  begin
    valor:= valor + it + '|';
  end;

  arquioIni.WriteString(obj.ClassName, propriedade.Name, valor);
end;

procedure TPersistenciaIni.PropToStr(obj: TObject; propriedade: TRttiProperty);
begin
  if (propriedade.GetValue(obj).IsOrdinal) and not ((propriedade.GetValue(obj).IsType<Integer>) or (propriedade.GetValue(obj).IsType<char>) or (propriedade.GetValue(obj).IsType<Boolean>)) then
  begin
    arquioIni.WriteInteger(obj.ClassName, propriedade.Name, Integer(propriedade.GetValue(obj).AsOrdinal));
  end
  else
    arquioIni.WriteString(obj.ClassName, propriedade.Name, VarToStr(propriedade.GetValue(obj).AsVariant));
end;

procedure TPersistenciaIni.PropListStrToStr(obj: TObject; propriedade: TRttiProperty);
var
  valor: string;
  lista: TList<string>;
  item: string;
begin
  valor := '';
  propriedade.GetValue(obj).TryAsType<TList<string>>(lista);

  for item in lista do
  begin
    valor := valor + item + '|';
  end;

  arquioIni.WriteString(obj.ClassName, propriedade.Name, valor);
end;
class function TPersistenciaIni.New: iSalvaCarregaConfiguracao;
begin
  result := self.Create;
end;

function TPersistenciaIni.salva(obj: TObject): iSalvaCarregaConfiguracao;
var
  propriedade: TRttiProperty;
  contexto: TRttiContext;
  tipo: TRttiType;
begin
  result := self;
  contexto := TRttiContext.Create;
  try
    tipo := contexto.GetType(obj.ClassInfo);
    for propriedade in tipo.GetProperties do
    begin
      if propriedade.Name.Equals('RefCount') or propriedade.Name.Contains('On') then
       Continue;

      if propriedade.GetValue(obj).IsInstanceOf(TStringList) then
        PropTStringsToStr(obj, propriedade)
      else if propriedade.GetValue(obj).IsInstanceOf(TList<String>) then
        PropListStrToStr(obj, propriedade)
      else
        PropToStr(obj, propriedade);

    end;

  finally
    FreeAndNil(tipo);
  end;
end;

end.

