unit Model.Ini;

interface

uses Model.Ini.Interfaces, System.SysUtils, System.iniFiles, System.Rtti, System.Generics.Collections;

type
   TModelIni = class(TInterfacedObject, iModelIni)
   private
      Farquivo: string;
      arquioIni: TIniFile;
      Fresultado: TDictionary<string, string>;
      //
      constructor Create;
   public
      class function New: iModelIni;
      destructor Destroy; override;
      function salva(obj: TObject): iModelIni;
      function carrega(obj: TObject): iModelIni;
      property arquivo: string read Farquivo;
      property resultado: TDictionary<string,string> read Fresultado;
   end;

implementation

uses
  System.Variants;

{ TModelIni }


function TModelIni.carrega(obj: TObject): iModelIni;
var
   propriedade: TRttiProperty;
   contexto: TRttiContext;
   tipo: TRttiType;
   valor, atributo: string;
begin
   result:= self;
   resultado.Clear;
   contexto:= TRttiContext.Create;
   try
      tipo:= contexto.GetType(obj.ClassInfo);

      for propriedade in tipo.GetProperties do
      begin
        atributo:= propriedade.Name;
        valor:=  arquioIni.ReadString(obj.ClassName, propriedade.Name, '');
        resultado.Add(atributo, valor);
      end;

   finally
      FreeAndNil(tipo);
   end;
end;

constructor TModelIni.Create;
begin
   inherited Create;
   Fresultado:= TDictionary<string,string>.Create;
   Farquivo:= ExtractFilePath(ParamStr(0))+'\config.ini';
   arquioIni:= TIniFile.Create(Farquivo);
end;

destructor TModelIni.Destroy;
begin
  FreeAndNil(arquioIni);
  FreeAndNil(Fresultado);
  inherited;
end;

class function TModelIni.New: iModelIni;
begin
   Result:= Self.Create;

end;


function TModelIni.salva(obj: TObject): iModelIni;
var
   propriedade: TRttiProperty;
   contexto: TRttiContext;
   tipo: TRttiType;
   valor: variant;
begin
   result:= self;
   contexto:= TRttiContext.Create;
   try
      tipo:= contexto.GetType(obj.ClassInfo);
      for propriedade in tipo.GetProperties do
      begin
        arquioIni.WriteString(obj.ClassName, propriedade.Name, VarToStr(propriedade.GetValue(obj).AsVariant));
      end;

   finally
      FreeAndNil(tipo);
   end;
end;

end.
