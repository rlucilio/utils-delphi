unit Entidade.programa;

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
  [Table('programa', '')]
  [PrimaryKey('PRG_ID', NotInc, NoSort, False, 'Chave primária')]
  Tprograma = class
  private
    { Private declarations } 
    FPRG_ID: Nullable<Integer>;
    FPRG_NOME: String;
    FPRG_DATA: TDateTime;
    FPRG_DESCRICAO: TBlob;
    FPRG_INFOATUALIZACAO: TBlob;
  public 
    { Public declarations } 
    [Column('PRG_ID', ftInteger)]
    [Dictionary('PRG_ID', 'Mensagem de validação', '', '', '', taCenter)]
    property PRG_ID: Nullable<Integer> read FPRG_ID write FPRG_ID;

    [Restrictions([NotNull])]
    [Column('PRG_NOME', ftString, 255)]
    [Dictionary('PRG_NOME', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property PRG_NOME: String read FPRG_NOME write FPRG_NOME;

    [Restrictions([NotNull])]
    [Column('PRG_DATA', ftDateTime)]
    [Dictionary('PRG_DATA', 'Mensagem de validação', 'Date', '', '!##/##/####;1;_', taCenter)]
    property PRG_DATA: TDateTime read FPRG_DATA write FPRG_DATA;

    [Column('PRG_DESCRICAO', ftBlob)]
    [Dictionary('PRG_DESCRICAO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property PRG_DESCRICAO: TBlob read FPRG_DESCRICAO write FPRG_DESCRICAO;

    [Column('PRG_INFOATUALIZACAO', ftBlob)]
    [Dictionary('PRG_INFOATUALIZACAO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property PRG_INFOATUALIZACAO: TBlob read FPRG_INFOATUALIZACAO write FPRG_INFOATUALIZACAO;
  end;

implementation

initialization

  TRegisterClass.RegisterEntity(Tprograma)

end.
