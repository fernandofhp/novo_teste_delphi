unit uControladorCliente;

interface

uses uCliente, SysUtils, Grids, Provider, DBClient, DB, uConexao, IBQuery;

type
  TControladorCliente = class(TObject)
  private
    DM: TDM;
    function GerarID: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Pesquisar(Chave: string; CD: TClientDataSet);
    procedure CarregarDados(Codigo: Integer; Cliente: TCliente);
    procedure Excluir(Codigo: Integer);
    function Inserir(Cliente: TCliente): Integer;
    procedure Alterar(Cliente: TCliente);
  end;

implementation

uses Dialogs, uPedido;

{ TConroladorCliente }

constructor TControladorCliente.Create;
begin
  DM := TDM.Create(nil);
end;

destructor TControladorCliente.Destroy;
begin
  FreeAndNil(DM);
  inherited;
end;

procedure TControladorCliente.Excluir(Codigo: Integer);
var
  Qry: TIBQuery;
begin
  Qry := TIBQuery.Create(nil);
  try
    DM.TransacaoIniciar;
    with Qry do
    begin
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' DELETE FROM CLIENTES WHERE (ID = :COD); ');
      ParamByName('COD').AsInteger := Codigo;
      Prepare;
      ExecSQL;
    end;
    DM.TransacaoCometer;
  finally
    FreeAndNil(Qry);
  end;
end;

function TControladorCliente.GerarID: Integer;
var
  Qry: TIBQuery;
  Aux: Integer;
begin
  Qry := TIBQuery.Create(nil);
  try
    DM.TransacaoCometer;
    with Qry do
    begin
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add('  SELECT (MAX(ID) + 1) AS PROXIMO FROM CLIENTES;   ');
      Prepare;
      Open;
      Aux := FieldByName('PROXIMO').AsInteger;
    end;
  finally
    FreeAndNil(Qry);
  end;
  Result := Aux;
end;

function TControladorCliente.Inserir(Cliente: TCliente): Integer;
var
  msgErro: string;
  Qry: TIBQuery;
begin
  DM.TransacaoIniciar;
  Qry := TIBQuery.Create(nil);
  try
    with Qry do
    begin
      Cliente.ID := GerarID;
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' INSERT INTO CLIENTES ( ');
      SQL.Add('   ID, ');
      SQL.Add('   NOME, ');
      SQL.Add('   EMAIL ');
      SQL.Add(' ) VALUES ( ');
      SQL.Add('   :ID, ');
      SQL.Add('   UPPER( :NOME), ');
      SQL.Add('   UPPER( :EMAIL) ');
      SQL.Add(' ); ');
      ParamByName('ID').AsInteger := Cliente.ID;
      ParamByName('NOME').AsString := Cliente.Nome;
      ParamByName('EMAIL').AsString := Cliente.Email;
    end;
    try
      Qry.Prepare;
      Qry.ExecSQL;
      DM.TransacaoCometer;
    except
      on E: Exception do
      begin
        DM.TransacaoReverter;
        msgErro := 'Não foi possivel Inserir Cliente:' + sLineBreak + E.Message;
        raise Exception.Create(msgErro);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
  Result := Cliente.ID;
end;



procedure TControladorCliente.Alterar(Cliente: TCliente);
var
  msgErro: string;
  Qry: TIBQuery;
begin
  DM.TransacaoIniciar;
  Qry := TIBQuery.Create(nil);
  try
    with Qry do
    begin
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' UPDATE CLIENTES SET                   ');
      SQL.Add('    NOME = UPPER( :NOME ),             ');
      SQL.Add('    EMAIL = UPPER( :EMAIL )            ');
      SQL.Add(' WHERE (ID = :ID);                     ');
      ParamByName('ID').AsInteger := Cliente.ID;
      ParamByName('NOME').AsString := Cliente.Nome;
      ParamByName('EMAIL').AsString := Cliente.Email;
    end;
    try
      Qry.Prepare;
      Qry.ExecSQL;
      DM.TransacaoCometer;
    except
      on E: Exception do
      begin
        DM.TransacaoReverter;
        msgErro :=
          'Não foi possivel Alterar o Cliente:' + sLineBreak + E.Message;
        raise Exception.Create(msgErro);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TControladorCliente.CarregarDados(Codigo: Integer; Cliente: TCliente);
var
  msgErro: string;
  Qry: TIBQuery;
begin
  Qry := TIBQuery.Create(nil);
  try
    try
      with Qry do
      begin
        Database := DM.Banco;
        SQL.Clear;
        SQL.Add(' SELECT              ');
        SQL.Add('   ID,               ');
        SQL.Add('   NOME,     ');
        SQL.Add('   EMAIL      ');
        SQL.Add(' FROM CLIENTES       ');
        SQL.Add(' WHERE               ');
        SQL.Add('    (ID =  :ID)      ');
        SQL.Add(' ORDER BY ID;        ');
        ParamByName('ID').AsInteger := Codigo;
        Prepare;
        Open;
        First;
        Cliente.ID := FieldByName('ID').AsInteger;
        Cliente.Nome := FieldByName('NOME').AsString;
        Cliente.Email := FieldByName('EMAIL').AsString;
      end;
    except
      on E: Exception do
      begin
        msgErro :=
          'Não foi possivel obter os dados do Cliente:' + sLineBreak +
          E.Message;
        raise Exception.Create(msgErro);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

// procedure TControladorCliente.Pesquisar(Chave: string; Qry: TIBQuery);
// begin
// try
// DM.Banco.Close;
// DM.Banco.Open;
// DM.TransacaoCometer;
// with Qry do
// begin
// if (Database = nil) then
// begin
// Database := DM.Banco;
// end;
// SQL.Clear;
// SQL.Add(' SELECT                                          ');
// SQL.Add('    ID,                                          ');
// SQL.Add('    NOMEFANTASIA,                                ');
// SQL.Add('    RAZAOSOCIAL,                                 ');
// SQL.Add('    CNPJ                                         ');
// SQL.Add(' FROM CLIENTES                                   ');
// SQL.Add(' WHERE                                           ');
// SQL.Add('    (UPPER(NOMEFANTASIA) LIKE  UPPER(:FANTA)) OR ');
// SQL.Add('    (UPPER(RAZAOSOCIAL) LIKE  UPPER(:RAZAO)) OR  ');
// SQL.Add('    (ID =  :ID)                                  ');
// SQL.Add(' ORDER BY ID;                                     ');
// ParamByName('FANTA').AsString := '%' + Chave + '%';
// ParamByName('RAZAO').AsString := '%' + Chave + '%';
// ParamByName('ID').AsInteger := StrToIntDef('0' + Chave, -1);
// Prepare;
// Open;
// end;
// except
// on E: Exception do
// begin
// raise Exception.Create('Erro:' + #13 + E.Message);
// end;
// end;
// end;

procedure TControladorCliente.Pesquisar(Chave: string; CD: TClientDataSet);
var
  Cliente: TCliente;
  Qry: TIBQuery;
begin
  Cliente := TCliente.Create;
  Qry := TIBQuery.Create(nil);
  try
    DM.TransacaoCometer;
    with Qry do
    begin
      Close;
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' SELECT  ');
      SQL.Add(' ID, ');
      SQL.Add(' NOME, ');
      SQL.Add(' EMAIL ');
      SQL.Add(' FROM CLIENTES ');
      SQL.Add(' WHERE   ');
      SQL.Add('  (UPPER(NOME) LIKE  UPPER(:NOME)) OR ');
      SQL.Add(' (UPPER(EMAIL) LIKE  UPPER(:EMAIL)) OR ');
      SQL.Add('    (ID =  :ID) ');
      SQL.Add(' ORDER BY ID ');
      SQL.Add(' ; ');
      ParamByName('NOME').AsString := '%' + Chave + '%';
      ParamByName('EMAIL').AsString := '%' + Chave + '%';
      ParamByName('ID').AsInteger := StrToIntDef('0' + Chave, -1);
    end;

    Qry.Prepare;
    Qry.Open;
    Qry.DisableControls;
    Qry.Last;
    Qry.First;

    CD.Close;
    CD.FieldDefs.Clear;
    CD.FieldDefs.Add('ID', ftInteger);
    CD.FieldDefs.Add('NOME', ftString, 50);
    CD.FieldDefs.Add('EMAIL', ftString, 50);
    CD.CreateDataSet;
    CD.Open;

    while (not(Qry.Eof)) do
    begin
      Cliente.ID := Qry.FieldByName('ID').AsInteger;
      Cliente.Nome := Qry.FieldByName('NOME').AsString;
      Cliente.Email := Qry.FieldByName('EMAIL').AsString;

      CD.Append;
      CD.FieldByName('ID').AsInteger := Cliente.ID;
      CD.FieldByName('NOME').AsString := Cliente.Nome;
      CD.FieldByName('EMAIL').AsString := Cliente.Email;
      CD.Post;

      Qry.Next;
    end;
    CD.First;
  finally
    FreeAndNil(Cliente);
    FreeAndNil(Qry);
  end;
end;

end.
