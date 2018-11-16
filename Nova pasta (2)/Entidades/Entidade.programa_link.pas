unit Entidade.programa_link;

interface

uses
  DB, 
  Classes, 
  SysUtils, 
  Generics.Collections, 

  /// orm 
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
  [Table('programa_link', '')]
  [PrimaryKey('PRG_LINK_ID', NotInc, NoSort, False, 'Chave primária')]
  Tprograma_link = class
  private
    { Private declarations } 
    FPRG_LINK_ID: Nullable<Integer>;
    FPRG_LINK: String;
    FPRG_ID: Integer;

    Fprograma_0:  Tprograma  ;
  public 
    { Public declarations } 
    constructor Create;
    destructor Destroy; override;
    [Column('PRG_LINK_ID', ftInteger)]
    [Dictionary('PRG_LINK_ID', 'Mensagem de validação', '', '', '', taCenter)]
    property PRG_LINK_ID: Nullable<Integer> read FPRG_LINK_ID write FPRG_LINK_ID;

    [Restrictions([NotNull])]
    [Column('PRG_LINK', ftString, 255)]
    [Dictionary('PRG_LINK', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property PRG_LINK: String read FPRG_LINK write FPRG_LINK;

    [Restrictions([NotNull])]
    [Column('PRG_ID', ftInteger)]
    [ForeignKey('programa_link_ibfk_1', 'PRG_ID', 'programa', 'PRG_ID', SetNull, SetNull)]
    [Dictionary('PRG_ID', 'Mensagem de validação', '', '', '', taCenter)]
    property PRG_ID: Integer read FPRG_ID write FPRG_ID;

    [Association(OneToOne,'PRG_ID','programa','PRG_ID')]
    property programa: Tprograma read Fprograma_0 write Fprograma_0;

  end;

implementation

constructor Tprograma_link.Create;
begin
  Fprograma_0 := Tprograma.Create;
end;

destructor Tprograma_link.Destroy;
begin
  if Assigned(Fprograma_0) then
    Fprograma_0.Free;

  inherited;
end;

initialization

  TRegisterClass.RegisterEntity(Tprograma_link)

end.
