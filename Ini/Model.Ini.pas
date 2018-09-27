unit Model.Ini;

interface

uses Model.Ini.Interfaces, System.SysUtils, System.iniFiles, System.Rtti,
   System.Generics.Collections,
   Model.EnumHelper;

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
      property resultado: TDictionary<string, string> read Fresultado;
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
   result := self;
   resultado.Clear;
   contexto := TRttiContext.Create;
   try
      tipo := contexto.GetType(obj.ClassInfo);

      for propriedade in tipo.GetProperties do
      begin
         atributo := propriedade.Name;
         valor := arquioIni.ReadString(obj.ClassName, propriedade.Name, '');
         resultado.Add(atributo, valor);
      end;

   finally
      FreeAndNil(tipo);
   end;
end;

constructor TModelIni.Create;
begin
   inherited Create;
   Fresultado := TDictionary<string, string>.Create;
   Farquivo := ExtractFilePath(ParamStr(0)) + '\config.ini';
   arquioIni := TIniFile.Create(Farquivo);
end;

destructor TModelIni.Destroy;
begin
   FreeAndNil(arquioIni);
   FreeAndNil(Fresultado);
   inherited;
end;

class function TModelIni.New: iModelIni;
begin
   result := self.Create;

end;

function TModelIni.salva(obj: TObject): iModelIni;
var
   propriedade: TRttiProperty;
   atributos: TCustomAttribute;
   contexto: TRttiContext;
   tipo: TRttiType;
   lista: TList<String>;
   item: string;
   valor: string;
begin
   result := self;
   contexto := TRttiContext.Create;
   try
      tipo := contexto.GetType(obj.ClassInfo);
      for propriedade in tipo.GetProperties do
      begin
         if propriedade.GetValue(obj).IsInstanceOf(TList<String>) then
         begin
            valor := '';
            propriedade.GetValue(obj).TryAsType < TList < String >> (lista);
            for item in lista do
            begin
               valor := valor + item + '|';
            end;
            arquioIni.WriteString(obj.ClassName, propriedade.Name, valor);
         end
         else
         begin

            if length(propriedade.GetAttributes) > 0 then
            begin
               for atributos in propriedade.GetAttributes do
               begin
                  if atributos is TEnumHelper then
                  begin
                     arquioIni.WriteString(obj.ClassName, propriedade.Name, TEnumHelper(atributos).nome);
                     break;
                  end;
               end;
            end
            else
               arquioIni.WriteString(obj.ClassName, propriedade.Name,
                 VarToStr(propriedade.GetValue(obj).AsVariant));
         end;
      end;

   finally
      FreeAndNil(tipo);
   end;
end;

end.
