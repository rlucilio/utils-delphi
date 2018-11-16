unit Entidade.programa_cliente;

interface

uses
  DB, 
  Classes, 
  SysUtils, 
  Generics.Collections, 

  /// orm 
  Entidade.cliente,
  Entidade.programa,
  ormbr.types.blob, 
  ormbr.types.lazy, 
  ormbr.types.mapping, 
  ormbr.types.nullable, 
  ormbr.mapping.classes, 
  ormbr.mapping.register, 
  ormbr.mapping.attributes; 

type
  [Entity]
  [Table('programa_cliente', '')]
  [PrimaryKey('PRG_CLI_ID', NotInc, NoSort, False, 'Chave primária')]
  Tprograma_cliente = class
  private
    { Private declarations } 
    FPRG_CLI_ID: Nullable<Integer>;
    FPRG_ID: Integer;
    FCLI_ID: Integer;
    FPRG_CLI_DATAINSTALACAO: TDateTime;
    FPRG_CLI_ACAO: String;
    FPRG_CLI_TECNICO: String;

    Fcliente_0:  Tcliente  ;
    Fprograma_1:  Tprograma  ;
  public 
    { Public declarations } 
    constructor Create;
    destructor Destroy; override;
    [Column('PRG_CLI_ID', ftInteger)]
    [Dictionary('PRG_CLI_ID', 'Mensagem de validação', '', '', '', taCenter)]
    property PRG_CLI_ID: Nullable<Integer> read FPRG_CLI_ID write FPRG_CLI_ID;

    [Restrictions([NotNull])]
    [Column('PRG_ID', ftInteger)]
    [ForeignKey('programa_cliente_ibfk_1', 'PRG_ID', 'programa', 'PRG_ID', SetNull, SetNull)]
    [Dictionary('PRG_ID', 'Mensagem de validação', '', '', '', taCenter)]
    property PRG_ID: Integer read FPRG_ID write FPRG_ID;

    [Restrictions([NotNull])]
    [Column('CLI_ID', ftInteger)]
    [ForeignKey('programa_cliente_ibfk_2', 'CLI_ID', 'cliente', 'CLI_ID', SetNull, SetNull)]
    [Dictionary('CLI_ID', 'Mensagem de validação', '', '', '', taCenter)]
    property CLI_ID: Integer read FCLI_ID write FCLI_ID;

    [Restrictions([NotNull])]
    [Column('PRG_CLI_DATAINSTALACAO', ftDateTime)]
    [Dictionary('PRG_CLI_DATAINSTALACAO', 'Mensagem de validação', 'Date', '', '!##/##/####;1;_', taCenter)]
    property PRG_CLI_DATAINSTALACAO: TDateTime read FPRG_CLI_DATAINSTALACAO write FPRG_CLI_DATAINSTALACAO;

    [Restrictions([NotNull])]
    [Column('PRG_CLI_ACAO', ftString, 255)]
    [Dictionary('PRG_CLI_ACAO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property PRG_CLI_ACAO: String read FPRG_CLI_ACAO write FPRG_CLI_ACAO;

    [Restrictions([NotNull])]
    [Column('PRG_CLI_TECNICO', ftString, 255)]
    [Dictionary('PRG_CLI_TECNICO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property PRG_CLI_TECNICO: String read FPRG_CLI_TECNICO write FPRG_CLI_TECNICO;

    [Association(OneToOne,'CLI_ID','cliente','CLI_ID')]
    property cliente: Tcliente read Fcliente_0 write Fcliente_0;

    [Association(OneToOne,'PRG_ID','programa','PRG_ID')]
    property programa: Tprograma read Fprograma_1 write Fprograma_1;

  end;

implementation

constructor Tprograma_cliente.Create;
begin
  Fcliente_0 := Tcliente.Create;
  Fprograma_1 := Tprograma.Create;
end;

destructor Tprograma_cliente.Destroy;
begin
  if Assigned(Fcliente_0) then
    Fcliente_0.Free;

  if Assigned(Fprograma_1) then
    Fprograma_1.Free;

  inherited;
end;

initialization

  TRegisterClass.RegisterEntity(Tprograma_cliente)

end.
