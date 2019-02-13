unit TratandoErro;

interface

uses
  System.SysUtils,
  {$IFDEF FMX}
  FMX.Forms,
  {$ELSE}
  VCL.Forms,
  {$ENDIF}
  System.IOUtils,
  TratandoErro.Email;

type
  TTratamentoErro = class
  private
    FMostraMensagem: Boolean;
    FEnviaErro: TEnviaErroEmail;
    function GetRTTILog(Sender: TObject): string;
  public
    constructor Create();
    destructor Destroy; override;

    procedure TratamentoDeErro(Sender: TObject; E: Exception);
    procedure DoAppExceptionEvent(Sender: TObject; E: Exception);
    procedure ErroLog(texto: string);

    property MostraMensagem: Boolean read FMostraMensagem write FMostraMensagem;
    property EnviaErro: TEnviaErroEmail read FEnviaErro;
  end;

var
  Tratamento: TTratamentoErro;

implementation

uses
  System.Rtti;

{ TTratamentoErro }

constructor TTratamentoErro.Create;
begin
  FMostraMensagem:= True;
  FEnviaErro:= TEnviaErroEmail.Create;
end;

destructor TTratamentoErro.Destroy;
begin
  FEnviaErro.Free;
  inherited;
end;

procedure TTratamentoErro.DoAppExceptionEvent(Sender: TObject; E: Exception);
var
  msgErro: TStringBuilder;
begin
  msgErro := TStringBuilder.Create;
  try
    try
      msgErro
      .Append('Erro: ').Append(E.Message).AppendLine()
      .Append('Unit: ').Append(E.UnitName).AppendLine()
      .Append('Escopo Unit: ').Append(E.UnitScope).AppendLine();

      if Assigned(Sender) then
        msgErro.Append(GetRTTILog(Sender));

      ErroLog(msgErro.ToString);

      if MostraMensagem then
      begin
        E.Message := msgErro.ToString;
        Application.ShowException(E);
      end;

    except
      on E: Exception do
        ErroLog(E.Message);
    end;

  finally
    FreeAndNil(msgErro);
  end;
end;

procedure TTratamentoErro.ErroLog(texto: string);
var
  nomeArquivo: string;
  txtFile: TextFile;
  nomeDoPrograma: string;
begin
  nomeDoPrograma := ExtractFileName(ParamStr(0));
  nomeDoPrograma := ChangeFileExt(nomeDoPrograma, '');

  ForceDirectories(Concat(TPath.GetDocumentsPath, '\SICLOP\', nomeDoPrograma));
  nomeArquivo := Concat(TPath.GetDocumentsPath, '\SICLOP\', nomeDoPrograma, '\',
    nomeDoPrograma, 'Erro.log');

  AssignFile(txtFile, nomeArquivo);
  try
{$I-}
    Append(txtFile);
{$I+}
    if IOResult <> 0 then
      Rewrite(txtFile);

      Writeln(txtFile, texto);

  finally
    CloseFile(txtFile);
  end;

end;

function TTratamentoErro.GetRTTILog(Sender: TObject): string;
var
  contexto: TRttiContext;
  tipo: TRTTIType;
  propriedade: TRttiProperty;
  msgErro: TStringBuilder;
  value: TValue;
  valueString: string;
begin
  result := String.Empty;

  if not Assigned(Sender) then
    exit;

  msgErro := TStringBuilder.Create();
  contexto := TRttiContext.Create;
  try
    tipo := contexto.GetType(Sender.ClassType);

    msgErro
    .Append('===Informações Extra===').AppendLine()
    .Append('Data: ').Append(FormatDateTime('c', Now)).AppendLine()
    .Append('Programa: ').Append(ExtractFileName(ParamStr(0))).AppendLine()
    .Append('Nome Class: ').Append(Sender.ClassName).AppendLine()
    .Append('Propriedades: ').AppendLine()
    .AppendLine();

    for propriedade in tipo.GetProperties do
    begin
      value:= propriedade.GetValue(Sender);
      value.TryAsType<string>(valueString);
      msgErro.Append(propriedade.Name).Append(': ').Append(valueString).AppendLine();
    end;

    result := msgErro.ToString;
  finally
    FreeAndNil(tipo);
    FreeAndNil(msgErro);
  end;
end;

procedure TTratamentoErro.TratamentoDeErro(Sender: TObject; E: Exception);
begin
  DoAppExceptionEvent(Sender, E);
end;

initialization

Tratamento := TTratamentoErro.Create();
Application.OnException := Tratamento.TratamentoDeErro;

finalization

FreeAndNil(Tratamento);

end.
