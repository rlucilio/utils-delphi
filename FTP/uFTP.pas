unit uFTP;

interface

uses
  IdFTP, System.Classes;

type
  IFTP = interface
    function Conectar: IFTP;
    function ListarArquivos: TArray<string>;
    function Update(const arquivo: string): IFTP; overload;
    function Update(const arquivo: TStream): IFTP;overload;
    function Download(const arquivo: string; const local: string): IFTP; overload;
    function Download(const arquivo: string; const arquivoBinario: TStream): IFTP; overload;
  end;

  TFTP = class(TInterfacedObject, IFTP)
  private
    FIndyFTP: TIdFTP;
    FHost: string;
    FUser: string;
    FPassword: string;
    FPort: integer;
  protected
    property Host: string read FHost;
    property User: string read FUser;
    property Password: string read FPassword;
    property Port: integer read FPort;
  public
    constructor Create(const _host, _user, _pass: string; const _port: integer);
    destructor Destroy; override;
    class Function New(const _host, _user, _pass: string; const _port: integer): IFTP;
    function Conectar: IFTP;
    function ListarArquivos: TArray<string>;
    function Update(const arquivo: string): IFTP; overload;
    function Update(const arquivo: TStream): IFTP;overload;
    function Download(const arquivo: string; const local: string): IFTP; overload;
    function Download(const arquivo: string; const arquivoBinario: TStream): IFTP; overload;
    
    property IdFtp: TIdFTP read FIndyFTP write FIndyFTP;
  end;

implementation

uses
  IdFTPCommon;

{ TFTP }

function TFTP.Conectar: IFTP;
begin
  result:= self;
  FIndyFTP.Host    := Host;
  FIndyFTP.Username:= User;
  FIndyFTP.Password:= Password;
  FIndyFTP.Port    := Port;
  FIndyFTP.Passive := true;
  FIndyFTP.TransferType:= ftBinary;
  try
    FIndyFTP.Connect;
  except
  end;
end;

constructor TFTP.Create(const _host, _user, _pass: string; const _port: integer);
begin
  FHost:= _host;
  FUser:= _user;
  FPassword:= _pass;
  FPort:= _port;
  FIndyFTP:= TIdFTP.Create(nil);
end;

destructor TFTP.Destroy;
begin
  FIndyFTP.Disconnect;
  FIndyFTP.Free;
  inherited;
end;


function TFTP.Download(const arquivo, local: string): IFTP;
begin
  result:= self;
  FIndyFTP.Get(arquivo, local, true, false);
end;

function TFTP.Download(const arquivo: string; const arquivoBinario: TStream): IFTP;
begin
  Result:= self;
  FIndyFTP.Get(arquivo, arquivoBinario, true);
end;

function TFTP.ListarArquivos: TArray<string>;
var
  resultado: TStringList;
begin
  resultado:= TStringList.Create;
  try
    FIndyFTP.List(resultado, '', false);
    result:= resultado.ToStringArray();
  finally;
    resultado.Free;
  end;
end;

class Function TFTP.New(const _host, _user, _pass: string; const _port: integer): IFTP;
begin
  Result:= self.Create(_host, _user, _pass, _port);
end;

function TFTP.Update(const arquivo: string): IFTP;
begin
  result:=self;
  FIndyFTP.Put(arquivo);
end;

function TFTP.Update(const arquivo: TStream): IFTP;
begin
  Result:= self;
  FIndyFTP.Put(arquivo, '');
end;

end.
