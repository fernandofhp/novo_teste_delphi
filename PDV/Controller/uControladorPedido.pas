unit uControladorPedido;

interface

uses uPedido, SysUtils, Grids, Provider, DBClient, DB, uConexao, IBQuery;

type
  TPesquisarPor = (porCliente, porPedido, porVendedor);

type
  TControladorPedido = class(TObject)
  private
    DM: TDM;
    FPesquisarPor: TPesquisarPor;
    FFim: TDate;
    FInicio: TDate;
    procedure SetPesquisarPor(const Value: TPesquisarPor);
    function GerarID: Integer;
    procedure SetFim(const Value: TDate);
    procedure SetInicio(const Value: TDate);
  public
    constructor Create;
    destructor Destroy; override;
    property PesquisarPor: TPesquisarPor read FPesquisarPor write
      SetPesquisarPor;
    property Inicio: TDate read FInicio write SetInicio;
    property Fim: TDate read FFim write SetFim;
    procedure Pesquisar(Chave: string; CD: TClientDataSet);
    procedure CarregarDados(Codigo: Integer; Pedido: TPedido);
    procedure Excluir(Codigo: Integer);
    function Inserir(Pedido: TPedido): Integer;
    procedure Alterar(Pedido: TPedido);
  end;

implementation

{ TControladorPedido }

procedure TControladorPedido.Alterar(Pedido: TPedido);
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
      SQL.Add(' UPDATE PEDIDOS SET                 ');
      SQL.Add('   DATAHORA = CURRENT_TIMESTAMP,    ');
      SQL.Add('   VENDEDORID = :VENDEDORID,        ');
      SQL.Add('   CLIENTEID = :CLIENTEID           ');
      SQL.Add(' WHERE                              ');
      SQL.Add('   (ID = :ID) ;                     ');
      ParamByName('ID').AsInteger := Pedido.ID;
      // ParamByName('DATAHORA').AsDateTime := Pedido.DataHora;
      ParamByName('VENDEDORID').AsInteger := Pedido.VendedorID;
      ParamByName('CLIENTEID').AsInteger := Pedido.ClienteID;
      try
        Qry.Prepare;
        Qry.ExecSQL;
        // Qry.Transaction.Commit; //CommitRetain;
        DM.TransacaoCometer;
      except
        on E: Exception do
        begin
          DM.TransacaoReverter;
          msgErro :=
            'Não foi possivel Alterar O Pedido:' + sLineBreak + E.Message;
          raise Exception.Create(msgErro);
        end;
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TControladorPedido.CarregarDados(Codigo: Integer; Pedido: TPedido);
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
        SQL.Add(' SELECT                            ');
        SQL.Add('    P.ID,                          ');
        SQL.Add('    P.CLIENTEID,                   ');
        SQL.Add('    P.VENDEDORID,                  ');
        SQL.Add('    P.DATAHORA,                    ');
        SQL.Add('    P.TOTALDESCONTO,               ');
        SQL.Add('    P.TOTALPEDIDO                  ');
        SQL.Add(' FROM PEDIDOS P                    ');
        SQL.Add(' WHERE                             ');
        SQL.Add('    (ID =  :ID)                    ');
        SQL.Add(' ORDER BY ID;                      ');
        ParamByName('ID').AsInteger := Codigo;

        Prepare;
        Open;
        First;

        Pedido.ID := FieldByName('ID').AsInteger;
        Pedido.ClienteID := FieldByName('CLIENTEID').AsInteger;
        Pedido.VendedorID := FieldByName('VENDEDORID').AsInteger;
        Pedido.DataHora := FieldByName('DATAHORA').AsDateTime;
        Pedido.TotalDesconto := FieldByName('TOTALDESCONTO').AsCurrency;
        Pedido.TotalPedido := FieldByName('TOTALPEDIDO').AsCurrency;
      end;

    except
      on E: Exception do
      begin
        msgErro :=
          'Não foi possivel obter os dados do Pedido:' + sLineBreak + E.Message;
        raise Exception.Create(msgErro);
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

constructor TControladorPedido.Create;
begin
  DM := TDM.Create(nil);
end;

destructor TControladorPedido.Destroy;
begin
  FreeAndNil(DM);
  inherited;
end;

procedure TControladorPedido.Excluir(Codigo: Integer);
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
      SQL.Add(' DELETE FROM PEDIDOS WHERE (ID = :COD); ');
      ParamByName('COD').AsInteger := Codigo;
      Prepare;
      ExecSQL;
    end;
    DM.TransacaoCometer;
  finally
    FreeAndNil(Qry);
  end;
end;

function TControladorPedido.GerarID: Integer;
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
      SQL.Add('  SELECT (MAX(ID) + 1) AS PROXIMO FROM PEDIDOS;   ');
      Prepare;
      Open;
      Aux := FieldByName('PROXIMO').AsInteger;
    end;
  finally
    FreeAndNil(Qry);
  end;
  Result := Aux;
end;

function TControladorPedido.Inserir(Pedido: TPedido): Integer;
var
  msgErro: string;
  Qry: TIBQuery;
begin
  DM.TransacaoIniciar;
  Qry := TIBQuery.Create(nil);
  try
    with Qry do
    begin
      Pedido.ID := GerarID;
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' INSERT INTO PEDIDOS (     ');
      SQL.Add('   ID,                     ');
      SQL.Add('   DATAHORA,               ');
      SQL.Add('   VENDEDORID,             ');
      SQL.Add('   CLIENTEID               ');
      SQL.Add(' ) VALUES (                ');
      SQL.Add('   :ID,                    ');
      SQL.Add('   CURRENT_TIMESTAMP,      ');
      SQL.Add('   :VENDEDORID,            ');
      SQL.Add('   :CLIENTEID              ');
      SQL.Add(' );                         ');
      ParamByName('ID').AsInteger := Pedido.ID;
      ParamByName('VENDEDORID').AsInteger := Pedido.VendedorID;
      ParamByName('CLIENTEID').AsInteger := Pedido.ClienteID;
      try
        Qry.Prepare;
        Qry.ExecSQL;
        DM.TransacaoCometer;
      except
        on E: Exception do
        begin
          DM.TransacaoReverter;
          msgErro :=
            'Não foi possivel Inserir O Pedido:' + sLineBreak + E.Message;
          raise Exception.Create(msgErro);
        end;
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
  Result := Pedido.ID;
end;

procedure TControladorPedido.Pesquisar(Chave: string; CD: TClientDataSet);
var
  Pedido: TPedido;
  Qry: TIBQuery;
begin
  Pedido := TPedido.Create;
  Qry := TIBQuery.Create(nil);
  DM.TransacaoCometer;
  try
    with Qry do
    begin
      Database := DM.Banco;
      SQL.Clear;
      SQL.Add(' SELECT                            ');
      SQL.Add('    P.ID,                          ');
      SQL.Add('    P.DATAHORA,                    ');
      SQL.Add('    P.TOTALDESCONTO,               ');
      SQL.Add('    P.TOTALPEDIDO                  ');
      SQL.Add(' FROM PEDIDOS P                    ');
      SQL.Add('   INNER JOIN CLIENTES C           ');
      SQL.Add('     ON (P.CLIENTEID = C.ID)       ');
      SQL.Add('   INNER JOIN VENDEDORES V         ');
      SQL.Add('     ON (P.VENDEDORID = v.ID)      ');
      SQL.Add(' WHERE                             ');
      case PesquisarPor of
        porCliente:
          begin
            SQL.Add('  (C.ID = :CLIENTEID) OR     ');
            SQL.Add('  (UPPER(C.NOME) LIKE UPPER(:NOME)) ');
          end;
        porPedido:
          begin
            SQL.Add(' (P.ID = :ID)                   ');
            SQL.Add(' OR (CAST(P.DATAHORA AS DATE) = :DATA )  ');
          end;
        porVendedor:
          begin
            SQL.Add(' (P.VENDEDORID = :VEND) AND ( ');
            SQL.Add('   (P.DATAHORA >= :INICIO) ');
            SQL.Add('   AND (P.DATAHORA <= :FIM) ');
            SQL.Add(' ) ');
          end;
      end;
      SQL.Add(' ORDER BY P.ID;                    ');
      case PesquisarPor of
        porCliente:
          begin
            ParamByName('CLIENTEID').AsInteger := StrToIntDef(Chave, -1);
            ParamByName('NOME').AsString := '%' + Chave + '%';
          end;
        porPedido:
          begin
            ParamByName('ID').AsInteger := StrToIntDef(Chave, -1);
            ParamByName('DATA').AsString := Chave;
          end;
        porVendedor:
          begin
            ParamByName('VEND').AsInteger := StrToIntDef(Chave, -1);
            ParamByName('INICIO').AsDate := Inicio;
            ParamByName('FIM').AsDate := Fim;
          end;
      end;
    end;
    Qry.Prepare;
    Qry.Open;
    Qry.DisableControls;
    Qry.Last;
    Qry.First;

    CD.Close;
    CD.FieldDefs.Clear;
    CD.FieldDefs.Add('ID', ftInteger);
    CD.FieldDefs.Add('DATAHORA', ftDateTime);
    CD.FieldDefs.Add('TOTALDESCONTO', ftCurrency);
    CD.FieldDefs.Add('TOTALPEDIDO', ftCurrency);
    CD.CreateDataSet;
    CD.Open;

    while (not(Qry.Eof)) do
    begin
      Pedido.ID := Qry.FieldByName('ID').AsInteger;
      Pedido.DataHora := Qry.FieldByName('DATAHORA').AsDateTime;
      Pedido.TotalDesconto := Qry.FieldByName('TOTALDESCONTO').AsCurrency;
      Pedido.TotalPedido := Qry.FieldByName('TOTALPEDIDO').AsCurrency;

      CD.Append;
      CD.FieldByName('ID').AsInteger := Pedido.ID;
      CD.FieldByName('ID').DisplayLabel := 'Código do Pedido';
      CD.FieldByName('DATAHORA').AsDateTime := Pedido.DataHora;
      CD.FieldByName('TOTALDESCONTO').AsCurrency := Pedido.TotalDesconto;
      CD.FieldByName('TOTALPEDIDO').AsCurrency := Pedido.TotalPedido;
      CD.Post;

      Qry.Next;
    end;
    CD.First;
  finally
    FreeAndNil(Qry);
    FreeAndNil(Pedido);
  end;
end;

procedure TControladorPedido.SetFim(const Value: TDate);
begin
  FFim := Value;
end;

procedure TControladorPedido.SetInicio(const Value: TDate);
begin
  FInicio := Value;
end;

procedure TControladorPedido.SetPesquisarPor(const Value: TPesquisarPor);
begin
  FPesquisarPor := Value;
end;

end.
