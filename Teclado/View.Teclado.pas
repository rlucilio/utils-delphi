unit View.Teclado;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, FMX.Edit,
  FMX.Effects;

type
   Tdirecao = (dDireteira, dEsquerda);

  TViewTeclado = class(TForm)
    ImgTeclado: TImage;
    LayoutC: TLayout;
    LayoutX: TLayout;
    LayoutD: TLayout;
    LayoutS: TLayout;
    LayoutA: TLayout;
    LayoutM: TLayout;
    LayoutN: TLayout;
    LayoutB: TLayout;
    LayoutZ: TLayout;
    LayoutF: TLayout;
    LayoutV: TLayout;
    LayoutH: TLayout;
    LayoutG: TLayout;
    LayoutJ: TLayout;
    LayoutK: TLayout;
    LayoutY: TLayout;
    LayoutT: TLayout;
    LayoutR: TLayout;
    LayoutE: TLayout;
    LayoutW: TLayout;
    LayoutCC: TLayout;
    LayoutL: TLayout;
    LayoutEnter: TLayout;
    LayoutBackSpace: TLayout;
    LayoutP: TLayout;
    LayoutO: TLayout;
    LayoutI: TLayout;
    LayoutU: TLayout;
    LayoutQ: TLayout;
    LayoutSpace: TLayout;
    LayoutNext: TLayout;
    LayoutBack: TLayout;
    ShadowEffect1: TShadowEffect;
    LayoutTeclado: TLayout;
    procedure LayoutQMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutWMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutEMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutRMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutTMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutYMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutUMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutIMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutOMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutPMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutAMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutSMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutDMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutFMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutGMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutHMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutJMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutKMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutLMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutCCMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutZMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutXMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutCMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutVMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutNMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutMMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutSpaceMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutNextMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure LayoutBackClick(Sender: TObject);
    procedure LayoutBackSpaceMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  private
   FEdit: TEdit;
    procedure letraPrescionada(sender: TObject;letra: char);
    procedure mudaPosicao(sender: TObject;direcao: Tdirecao);
    procedure apagaTexto(sender: TObject);
    { Private declarations }
  public
    constructor Create(owner: TComponent; sender: TObject);reintroduce;

    { Public declarations }
  end;


implementation

{$R *.fmx}

procedure TViewTeclado.apagaTexto(sender: TObject);
var
   texto: string;
begin
   texto:= TEdit(sender).Text;
   delete(texto, TEdit(sender).SelStart, 1);
   TEdit(sender).Text:= texto;
end;


constructor TViewTeclado.Create(owner: TComponent; sender: TObject);
begin
   inherited Create(owner);
   FEdit:= TEdit(sender);
end;

procedure TViewTeclado.LayoutAMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'A');
end;

procedure TViewTeclado.LayoutBackClick(Sender: TObject);
begin
    mudaPosicao(FEdit, dEsquerda);
end;

procedure TViewTeclado.LayoutBackSpaceMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
   apagaTexto(FEdit);
end;

procedure TViewTeclado.LayoutBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'B');
end;

procedure TViewTeclado.LayoutCCMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'Ç');
end;

procedure TViewTeclado.LayoutCMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'C');
end;

procedure TViewTeclado.LayoutDMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'D');
end;

procedure TViewTeclado.LayoutEMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'E');
end;

procedure TViewTeclado.LayoutFMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'F');
end;

procedure TViewTeclado.LayoutGMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'G');
end;

procedure TViewTeclado.LayoutHMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'H');
end;

procedure TViewTeclado.LayoutIMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'I');
end;

procedure TViewTeclado.LayoutJMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'J');
end;

procedure TViewTeclado.LayoutKMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'K');
end;

procedure TViewTeclado.LayoutLMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'L');
end;

procedure TViewTeclado.LayoutMMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'M');
end;

procedure TViewTeclado.LayoutNextMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    mudaPosicao(FEdit, dDireteira);
end;

procedure TViewTeclado.LayoutNMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'N');
end;

procedure TViewTeclado.LayoutOMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'O');
end;

procedure TViewTeclado.LayoutPMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'P');
end;

procedure TViewTeclado.LayoutQMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'Q');
end;

procedure TViewTeclado.LayoutRMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'R');
end;

procedure TViewTeclado.LayoutSMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'S');
end;

procedure TViewTeclado.LayoutSpaceMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,' ');
end;

procedure TViewTeclado.LayoutTMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'T');
end;

procedure TViewTeclado.LayoutUMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'U');
end;

procedure TViewTeclado.LayoutVMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'V');
end;

procedure TViewTeclado.LayoutWMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'W');
end;

procedure TViewTeclado.LayoutXMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'X');
end;

procedure TViewTeclado.LayoutYMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'Y');
end;

procedure TViewTeclado.LayoutZMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
   letraPrescionada(FEdit,'Z');
end;

procedure TViewTeclado.mudaPosicao(sender: TObject; direcao: Tdirecao);
begin
   if direcao = dDireteira then
   begin
      if FEdit.SelLength < FEdit.SelStart+1 then
      begin
         FEdit.SelStart:= FEdit.SelStart+1;
      end;
   end
   else
   begin
      if FEdit.SelStart-1 > -1 then
      begin
         FEdit.SelStart:= FEdit.SelStart-1;
      end;
   end;

end;

procedure TViewTeclado.letraPrescionada(sender: TObject;letra: char);
begin
   FEdit.Text:= FEdit.Text+letra;
   FEdit.SelStart:= Length(FEdit.Text);
end;

end.
