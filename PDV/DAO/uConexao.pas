unit uConexao;

interface

uses
  SysUtils, Classes, DB, IBDatabase, IBCustomDataSet, IBQuery;

type
  TDM = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    FBanco: TIBDatabase;
    FTransacao: TIBTransaction;
  public
    procedure AbrirBanco;
    procedure TransacaoIniciar;
    procedure TransacaoCometer;
    procedure TransacaoReverter;
    function Banco: TIBDatabase;
    function Transacao: TIBTransaction;
  end;

var
  DM: TDM;

implementation

{$R *.dfm}
{ TDataModule1 }

procedure TDM.AbrirBanco;
var
  Caminho: string;
begin
  Caminho := ExpandFileName(GetCurrentDir) + '\BANCO.FDB';
  if (Banco.Connected) then
  begin
    Banco.Close;
  end;
  Banco.Params.Add('user_name=SYSDBA');
  Banco.Params.Add('password=masterkey');
  Banco.Params.Add('lc_ctype=UTF8');
  Banco.DatabaseName := Caminho;
  Banco.LoginPrompt := False;
  Banco.DefaultTransaction := Transacao;
  Banco.Open;
end;

function TDM.Banco: TIBDatabase;
begin
  If (not Assigned(FBanco)) Then
  begin
    FBanco := TIBDatabase.Create(nil);
  end;
  Result := FBanco;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  AbrirBanco;
end;

function TDM.Transacao: TIBTransaction;
begin
  If (not Assigned(FTransacao)) Then
  begin
    FTransacao := TIBTransaction.Create(nil);
  end;
  Result := FTransacao;
end;

procedure TDM.TransacaoIniciar;
begin
  // Qry.SQL.Clear;
  // Qry.SQL.Add(' START TRANSACTION; ');
  // Qry.Prepare;
  // Qry.ExecSQL;
  if not Transacao.InTransaction then
  begin
    Transacao.StartTransaction;
  end;
end;

procedure TDM.TransacaoCometer;
begin
  // Qry.SQL.Clear;
  // Qry.SQL.Add(' COMMIT WORK; ');
  // Qry.Prepare;
  // Qry.ExecSQL;
  if Transacao.InTransaction then
  begin
    Transacao.Commit;
  end;
end;

procedure TDM.TransacaoReverter;
begin
  // Qry.SQL.Clear;
  // Qry.SQL.Add(' ROLLBACK; ');
  // Qry.Prepare;
  // Qry.ExecSQL;
  if Transacao.InTransaction then
  begin
    Transacao.Rollback;
  end;
end;

end.
