unit TaskSegura;

interface

uses
  System.SysUtils,
  System.Threading;

type

  TAction<T> = reference to procedure(const arg: T);


  TTaskContinuationOptions = (
    NotOnCompleted,
    NotOnFaulted,
    NotOnCanceled,
    OnlyOnCompleted,
    OnlyOnFaulted,
    OnlyOnCanceled
  );

  {
    Interface que implementa os métodos para a TaskSegura

    GetExceptObj = Retorna obj da Exception
    GetStatus = Retorna o status da Task
    ContinueWith = Método que faz uma ação para corrigir uma exception seguindo uma opção de continuação
  }
  ITaskSegura = interface(ITask)
    ['{A518AB32-1242-4B39-A410-4D23CB643B83}']
    function GetExceptObj: Exception;
    function GetStatus: TTaskStatus;
    function ContinueWith(const ContinuationAction: TAction<ITaskSegura>;
      continuationOptions: TTaskContinuationOptions):ITaskSegura;
    property ExceptObj: Exception read GetExceptObj;
  end;

  TTaskSegura = class(TTask, ITaskSegura)
  private
     FExceptObj: Exception;
     function GetExceptObj: Exception;
  public
    destructor Destroy; override;
    function ContinueWith(const ContinuationAction: TAction<ITaskSegura>;
      continuationOptions: TTaskContinuationOptions):ITaskSegura;
    property ExceptObj: Exception read GetExceptObj;
    class function Run(const action: TProc): ITaskSegura; static;
  end;


implementation

uses
  System.Classes;

{ TaskSegura }

function TTaskSegura.ContinueWith(
  const ContinuationAction: TAction<ITaskSegura>;
  continuationOptions: TTaskContinuationOptions): ITaskSegura;
begin
  Result:= TTaskSegura.Run(
  procedure
  var
    task: ITaskSegura;
    doContinue: Boolean;
  begin
    task:= self;

    //verifica se já está completa essa task
    if not IsComplete then
      DoneEvent.WaitFor();

    //pega o obj de exception da task
    FExceptObj:= GetExceptionObject();

    //define as opções pra conitnuar a task
    case continuationOptions of
      NotOnCompleted:  doContinue := GetStatus <> TTaskStatus.Completed;
      NotOnFaulted:    doContinue := GetStatus <> TTaskStatus.Exception;
      NotOnCanceled:   doContinue := GetStatus <> TTaskStatus.Canceled;
      OnlyOnCompleted: doContinue := GetStatus = TTaskStatus.Completed;
      OnlyOnFaulted:   doContinue := GetStatus = TTaskStatus.Exception;
      OnlyOnCanceled:  doContinue := GetStatus = TTaskStatus.Canceled;

      else
        doContinue:= false;
    end;

    //caso continue executara a task
    if doContinue then
      ContinuationAction(task);
  end);
end;

destructor TTaskSegura.Destroy;
begin
  FExceptObj.Free;
  inherited;
end;

function TTaskSegura.GetExceptObj: Exception;
begin
  result:= FExceptObj;
end;


class function TTaskSegura.Run(const action: TProc): ITaskSegura;
var
  task: TTaskSegura;
begin
  task := TTaskSegura.Create(nil, TNotifyEvent(nil), action, TThreadPool.Default, nil);
  result:= task.Start as ITaskSegura;
end;

end.
