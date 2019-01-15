unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, Vcl.StdCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    btn2: TButton;
    btn9: TButton;
    btn1: TButton;
    mmo1: TMemo;
    edt1: TEdit;
    btn3: TBitBtn;
    btn4: TBitBtn;
    btn5: TBitBtn;
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Model.LibUtil,
  WinSpool, uRelatorio.Interfaces, uRelatorio.InformativosSimples, uRelatorio.Linhas, uRelatorio.Termica, uRelatorio.InformacacaoImportante, uRelatorio.Matricial, uRelatorio.InformacaoRodape, uRelatorio.InformacaoLista,
  System.Generics.Collections,
  Printers;
var
  imp: TPrinter;

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
  ShowMessage(AlinhaString('Renan', '-', 48, atRigth));
  ShowMessage(AlinhaString('Renan', '-', 48, atLeft));
  ShowMessage(AlinhaString('Renan', '-', 48, atCenter));
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  print : textfile ;
begin
//      writeLn(print, #27+'X'); // Delay
//      writeLn(print, #13); // Avança bobina
  try
    try
      Assignfile (print, '\\RenanLucilio\Termica');
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

procedure TForm1.btn3Click(Sender: TObject);
var
  print : textfile ;
  str: string;
begin
//      writeLn(print, #27+'X'); // Delay
//      writeLn(print, #13); // Avança bobina
  try
    try
      Printer.Canvas.Font.Name := 'Times New Roman';
      Printer.Canvas.Font.Size:= 40;
      Assignfile (print, '\\RenanLucilio\Termica');
      rewrite(print);


      writeLn(print,'Renan Lucilio');

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

procedure TForm1.btn4Click(Sender: TObject);
var
  indice: Integer;
  it: string;
begin
  imp := TPrinter.Create;
  indice := imp.Printers.IndexOf('Termica');

  if indice > -1 then
  begin
    imp.PrinterIndex:= indice;
    imp.BeginDoc;
      for it in imp.Fonts do
      begin
        imp.Canvas.Font.Size:= 12;
        imp.Canvas.TextOut(0,0,it);
        imp.NewPage;
      end;


    imp.EndDoc;
  end
  else
    ShowMessage('Impressora não existe');
end;

procedure TForm1.btn5Click(Sender: TObject);
begin
  imp.EndDoc
end;

procedure TForm1.btn6Click(Sender: TObject);
var
  listaInteger: TList<Integer>;
  listaString3: TList<string>;
begin
  listaInteger:= TList<Integer>.Create;
  listaString3:= TList<string>.Create;
  try
    listaString3.Add('RenanLucilioRenanLucilioRenanLucilioRenanLucilioRenanLucilioRenanLucilio');
    listaString3.Add('12345678912345678912345678912');
    listaString3.Add('ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ');
    listaString3.Add('RERERERERERERRERE');

    listaInteger.Add(10);
    listaInteger.Add(10);
    listaInteger.Add(10);
    listaInteger.Add(10);
    TTratamentoLinhas.New.AddLinhasColunadas(mmo1.Lines, listaString3.ToArray, listaInteger.ToArray);
  finally
    listaInteger.Free;
    listaString3.Free;
  end;
end;

procedure TForm1.btn8Click(Sender: TObject);
var
  print : textfile ;
begin
//      writeLn(print, #27+'X'); // Delay
//      writeLn(print, #13); // Avança bobina
  try
    try
      Assignfile (print, '\\RenanLucilio\Termica');
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


procedure TForm1.btn9Click(Sender: TObject);
var
  importante: IInformacaoImportante;
  simples: IInformacaoSimples;
  rodape: IInformacaoRodape;
  lista: IInformacaoLista;

  relatorio: IRelatorio;
  relatorio2: IRelatorio;
  listaString: TList<string>;
  listaString2: TList<string>;
  listaString3: TList<string>;
  listaInteger: TList<Integer>;
begin
  relatorio:= TRelatorioMatricial.Create;
//  relatorio2:= TRelatorioTermica.Create(0, 0, 0, 0, 320, 400);
  relatorio.Ref;
  relatorio2.Ref;

  listaInteger:= TList<Integer>.Create;
  listaString3:= TList<string>.Create;
  listaString2:= TList<string>.Create;
  listaString:= TList<string>.Create;
  try
    listaString.Add('Endereco: Rua Roberto Cavanza Endereco: Rua Roberto Cavanza Endereco: Rua Roberto Cavanza Endereco: Rua Roberto Cavanza');
    listaString.Add('Contato: 4679-6537');
    listaString.Add('Contato: 4679-6537');
    listaString.Add('Contato: 4679-6537');
    importante:= TInformacaoImportante.New('RENAN LUCILIO RENAN LUCILIO RENAN LUCILIO RENAN LUCILIO',
     11, 45, 8, listaString);
//    relatorio.addInformacaoImportante(importante);
    relatorio2.addInformacaoImportante(importante);

    simples:= TInformacaoSimples.New('Total:','45,00', 12, 53);
//    relatorio.addInformacaoSimples(simples);
    relatorio2.addInformacaoSimples(simples);

    listaString3.Add('RenanLucilioRenanLucilioRenanLucilioRenanLucilioRenanLucilioRenanLucilio');
    listaString3.Add('12345678912345678912345678912');
    listaString3.Add('ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ');

    listaInteger.Add(11);
    listaInteger.Add(11);
    listaInteger.Add(11);
    lista:= TInformacaoLista.New(listaString3, listaInteger);
//    relatorio.addInformacoesLista(lista);
    relatorio2.addInformacoesLista(lista);

    listaString2.Add('SICLOP');
    listaString2.Add('p.com.brwww.centralsiclop.com.brwww.centralsiclop.com.brwww.centralsiclop.com.brwww.centralsiclop.com.brwww.centralsiclop.com.brwww.centralsiclop.com.brwww.centralsiclop.com.brwww.centralsiclop.com.br');
    rodape:=  TInformacaoRodape.New(listaString2, 7, 58);
//    relatorio.addInformacaoRodape(rodape);
    relatorio2.addInformacaoRodape(rodape);

//    relatorio.imprimir('', 'RenanLucilio', 'matricial', false);
//    relatorio.imprimir('', 'RenanLucilio', 'perto', false);

//    relatorio2.imprimir('teste', 'RenanLucilio', 'Termica', false);
  finally
    listaInteger.Free;
    listaString3.Free;
    listaString2.Free;
    listaString.Free;
  end;
end;

end.


