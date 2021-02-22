unit uPedido;

interface

type
  TPedido = class(TObject)
  private
    FDataHora: TDateTime;
    FID: Integer;
    FTotalDesconto: Currency;
    FTotalPedido: Currency;
    FClienteID: Integer;
    FVendedorID: Integer;
    FNomeCliente: string;
    FNomeVendedor: string;
    procedure SetClienteID(const Value: Integer);
    procedure SetDataHora(const Value: TDateTime);
    procedure SetID(const Value: Integer);
    procedure SetTotalDesconto(const Value: Currency);
    procedure SetTotalPedido(const Value: Currency);
    procedure SetVendedorID(const Value: Integer);
    procedure SetNomeCliente(const Value: string);
    procedure SetNomeVendedor(const Value: string);

  public
    property ID: Integer read FID write SetID;
    property VendedorID: Integer read FVendedorID write SetVendedorID;
    property NomeVendedor: string read FNomeVendedor write SetNomeVendedor;
    property ClienteID: Integer read FClienteID write SetClienteID;
    property NomeCliente: string read FNomeCliente write SetNomeCliente;
    property DataHora: TDateTime read FDataHora write SetDataHora;
    property TotalDesconto: Currency read FTotalDesconto write SetTotalDesconto;
    property TotalPedido: Currency read FTotalPedido write SetTotalPedido;
  end;

implementation

{ TPedido }

procedure TPedido.SetClienteID(const Value: Integer);
begin
  FClienteID := Value;
end;

procedure TPedido.SetDataHora(const Value: TDateTime);
begin
  FDataHora := Value;
end;

procedure TPedido.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TPedido.SetNomeCliente(const Value: string);
begin
  FNomeCliente := Value;
end;

procedure TPedido.SetNomeVendedor(const Value: string);
begin
  FNomeVendedor := Value;
end;

procedure TPedido.SetTotalDesconto(const Value: Currency);
begin
  FTotalDesconto := Value;
end;

procedure TPedido.SetTotalPedido(const Value: Currency);
begin
  FTotalPedido := Value;
end;

procedure TPedido.SetVendedorID(const Value: Integer);
begin
  FVendedorID := Value;
end;

end.
