unit uControladorVendedor;

interface

uses SysUtils, uConexao, uVendedor, Provider, DBClient, DB, IBQuery;

type
  TControladorVendedor = class(TObject)
  private
    DM: TDM;
    function GerarID: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Pesquisar(Chave: string; CD: TClientDataSet);
    procedure CarregarDados(Codigo: Integer; Vendedor: TVendedor);
    procedure Excluir(Codigo: Integer);
    function Inserir(Vendedor: TVendedor): Integer;
    procedure Alterar(Vendedor: TVendedor);
  end;

implementation

{ TControladorVendedor }

procedure TControladorVendedor.Alterar(Vendedor: TVendedor);
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
      SQL.Add(' UPDATE VENDEDORES SET                   ');
      SQL.Add('    NOME = UPPER( :NOME )             ');
      SQL.Add(' WHERE (ID = :ID);                     ');
      ParamByName('ID').AsInteger := Vendedor.ID;
      ParamByName('NOME').AsString := Vendedor.Nome;
    end;
    try
      Qry.Prepare;
      Qry.ExecSQL;
      DM.TransacaoCometer;
    except
      on E: Exception do
      begin
        DM.TransacaoReverter;
        msgErro := 'Não foi possivel Alterar o Cliente:' + sLineBreak + E.Message;
        raise Exception.Create(msgErro);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TControladorVendedor.CarregarDados(Codigo: Integer;
  Vendedor: TVendedor);
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
        SQL.Add('   NOME              ');
        SQL.Add(' FROM VENDEDORES     ');
        SQL.Add(' WHERE               ');
        SQL.Add('    (ID =  :ID)      ');
        SQL.Add(' ORDER BY ID;        ');
        ParamByName('ID').AsInteger := Codigo;
        Prepare;
        Open;
        First;
        Vendedor.ID := FieldByName('ID').AsInteger;
        Vendedor.Nome := FieldByName('NOME').AsString;
      end;
    except
      on E: Exception do
      begin
        msgErro :=
          'Não foi possivel obter os dados do Vendedor:' + sLineBreak +
          E.Message;
        raise Exception.Create(msgErro);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

constructor TControladorVendedor.Create;
begin
  DM := TDM.Create(nil);
end;

destructor TControladorVendedor.Destroy;
begin
  FreeAndNil(DM);
  inherited;
end;

procedure TControladorVendedor.Excluir(Codigo: Integer);
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
      SQL.Add(' DELETE FROM VENDEDORES WHERE (ID = :COD); ');
      ParamByName('COD').AsInteger := Codigo;
      Prepare;
      ExecSQL;
    end;
    DM.TransacaoCometer;
  finally
    FreeAndNil(Qry);
  end;
end;

function TControladorVendedor.GerarID: Integer;
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
      SQL.Add('  SELECT (MAX(ID) + 1) AS PROXIMO FROM VENDEDORES;   ');
      Prepare;
      Open;
      Aux := FieldByName('PROXIMO').AsInteger;
    end;
  finally
    FreeAndNil(Qry);
  end;
  Result := Aux;
end;

function TControladorVendedor.Inserir(Vendedor: TVendedor): Integer;
var
  msgErro: string;
  Qry: TIBQuery;
begin
  DM.TransacaoIniciar;
  Qry := TIBQuery.Create(nil);
  try
    with Qry do
    begin
      Vendedor.ID := GerarID;
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' INSERT INTO VENDEDORES ( ');
      SQL.Add('   ID, ');
      SQL.Add('   NOME ');
      SQL.Add(' ) VALUES ( ');
      SQL.Add('   :ID, ');
      SQL.Add('   UPPER( :NOME ) ');
      SQL.Add(' ); ');
      ParamByName('ID').AsInteger := Vendedor.ID;
      ParamByName('NOME').AsString := Vendedor.Nome;
    end;
    try
      Qry.Prepare;
      Qry.ExecSQL;
      DM.TransacaoCometer;
    except
      on E: Exception do
      begin
        DM.TransacaoReverter;
        msgErro := 'Não foi possivel Inserir Vendedor:' + sLineBreak + E.Message;
        raise Exception.Create(msgErro);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
  Result := Vendedor.ID;
end;

procedure TControladorVendedor.Pesquisar(Chave: string; CD: TClientDataSet);
var
  Vendedor: TVendedor;
  Qry: TIBQuery;
begin
  Vendedor := TVendedor.Create;
  Qry := TIBQuery.Create(nil);
  try
    DM.TransacaoCometer;
    with Qry do
    begin
      Close;
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' SELECT                                  ');
      SQL.Add('    ID,                                  ');
      SQL.Add('    NOME                                 ');
      SQL.Add(' FROM VENDEDORES                         ');
      SQL.Add(' WHERE                                   ');
      SQL.Add('   (UPPER(NOME) LIKE  UPPER(:NOME)) OR   ');
      SQL.Add('   (ID =  :ID)                           ');
      SQL.Add(' ORDER BY ID;                            ');
      ParamByName('NOME').AsString := '%' + Chave + '%';
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
    CD.CreateDataSet;
    CD.Open;

    while (not(Qry.Eof)) do
    begin
      Vendedor.ID := Qry.FieldByName('ID').AsInteger;
      Vendedor.Nome := Qry.FieldByName('NOME').AsString;

      CD.Append;
      CD.FieldByName('ID').AsInteger := Vendedor.ID;
      CD.FieldByName('NOME').AsString := Vendedor.Nome;
      CD.Post;

      Qry.Next;
    end;
    CD.First;
  finally
    FreeAndNil(Vendedor);
    FreeAndNil(Qry);
  end;
end;

end.
