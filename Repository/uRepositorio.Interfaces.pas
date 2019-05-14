unit uRepositorio.Interfaces;

interface

uses
  {Delphi}
    System.Generics.Collections,
    System.Json,
    RTTI;

  const USER_JSON= 'TOTEM';
  const PASS_JSON= 'TOTEM';
type
  IRepositorio<T: Class> = interface
    ['{82615B3B-F597-4459-AAF2-820D47F72350}']
    function GetDisponivel: Boolean;
    function Ref: IRepositorio<T>;

    function GetDadoSimples(nomeRota:string; param: string = ''): TValue;
    function GetDado(nomeRota:string; param: string = ''): T;
    function GetJsonString(nomeRota:string; param: string = ''): string;
    function GetDados(nomeRota:string; param: string = ''): TObjectList<T>;

    function SetDadoSimples(aKey: string; aValue: TValue): boolean;
    function SetDado(akey: string; obj: TObject): Boolean;
    function SetListaDados(akey: string; listaDados: TObjectList<TObject>): Boolean;

    function DeletaDado(aKey: string; aValue: TValue): boolean;
  end;

  IRecuperador<T: class> = interface
    ['{C009F8DC-39F4-47CA-9E4B-36FADCBCE988}']
    procedure AddParam(const param: string);
    function GetJsonObject: TJSONObject;
    function GetJsonString: string;
    function GetDado: T;
    function GetDadoSimples(nome: string): TValue;
    function GetDados: TObjectList<T>;
  end;

  IPersistencia = interface
    ['{5F2FA64B-8A3D-4D4F-855F-D23FEE8F2DD7}']
    function SetDadoSimples(aKey: string; aValue: TValue): IPersistencia;
    function SetDados(aKey: string ;Obj: TObject): IPersistencia;
    function SetListaDados(aKey: string; ListaDados: TObjectList<TObject>): IPersistencia;
    function DeleteDado(aKey: string; aValue: TValue): IPersistencia;
    function GetConfirmacao: boolean;
  end;

implementation

end.
