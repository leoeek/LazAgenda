unit UPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Calendar,
  StdCtrls, Buttons, ComCtrls, DbCtrls, ExtCtrls, DBGrids, Grids, Menus,
  PopupNotifier, types, db;

type

  { TFPrincipal }

  TFPrincipal = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    btCancelarTarefa: TBitBtn;
    btConcluirTarefa: TBitBtn;
    btSalvarNotas: TBitBtn;
    btIncluirTarefa: TBitBtn;
    btSavlarTarefa: TBitBtn;
    calendario: TCalendar;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBGrid1: TDBGrid;
    DBMemo1: TDBMemo;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbSemana: TLabel;
    lbHora: TLabel;
    lbDia: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    pCadastroTarefa: TPanel;
    pg: TPageControl;
    popApp: TPopupMenu;
    notificacao: TPopupNotifier;
    Shape1: TShape;
    tabNotas: TTabSheet;
    tabTarefas: TTabSheet;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    procedure BitBtn1Click(Sender: TObject);
    procedure btCancelarTarefaClick(Sender: TObject);
    procedure btConcluirTarefaClick(Sender: TObject);
    procedure btIncluirTarefaClick(Sender: TObject);
    procedure btSalvarNotasClick(Sender: TObject);
    procedure btSavlarTarefaClick(Sender: TObject);
    procedure calendarioClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBMemo1Change(Sender: TObject);
    procedure DBMemo1Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure tabTarefasShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure getNotas;
    procedure getSemana;
    procedure getAgenda;
  end; 

var
  FPrincipal: TFPrincipal;

implementation

uses
  udmConexao;

{$R *.lfm}

{ TFPrincipal }

(*
  Salvando a nota;
*)
procedure TFPrincipal.btSalvarNotasClick(Sender: TObject);
begin
  //Verificando se esta em edição;
  if not (dmConexao.dsNotas.State in [dsBrowse, dsInactive]) then
  begin
    dmConexao.qryNotasdt.AsString := Calendario.Date;
    dmConexao.qryNotas.Post;
  end;
end;

(*
  Salvando a tarefa;
*)
procedure TFPrincipal.btSavlarTarefaClick(Sender: TObject);
begin
  //Verificando se esta em edição;
  if not (dmConexao.dsTarefas.State in [dsBrowse, dsInactive]) then
  begin
    dmConexao.qryTarefasdt.AsString        := Calendario.Date;
    dmConexao.qryTarefasconcluido.AsString := 'Não';
    dmConexao.qryTarefasalerta.AsString    := 'F';
    dmConexao.qryTarefas.Post;
  end;

  pCadastroTarefa.Visible := False;
end;

(*
  Selecionando a data no calendário;
*)
procedure TFPrincipal.calendarioClick(Sender: TObject);
begin
  getNotas;
  getSemana;
  getAgenda;
end;

procedure TFPrincipal.DBGrid1DblClick(Sender: TObject);
begin
  pCadastroTarefa.Visible := True;
  dmConexao.qryTarefas.Edit;
end;

(*
  Inclusão de tarefa;
*)
procedure TFPrincipal.btIncluirTarefaClick(Sender: TObject);
begin
  pCadastroTarefa.Top     := 346;  //Posicionando o panel na parte de baixo
  pCadastroTarefa.Visible := True;

  DBEdit1.SetFocus;

  //Colocando em inclusão a tabela de tarefas;
  dmConexao.qryTarefas.Append;
end;

(*
  Cancelando a inclusão
*)
procedure TFPrincipal.btCancelarTarefaClick(Sender: TObject);
begin
  dmConexao.qryTarefas.Cancel;

  pCadastroTarefa.Visible := False;
end;

(*
  Marcando/Desmarcando como concluído a tarefa
*)
procedure TFPrincipal.btConcluirTarefaClick(Sender: TObject);
begin
  if (dmConexao.qryTarefasid.AsInteger > 0) then
  begin
    dmConexao.qryTarefas.Edit;
    if (dmConexao.qryTarefasconcluido.AsString = 'Sim') then
      dmConexao.qryTarefasconcluido.AsString := 'Não'
    else
      dmConexao.qryTarefasconcluido.AsString := 'Sim';
    dmConexao.qryTarefas.Post;
  end;
end;

(*
  Escondendo a aplição no relógio;
*)
procedure TFPrincipal.BitBtn1Click(Sender: TObject);
begin
  FPrincipal.Hide;
end;

(*
  Quando o usuário digitar algo no memo, se a sua tabela ainda não estiver em edição;
*)
procedure TFPrincipal.DBMemo1Change(Sender: TObject);
begin
  if not (dmConexao.dsNotas.State in [dsBrowse, dsInactive]) then
  begin
    dmConexao.qryNotas.Edit;
  end;
end;

(*
  Editar a tabela ao entrar no memo de notas;
*)
procedure TFPrincipal.DBMemo1Enter(Sender: TObject);
begin
  dmConexao.qryNotas.Edit;
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  ShortDateFormat := 'dd/mm/yyyy';   //Definindo o padrão da data
  ShortTimeFormat := 'hh:mm:ss';     //Definindo o padrão da hora

  calendario.DateTime := Date;

  pg.ActivePage := tabNotas;

  getSemana; //Retornando a semana
  getNotas;  //Retornando as notas do dia
  getAgenda; //Retornando a agenda do dia
end;

(*
  Exibindo a aplicaçao pelo menu;
*)
procedure TFPrincipal.MenuItem1Click(Sender: TObject);
begin
  FPrincipal.Show;
end;

(*
  Finalizando a aplicação pelo menu;
*)
procedure TFPrincipal.MenuItem2Click(Sender: TObject);
begin
  Application.Terminate;
end;

(*
  Exibindo o tab de tarefas;
*)
procedure TFPrincipal.tabTarefasShow(Sender: TObject);
begin
  getAgenda;
end;


procedure TFPrincipal.Timer1Timer(Sender: TObject);
var
  linha: TBookmark;
begin
  lbHora.Caption := TimeToStr(Time);

  if not (dmConexao.qryTarefas.State in [dsBrowse, dsInactive]) then
    Exit;

  try
    linha := dmConexao.qryTarefas.GetBookmark;

    if (dmConexao.qryTarefas.Locate('hora', FormatDateTime('hh:mm', Time), [lopartialkey])) and (dmConexao.qryTarefasconcluido.AsString = 'Não') and (dmConexao.qryTarefasalerta.AsString = 'F') then
    begin
      notificacao.Text := dmConexao.qryTarefasdescricao.AsString;
      notificacao.ShowAtPos(50, 50);
      notificacao.Show;

      dmConexao.qryTarefas.Edit;
      dmConexao.qryTarefasalerta.AsString := 'T';
      dmConexao.qryTarefas.Post;
    end;

  finally
    dmConexao.qryTarefas.GotoBookmark(linha);
  end;
end;

procedure TFPrincipal.TrayIcon1Click(Sender: TObject);
begin
  FPrincipal.Show;
end;

(*
  Retorna todas as notas do dia;
*)
procedure TFPrincipal.getNotas;
begin
  with dmConexao do
  begin
    qryNotas.Close;
    qryNotas.ParamByName('dt').AsString := calendario.Date;
    qryNotas.Open;
  end;
end;

(*
  Retorna a semana;
*)
procedure TFPrincipal.getSemana;
var
  diaSemana: array[1..7] of String;
begin
  diaSemana[1] := 'Domingo';
  diaSemana[2] := 'Segunda';
  diaSemana[3] := 'Terça';
  diaSemana[4] := 'Quarta';
  diaSemana[5] := 'Quinta';
  diaSemana[6] := 'Sexta';
  diaSemana[7] := 'Sábado';

  lbSemana.Caption := diaSemana[DayOfWeek(calendario.DateTime)];
  lbDia.Caption    := FormatDateTime('dd', calendario.DateTime);
end;

(*
  Retorna a agenda do dia;
*)
procedure TFPrincipal.getAgenda;
begin
  with dmConexao do
  begin
    qryTarefas.Close;
    qryTarefas.ParamByName('dt').AsString := calendario.Date;
    qryTarefas.Open;
  end;
end;

end.











