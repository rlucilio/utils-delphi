unit Model.Exception;

interface

uses
   System.SysUtils, FMX.Forms, Model.Txt.log;

type
   TControllerException = class
   private
      Constructor Create;
   public
      Destructor Destroy; override;
      procedure tratarException(Sender: TObject; E: Exception);
   end;

implementation

{ TControllerException }

constructor TControllerException.Create;
begin
   Application.OnException := tratarException;
end;

destructor TControllerException.Destroy;
begin

   inherited;
end;

procedure TControllerException.tratarException(Sender: TObject; E: Exception);
var
   erro: TStringBuilder;
begin
   try
      erro := TStringBuilder.Create;
      erro.AppendLine.Append('SAT').Append('Erro: ').Append(E.Message).AppendLine.Append('Classe: ').Append(E.ClassName)
        .AppendLine.Append('Unit: ').Append(E.UnitName).AppendLine.Append('----')
        .Append(FormatDateTime('hh:nn dd/mm/yyyy', now)).Append('----');

      TModelLogTxt.New.Gravar('Erros.txt', erro.ToString);
   finally
      FreeAndNil(erro);
   end;
end;

var
   FTrataException: TControllerException;

initialization

FTrataException := TControllerException.Create;

finalization

FTrataException.Free;

end.
