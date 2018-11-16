unit Entidade.programa_foto;

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
  [Table('programa_foto', '')]
  [PrimaryKey('PRG_FOTO_ID', NotInc, NoSort, False, 'Chave primária')]
  Tprograma_foto = class
  private
    { Private declarations } 
    FPRG_FOTO_ID: Nullable<Integer>;
    FPRG_FOTO: String;
    FPRG_ID: Integer;

    Fprograma_0:  Tprograma  ;
  public 
    { Public declarations } 
    constructor Create;
    destructor Destroy; override;
    [Column('PRG_FOTO_ID', ftInteger)]
    [Dictionary('PRG_FOTO_ID', 'Mensagem de validação', '', '', '', taCenter)]
    property PRG_FOTO_ID: Nullable<Integer> read FPRG_FOTO_ID write FPRG_FOTO_ID;

    [Restrictions([NotNull])]
    [Column('PRG_FOTO', ftString, 200)]
    [Dictionary('PRG_FOTO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property PRG_FOTO: String read FPRG_FOTO write FPRG_FOTO;

    [Restrictions([NotNull])]
    [Column('PRG_ID', ftInteger)]
    [ForeignKey('programa_foto_ibfk_1', 'PRG_ID', 'programa', 'PRG_ID', SetNull, SetNull)]
    [Dictionary('PRG_ID', 'Mensagem de validação', '', '', '', taCenter)]
    property PRG_ID: Integer read FPRG_ID write FPRG_ID;

    [Association(OneToOne,'PRG_ID','programa','PRG_ID')]
    property programa: Tprograma read Fprograma_0 write Fprograma_0;

  end;

implementation

constructor Tprograma_foto.Create;
begin
  Fprograma_0 := Tprograma.Create;
end;

destructor Tprograma_foto.Destroy;
begin
  if Assigned(Fprograma_0) then
    Fprograma_0.Free;

  inherited;
end;

initialization

  TRegisterClass.RegisterEntity(Tprograma_foto)

end.
