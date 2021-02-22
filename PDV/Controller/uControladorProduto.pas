unit uControladorProduto;

interface

uses uProduto, SysUtils, Grids, Provider, DBClient, DB, uConexao, IBQuery;

type
  TControladorProduto = class(TObject)
  private
    DM: TDM;
    function gerarID: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Pesquisar(Chave: string; CD: TClientDataSet);
    procedure CarregarDados(Codigo: Integer; Produto: TProduto);
    procedure Excluir(Codigo: Integer);
    function Inserir(Produto: TProduto): Integer;
    procedure Alterar(Produto: TProduto);
  end;

implementation

{ TControladorProduto }

constructor TControladorProduto.Create;
begin
  DM := TDM.Create(nil);
end;

destructor TControladorProduto.Destroy;
begin
  FreeAndNil(DM);
  inherited;
end;

procedure TControladorProduto.Alterar(Produto: TProduto);
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
      SQL.Add(' UPDATE PRODUTOS SET              ');
      SQL.Add('    DESCRICAO = UPPER( :DESCR ),  ');
      SQL.Add('    PRECO =  :PRECO               ');
      SQL.Add(' WHERE (ID = :ID);                ');
      ParamByName('ID').AsInteger := Produto.ID;
      ParamByName('DESCR').AsString := Produto.Descricao;
      ParamByName('PRECO').AsCurrency := Produto.Preco;
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
          'Não foi possivel Alterar o Produto:' + sLineBreak + E.Message;
        raise Exception.Create(msgErro);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TControladorProduto.CarregarDados(Codigo: Integer; Produto: TProduto);
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
        SQL.Add('     ID,             ');
        SQL.Add('     DESCRICAO,      ');
        SQL.Add('     PRECO           ');
        SQL.Add(' FROM PRODUTOS       ');
        SQL.Add(' WHERE               ');
        SQL.Add('    (ID =  :ID)      ');
        SQL.Add(' ORDER BY ID;        ');
        ParamByName('ID').AsInteger := Codigo;
        Prepare;
        Open;
        First;
        Produto.ID := FieldByName('ID').AsInteger;
        Produto.Descricao := FieldByName('DESCRICAO').AsString;
        Produto.Preco := FieldByName('PRECO').AsCurrency;
      end;
    except
      on E: Exception do
      begin
        msgErro :=
          'Não foi possivel obter os dados do Produto:' + sLineBreak +
          E.Message;
        raise Exception.Create(msgErro);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TControladorProduto.Excluir(Codigo: Integer);
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
      SQL.Add(' DELETE FROM PRODUTOS WHERE (ID = :COD); ');
      ParamByName('COD').AsInteger := Codigo;
      Prepare;
      ExecSQL;
    end;
    DM.TransacaoCometer;
  finally
    FreeAndNil(Qry);
  end;
end;

function TControladorProduto.gerarID: Integer;
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
      SQL.Add('  SELECT (MAX(ID) + 1) AS PROXIMO FROM PRODUTOS;   ');
      Prepare;
      Open;
      Aux := FieldByName('PROXIMO').AsInteger;
    end;
  finally
    FreeAndNil(Qry);
  end;
  Result := Aux;
end;

function TControladorProduto.Inserir(Produto: TProduto): Integer;
var
  msgErro: string;
  Qry: TIBQuery;
begin
  DM.TransacaoIniciar;
  Qry := TIBQuery.Create(nil);
  try
    with Qry do
    begin
      Produto.ID := gerarID;
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' INSERT INTO PRODUTOS (  ');
      SQL.Add('   ID,                   ');
      SQL.Add('   DESCRICAO,            ');
      SQL.Add('   PRECO                 ');
      SQL.Add(' ) VALUES (              ');
      SQL.Add('   :ID,                  ');
      SQL.Add('   UPPER( :DESCR ),      ');
      SQL.Add('   :PRECO                ');
      SQL.Add(' );                      ');
      ParamByName('ID').AsInteger := Produto.ID;
      ParamByName('DESCR').AsString := Produto.Descricao;
      ParamByName('PRECO').AsCurrency := Produto.Preco;
    end;
    try
      Qry.Prepare;
      Qry.ExecSQL;
      // Qry.Transaction.Commit; //CommitRetain;
      DM.TransacaoCometer;
    except
      on E: Exception do
      begin
        DM.TransacaoReverter;
        msgErro := 'Não foi possivel Inserir o Produto:' + sLineBreak + E.Message;
        raise Exception.Create(msgErro);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
  Result := Produto.ID;
end;

procedure TControladorProduto.Pesquisar(Chave: string; CD: TClientDataSet);
var
  Produto: TProduto;
  Qry: TIBQuery;
begin
  Produto := TProduto.Create;
  Qry := TIBQuery.Create(nil);
  DM.TransacaoCometer;
  try
    with Qry do
    begin
      Close;
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' SELECT                                          ');
      SQL.Add('     ID,                                         ');
      SQL.Add('     DESCRICAO,                                  ');
      SQL.Add('     PRECO                                       ');
      SQL.Add(' FROM PRODUTOS                                   ');
      SQL.Add(' WHERE                                           ');
      SQL.Add('     (UPPER(DESCRICAO) LIKE UPPER(:DESCR)) OR    ');
      SQL.Add('     (ID = :ID)                                  ');
      SQL.Add(' ORDER BY ID;                                    ');
      ParamByName('DESCR').AsString := '%' + Chave + '%';
      ParamByName('ID').AsInteger := StrToIntDef(Chave, -1);
    end;
    Qry.Prepare;
    Qry.Open;
    Qry.DisableControls;
    Qry.Last;
    Qry.First;

    CD.Close;
    CD.FieldDefs.Clear;
    CD.FieldDefs.Add('ID', ftInteger);
    CD.FieldDefs.Add('DESCRICAO', ftString, 40);
    CD.FieldDefs.Add('PRECO', ftCurrency);
    CD.CreateDataSet;
    CD.Open;

    while (not(Qry.Eof)) do
    begin
      Produto.ID := Qry.FieldByName('ID').AsInteger;
      Produto.Descricao := Qry.FieldByName('DESCRICAO').AsString;
      Produto.Preco := Qry.FieldByName('PRECO').AsCurrency;

      CD.Append;
      CD.FieldByName('ID').AsInteger := Produto.ID;
      CD.FieldByName('DESCRICAO').AsString := Produto.Descricao;
      CD.FieldByName('PRECO').AsCurrency := Produto.Preco;
      CD.Post;

      Qry.Next;
    end;
    CD.First;
  finally
    FreeAndNil(Produto);
    FreeAndNil(Qry);
  end;
end;

end.
