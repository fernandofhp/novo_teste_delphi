unit uItem;

interface

type
  TItem = class(TObject)
  private
    FValorDesconto: Currency;
    FValorUnitario: Currency;
    FProdutoID: Integer;
    FID: Integer;
    FValorTotal: Currency;
    FQuantidade: Currency;
    FPedidoID: Integer;
    FDescricao: string;
    procedure SetID(const Value: Integer);
    procedure SetPedidoID(const Value: Integer);
    procedure SetProdutoID(const Value: Integer);
    procedure SetQuantidade(const Value: Currency);
    procedure SetValorDesconto(const Value: Currency);
    procedure SetValorTotal(const Value: Currency);
    procedure SetValorUnitario(const Value: Currency);
    procedure SetDescricao(const Value: string);
  public
    property ID: Integer read FID write SetID;
    property PedidoID: Integer read FPedidoID write SetPedidoID;
    property ProdutoID: Integer read FProdutoID write SetProdutoID;
    property Descricao: string read FDescricao write SetDescricao;
    property Quantidade: Currency read FQuantidade write SetQuantidade;
    property ValorUnitario: Currency read FValorUnitario write SetValorUnitario;
    property ValorDesconto: Currency read FValorDesconto write SetValorDesconto;
    property ValorTotal: Currency read FValorTotal write SetValorTotal;
  end;

implementation

{ TItem }

procedure TItem.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TItem.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TItem.SetPedidoID(const Value: Integer);
begin
  FPedidoID := Value;
end;

procedure TItem.SetProdutoID(const Value: Integer);
begin
  FProdutoID := Value;
end;

procedure TItem.SetQuantidade(const Value: Currency);
begin
  FQuantidade := Value;
end;

procedure TItem.SetValorDesconto(const Value: Currency);
begin
  FValorDesconto := Value;
end;

procedure TItem.SetValorTotal(const Value: Currency);
begin
  FValorTotal := Value;
end;

procedure TItem.SetValorUnitario(const Value: Currency);
begin
  FValorUnitario := Value;
end;

end.
