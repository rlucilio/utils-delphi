unit Entidade.cliente;

interface

uses
  DB, 
  Classes, 
  SysUtils, 
  Generics.Collections, 

  /// orm 
  ormbr.types.blob, 
  ormbr.types.lazy, 
  ormbr.types.mapping, 
  ormbr.types.nullable, 
  ormbr.mapping.classes, 
  ormbr.mapping.register, 
  ormbr.mapping.attributes; 

type
  [Entity]
  [Table('cliente', '')]
  [PrimaryKey('CLI_ID', NotInc, NoSort, False, 'Chave primária')]
  Tcliente = class
  private
    { Private declarations } 
    FCLI_ID: Nullable<Integer>;
    FCLI_IP: String;
    FCLI_CHAVE: String;
    FCLI_NOMEFANTASIA: String;
    FCLI_RESPONSAVEL: String;
  public 
    { Public declarations } 
    [Column('CLI_ID', ftInteger)]
    [Dictionary('CLI_ID', 'Mensagem de validação', '', '', '', taCenter)]
    property CLI_ID: Nullable<Integer> read FCLI_ID write FCLI_ID;

    [Restrictions([NotNull])]
    [Column('CLI_IP', ftString, 100)]
    [Dictionary('CLI_IP', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property CLI_IP: String read FCLI_IP write FCLI_IP;

    [Restrictions([NotNull])]
    [Column('CLI_CHAVE', ftString, 255)]
    [Dictionary('CLI_CHAVE', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property CLI_CHAVE: String read FCLI_CHAVE write FCLI_CHAVE;

    [Restrictions([NotNull])]
    [Column('CLI_NOMEFANTASIA', ftString, 255)]
    [Dictionary('CLI_NOMEFANTASIA', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property CLI_NOMEFANTASIA: String read FCLI_NOMEFANTASIA write FCLI_NOMEFANTASIA;

    [Restrictions([NotNull])]
    [Column('CLI_RESPONSAVEL', ftString, 255)]
    [Dictionary('CLI_RESPONSAVEL', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property CLI_RESPONSAVEL: String read FCLI_RESPONSAVEL write FCLI_RESPONSAVEL;
  end;

implementation

initialization

  TRegisterClass.RegisterEntity(Tcliente)

end.
