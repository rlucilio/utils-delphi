unit View.TecladoNumerico;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Layouts, FMX.Objects, FMX.Edit;

type
  TfrmTecladoNumerico = class(TForm)
    Rectangle1: TRectangle;
    btn1: TRectangle;
    Text1: TText;
    btn2: TRectangle;
    Text2: TText;
    btn3: TRectangle;
    Text3: TText;
    btn4: TRectangle;
    Text4: TText;
    btn5: TRectangle;
    Text8: TText;
    btn6: TRectangle;
    Text7: TText;
    btn7: TRectangle;
    Text6: TText;
    btn8: TRectangle;
    Text5: TText;
    btn9: TRectangle;
    Text10: TText;
    btn0: TRectangle;
    Text9: TText;
    btnApagar: TRectangle;
    Text40: TText;
    btnEnter: TRectangle;
    Text41: TText;
    btnVirgula: TRectangle;
    Text11: TText;
    lTeclado: TLayout;
    procedure btnEnterClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
  private
    FCorFundo: TAlphaColor;
    FCorFundoLetra: TAlphaColor;
    FCorLetra: TAlphaColor;
    FTemDecimal: Boolean;
    FEdit: TEdit;
    { Private declarations }
    procedure SetTeclasCores();
    procedure ApagarTexto();
    procedure Teclar(btn: TRectangle);
    procedure btnClick(Sender: TObject);
  public
    property CorLetra:      TAlphaColor  read FCorLetra      ;
    property CorFundo:      TAlphaColor  read FCorFundo      ;
    property CorFundoLetra: TAlphaColor  read FCorFundoLetra ;
    property TemDecimal:    Boolean      read FTemDecimal    ;
    property Edit:          TEdit        read FEdit          ;

    constructor Create(aEdit: TEdit; aTemDecimal: Boolean;
      aCorFundo, aCorLetra, aCorFundoLetra: TAlphaColor); reintroduce;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TForm8 }

procedure TfrmTecladoNumerico.btnApagarClick(Sender: TObject);
begin
  ApagarTexto;
end;

procedure TfrmTecladoNumerico.btnClick(Sender: TObject);
begin
  Teclar(TRectangle(sender));
end;

procedure TfrmTecladoNumerico.Teclar(btn: TRectangle);
var
  caractere: string;
begin
   caractere:= btn.TagString;
   Edit.Text:= Edit.Text+caractere;
   Edit.SelStart:= Length(Edit.Text);
end;

procedure TfrmTecladoNumerico.ApagarTexto;
var
   texto: string;
begin
   texto:= Edit.Text;
   delete(texto, Edit.SelStart, 1);
   Edit.Text:= texto;
end;

procedure TfrmTecladoNumerico.btnEnterClick(Sender: TObject);
begin
  Edit.OnExit(Application);
end;

constructor TfrmTecladoNumerico.Create(aEdit: TEdit; aTemDecimal: Boolean;
      aCorFundo, aCorLetra, aCorFundoLetra: TAlphaColor);
begin
  inherited Create(nil);
  FEdit:=     aEdit;
  FCorLetra:= aCorLetra;
  FCorFundo:= aCorFundo;
  FCorFundoLetra:= aCorFundoLetra;
  FTemDecimal:= aTemDecimal;
  SetTeclasCores();

  Edit.SelStart:= Edit.Text.Length;

  if not TemDecimal then
  begin
    btnVirgula.Visible:= false;
    btn0.Position.X:= 72;
  end;
end;

procedure TfrmTecladoNumerico.SetTeclasCores;
var
  I: Integer;
begin
  for I := 0 to (Self.ComponentCount) -1 do
  begin
    if Components[I] is TRectangle then
    begin
      if (Components[I] as TRectangle).Tag > 0 then
      begin
        if (Components[I] as TRectangle).Tag = 99 then
          (Components[I] as TRectangle).TagString:= 'Ç'
        else
          (Components[I] as TRectangle).TagString:= char((Components[I] as TRectangle).Tag);

        (Components[I] as TRectangle).Stroke.Kind := TBrushKind.None;

        (Components[I] as TRectangle).Fill.Color := CorFundoLetra;

        if not ((Components[I] as TRectangle).Tag in [8, 27]) then
          (Components[I] as TRectangle).OnClick:= btnClick;
      end
      else
        (Components[I] as TRectangle).Fill.Color := CorFundo;
    end
    else if Components[I] is TText then
    begin
      (Components[I] as TText).Color:= CorLetra;
    end;
  end;
end;

end.
