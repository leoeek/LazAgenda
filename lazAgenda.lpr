program lazAgenda;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, UPrincipal, udmConexao;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmConexao, dmConexao);
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.

