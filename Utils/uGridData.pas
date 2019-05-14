unit uGridData;

interface

uses
  FMX.Grid;

type
  TGridDataObject = class
  private
    FColumn: Integer;
    [Weak] FOwner: TCustomGrid;
  public
    property Owner: TCustomGrid read FOwner;
    property Column: Integer read FColumn;
  end;

implementation

end.
