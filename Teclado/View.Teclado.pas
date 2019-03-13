unit View.Teclado;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Objects, FMX.Layouts, FMX.Edit;

type
  TTipoTeclado = (alphaNumerico, Letra);

  TfrmTecladoAlphaNumeric = class(TForm)
    lTeclado: TLayout;
    btn1: TRectangle;
    Text1: TText;
    btn2: TRectangle;
    Text2: TText;
    btn4: TRectangle;
    Text4: TText;
    btn3: TRectangle;
    Text3: TText;
    btn8: TRectangle;
    Text5: TText;
    btn7: TRectangle;
    Text6: TText;
    btn6: TRectangle;
    Text7: TText;
    btn5: TRectangle;
    Text8: TText;
    btn0: TRectangle;
    Text9: TText;
    btn9: TRectangle;
    Text10: TText;
    btnP: TRectangle;
    Text11: TText;
    btnO: TRectangle;
    Text12: TText;
    btnI: TRectangle;
    Text13: TText;
    btnU: TRectangle;
    Text14: TText;
    btnY: TRectangle;
    Text15: TText;
    btnT: TRectangle;
    Text16: TText;
    btnR: TRectangle;
    Text17: TText;
    btnE: TRectangle;
    Text18: TText;
    btnW: TRectangle;
    Text19: TText;
    btnQ: TRectangle;
    Text20: TText;
    btnM: TRectangle;
    Text33: TText;
    btnN: TRectangle;
    Text34: TText;
    btnB: TRectangle;
    Text35: TText;
    btnV: TRectangle;
    Text36: TText;
    btnC: TRectangle;
    Text37: TText;
    btnX: TRectangle;
    Text38: TText;
    btnZ: TRectangle;
    Text39: TText;
    btnEspaco: TRectangle;
    Text31: TText;
    btnApagar: TRectangle;
    Text40: TText;
    btnCCedilha: TRectangle;
    Text21: TText;
    btnL: TRectangle;
    Text22: TText;
    btnK: TRectangle;
    Text23: TText;
    btnJ: TRectangle;
    Text24: TText;
    btnH: TRectangle;
    Text25: TText;
    btnG: TRectangle;
    Text26: TText;
    btnF: TRectangle;
    Text27: TText;
    btnD: TRectangle;
    Text28: TText;
    btnS: TRectangle;
    Text29: TText;
    btnA: TRectangle;
    Text30: TText;
    btnEnter: TRectangle;
    Text41: TText;
    Rectangle1: TRectangle;
    RectAnimation1: TRectAnimation;
    procedure btnEnterClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
  private
    FCorLetra:      TAlphaColor;
    FCorFundo:      TAlphaColor;
    FCorFundoLetra: TAlphaColor;
    FTipoTeclado:   TTipoTeclado;
    FEdit: TEdit;
    { Private declarations }
    procedure btnClick(Sender: TObject);

    procedure DefinirTipoTeclado(btnTecla: TRectangle);
    procedure SetTeclasCores();

    procedure ApagarTexto();
    procedure Teclar(btn: TRectangle);
  public
    property CorLetra:      TAlphaColor  read FCorLetra      ;
    property CorFundo:      TAlphaColor  read FCorFundo      ;
    property CorFundoLetra: TAlphaColor  read FCorFundoLetra ;
    property TipoTeclado:   TTipoTeclado read FTipoTeclado   ;
    property Edit:          TEdit        read FEdit          write FEdit;

    constructor Create(aEdit: TEdit ;aTipoTeclado: TTipoTeclado;
      aCorFundo, aCorLetra, aCorFundoLetra: TAlphaColor); reintroduce;


    { Public declarations }
  end;



implementation

{$R *.fmx}

{ TfrmTecladoAlphaNumeric }

procedure TfrmTecladoAlphaNumeric.ApagarTexto;
var
   texto: string;
begin
   texto:= Edit.Text;
   delete(texto, Edit.SelStart, 1);
   Edit.Text:= texto;
end;

procedure TfrmTecladoAlphaNumeric.btnApagarClick(Sender: TObject);
begin
  ApagarTexto;
end;

procedure TfrmTecladoAlphaNumeric.btnClick(Sender: TObject);
begin
  Teclar(TRectangle(sender));
end;

procedure TfrmTecladoAlphaNumeric.btnEnterClick(Sender: TObject);
begin
  Edit.OnExit(Application);
end;

constructor TfrmTecladoAlphaNumeric.Create(aEdit: TEdit ;aTipoTeclado: TTipoTeclado;
      aCorFundo, aCorLetra, aCorFundoLetra: TAlphaColor);
begin
  inherited Create(nil);
  FEdit:= aEdit;
  FCorLetra:= aCorLetra;
  FCorFundo:= aCorFundo;
  FCorFundoLetra:= aCorFundoLetra;
  FTipoTeclado:= aTipoTeclado;
  SetTeclasCores();
  Edit.SelStart:= Edit.Text.Length;

end;

procedure TfrmTecladoAlphaNumeric.DefinirTipoTeclado(btnTecla: TRectangle);
begin
  if TipoTeclado = Letra then
  begin
    if btnTecla.Tag in [48..57] then
    begin
      btnTecla.Visible:= false;
      btnEnter.Position.Y:= 119;
      btnApagar.Position.Y:= 64;
    end;
  end;
end;

procedure TfrmTecladoAlphaNumeric.SetTeclasCores;
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


        DefinirTipoTeclado((Components[I] as TRectangle));

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

procedure TfrmTecladoAlphaNumeric.Teclar(btn: TRectangle);
var
  caractere: string;
begin
   caractere:= btn.TagString;
   Edit.Text:= Edit.Text+caractere;
   Edit.SelStart:= Length(Edit.Text);
end;

end.
