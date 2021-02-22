unit uControladorItens;

interface

uses uItem, SysUtils, Grids, Provider, DBClient, DB, uConexao, IBQuery;

type
  TControladorItens = class(TObject)
  private
    DM: TDM;
    function GerarID: Integer;
    function ProdutoJaIncluso(PedidoID: Integer; ProdutoID: Integer): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function Inserir(Item: TItem): Integer;
    procedure Alterar(Item: TItem);
    procedure Pesquisar(PedidoID: Integer; CD: TClientDataSet);
    procedure Excluir(Codigo: Integer);
    procedure CarregarDados(Codigo: Integer; Item: TItem);
  end;

implementation

{ TControladorItens }

procedure TControladorItens.Alterar(Item: TItem);
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
      SQL.Add(' UPDATE ITENS SET                  ');
      SQL.Add('   QUANTIDADE = :QUANTIDADE,       ');
      SQL.Add('   VALORUNITARIO = :VALORUNITARIO, ');
      SQL.Add('   VALORDESCONTO = :VALORDESCONTO  ');
      SQL.Add(' WHERE                      ');
      SQL.Add('   (ID = :ID);              ');
      ParamByName('ID').AsInteger := Item.ID;
      ParamByName('QUANTIDADE').AsCurrency := Item.Quantidade;
      ParamByName('VALORUNITARIO').AsCurrency := Item.ValorUnitario;
      ParamByName('VALORDESCONTO').AsCurrency := Item.ValorDesconto;
      try
        Qry.Prepare;
        Qry.ExecSQL;
        DM.TransacaoCometer;
      except
        on E: Exception do
        begin
          DM.TransacaoReverter;
          msgErro :=
            'Não foi possivel Alterar O Item do Pedido:' + sLineBreak +
            E.Message;
          raise Exception.Create(msgErro);
        end;
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TControladorItens.CarregarDados(Codigo: Integer; Item: TItem);
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
        SQL.Add(' SELECT                       ');
        SQL.Add('   I.ID,                      ');
        SQL.Add('   I.PEDIDOID,                ');
        SQL.Add('   I.PRODUTOID,               ');
        SQL.Add('   P.DESCRICAO AS DESCRICAO,  ');
        SQL.Add('   I.QUANTIDADE,              ');
        SQL.Add('   I.VALORUNITARIO,           ');
        SQL.Add('   I.VALORDESCONTO,           ');
        SQL.Add('   I.VALORTOTAL               ');
        SQL.Add(' FROM                         ');
        SQL.Add('   ITENS I                    ');
        SQL.Add(' INNER JOIN PRODUTOS P        ');
        SQL.Add('   ON (I.PRODUTOID = P.ID)    ');
        SQL.Add(' WHERE                        ');
        SQL.Add('    (I.ID =  :COD)            ');
        SQL.Add(' ORDER BY ID;                 ');
        ParamByName('COD').AsInteger := Codigo;

        Prepare;
        Open;
        First;

        Item.ID := Qry.FieldByName('ID').AsInteger;
        Item.PedidoID := Qry.FieldByName('PEDIDOID').AsInteger;
        Item.ProdutoID := Qry.FieldByName('PRODUTOID').AsInteger;
        Item.Descricao := Qry.FieldByName('DESCRICAO').AsString;
        Item.Quantidade := Qry.FieldByName('QUANTIDADE').AsFloat;
        Item.ValorUnitario := Qry.FieldByName('VALORUNITARIO').AsCurrency;
        Item.ValorDesconto := Qry.FieldByName('VALORDESCONTO').AsCurrency;
        Item.ValorTotal := Qry.FieldByName('VALORTOTAL').AsCurrency;
      end;

    except
      on E: Exception do
      begin
        msgErro :=
          'Não foi possivel obter os dados do Item do Pedido:' + sLineBreak +
          E.Message;
        raise Exception.Create(msgErro);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

constructor TControladorItens.Create;
begin
  DM := TDM.Create(nil);
end;

destructor TControladorItens.Destroy;
begin
  FreeAndNil(DM);
  inherited;
end;

procedure TControladorItens.Excluir(Codigo: Integer);
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
      SQL.Add(' DELETE FROM ITENS WHERE (ID = :COD); ');
      ParamByName('COD').AsInteger := Codigo;
      Prepare;
      ExecSQL;
    end;
    DM.TransacaoCometer;
  finally
    FreeAndNil(Qry);
  end;
end;

function TControladorItens.GerarID: Integer;
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
      SQL.Add('  SELECT (MAX(ID) + 1) AS PROXIMO FROM ITENS;   ');
      Prepare;
      Open;
      Aux := FieldByName('PROXIMO').AsInteger;
    end;
  finally
    FreeAndNil(Qry);
  end;
  Result := Aux;
end;

function TControladorItens.Inserir(Item: TItem): Integer;
var
  msgErro: string;
  Qry: TIBQuery;
  TemNoPedido: Boolean;
begin
  DM.TransacaoIniciar;
  Qry := TIBQuery.Create(nil);
  try
    with Qry do
    begin
      Database := DM.Banco;
      TemNoPedido := ProdutoJaIncluso(Item.PedidoID, Item.ProdutoID);
      if (TemNoPedido) then
      begin
        SQL.Clear;
        SQL.Add(' UPDATE ITENS SET                  ');
        SQL.Add('   QUANTIDADE = QUANTIDADE + :QTDE, ');
        SQL.Add('   VALORDESCONTO = :DESCONTO       ');
        SQL.Add(' WHERE                             ');
        SQL.Add('   (PEDIDOID = :PEDIDOID) AND      ');
        SQL.Add('   (PRODUTOID = :PRODUTOID)        ');
        SQL.Add(' ;                                 ');
        ParamByName('PEDIDOID').AsInteger := Item.PedidoID;
        ParamByName('PRODUTOID').AsInteger := Item.ProdutoID;
        ParamByName('QTDE').AsCurrency := Item.Quantidade;
        ParamByName('DESCONTO').AsCurrency := Item.ValorDesconto;
      end
      else
      begin
        Item.ID := GerarID;
        SQL.Clear;
        SQL.Add(' INSERT INTO ITENS (        ');
        SQL.Add('   ID,                      ');
        SQL.Add('   PEDIDOID,                ');
        SQL.Add('   PRODUTOID,               ');
        SQL.Add('   QUANTIDADE,              ');
        SQL.Add('   VALORUNITARIO,           ');
        SQL.Add('   VALORDESCONTO            ');
        SQL.Add(' ) VALUES (                 ');
        SQL.Add('   :ID,                     ');
        SQL.Add('   :PEDIDOID,               ');
        SQL.Add('   :PRODUTOID,              ');
        SQL.Add('   :QUANTIDADE,             ');
        SQL.Add('   :VALORUNITARIO,          ');
        SQL.Add('   :VALORDESCONTO           ');
        SQL.Add(' );                         ');
        ParamByName('ID').AsInteger := Item.ID;
        ParamByName('PEDIDOID').AsInteger := Item.PedidoID;
        ParamByName('PRODUTOID').AsInteger := Item.ProdutoID;
        ParamByName('QUANTIDADE').AsCurrency := Item.Quantidade;
        ParamByName('VALORUNITARIO').AsCurrency := Item.ValorUnitario;
        ParamByName('VALORDESCONTO').AsCurrency := Item.ValorDesconto;
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
            'Não foi possivel Inserir O Item ao Pedido:' + sLineBreak +
            E.Message;
          raise Exception.Create(msgErro);
        end;
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
  Result := Item.ID;
end;

procedure TControladorItens.Pesquisar(PedidoID: Integer; CD: TClientDataSet);
var
  Item: TItem;
  Qry: TIBQuery;
  NroItem: Integer;
begin
  Item := TItem.Create;
  Qry := TIBQuery.Create(nil);
  DM.TransacaoCometer;
  try
    with Qry do
    begin
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' SELECT                       ');
      SQL.Add('   I.ID,                      ');
      SQL.Add('   I.PEDIDOID,                ');
      SQL.Add('   I.PRODUTOID,               ');
      SQL.Add('   P.DESCRICAO AS DESCRICAO,  ');
      SQL.Add('   I.QUANTIDADE,              ');
      SQL.Add('   I.VALORUNITARIO,           ');
      SQL.Add('   I.VALORDESCONTO,           ');
      SQL.Add('   I.VALORTOTAL               ');
      SQL.Add(' FROM                         ');
      SQL.Add('   ITENS I                    ');
      SQL.Add(' INNER JOIN PRODUTOS P        ');
      SQL.Add('   ON (I.PRODUTOID = P.ID)    ');
      SQL.Add(' WHERE                        ');
      SQL.Add('   ( I.PEDIDOID = :PEDIDOID ) ');
      SQL.Add(' ORDER BY ID;                 ');
      ParamByName('PEDIDOID').AsInteger := PedidoID;
    end;
    Qry.Prepare;
    Qry.Open;
    Qry.DisableControls;
    Qry.Last;
    Qry.First;

    CD.Close;
    CD.FieldDefs.Clear;
    CD.FieldDefs.Add('ID', ftInteger);
    CD.FieldDefs.Add('NROITEM', ftInteger);
    CD.FieldDefs.Add('PRODUTOID', ftInteger);
    CD.FieldDefs.Add('DESCRICAO', ftString, 30);
    CD.FieldDefs.Add('QUANTIDADE', ftFloat);
    CD.FieldDefs.Add('VALORUNITARIO', ftCurrency);
    CD.FieldDefs.Add('VALORDESCONTO', ftCurrency);
    CD.FieldDefs.Add('VALORTOTAL', ftCurrency);
    CD.CreateDataSet;
    CD.Open;

    NroItem := 1;
    while (not(Qry.Eof)) do
    begin
      Item.ID := Qry.FieldByName('ID').AsInteger;
      Item.PedidoID := Qry.FieldByName('PEDIDOID').AsInteger;
      Item.ProdutoID := Qry.FieldByName('PRODUTOID').AsInteger;
      Item.Descricao := Qry.FieldByName('DESCRICAO').AsString;
      Item.Quantidade := Qry.FieldByName('QUANTIDADE').AsFloat;
      Item.ValorUnitario := Qry.FieldByName('VALORUNITARIO').AsCurrency;
      Item.ValorDesconto := Qry.FieldByName('VALORDESCONTO').AsCurrency;
      Item.ValorTotal := Qry.FieldByName('VALORTOTAL').AsCurrency;

      CD.Append;
      CD.FieldByName('ID').AsInteger := Item.ID;
      CD.FieldByName('ID').Visible := False;
      CD.FieldByName('NROITEM').AsInteger := NroItem;
      CD.FieldByName('NROITEM').DisplayLabel := 'N° Item';
      CD.FieldByName('PRODUTOID').AsInteger := Item.ProdutoID;
      CD.FieldByName('PRODUTOID').Visible := False;
      CD.FieldByName('DESCRICAO').AsString := Item.Descricao;
      CD.FieldByName('QUANTIDADE').AsFloat := Item.Quantidade;
      CD.FieldByName('VALORUNITARIO').AsCurrency := Item.ValorUnitario;
      CD.FieldByName('VALORDESCONTO').AsCurrency := Item.ValorDesconto;
      CD.FieldByName('VALORTOTAL').AsCurrency := Item.ValorTotal;
      CD.Post;
      Inc(NroItem);

      Qry.Next;
    end;
    CD.First;
  finally
    FreeAndNil(Qry);
    FreeAndNil(Item);
  end;
end;

function TControladorItens.ProdutoJaIncluso(PedidoID: Integer;
  ProdutoID: Integer): Boolean;
var
  Qry: TIBQuery;
begin
  Qry := TIBQuery.Create(nil);
  try
    DM.TransacaoCometer;
    with Qry do
    begin
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' SELECT                      ');
      SQL.Add('    COUNT(ID) AS TEMNOPEDIDO ');
      SQL.Add(' FROM                        ');
      SQL.Add('    ITENS                    ');
      SQL.Add(' WHERE (                     ');
      SQL.Add('   (PEDIDOID = :PED) AND     ');
      SQL.Add('   (PRODUTOID = :PROD)       ');
      SQL.Add(' );                          ');
      ParamByName('PED').AsInteger := PedidoID;
      ParamByName('PROD').AsInteger := ProdutoID;
      Prepare;
      Open;
      Result := (FieldByName('TEMNOPEDIDO').AsInteger > 0);
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

end.
