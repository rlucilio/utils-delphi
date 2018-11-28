unit TratandoErro;

interface

uses
  System.SysUtils, FMX.Forms, System.IOUtils;

type
  TTratamentoErro = class
  private
    function GetRTTILog(Sender: TObject): string;
  public
    procedure TratamentoDeErro(Sender: TObject; E: Exception);
    procedure DoAppExceptionEvent(Sender: TObject; E: Exception;
      MostraMsg: Boolean = true);
    procedure ErroLog(texto: string);
  end;

implementation

uses
  System.Rtti;

{ TTratamentoErro }

procedure TTratamentoErro.DoAppExceptionEvent(Sender: TObject; E: Exception;
  MostraMsg: Boolean);
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

      if MostraMsg then
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
    .Append('===Informa��es Extra===').AppendLine()
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

var
  Tratamento: TTratamentoErro;

initialization

Tratamento := TTratamentoErro.Create();
Application.OnException := Tratamento.TratamentoDeErro;

finalization

FreeAndNil(Tratamento);

end.
