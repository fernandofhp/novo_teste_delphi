unit uPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, dxGDIPlusClasses;

type
  TFrmPrincipal = class(TForm)
    Panel1: TPanel;
    btnClientes: TBitBtn;
    Panel2: TPanel;
    btnSair: TBitBtn;
    Image1: TImage;
    btnProdutos: TBitBtn;
    btnVendedores: TBitBtn;
    btnPedidosVenda: TBitBtn;
    btnRelatorios: TBitBtn;
    procedure btnSairClick(Sender: TObject);
    procedure btnClientesClick(Sender: TObject);
    procedure btnProdutosClick(Sender: TObject);
    procedure btnVendedoresClick(Sender: TObject);
    procedure btnPedidosVendaClick(Sender: TObject);
    procedure btnRelatoriosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses uFrmClientes, uFrmProdutos, uFrmVendedores, uFrmPedidosVenda,
  uFrmConsultasRelatorios;
{$R *.dfm}

procedure TFrmPrincipal.btnClientesClick(Sender: TObject);
var
  FrmClientes: TFrmClientes;
begin
  FrmClientes := TFrmClientes.Create(nil);
  try
    FrmClientes.ShowModal;
  finally
    FreeAndNil(FrmClientes);
  end;
end;

procedure TFrmPrincipal.btnPedidosVendaClick(Sender: TObject);
var
  FrmPedidosVenda: TFrmPedidosVenda;
begin
  FrmPedidosVenda := TFrmPedidosVenda.Create(nil);
  try
    FrmPedidosVenda.ShowModal;
  finally
    FreeAndNil(FrmPedidosVenda);
  end;
end;

procedure TFrmPrincipal.btnProdutosClick(Sender: TObject);
var
  FrmProdutos: TFrmProdutos;
begin
  FrmProdutos := TFrmProdutos.Create(nil);
  try
    FrmProdutos.ShowModal;
  finally
    FreeAndNil(FrmProdutos);
  end;
end;

procedure TFrmPrincipal.btnRelatoriosClick(Sender: TObject);
var Form: TFrmConultasRelatorios;
begin
  Form := TFrmConultasRelatorios.Create(nil);
  try
    form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;

procedure TFrmPrincipal.btnVendedoresClick(Sender: TObject);
var
  FrmVendedores: TFrmVendedores;
begin
  FrmVendedores := TFrmVendedores.Create(nil);
  try
    FrmVendedores.ShowModal;
  finally
    FreeAndNil(FrmVendedores);
  end;
end;

procedure TFrmPrincipal.btnSairClick(Sender: TObject);
begin
  Close;
end;

end.
