unit uRepositorio.Json;

interface

uses
  {Repositorio}
    uRepositorio.Interfaces,
    uRecuperador.Json,
    uPersistencia.Json,
  {Delphi}
    System.Generics.Collections,
    RTTI,
  {Log}
    uLog,
  {Resource}
    uResource.Strings;

type
  TEventOperacao = procedure(aValue: string) of object;

  TRepositorioJson<T: Class, constructor> = class(TInterfacedObject, IRepositorio<T>)
  private
    FURLServidor:      string;
    FOnAfterOperacao:  TEventOperacao;
    FOnBeforeOperacao: TEventOperacao;
    procedure DoAfterOperacao;
    procedure DoBeforeOperacao;
  public

    constructor Create(aUrl: string);
    destructor Destroy; override;

    property URLServidor:      string         read FURLServidor;
    property OnAfterOperacao:  TEventOperacao read FOnAfterOperacao  write FOnAfterOperacao;
    property OnBeforeOperacao: TEventOperacao read FOnBeforeOperacao write FOnBeforeOperacao;

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

implementation

uses
  {Delphi}
    System.SysUtils;

{ TRepositorio }

constructor TRepositorioJson<T>.Create(aUrl: string);
begin
  if aUrl.IsEmpty then
    raise Exception.Create(MsgErroServNaoEncontrado);

  FURLServidor:= aUrl;
end;

function TRepositorioJson<T>.DeletaDado(aKey: string;
  aValue: TValue): boolean;
var
  persistencia: IPersistencia;
begin
  DoAfterOperacao;

  persistencia:= TPersistenciaJson.Create(URLServidor, aKey);
  result:= persistencia.DeleteDado(aKey, aValue).GetConfirmacao;

  DoBeforeOperacao;
end;

destructor TRepositorioJson<T>.Destroy;
begin

  inherited;
end;

function TRepositorioJson<T>.GetDado(nomeRota:string; param: string): T;
var
  recuperar: IRecuperador<T>;
begin
  DoAfterOperacao;

  recuperar:= TRecuperadorJson<T>.Create(URLServidor, nomeRota);
  if param.IsEmpty then
    Result := recuperar.GetDado()
  else
  begin
    recuperar.AddParam(param);
    Result := recuperar.GetDado();
  end;

  DoBeforeOperacao;
end;

function TRepositorioJson<T>.GetDados(nomeRota:string; param: string): TObjectList<T>;
var
  recuperar: IRecuperador<T>;
begin
  DoAfterOperacao;

  recuperar:= TRecuperadorJson<T>.Create(URLServidor, nomeRota);

  if param.IsEmpty then
    Result := recuperar.GetDados
  else
  begin
    recuperar.AddParam(param);
    Result := recuperar.GetDados;
  end;

  DoBeforeOperacao;
end;

function TRepositorioJson<T>.GetDadoSimples(nomeRota:string; param: string): TValue;
var
  recuperar: IRecuperador<TObject>;
begin
  DoAfterOperacao;

  recuperar:= TRecuperadorJson<TObject>.Create(URLServidor, nomeRota);
  if param.IsEmpty then
    Result := recuperar.GetDadoSimples(nomeRota)
  else
  begin
    recuperar.AddParam(param);
    Result := recuperar.GetDadoSimples(nomeRota);
  end;

  DoBeforeOperacao;
end;

function TRepositorioJson<T>.GetDisponivel: Boolean;
var
  recuperar: IRecuperador<TObject>;
begin
  DoAfterOperacao;

  recuperar:= TRecuperadorJson<TObject>.Create(URLServidor, 'disponivel');

  Result := recuperar.GetDadoSimples('disponivel').AsBoolean;

  DoBeforeOperacao;
end;

function TRepositorioJson<T>.GetJsonString(nomeRota: string; param: string): string;
var
  recuperar: IRecuperador<TObject>;
begin
  DoAfterOperacao;

  recuperar:= TRecuperadorJson<TObject>.Create(URLServidor, nomeRota);

  if param.IsEmpty then
    Result := recuperar.GetJsonString
  else
  begin
    recuperar.AddParam(param);
    Result := recuperar.GetJsonString;
  end;

  DoBeforeOperacao;
end;

function TRepositorioJson<T>.Ref: IRepositorio<T>;
begin
  result:= self;
end;

function TRepositorioJson<T>.SetDado(akey: string; obj: TObject): Boolean;
var
  persistencia: IPersistencia;
begin
  DoAfterOperacao;

  persistencia:= TPersistenciaJson.Create(URLServidor, aKey);
  result:= persistencia.SetDados(aKey, obj).GetConfirmacao;

  DoBeforeOperacao;
end;

function TRepositorioJson<T>.SetDadoSimples(aKey: string;
  aValue: TValue): boolean;
var
  persistencia: IPersistencia;
begin
  DoAfterOperacao;

  persistencia:= TPersistenciaJson.Create(URLServidor, aKey);
  result:= persistencia.SetDadoSimples(aKey, aValue).GetConfirmacao;

  DoBeforeOperacao;
end;

function TRepositorioJson<T>.SetListaDados(akey: string;
  listaDados: TObjectList<TObject>): Boolean;
var
  persistencia: IPersistencia;
begin
  DoAfterOperacao;

  persistencia:= TPersistenciaJson.Create(URLServidor, aKey);
  result:= persistencia.SetDadoSimples(aKey, listaDados).GetConfirmacao;

  DoBeforeOperacao;
end;

procedure TRepositorioJson<T>.DoBeforeOperacao;
begin
  if Assigned(FOnBeforeOperacao) then
    OnBeforeOperacao('Concluido');
end;

procedure TRepositorioJson<T>.DoAfterOperacao;
begin
  if Assigned(FOnAfterOperacao) then
    OnAfterOperacao('Verificando');
end;

end.
