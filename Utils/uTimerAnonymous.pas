unit uTimerAnonymous;

interface

uses
  FMX.Types, System.SysUtils;

type
  TTimerAnonimo = class helper for TTimer
    class function CreateAnonymousTimer(proc: TProc; primeiroIntervalo: integer;
      intervalo: integer = 0): TTimer; overload;
    class function CreateAnonymousTimer(func: TFunc<Boolean>;
      primeiroIntervalo: integer; intervalo: integer = 0): TTimer; overload;
  end;

implementation

uses
  System.Classes, FMX.Forms;

type
  TTimerExtended = class(TTimer)
  private
    FProc: TProc;
    FFunc: TFunc<Boolean>;
    FIntervaloAfter: integer;
    procedure DoTimer(sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  { TTimerAnonimo }

class function TTimerAnonimo.CreateAnonymousTimer(func: TFunc<Boolean>;
  primeiroIntervalo: integer; intervalo: integer = 0): TTimer;
var
  timer: TTimerExtended;
begin
  timer := TTimerExtended.Create(application);
  timer.FFunc := func;
  timer.FIntervaloAfter := intervalo;
  timer.Interval := primeiroIntervalo;
  timer.Enabled := true;
  Result := timer;
end;

class function TTimerAnonimo.CreateAnonymousTimer(proc: TProc;
  primeiroIntervalo: integer; intervalo: integer = 0): TTimer;
var
  timer: TTimerExtended;
begin
  timer := TTimerExtended.Create(application);
  timer.FProc := proc;
  timer.FIntervaloAfter := intervalo;
  timer.Interval := primeiroIntervalo;
  timer.Enabled := true;
  Result := timer;
end;

{ TTimerExtended }

constructor TTimerExtended.Create(AOwner: TComponent);
begin
  inherited;
  FIntervaloAfter := 1000;
  OnTimer := DoTimer;
end;

procedure TTimerExtended.DoTimer(sender: TObject);
var
  OldEnabled: Boolean;
  Parado: Boolean;
begin
  OldEnabled := Enabled;

  try
    Enabled := false;
    try

      if Assigned(FProc) then
        FProc
      else if Assigned(FFunc) then
      begin
        Parado := FFunc;
        if Parado then
          FIntervaloAfter := 0;
      end;

    except
    end;

    if FIntervaloAfter <= 0 then
      self.Free
    else
      Interval := FIntervaloAfter;

  finally
    Enabled := OldEnabled and (FIntervaloAfter > 0);
  end;
end;

end.
