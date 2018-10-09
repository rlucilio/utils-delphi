unit ToForm;

interface

uses
  ToForm.Interfaces, FMX.Forms, System.Rtti, System.SysUtils, System.Classes,
  System.Generics.Collections;

type
  TToForm = class(TInterfacedObject, iToForm)
  private
    _Form: tform;
    constructor Create(form: tform);
    procedure PropToText(propridade: TRttiProperty; obj: TObject);
    procedure PropToChecked(propridade: TRttiProperty; obj: TObject);
    procedure PropToIndex(propridade: TRttiProperty; obj: TObject);
    procedure propToDateTime(propridade: TRttiProperty; obj: TObject);
    procedure propToLines(propridade: TRttiProperty; obj: TObject);
    procedure SetString(propridade: TRttiProperty; obj: TObject);
    procedure SetInt(propridade: TRttiProperty; obj: TObject);
    procedure SetFloat(propridade: TRttiProperty; obj: TObject);
    procedure SetBool(propridade: TRttiProperty; obj: TObject);
    procedure SetDateTime(propridade: TRttiProperty; obj: TObject);
    procedure SetListString(propridade: TRttiProperty; obj: TObject);
    procedure setEnum(propridade: TRttiProperty; obj: TObject);
    function VarrerComponente(nomeComponente: string;
      tipoConversao: TTipoConversao; out componente: TComponent): TRttiProperty;
    procedure AcaoASerFeita(acao: TTipoAcaoConversao; obj: TObject);
  public
    destructor Destroy; override;
    class function New(form: tform): iToForm;
    function ClassToForm(obj: TObject): iToForm;
    function FormToClasse(obj: TObject;
      acao: TTipoAcaoConversao = tacNada): iToForm;
  end;

implementation

uses
  System.Variants, TypInfo, Model.Ini.Interfaces;

{ TMinhaClasse }

constructor TToForm.Create(form: tform);
begin
  inherited Create;
  _Form := form;
end;

destructor TToForm.Destroy;
begin

  inherited;
end;

function TToForm.FormToClasse(obj: TObject; acao: TTipoAcaoConversao): iToForm;
var
  propridade: TRttiProperty;
  contexto: TRttiContext;
  tipo: TRttiType;
begin
  result := self;

  contexto := TRttiContext.Create;
  tipo := contexto.GetType(obj.ClassInfo);
  for propridade in tipo.GetProperties do
  begin

    if (propridade.IsWritable) then
    begin

      if (propridade.GetValue(obj).IsOrdinal) and
        not((propridade.GetValue(obj).IsType<Integer>()) or
        (propridade.GetValue(obj).IsType<char>()) or
        (propridade.GetValue(obj).IsType<Boolean>())) then
      begin
        setEnum(propridade, obj);
        Continue;
      end;

      if propridade.GetValue(obj).IsType<string>() then
      begin
        SetString(propridade, obj);
        Continue;
      end;

      if propridade.GetValue(obj).IsType<Integer>() then
      begin
        SetInt(propridade, obj);
        Continue;
      end;

      if propridade.GetValue(obj).IsType<Boolean>() then
      begin
        SetBool(propridade, obj);
        Continue;
      end;

      if (propridade.GetValue(obj).IsType<TDate>) or
        (propridade.GetValue(obj).IsType<TTime>() or
        (propridade.GetValue(obj).IsType<TDateTime>())) then
      begin
        SetDateTime(propridade, obj);
        Continue;
      end;

      if propridade.GetValue(obj).IsType < TList < string >> () then
      begin
        SetListString(propridade, obj);
        Continue;
      end;

      if propridade.GetValue(obj).IsType<Double>() and
        not((propridade.GetValue(obj).IsType<TDateTime>())) then
      begin
        SetFloat(propridade, obj);
        Continue;
      end;

    end;

  end;

  AcaoASerFeita(acao, obj);

end;

class function TToForm.New(form: tform): iToForm;
begin
  result := self.Create(form)
end;

procedure TToForm.PropToChecked(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcChecked, _componente);

  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    _propriedade.SetValue(_componente, propridade.GetValue(obj).AsBoolean);
  end;
end;

procedure TToForm.PropToIndex(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
  indice: Integer;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcItemIndex, _componente);

  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    indice := Integer(propridade.GetValue(obj).AsOrdinal);

    _propriedade.SetValue(_componente, indice);
  end;
end;

procedure TToForm.propToLines(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
  value: TValue;
  item: string;
  _stringsAux: TStringList;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcLines, _componente);

  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    try
      _stringsAux := TStringList.Create;
      value := TValue.From < TList < string >>
        (propridade.GetValue(obj).AsType < TList < string >> ());

      for item in value.AsType < TList < string >> () do
      begin
        _stringsAux.Add(item);
      end;

      _propriedade.SetValue(_componente, _stringsAux);
    finally
      FreeAndNil(_stringsAux);
    end;
  end;
end;

procedure TToForm.propToDateTime(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcDateTime, _componente);

  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    _propriedade.SetValue(_componente,
      VarToDateTime(propridade.GetValue(obj).AsVariant));
  end;
end;

procedure TToForm.PropToText(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcText, _componente);

  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    _propriedade.SetValue(_componente,
      vartostr(propridade.GetValue(obj).AsVariant));
  end;
end;

procedure TToForm.SetBool(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcChecked, _componente);

  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    propridade.SetValue(obj, _propriedade.GetValue(_componente).AsBoolean);
  end;
end;

procedure TToForm.SetDateTime(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
  value: TDateTime;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcDateTime, _componente);

  value := FloatToDateTime(_propriedade.GetValue(_componente).AsExtended);

  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    propridade.SetValue(obj, value);
  end;
end;

procedure TToForm.setEnum(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
  value: Integer;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcItemIndex, _componente);

  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    value := _propriedade.GetValue(_componente).AsInteger;

    propridade.SetValue(obj,
      TValue.FromOrdinal(propridade.PropertyType.Handle, value));
  end;
end;

procedure TToForm.SetFloat(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcText, _componente);

  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    propridade.SetValue(obj, _propriedade.GetValue(_componente).AsExtended);
  end;
end;

procedure TToForm.SetInt(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
  value: Integer;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcText, _componente);

  value := StrToIntDef(_propriedade.GetValue(_componente).AsString, -1);
  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    propridade.SetValue(obj, value);
  end;
end;

procedure TToForm.SetListString(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
  _auxTStrings: TStrings;
  value: TList<string>;
  item: string;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcLines, _componente);

  _auxTStrings := _propriedade.GetValue(_componente).AsType<TStrings>();

  value := propridade.GetValue(obj).AsType < TList < string >> ();
  value.Clear;
  for item in _auxTStrings do
  begin
    value.Add(item);
  end;

  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    propridade.SetValue(obj, value);
  end;

end;

procedure TToForm.SetString(propridade: TRttiProperty; obj: TObject);
var
  _propriedade: TRttiProperty;
  _componente: TComponent;
begin
  _propriedade := VarrerComponente(Concat(obj.ClassName, '_', propridade.Name),
    tcText, _componente);

  if (Assigned(_componente)) and (Assigned(_propriedade)) then
  begin
    propridade.SetValue(obj, trim(_propriedade.GetValue(_componente).AsString));
  end;
end;

function TToForm.VarrerComponente(nomeComponente: string;
  tipoConversao: TTipoConversao; out componente: TComponent): TRttiProperty;
var
  _componente: TComponent;
  _nomeComponente: string;
  I: Integer;

  _propridade: TRttiProperty;
  contexto: TRttiContext;
  tipo: TRttiType;
begin
  result := nil;
  componente := nil;
  _propridade := nil;
  for I := 0 to _Form.ComponentCount - 1 do
  begin
    _componente := _Form.Components[I];
    _nomeComponente := _componente.Name;

    if _nomeComponente.Contains(Concat(nomeComponente)) then
    begin
      try
        contexto := TRttiContext.Create;
        tipo := contexto.GetType(_componente.ClassInfo);

        case tipoConversao of
          tcText:
            _propridade := tipo.GetProperty('Text');
          tcItemIndex:
            _propridade := tipo.GetProperty('ItemIndex');
          tcChecked:
            _propridade := tipo.GetProperty('IsChecked');
          tcDateTime:
            _propridade := tipo.GetProperty('DateTime');
          tcLines:
            _propridade := tipo.GetProperty('Lines');
        end;

        result := _propridade;
        componente := _componente;

      finally
        FreeAndNil(tipo);
      end;
    end;
  end;

end;

procedure TToForm.AcaoASerFeita(acao: TTipoAcaoConversao; obj: TObject);
var
  Ini: iModelIni;
begin
  case acao of
    tacSalvar:
      begin
        if Supports(obj, iModelIni, Ini) then
          Ini.salva(obj)
        else
        begin
          raise Exception.Create('Essa classe não implementa o método salvar');
        end;
      end;
    tacNada:
      Exit;
  end;
end;

function TToForm.ClassToForm(obj: TObject): iToForm;
var
  propridade: TRttiProperty;
  contexto: TRttiContext;
  tipo: TRttiType;
begin
  result := self;

  contexto := TRttiContext.Create;
  try
    tipo := contexto.GetType(obj.ClassInfo);
    for propridade in tipo.GetProperties do
    begin

      if (propridade.IsWritable) then
      begin

        if (propridade.GetValue(obj).IsOrdinal) and
          not((propridade.GetValue(obj).IsType<Integer>()) or
          (propridade.GetValue(obj).IsType<char>()) or
          (propridade.GetValue(obj).IsType<Boolean>())) then
        begin
          PropToIndex(propridade, obj);
          Continue;
        end;

        if propridade.GetValue(obj).IsType<string>() then
        begin
          PropToText(propridade, obj);
          Continue;
        end;

        if propridade.GetValue(obj).IsType<Integer>() then
        begin
          PropToText(propridade, obj);
          Continue;
        end;

        if propridade.GetValue(obj).IsType<Boolean>() then
        begin
          PropToChecked(propridade, obj);
          Continue;
        end;

        if (propridade.GetValue(obj).IsType<TDate>) or
          (propridade.GetValue(obj).IsType<TTime>() or
          (propridade.GetValue(obj).IsType<TDateTime>())) then
        begin
          propToDateTime(propridade, obj);
          Continue;
        end;

        if propridade.GetValue(obj).IsType < TList < string >> () then
        begin
          propToLines(propridade, obj);
          Continue;
        end;

      end;

    end;
  finally
    FreeAndNil(tipo);
  end;
end;

end.
