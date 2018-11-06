unit DB.Helper;

interface

uses
  Data.DB;

Type
  TDataSetHelper = class helper for TDataSet
    function ToJSON(alias: string = ''): string;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders;

{ TDataSetHelper }

function TDataSetHelper.ToJSON(alias: string): string;
var
  //JSON BUILDER
  builder: TJSONObjectBuilder;
  writer: TJsonTextWriter;
  stringWriter: TStringWriter;
  stringBuilter: TStringBuilder;

  //Primeiros Elementos
  objJson: TJSONCollectionBuilder.TPairs;
  arrayJson: TJSONCollectionBuilder.TElements;

  //Elementos do Array
  objElemento: TJSONCollectionBuilder.TPairs;

  item: TField;
begin
  stringBuilter:= TStringBuilder.Create();
  stringWriter:= TStringWriter.Create(stringBuilter);
  writer:= TJsonTextWriter.Create(stringWriter);
  writer.Formatting:= TJsonFormatting.Indented;
  builder:= TJSONObjectBuilder.Create(writer);
  try
    Self.First;
    objJson:= builder.BeginObject;
    arrayJson:= objJson.BeginArray(alias);

    while not Self.Eof do
    begin
      objElemento:= arrayJson.BeginObject;

      for item in Self.Fields do
      begin
        if item.IsNull then
          objElemento.AddNull(item.FieldName)
        else
          objElemento.Add(item.FieldName, item.AsString);
      end;

      objElemento.EndObject;
      Self.Next;
    end;

    arrayJson
      .EndArray
        .EndObject;

    Result := stringBuilter.ToString;

    if alias.IsEmpty then
    begin
      Result:= StringReplace(Result,'"":','', []);
    end;
  finally
    FreeAndNil(builder);
    FreeAndNil(writer);
    FreeAndNil(stringWriter);
    FreeAndNil(stringBuilter);
  end;

end;

end.
