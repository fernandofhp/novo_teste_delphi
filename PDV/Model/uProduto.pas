unit uProduto;

interface

type
  TProduto = class(TObject)
  private
    FPreco: Currency;
    FDescricao: string;
    FID: Integer;
    procedure SetDescricao(const Value: string);
    procedure SetID(const Value: Integer);
    procedure SetPreco(const Value: Currency);

  public
    property ID: Integer read FID write SetID;
    property Descricao: string read FDescricao write SetDescricao;
    property Preco: Currency read FPreco write SetPreco;
  end;

implementation

{ TProduto }

{ TProduto }

procedure TProduto.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TProduto.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TProduto.SetPreco(const Value: Currency);
begin
  FPreco := Value;
end;

end.
