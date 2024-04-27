unit udmConexao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb, db, FileUtil;

type

  { TdmConexao }

  TdmConexao = class(TDataModule)
    dsTarefas: TDatasource;
    dsNotas: TDatasource;
    Conexao: TSQLite3Connection;
    qryNotasdescricao: TMemoField;
    qryNotasdt: TStringField;
    qryNotasid: TLongintField;
    qryTarefas: TSQLQuery;
    qryNotas: TSQLQuery;
    qryTarefasalerta: TStringField;
    qryTarefasconcluido: TStringField;
    qryTarefasdescricao: TStringField;
    qryTarefasdt: TStringField;
    qryTarefashora: TStringField;
    qryTarefasid: TLongintField;
    Transacao: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure qryNotasAfterPost(DataSet: TDataSet);
    procedure qryCompromissodataChange(Sender: TField);
    procedure qryTarefasAfterPost(DataSet: TDataSet);
    procedure qryTarefasBeforeCancel(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  dmConexao: TdmConexao;

implementation

{$R *.lfm}

{ TdmConexao }

procedure TdmConexao.DataModuleCreate(Sender: TObject);
begin

end;

procedure TdmConexao.qryNotasAfterPost(DataSet: TDataSet);
begin
  try
    qryNotas.ApplyUpdates;
    if (Transacao.Active) then
    begin
      Transacao.CommitRetaining;
      //Transacao.Commit;
    end;
  except
    Transacao.Rollback;
  end;
end;

procedure TdmConexao.qryCompromissodataChange(Sender: TField);
begin

end;

procedure TdmConexao.qryTarefasAfterPost(DataSet: TDataSet);
begin
  try
    qryTarefas.ApplyUpdates;
    if (Transacao.Active) then
    begin
      Transacao.CommitRetaining;
      //Transacao.Commit;
    end;
  except
    Transacao.Rollback;
  end;
end;

procedure TdmConexao.qryTarefasBeforeCancel(DataSet: TDataSet);
begin

end;

end.

