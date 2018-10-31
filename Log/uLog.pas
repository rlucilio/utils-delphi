unit uLog;

interface

uses
  System.SysUtils, System.DateUtils;

type
  TLog = class
  private
    FArquivoDeLog: string;
    procedure ApagarArquivoAntigo();
    procedure gravaLinha(const linha: string);
    constructor Create;
  public
    destructor Destroy; override;
    property ArquivoDeLog: string read FArquivoDeLog;
    procedure DoObj(const obj: TObject;const msg: string);
    procedure DoMsg(const msg: string);
  end;
  
var
  LogSystem: TLog;

implementation

uses
  Obj.Helper, System.TypInfo;

{ TLog }

procedure TLog.ApagarArquivoAntigo;
var
  dataDoArquivo: TDateTime;
begin
  if FileExists(ArquivoDeLog) then
  begin
    fileage(ArquivoDeLog, dataDoArquivo);

    if dayOf(dataDoArquivo) = DayOf(now) then
      exit();

    DeleteFile(ArquivoDeLog);
  end;
end;

constructor TLog.Create;
var
  nomeDoPrograma: string;
begin
  inherited Create;
  nomeDoPrograma:= ChangeFileExt(ExtractFileName(ParamStr(0)), '');

  FArquivoDeLog:= Concat(ExtractFilePath(ParamStr(0)), nomeDoPrograma, '.log');

  ApagarArquivoAntigo();
end;

destructor TLog.Destroy;
begin
  inherited;
end;

procedure TLog.DoMsg(const msg: string);
begin
  if not string.IsNullOrWhiteSpace(msg) then
    gravaLinha(msg);
end;

procedure TLog.DoObj(const obj: TObject;const msg: string);
var
  informacoesObj: TStringBuilder;
  propridade, value, valueArray: string;
  I, J: integer;
begin
  informacoesObj:= TStringBuilder.Create();
  try
    informacoesObj
      .Append(msg).AppendLine()
      .Append('Classe: ').Append(obj.ClassName).AppendLine();

    for I := 0 to obj.ContextPropertyCount do
    begin
      value:= '';
      propridade:= obj.ContextPropertyName(I);       
      if obj.ContextProperties[propridade].IsArray then
      begin
        informacoesObj
        .Append(propridade).Append(': ').AppendLine();
      
        for J := 0 to Pred(obj.ContextProperties[propridade].GetArrayLength) do
        begin
          valueArray:= '';
          if obj.ContextProperties[propridade].GetArrayElement(J).IsObject and
            (obj.ContextProperties[propridade].GetArrayElement(J).AsObject <> nil) then
              valueArray:= obj.ContextProperties[propridade].GetArrayElement(J).AsObject.ToJson();

          if valueArray.IsEmpty then
            valueArray:= obj.ContextProperties[propridade].GetArrayElement(J).ToString;  

          informacoesObj
            .Append(obj.ContextProperties[propridade].GetArrayElement(J).TypeInfo.Name).Append('[').Append(j).Append(']')
            .Append(': ')  
            .Append(valueArray).AppendLine();
        end;
      end
      else
      begin 
      
        if Obj.ContextProperties[propridade].IsObject and
           (Obj.ContextProperties[propridade].AsObject <> nil) then
          value:= Obj.ContextProperties[propridade].AsObject.ToJson();

        if value.IsEmpty then
          value:= Obj.ContextProperties[propridade].ToString();
                         
        informacoesObj
          .Append(propridade).Append(': ').Append(value).AppendLine();
      end;

    end;
    
      gravaLinha(informacoesObj.ToString);
  finally
    FreeAndNil(informacoesObj);
  end;
end;

procedure TLog.gravaLinha(const linha: string);
var
  txtFile: TextFile;
  linhaComDataHora: string;
begin
  linhaComDataHora:= Concat(FormatDateTime('[dd/mm/yyyy hh:mm:ss.zzz]= ', Now), linha);

  AssignFile(txtFile, ArquivoDeLog);
  try  

    {$I-}
      Append(txtFile);
    {$I+}    
    
    if IOResult <> 0 then
      Rewrite(txtFile);

    Writeln(txtFile, linhaComDataHora);
    
  finally
    CloseFile(txtFile);
  end;

end;

initialization
  LogSystem:= TLog.Create();   

finalization
  FreeAndNil(LogSystem);

end.
