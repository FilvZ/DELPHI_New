program P_2048;

uses
  Forms,
  p_main in 'p_main.pas' {f_main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tf_main, f_main);
  Application.Run;
end.
