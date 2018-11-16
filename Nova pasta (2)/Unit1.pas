unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, uConexao.MySQL;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uConexao.interfaces, uConexaoORM, ormbr.factory.interfaces, Entidade.cliente,
  System.Generics.Collections, Entidade.programa_cliente;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  con: iConexao;
  orm: TConexaoORM;
  parametros: TParamsMySQL;
  item: Tprograma_cliente;
  lista: TObjectList<Tprograma_cliente>;
begin
  try
    parametros.Database:= 'siclop_store';
    parametros.User_name:= 'root';
    parametros.Server:= 'localhost';
    parametros.Port:= '3306';
    con:= TConexaoMySQL.New(parametros);
    orm:= TConexaoORM.Create(con.Connection, dnMySQL);
    orm.Ref;
    lista:= orm.DAO<Tprograma_cliente>().FindWhere('CLI_ID = 1');
    for item in lista do
    begin
      ShowMessage(item.PRG_CLI_ACAO);
    end;


  finally
    lista.Clear;
    FreeAndNil(lista);
  end;
end;

end.
