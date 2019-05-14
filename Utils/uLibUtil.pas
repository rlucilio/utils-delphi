unit uLibUtil;

interface
uses
  System.SysUtils,
  System.Classes,
  FMX.Graphics,
  Soap.EncdDecd,
  System.NetEncoding;

function Base64FromBitmap(ABitmap: TBitmap): string;

function BitmapFromBase64(const base64: string): TBitmap;

function GetIdUnique:String;

implementation

function GetIdUnique:String;
var
  gID: TGuid;
begin
  CreateGUID(gID);
  result := gID.ToString;
end;

function Base64FromBitmap(ABitmap: TBitmap): string;
var
  LInputStream: TBytesStream;
  LOutputStream: TStringStream;
begin
  Result := '';
  if ABitmap.IsEmpty then
    Exit;
  LInputStream := TBytesStream.Create;
  try
    ABitmap.SaveToStream(LInputStream);
    LInputStream.Position := 0;
    LOutputStream := TStringStream.Create('');
    try
      TNetEncoding.Base64.Encode(LInputStream, LOutputStream);
      Result := LOutputStream.DataString;
    finally
      LOutputStream.Free;
    end;
  finally
    LInputStream.Free;
  end;
end;

function BitmapFromBase64(const base64: string): TBitmap;
var
  Input: TStringStream;
  Output: TBytesStream;
begin
  Input := TStringStream.Create(base64, TEncoding.ASCII);
  try
    Output := TBytesStream.Create;
    try
      Soap.EncdDecd.DecodeStream(Input, Output);
      Output.Position := 0;
      Result := TBitmap.Create;
      try
        Result.LoadFromStream(Output);
      except
        Result.Free;
        raise;
      end;
    finally
      Output.Free;
    end;
  finally
    Input.Free;
  end;
end;


end.
