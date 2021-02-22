unit uVendedor;

interface

type
  TVendedor = class(TObject)
  private
    FID: Integer;
    FNome: string;
    procedure SetID(const Value: Integer);
    procedure SetNome(const Value: string);

  public
    property ID: Integer read FID write SetID;
    property Nome: string read FNome write SetNome;
  end;

implementation

{ TVendedor }

procedure TVendedor.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TVendedor.SetNome(const Value: string);
begin
  FNome := Value;
end;

end.
