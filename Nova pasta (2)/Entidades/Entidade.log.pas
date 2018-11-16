unit Entidade.log;

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
  [Table('log', '')]
  [PrimaryKey('LOG_ID', NotInc, NoSort, False, 'Chave primária')]
  Tlog = class
  private
    { Private declarations } 
    FLOG_ID: Nullable<Integer>;
    FLOG_DATAHORA: Nullable<TDateTime>;
    FLOG_INFORMACOES: TBlob;
  public 
    { Public declarations } 
    [Column('LOG_ID', ftInteger)]
    [Dictionary('LOG_ID', 'Mensagem de validação', '', '', '', taCenter)]
    property LOG_ID: Nullable<Integer> read FLOG_ID write FLOG_ID;

    [Column('LOG_DATAHORA', ftDateTime)]
    [Dictionary('LOG_DATAHORA', 'Mensagem de validação', '', '', '', taCenter)]
    property LOG_DATAHORA: Nullable<TDateTime> read FLOG_DATAHORA write FLOG_DATAHORA;

    [Restrictions([NotNull])]
    [Column('LOG_INFORMACOES', ftBlob)]
    [Dictionary('LOG_INFORMACOES', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property LOG_INFORMACOES: TBlob read FLOG_INFORMACOES write FLOG_INFORMACOES;
  end;

implementation

initialization

  TRegisterClass.RegisterEntity(Tlog)

end.
