unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    btn6: TButton;
    btn8: TButton;
    btn9: TButton;
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn2Click(Sender: TObject);
var
  print : textfile ;
begin
//      writeLn(print, #27+'X'); // Delay
//      writeLn(print, #13); // Avança bobina
  try
    try
      Assignfile (print, '\\RenanLucilio\imprede');
      rewrite(print);

      writeLn(print, 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');

      //Espaçamento horizontal em 12cpp
      writeLn(print, 'LINHA NORMAL...');
      writeLn(print, #27+'M'+'ESPAÇAMENTO HORIZONTAL EM 12CPP...');
      writeLn(print, #27+'M'+'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
      Writeln(print);
      Writeln(print);

      // Ativa o modo condensado          // Desativa o modo condensado
      writeLn(print, 'LINHA NORMAL...');
      writeLn(print, #15+'ATIVA O MODO CONDENSADO');
      writeLn(print, #15+'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
      writeLn(print, #15+'DESATIVA ' + #18+ 'O MODO CONDENSADO');
      Writeln(print);
      Writeln(print);

      // Ativa o modo expandido      // Desativa o modo expandido
      writeLn(print, 'LINHA NORMAL...');
      writeLn(print, #27+'W'+'1'+'ATIVA O MODO EXPANDIDO');
      writeLn(print, #27+'W'+'1'+'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
      writeLn(print, #27+'W'+'1'+'DESATIVA O '+ #27+'W'+'0'+'MODO EXPANDIDO ');
      Writeln(print);
      Writeln(print);

      // Ativa o modo subescrito      // Desativa o modo subescrito
      writeLn(print, 'LINHA NORMAL...');
      writeLn(print, #27+'S0'+'ATIVA O MODO SUBESCRITO');
      writeLn(print, #27+'S0'+'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
      writeLn(print, #27+'S0'+'DESATIVA' +#27+'T'+'MODO SUBESCRITO');
      Writeln(print);
      Writeln(print);

      // Ativa o modo sublinhado    // Desativa o modo sublinhado
      writeLn(print, 'LINHA NORMAL...');
      writeLn(print, #27+'-'+'1'+'ATIVA O MODO SUBLINHADO');
      writeLn(print, #27+'-'+'1'+'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
      writeLn(print, #27+'-'+'1'+'DESATIVA O'+ #27+'-'+'0'+'MODO SUBLINHADO');
      Writeln(print);
      Writeln(print);

      // Ativa o modo sobrescrito     // Desativa os modos sobrescrito
      writeLn(print, 'LINHA NORMAL...');
      writeLn(print, #27+'S1'+'ATIVA O MODO SOBRESCRITO');
      writeLn(print, #27+'S1'+'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
      writeLn(print, #27+'S1'+'DESATIVA O' +#27+'T'+'MODO SOBRESCRITO');
      Writeln(print);
      Writeln(print);

       // Ativa o modo negrito     // Desativa o modo negrito
      writeLn(print, 'LINHA NORMAL...');
      writeLn(print, #27+'E'+'ATIVA O MODO NEGRITO ');
      writeLn(print, #27+'E'+'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
      writeLn(print, #27+'E'+'DESATIVA O ' + #27+'F'+'MODO NEGRITO');
      Writeln(print);
      Writeln(print);

      writeLn(print);//pula linha
       writeLn(print);//pula linha
        writeLn(print);//pula linha
         writeLn(print);//pula linha
          writeLn(print);//pula linha

    except
      ShowMessage('Erro a fazer impressão');
    end;
  finally
    closefile(print);
  end;

end;

end.


