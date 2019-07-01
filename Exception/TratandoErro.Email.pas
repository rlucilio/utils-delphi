unit TratandoErro.Email;

interface

CONST
//  EMAILREMETENTE = 'desenvolvimento@centralsiclop.com.br';
//  SERV = 'mail.centralsiclop.com.br';
//  SENHA = 'php787878';

  EMAILREMETENTE = 'siclopsat@gmail.com';
  SERV = 'smtp.gmail.com';
  SENHA = 'sat787878';

type
  TEnviaErroEmail = class
  private
    FArquivoZip: string;
    FPastaLogs: string;
    function PodeEnviar: Boolean;
    procedure enviarEmail(arquivoZip: string);
  public
    constructor Create;
    destructor Destroy; override;

    property ArquivoZip: string read FArquivoZip;
    property PastaLogs: string read FPastaLogs;
  end;

implementation

uses
  {Delphi}
    System.IOUtils,
    System.SysUtils,
    System.DateUtils,
  {Util}
    Model.LibUtil,
  {Email}
    Model.Email;

{ TEnviaErroEmail }

constructor TEnviaErroEmail.Create;
begin
  FPastaLogs:= TPath.GetDocumentsPath+ '\SICLOP';
  if PodeEnviar then
  begin
    FArquivoZip:= compactarPasta(PastaLogs, FormatDateTime('dd.mm.yyy ', now)+ 'Log');
    enviarEmail(ArquivoZip);
  end;

end;

destructor TEnviaErroEmail.Destroy;
begin
  if FileExists(ArquivoZip) then
    DeleteFile(PWideChar(ArquivoZip));

  inherited;
end;

procedure TEnviaErroEmail.enviarEmail(arquivoZip: string);
var
  emailTemp: TModelEmail;
begin
  emailTemp:= TModelEmail.Create(EMAILREMETENTE, 'SICLOP SAT');

    emailTemp
      .setServer(SERV, SENHA)
      .setEnvio(['siclopsat@gmail.com'], FormatDateTime('dd.mm.yyy ', now)+ 'Log')
      .setMensagem('Segue os logs')
      .setAnexos([arquivoZip])
      .enviar;

    if DirectoryExists(PastaLogs) then
      RemoveDir(PastaLogs);


end;

function TEnviaErroEmail.PodeEnviar: Boolean;
begin
  result:= DirectoryExists(PastaLogs) and (DayOfTheWeek(now()) = DayFriday);
end;

end.
