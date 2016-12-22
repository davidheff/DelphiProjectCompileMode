unit Main;

interface

implementation

uses
  Windows, ToolsAPI;

type
  TOTACompileNotifier = class(TInterfacedObject, IOTACompileNotifier)
  protected
    procedure ProjectCompileStarted(const Project: IOTAProject; Mode: TOTACompileMode);
    procedure ProjectCompileFinished(const Project: IOTAProject; Result: TOTACompileResult);
    procedure ProjectGroupCompileStarted(Mode: TOTACompileMode);
    procedure ProjectGroupCompileFinished(Result: TOTACompileResult);
  end;

{ TOTACompileNotifier }

const
  SDelphiProjectCompileMode = 'DelphiProjectCompileMode';

procedure TOTACompileNotifier.ProjectCompileStarted(const Project: IOTAProject; Mode: TOTACompileMode);
var
  Value: string;
begin
  case Mode of
  cmOTAMake:
    Value := 'Make';
  cmOTABuild:
    Value := 'Build';
  cmOTACheck:
    Value := 'Check';
  cmOTAMakeUnit:
    Value := 'MakeUnit';
  else
    Value := 'Unrecognised';
  end;
  SetEnvironmentVariable(SDelphiProjectCompileMode, PChar(Value));
end;

procedure TOTACompileNotifier.ProjectCompileFinished(const Project: IOTAProject; Result: TOTACompileResult);
begin
  SetEnvironmentVariable(SDelphiProjectCompileMode, nil);
end;

procedure TOTACompileNotifier.ProjectGroupCompileFinished(Result: TOTACompileResult);
begin
end;

procedure TOTACompileNotifier.ProjectGroupCompileStarted(Mode: TOTACompileMode);
begin
end;

var
  NotifierIndex: Integer;

initialization
  NotifierIndex := (BorlandIDEServices as IOTACompileServices).AddNotifier(
    TOTACompileNotifier.Create
  );

finalization
  (BorlandIDEServices as IOTACompileServices).RemoveNotifier(
    NotifierIndex
  );

end.
