unit Model.EnumHelper;

interface

type
   TEnumHelper = class(TCustomAttribute)
   private
      Fnome: string;
      Findice: integer;
   public
      constructor Create(nome: string; indice: integer);
      property nome: string read Fnome write Fnome;
      property indice: integer read Findice write Findice;
   end;

implementation

{ TEnumHelper }

constructor TEnumHelper.Create(nome: string; indice: integer);
begin
   inherited Create;
   Fnome := nome;
   Findice := indice;
end;

end.
