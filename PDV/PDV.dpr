program PDV;

uses
  Forms,
  uPrincipal in 'View\uPrincipal.pas' {FrmPrincipal},
  uConexao in 'DAO\uConexao.pas' {DM: TDataModule},
  uCliente in 'Model\uCliente.pas',
  uControladorCliente in 'Controller\uControladorCliente.pas',
  uFrmClientes in 'View\uFrmClientes.pas' {FrmClientes},
  uProduto in 'Model\uProduto.pas',
  uControladorProduto in 'Controller\uControladorProduto.pas',
  uFrmProdutos in 'View\uFrmProdutos.pas' {FrmProdutos},
  uVendedor in 'Model\uVendedor.pas',
  uFrmVendedores in 'View\uFrmVendedores.pas' {FrmVendedores},
  uControladorVendedor in 'Controller\uControladorVendedor.pas',
  uFrmPedidosVenda in 'View\uFrmPedidosVenda.pas' {FrmPedidosVenda},
  uPedido in 'Model\uPedido.pas',
  uItem in 'Model\uItem.pas',
  uControladorPedido in 'Controller\uControladorPedido.pas',
  uControladorItens in 'Controller\uControladorItens.pas',
  uReportPedido in 'View\uReportPedido.pas' {FrmRelatorioPedido},
  uFrmConsultasRelatorios in 'View\uFrmConsultasRelatorios.pas' {FrmConultasRelatorios},
  uFrmRelatorioPorVendedor in 'View\uFrmRelatorioPorVendedor.pas' {FrmRelatorioPorVendedor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'SISTEMA PDV FHP';
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmClientes, FrmClientes);
  Application.CreateForm(TFrmProdutos, FrmProdutos);
  Application.CreateForm(TFrmVendedores, FrmVendedores);
  Application.CreateForm(TFrmPedidosVenda, FrmPedidosVenda);
  Application.CreateForm(TFrmRelatorioPedido, FrmRelatorioPedido);
  Application.CreateForm(TFrmConultasRelatorios, FrmConultasRelatorios);
  Application.CreateForm(TFrmRelatorioPorVendedor, FrmRelatorioPorVendedor);
  Application.Run;
end.
