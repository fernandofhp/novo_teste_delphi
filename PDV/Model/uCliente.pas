unit uCliente;

interface

type
  TCliente = class(TObject)
  private
    FEmail: string;
    FID: Integer;
    FNome: string;
    procedure SetEmail(const Value: string);
    procedure SetID(const Value: Integer);
    procedure SetNome(const Value: string);

  public
    property ID: Integer read FID write SetID;
    property Nome: string read FNome write SetNome;
    property Email: string read FEmail write SetEmail;
  end;

implementation

{ TCliente }
{ TCliente }

procedure TCliente.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TCliente.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TCliente.SetNome(const Value: string);
begin
  FNome := Value;
end;

end.
