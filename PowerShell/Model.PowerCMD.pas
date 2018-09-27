unit Model.PowerCMD;

interface

uses
   System.Classes, Winapi.ShellAPI, Model.PowerCMD.Interfaces,
   System.ioutils;

type
   TModelPowerCMD = class(TInterfacedObject, iModelPowerCMD)
   private
      constructor Create;
      class var FHandle: THandle;
   protected
   public
      class function New(Handle: THandle): iModelPowerCMD;
      function ExecComando(pComando: string; var pResultado: string)
        : iModelPowerCMD;
      function ExecLink(pLink: string): iModelPowerCMD;
      function ExecDir(pDir: string): Boolean;
   end;

implementation

uses
   Model.PowerCMD.Exceptions, System.SysUtils, Winapi.Windows;

{ TModelPowerCMD }

constructor TModelPowerCMD.Create;
begin
   inherited Create;

end;

function TModelPowerCMD.ExecComando(pComando: string; var pResultado: string)
  : iModelPowerCMD;
var
   oLinhaTexto: TStringBuilder;
   oMemo: tstringlist;
   oCopiaArquivo: TStream;
   vArquivo: string;
   vPasta: string;
   vLinha: string;
   vTentativas: Integer;
begin
   Result := Self;
   try
      oLinhaTexto := TStringBuilder.Create;
      oMemo := tstringlist.Create;
      try

         if pComando.IsEmpty then
            raise EPowerCMD.Create('O comando está vazio');

         Randomize;
         vArquivo := IntToStr(Random(100000));
         vPasta := TPath.GetSharedDocumentsPath + '\';
         oLinhaTexto.Append(vPasta).Append(vArquivo).Append('.txt');
         oMemo.Clear;
         oMemo.SaveToFile(oLinhaTexto.ToString);

         oLinhaTexto.Clear;
         oLinhaTexto.Append('-command').Append(' ').Append(pComando)
           .Append(' > ').Append(vPasta).Append(vArquivo).Append('.txt');

         ShellExecute(FHandle, 'open', 'powershell.exe',
           pchar(oLinhaTexto.ToString), nil, SW_HIDE);

         oLinhaTexto.Clear;

         oLinhaTexto.Append(vPasta).Append(vArquivo).Append('.txt');

         vTentativas := 0;
         repeat
            oCopiaArquivo := TFileStream.Create(oLinhaTexto.ToString,
              fmShareDenyNone);
            oMemo.LoadFromStream(oCopiaArquivo);
            FreeAndNil(oCopiaArquivo);
            if (not(oMemo.Text.IsEmpty)) or (vTentativas = 10) then
            begin
               DeleteFile(pchar(oLinhaTexto.ToString));
               Break;
            end
            else
            begin
               Sleep(250 + (250 * vTentativas));
               Inc(vTentativas);
            end;

         until (not(oMemo.Text.IsEmpty));

         pResultado := '';
         if not(oMemo.Text.IsEmpty) then
         begin
            for vLinha in oMemo do
            begin
               if not(vLinha.IsEmpty) then
                  pResultado := pResultado + vLinha + sLineBreak;
            end;
         end;

      except
         raise EPowerCMD.Create('Erro ao executar comando');
      end;
   finally
      FreeAndNil(oLinhaTexto);
      FreeAndNil(oMemo);
   end;
end;

function TModelPowerCMD.ExecDir(pDir: string): Boolean;
begin
   Result := ShellExecute(FHandle, pchar('open'), pchar('explorer.exe'),
     pchar(pDir), nil, SW_NORMAL) > 32;
end;

function TModelPowerCMD.ExecLink(pLink: string): iModelPowerCMD;
begin
   Result := Self;
   if pLink.IsEmpty then
      raise EPowerCMD.Create('Link invalido');
   ShellExecute(FHandle, 'open', pchar(pLink), '', '', SW_SHOWDEFAULT);
end;

class function TModelPowerCMD.New(Handle: THandle): iModelPowerCMD;
begin
   Result := Self.Create;
   FHandle := Handle;
end;

end.
