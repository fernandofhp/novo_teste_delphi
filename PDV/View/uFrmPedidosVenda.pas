unit uFrmPedidosVenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, cxLookAndFeelPainters, cxButtons, Buttons,
  cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, DBClient, Provider;

type
  TOperacao = (opVer, opInserir, opAlterar);

type
  TFrmPedidosVenda = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StaticText1: TStaticText;
    edPedidoChave: TEdit;
    lblPedidoChave: TStaticText;
    btnPedidoPesquisar: TBitBtn;
    Panel5: TPanel;
    StaticText3: TStaticText;
    edVendedorChave: TEdit;
    StaticText4: TStaticText;
    btnVendedorPesquisar: TBitBtn;
    StaticText5: TStaticText;
    edVendedorNome: TEdit;
    Panel6: TPanel;
    StaticText6: TStaticText;
    edClienteChave: TEdit;
    StaticText7: TStaticText;
    btnClientePesquisar: TBitBtn;
    StaticText8: TStaticText;
    edClienteNome: TEdit;
    Panel7: TPanel;
    StaticText10: TStaticText;
    edProdutoChave: TEdit;
    StaticText11: TStaticText;
    btnProdutoPesquisar: TBitBtn;
    StaticText12: TStaticText;
    edProdutoDescricao: TEdit;
    StaticText13: TStaticText;
    edProdutoPreco: TEdit;
    edProdutoQuantidade: TEdit;
    StaticText14: TStaticText;
    edProdutoDesconto: TEdit;
    StaticText15: TStaticText;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    btnAdicionarItem: TBitBtn;
    Panel4: TPanel;
    Image5: TImage;
    StaticText16: TStaticText;
    gridItensDBTableView1: TcxGridDBTableView;
    gridItensLevel1: TcxGridLevel;
    gridItens: TcxGrid;
    cdItens: TClientDataSet;
    dsItens: TDataSource;
    StaticText17: TStaticText;
    edVendedorID: TEdit;
    StaticText18: TStaticText;
    edClienteID: TEdit;
    StaticText19: TStaticText;
    edProdutoID: TEdit;
    StaticText20: TStaticText;
    edItemID: TEdit;
    StaticText21: TStaticText;
    edItemDescricao: TEdit;
    StaticText22: TStaticText;
    edItemPreco: TEdit;
    StaticText23: TStaticText;
    edItemQuantidade: TEdit;
    StaticText24: TStaticText;
    edItemDesconto: TEdit;
    StaticText25: TStaticText;
    edItemTotal: TEdit;
    btnItemAlterar: TcxButton;
    btnItemGravar: TcxButton;
    btnItemCancelar: TcxButton;
    btnItemExcluir: TcxButton;
    Panel8: TPanel;
    btnFechar: TBitBtn;
    cdPedidos: TClientDataSet;
    dsPedidos: TDataSource;
    rgrPedidoPesquisar: TRadioGroup;
    gridPedidosDBTableView1: TcxGridDBTableView;
    gridPedidosLevel1: TcxGridLevel;
    gridPedidos: TcxGrid;
    Panel9: TPanel;
    StaticText28: TStaticText;
    edPedidoID: TEdit;
    btnPedidoNovo: TcxButton;
    StaticText9: TStaticText;
    edPedidoDataHora: TEdit;
    btnPedidoAlterar: TcxButton;
    StaticText26: TStaticText;
    edPedidoTotalDesconto: TEdit;
    btnPedidoGravar: TcxButton;
    StaticText27: TStaticText;
    btnPedidoCancelar: TcxButton;
    btnPedidoExcluir: TcxButton;
    edPedidoTotalPedido: TEdit;
    btnClientes: TBitBtn;
    btnVendedores: TBitBtn;
    btnProdutos: TBitBtn;
    Panel10: TPanel;
    btnRelatorioVisualizar: TcxButton;
    cxButton1: TcxButton;
    procedure btnFecharClick(Sender: TObject);
    procedure btnPedidoPesquisarClick(Sender: TObject);
    procedure rgrPedidoPesquisarClick(Sender: TObject);
    procedure gridItensDBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure btnVendedorPesquisarClick(Sender: TObject);
    procedure btnClientesClick(Sender: TObject);
    procedure btnClientePesquisarClick(Sender: TObject);
    procedure btnVendedoresClick(Sender: TObject);
    procedure btnProdutosClick(Sender: TObject);
    procedure btnProdutoPesquisarClick(Sender: TObject);
    procedure btnPedidoAlterarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnPedidoCancelarClick(Sender: TObject);
    procedure btnPedidoGravarClick(Sender: TObject);
    procedure btnPedidoExcluirClick(Sender: TObject);
    procedure btnPedidoNovoClick(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btnItemAlterarClick(Sender: TObject);
    procedure btnItemGravarClick(Sender: TObject);
    procedure btnItemCancelarClick(Sender: TObject);
    procedure btnItemExcluirClick(Sender: TObject);
    procedure gridPedidosDBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure btnRelatorioVisualizarClick(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
  private
    FOperacaoPedido: TOperacao;
    FOperacaoItem: TOperacao;
    procedure PesquisarPedido(Chave: string);
    procedure PesquisarItens(PedidoID: Integer);
    procedure CarregarPedido(Codigo: Integer);
    procedure CarregarCliente(Codigo: Integer);
    procedure CarregarVendedor(Codigo: Integer);
    procedure CarregarProduto(Codigo: Integer);
    procedure CarregarItem(Codigo: Integer);
    procedure LimparCamposPedido;
    procedure LimparCamposItens;
    procedure LimparCamposClientes;
    procedure LimparCamposProdutos;
    procedure LimparCamposVendedores;
    procedure SetOperacaoItem(const Value: TOperacao);
    procedure SetOperacaoPedido(const Value: TOperacao);
    procedure InicializarConfiguracoes;
    procedure PedidosGravar;
    procedure PedidosAlterar(Codigo: Integer);
    procedure PedidoPodeGravar;
    procedure PedidoExcluir(Codigo: Integer);
    procedure PedidoInserir;
    procedure ItemInserir;
    procedure ItemPodeGravar;
    procedure ItemGravar;
    procedure Itemalterar;
    procedure ItemExcluir(Codigo: Integer);
  public
    property OperacaoPedido: TOperacao read FOperacaoPedido write
      SetOperacaoPedido;
    property OperacaoItem: TOperacao read FOperacaoItem write SetOperacaoItem;
  end;

var
  FrmPedidosVenda: TFrmPedidosVenda;

implementation

uses uControladorPedido, uControladorCliente, uControladorProduto,
  uControladorItens, uControladorVendedor, uPedido, uCliente, uVendedor,
  uProduto, uItem, uFrmClientes, uFrmVendedores, uFrmProdutos, uReportPedido;
{$R *.dfm}

procedure TFrmPedidosVenda.btnAdicionarItemClick(Sender: TObject);
begin
  ItemInserir;
  rgrPedidoPesquisar.ItemIndex := 0; //Pedidos
  edPedidoChave.Text := edPedidoID.Text;
  edPedidoID.Tag := StrToIntDef(edPedidoID.Text, -1);
  btnPedidoPesquisar.Click;
  PesquisarItens(edPedidoID.Tag);
end;

procedure TFrmPedidosVenda.btnClientePesquisarClick(Sender: TObject);
begin
  if (Trim(edClienteChave.Text) <> EmptyStr) then
  begin
    edClienteChave.Tag := StrToIntDef(edClienteChave.Text, -1);
    CarregarCliente(edClienteChave.Tag);
  end;
end;

procedure TFrmPedidosVenda.btnClientesClick(Sender: TObject);
var
  FrmClientes: TFrmClientes;
begin
  FrmClientes := TFrmClientes.Create(nil);
  try
    if (FrmClientes.ShowModal = mrOk) then
    begin
      try
        edClienteChave.Text := FrmClientes.cdLista.FieldByName('ID').AsString;
      except
        on E: Exception do
        begin
          edClienteChave.Text := '';
          raise Exception.Create('Nenhum Cliente selecionado!');
        end;
      end;

      btnClientePesquisar.Click;
    end;
  finally
    FreeAndNil(FrmClientes);
  end;
end;

procedure TFrmPedidosVenda.btnFecharClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmPedidosVenda.btnItemAlterarClick(Sender: TObject);
begin
  OperacaoItem := opAlterar;
  btnItemCancelar.Enabled := True;
  if (edItemPreco.CanFocus) then
  begin
    edItemPreco.SetFocus;
  end;
  ItemPodeGravar;
end;

procedure TFrmPedidosVenda.btnItemCancelarClick(Sender: TObject);
begin
  InicializarConfiguracoes;
end;

procedure TFrmPedidosVenda.btnItemExcluirClick(Sender: TObject);
var
  msgConfirmar: string;
  Sim: Boolean;
begin
  msgConfirmar := 'ATENÇÃO!!!' + sLineBreak + 'Tem certeza de que deseja' +
    sLineBreak + 'Excluir o item atual do pedido? ';
  Sim := (MessageDlg(msgConfirmar, mtConfirmation, mbYesNo, 0, mbNo) = mrYes);
  if (Sim) then
  begin
    edItemID.Tag := StrToIntDef(edItemID.Text, -1);
    ItemExcluir(edItemID.Tag);
    btnPedidoPesquisar.Click;
    CarregarPedido(cdPedidos.FieldByName('ID').AsInteger);
  end;
end;

procedure TFrmPedidosVenda.btnItemGravarClick(Sender: TObject);
begin
  ItemGravar;
  LimparCamposItens;
  edPedidoID.Tag := cdPedidos.FieldByName('ID').AsInteger;
  CarregarPedido(edPedidoID.Tag);
end;

procedure TFrmPedidosVenda.btnPedidoAlterarClick(Sender: TObject);
begin
  OperacaoPedido := opAlterar;
  btnPedidoCancelar.Enabled := True;
  if (edVendedorChave.CanFocus) then
  begin
    edVendedorChave.SetFocus;
  end;
  PedidoPodeGravar;
end;

procedure TFrmPedidosVenda.btnPedidoCancelarClick(Sender: TObject);
begin
  InicializarConfiguracoes;
end;

procedure TFrmPedidosVenda.btnPedidoExcluirClick(Sender: TObject);
var
  msgConfirmar: string;
  Sim: Boolean;
begin
  msgConfirmar := 'ATENÇÃO!!!' + sLineBreak + 'Tem certeza de que deseja' +
    sLineBreak + 'Excluir o pedido atual e todos os seus itens? ';
  Sim := (MessageDlg(msgConfirmar, mtConfirmation, mbYesNo, 0, mbNo) = mrYes);
  if (Sim) then
  begin
    edPedidoID.Tag := StrToIntDef(edPedidoID.Text, -1);
    PedidoExcluir(edPedidoID.Tag);
    btnPedidoPesquisar.Click;
  end;
end;

procedure TFrmPedidosVenda.btnPedidoGravarClick(Sender: TObject);
begin
  PedidosGravar;
  btnPedidoPesquisar.Click;
end;

procedure TFrmPedidosVenda.btnPedidoNovoClick(Sender: TObject);
begin
  OperacaoPedido := opInserir;
  PedidoPodeGravar;
end;

procedure TFrmPedidosVenda.btnPedidoPesquisarClick(Sender: TObject);
begin
  InicializarConfiguracoes;
  PesquisarPedido(edPedidoChave.Text);
end;

procedure TFrmPedidosVenda.btnProdutoPesquisarClick(Sender: TObject);
begin
  LimparCamposProdutos;
  if (Trim(edProdutoChave.Text) <> EmptyStr) then
  begin
    edProdutoChave.Tag := StrToIntDef(edProdutoChave.Text, -1);
    CarregarProduto(edProdutoChave.Tag);
    edProdutoQuantidade.Text := '1';
    if edProdutoQuantidade.CanFocus then
    begin
      edProdutoQuantidade.SetFocus;
    end;
  end;
  btnAdicionarItem.Enabled := (Trim(edProdutoID.Text) <> EmptyStr);
end;

procedure TFrmPedidosVenda.btnProdutosClick(Sender: TObject);
var
  FrmProdutos: TFrmProdutos;
begin
  FrmProdutos := TFrmProdutos.Create(nil);
  try
    if (FrmProdutos.ShowModal = mrOk) then
    begin
      try
        edProdutoChave.Text := FrmProdutos.cdLista.FieldByName('ID').AsString;
      except
        on E: Exception do
        begin
          edProdutoChave.Text := '';
          raise Exception.Create('Nenhum Produto Selecionado!');
        end;
      end;

      btnProdutoPesquisar.Click;
    end;
  finally
    FreeAndNil(FrmProdutos);
  end;
end;

procedure TFrmPedidosVenda.btnRelatorioVisualizarClick(Sender: TObject);
begin
  FrmRelatorioPedido.CARRINHO.Data := cdItens.Data;
  FrmRelatorioPedido.CARRINHO.EnableControls;
  FrmRelatorioPedido.Relatorio.Prepare;
  FrmRelatorioPedido.Relatorio.Preview;
end;

procedure TFrmPedidosVenda.btnVendedoresClick(Sender: TObject);
var
  Form: TFrmVendedores;
begin
  Form := TFrmVendedores.Create(nil);
  try
    if (Form.ShowModal = mrOk) then
    begin
      try
        edVendedorChave.Text := Form.cdLista.FieldByName('ID').AsString;
      except
        on E: Exception do
        begin
          edVendedorChave.Text := '';
          raise Exception.Create('Nenhum Vendedor Selecionado!');
        end;
      end;
      btnVendedorPesquisar.Click;
    end;
  finally
    FreeAndNil(Form);
  end;
end;

procedure TFrmPedidosVenda.btnVendedorPesquisarClick(Sender: TObject);
begin
  if (Trim(edVendedorChave.Text) <> EmptyStr) then
  begin
    edVendedorChave.Tag := StrToIntDef(edVendedorChave.Text, -1);
    CarregarVendedor(edVendedorChave.Tag);
  end;
end;

procedure TFrmPedidosVenda.CarregarCliente(Codigo: Integer);
var
  Controlador: TControladorCliente;
  Cliente: TCliente;
begin
  Cliente := TCliente.Create;
  Controlador := TControladorCliente.Create;
  try
    Controlador.CarregarDados(Codigo, Cliente);
    with Cliente do
    begin
      edClienteID.Text := IntToStr(ID);
      edClienteNome.Text := Nome;
    end;
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Cliente);
  end;
end;

procedure TFrmPedidosVenda.CarregarItem(Codigo: Integer);
var
  Controlador: TControladorItens;
  Item: TItem;
begin
  Controlador := TControladorItens.Create;
  Item := TItem.Create;
  try
    Controlador.CarregarDados(Codigo, Item);
    with Item do
    begin
      edItemID.Text := IntToStr(ID);
      edItemDescricao.Text := Descricao;
      edItemPreco.Text := CurrToStrF(ValorUnitario, ffCurrency, 2);
      edItemQuantidade.Text := FloatToStrF(Quantidade, ffGeneral, 15, 2);
      edItemDesconto.Text := CurrToStr(ValorDesconto);
      edItemTotal.Text := CurrToStrF(ValorTotal, ffCurrency, 2);
    end;
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Item);
  end;
end;

procedure TFrmPedidosVenda.CarregarPedido(Codigo: Integer);
var
  Controlador: TControladorPedido;
  Pedido: TPedido;
begin
  Controlador := TControladorPedido.Create;
  Pedido := TPedido.Create;
  try
    Controlador.CarregarDados(Codigo, Pedido);
    with Pedido do
    begin
      edPedidoID.Text := IntToStr(ID);
      edPedidoDataHora.Text := DateTimeToStr(DataHora);
      edPedidoTotalDesconto.Text := CurrToStrF(TotalDesconto, ffCurrency, 2);
      edPedidoTotalPedido.Text := CurrToStrF(TotalPedido, ffCurrency, 2);

      CarregarVendedor(Pedido.VendedorID);
      CarregarCliente(Pedido.ClienteID);
      PesquisarItens(ID);
    end;
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Pedido);
  end;
end;

procedure TFrmPedidosVenda.CarregarProduto(Codigo: Integer);
var
  Controlador: TControladorProduto;
  Produto: TProduto;
begin
  Controlador := TControladorProduto.Create;
  Produto := TProduto.Create;
  try
    Controlador.CarregarDados(Codigo, Produto);
    with Produto do
    begin
      edProdutoID.Text := IntToStr(ID);
      edProdutoDescricao.Text := Descricao;
      edProdutoPreco.Text := CurrToStrF(Preco, ffCurrency, 2);
    end;
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Produto);
  end;
end;

procedure TFrmPedidosVenda.CarregarVendedor(Codigo: Integer);
var
  Controlador: TControladorVendedor;
  Vendedor: TVendedor;
begin
  Controlador := TControladorVendedor.Create;
  Vendedor := TVendedor.Create;
  try
    Controlador.CarregarDados(Codigo, Vendedor);
    with Vendedor do
    begin
      edVendedorID.Text := IntToStr(ID);
      edVendedorNome.Text := Nome;
    end;
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Vendedor);
  end;
end;

procedure TFrmPedidosVenda.cxButton1Click(Sender: TObject);
begin
  FrmRelatorioPedido.CARRINHO.Data := cdItens.Data;
  FrmRelatorioPedido.CARRINHO.EnableControls;
  FrmRelatorioPedido.Relatorio.Prepare;
  FrmRelatorioPedido.Relatorio.Print;
end;

procedure TFrmPedidosVenda.FormShow(Sender: TObject);
begin
  InicializarConfiguracoes;
end;

procedure TFrmPedidosVenda.gridItensDBTableView1CellClick
  (Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  edItemID.Tag := cdItens.FieldByName('ID').AsInteger;
  CarregarItem(edItemID.Tag);
  btnItemAlterar.Enabled := True;
  btnItemExcluir.Enabled := True;
end;

procedure TFrmPedidosVenda.gridPedidosDBTableView1CellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  CarregarPedido(cdPedidos.FieldByName('ID').AsInteger);
  btnPedidoAlterar.Enabled := True;
  btnPedidoExcluir.Enabled := True;
end;

procedure TFrmPedidosVenda.InicializarConfiguracoes;
begin
  OperacaoPedido := opVer;
  OperacaoItem := opVer;
  btnAdicionarItem.Enabled := False;
  btnPedidoNovo.Enabled := True;
  btnPedidoAlterar.Enabled := False;
  btnPedidoGravar.Enabled := False;
  btnPedidoCancelar.Enabled := False;
  btnPedidoExcluir.Enabled := False;
  btnItemAlterar.Enabled := False;
  btnItemGravar.Enabled := False;
  btnItemCancelar.Enabled := False;
  btnItemExcluir.Enabled := False;
end;

procedure TFrmPedidosVenda.Itemalterar;
var
  Controlador: TControladorItens;
  Item: TItem;
  InApto: Boolean;
  msgErro, Aux: string;
begin
  msgErro := 'Para Alterar o item' + sLineBreak + 'selecione um item' +
    sLineBreak + ' Defina o preço (exceto zero) e a Quantidade';
  InApto := (Trim(edItemID.Text) = '') or (Trim(edItemPreco.Text) = '') or
    (Trim(edItemQuantidade.Text) = '');
  if (InApto) then
  begin
    raise Exception.Create(msgErro);
  end;
  Controlador := TControladorItens.Create;
  Item := TItem.Create;
  try
    Item.ID := StrToIntDef(edItemID.Text, -1);
    Aux := edItemPreco.Text;
    Aux := StringReplace(Aux, 'R$ ', '', [rfReplaceAll, rfIgnoreCase]);
    Aux := StringReplace(Aux, '.', '', [rfReplaceAll, rfIgnoreCase]);
    Item.ValorUnitario := StrToCurrDef(Aux, 0);
    Aux := edItemQuantidade.Text;
    Aux := StringReplace(Aux, 'R$ ', '', [rfReplaceAll, rfIgnoreCase]);
    Aux := StringReplace(Aux, '.', '', [rfReplaceAll, rfIgnoreCase]);
    Item.Quantidade := StrToCurrDef(Aux, 0);
    Aux := edItemDesconto.Text;
    Aux := StringReplace(Aux, 'R$ ', '', [rfReplaceAll, rfIgnoreCase]);
    Aux := StringReplace(Aux, '.', '', [rfReplaceAll, rfIgnoreCase]);
    Item.ValorDesconto := StrToCurrDef(Aux, 0);
    Controlador.Alterar(Item);
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Item);
  end;
end;

procedure TFrmPedidosVenda.ItemExcluir(Codigo: Integer);
var
  Controlador: TControladorItens;
begin
  Controlador := TControladorItens.Create;
  try
    Controlador.Excluir(Codigo);
  finally
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmPedidosVenda.ItemGravar;
begin
  case OperacaoItem of
    opVer:
      begin
        Beep;
      end;
    opAlterar:
      begin
        Itemalterar;
      end;
  end;
end;

procedure TFrmPedidosVenda.ItemInserir;
var
  Controlador: TControladorItens;
  Item: TItem;
  InApto: Boolean;
  msgErro, Aux: string;
  Qtd, VlrUni, Desconto: Currency;
begin
  msgErro := 'Para Inserir um Item ao Pedido' + sLineBreak +
    'defina o Pedido' + sLineBreak + 'um Produto ' + sLineBreak +
    'e a Quantidade! ';
  InApto := (Trim(edPedidoID.Text) = '') or (Trim(edProdutoID.Text) = '') or
    (Trim(edProdutoQuantidade.Text) = '');
  if (InApto) then
  begin
    raise Exception.Create(msgErro);
  end;
  Controlador := TControladorItens.Create;
  Item := TItem.Create;
  try
    edPedidoID.Tag := StrToIntDef(edPedidoID.Text, -1);
    edProdutoID.Tag := StrToIntDef(edProdutoID.Text, -1);
    Qtd := StrToFloatDef(edProdutoQuantidade.Text, 1);
    Aux := edProdutoPreco.Text;
    Aux := StringReplace(Aux, 'R$ ', '', [rfReplaceAll, rfIgnoreCase]);
    Aux := StringReplace(Aux, '.', '', [rfReplaceAll, rfIgnoreCase]);
    VlrUni := StrToCurrDef(Aux, 0);
    Aux := edProdutoDesconto.Text;
    Aux := StringReplace(Aux, 'R$ ', '', [rfReplaceAll, rfIgnoreCase]);
    Aux := StringReplace(Aux, '.', '', [rfReplaceAll, rfIgnoreCase]);
    Desconto := StrToCurrDef(Aux, 0);
    Item.PedidoID := edPedidoID.Tag;
    Item.ProdutoID := edProdutoID.Tag;
    Item.Quantidade := Qtd;
    // raise Exception.Create(CurrToStr(VlrUni));
    Item.ValorUnitario := VlrUni;
    Item.ValorDesconto := Desconto;
    Controlador.Inserir(Item);
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Item);
  end;
end;

procedure TFrmPedidosVenda.ItemPodeGravar;
var
  Apto: Boolean;
begin
  Apto := (Trim(edItemID.Text) <> '') and (Trim(edItemPreco.Text) <> '') and
    (Trim(edItemQuantidade.Text) <> '');
  if (OperacaoItem in [opAlterar, opInserir]) then
  begin
    btnItemGravar.Enabled := Apto;
  end;
end;

procedure TFrmPedidosVenda.LimparCamposClientes;
begin
  edClienteID.Text := EmptyStr;
  edClienteNome.Text := EmptyStr;
end;

procedure TFrmPedidosVenda.LimparCamposItens;
begin
  edItemID.Text := EmptyStr;
  edItemDescricao.Text := EmptyStr;
  edItemQuantidade.Text := EmptyStr;
  edItemPreco.Text := EmptyStr;
  edItemDesconto.Text := EmptyStr;
  edItemTotal.Text := EmptyStr;
end;

procedure TFrmPedidosVenda.LimparCamposPedido;
begin
  edPedidoID.Text := EmptyStr;
  edPedidoDataHora.Text := EmptyStr;
  edPedidoTotalDesconto.Text := EmptyStr;
  edPedidoTotalPedido.Text := EmptyStr;
end;

procedure TFrmPedidosVenda.LimparCamposProdutos;
begin
  edProdutoID.Text := EmptyStr;
  edProdutoDescricao.Text := EmptyStr;
  edProdutoQuantidade.Text := EmptyStr;
  edProdutoPreco.Text := EmptyStr;
end;

procedure TFrmPedidosVenda.LimparCamposVendedores;
begin
  edVendedorID.Text := EmptyStr;
  edVendedorNome.Text := EmptyStr;
end;

procedure TFrmPedidosVenda.PedidoExcluir(Codigo: Integer);
var
  Controlador: TControladorPedido;
begin
  Controlador := TControladorPedido.Create;
  try
    Controlador.Excluir(Codigo);
  finally
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmPedidosVenda.PedidoInserir;
var
  Controlador: TControladorPedido;
  Pedido: TPedido;
  InApto: Boolean;
  msgErro: string;
begin
  msgErro := 'Para Inserir um pedido' + sLineBreak + 'defina um Vendedor' +
    sLineBreak + 'e um Cliente! ';
  InApto := (Trim(edClienteID.Text) = '') or (Trim(edVendedorID.Text) = '');
  if (InApto) then
  begin
    raise Exception.Create(msgErro);
  end;
  Controlador := TControladorPedido.Create;
  Pedido := TPedido.Create;
  try
    edVendedorID.Tag := StrToIntDef(edVendedorID.Text, -1);
    edClienteID.Tag := StrToIntDef(edClienteID.Text, -1);
    Pedido.VendedorID := edVendedorID.Tag;
    Pedido.ClienteID := edClienteID.Tag;
    edPedidoChave.Tag := Controlador.Inserir(Pedido);
    edPedidoChave.Text := IntToStr(edPedidoChave.Tag);
    rgrPedidoPesquisar.ItemIndex := 0; // PEDIDO
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Pedido);
  end;
end;

procedure TFrmPedidosVenda.PedidoPodeGravar;
var
  Apto: Boolean;
begin
  Apto := (Trim(edClienteID.Text) <> '') and (Trim(edVendedorID.Text) <> '');
  if (OperacaoPedido in [opAlterar, opInserir]) then
  begin
    btnPedidoGravar.Enabled := Apto;
  end;
end;

procedure TFrmPedidosVenda.PedidosAlterar(Codigo: Integer);
var
  Controlador: TControladorPedido;
  Pedido: TPedido;
  InApto: Boolean;
  msgErro: string;
begin
  msgErro := 'Para Alterar o pedido' + sLineBreak + 'defina um Vendedor' +
    sLineBreak + 'e um Cliente! ';
  InApto := (Trim(edClienteID.Text) = '') or (Trim(edVendedorID.Text) = '');
  if (InApto) then
  begin
    raise Exception.Create(msgErro);
  end;
  Controlador := TControladorPedido.Create;
  Pedido := TPedido.Create;
  try
    edPedidoID.Tag := StrToIntDef(edPedidoID.Text, -1);
    Pedido.ID := edPedidoID.Tag;
    Pedido.ClienteID := StrToIntDef(edClienteID.Text, -1);
    Pedido.VendedorID := StrToIntDef(edVendedorID.Text, -1);
    Controlador.Alterar(Pedido);
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Pedido);
  end;
end;

procedure TFrmPedidosVenda.PedidosGravar;
begin
  case OperacaoPedido of
    opVer:
      begin
        Beep;
      end;
    opInserir:
      begin
        PedidoInserir;
      end;
    opAlterar:
      begin
        PedidosAlterar(StrToIntDef(edPedidoID.Text, -1));
      end;
  end;
end;

procedure TFrmPedidosVenda.PesquisarItens(PedidoID: Integer);
var
  Controlador: TControladorItens;
begin
  LimparCamposItens;
  Controlador := TControladorItens.Create;
  try
    Controlador.Pesquisar(PedidoID, cdItens);
    gridItensDBTableView1.DataController.CreateAllItems(True);
  finally
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmPedidosVenda.PesquisarPedido(Chave: string);
var
  Controlador: TControladorPedido;
begin
  LimparCamposPedido;
  LimparCamposVendedores;
  LimparCamposClientes;
  LimparCamposProdutos;
  LimparCamposItens;
  Controlador := TControladorPedido.Create;
  try
    case rgrPedidoPesquisar.ItemIndex of
      0: // Pedido
        begin
          Controlador.PesquisarPor := porPedido;
        end;
      1: // Cliente
        begin
          Controlador.PesquisarPor := porCliente;
        end;
    else
      Controlador.PesquisarPor := porPedido;
    end;
    Controlador.Pesquisar(Chave, cdPedidos);
    gridPedidosDBTableView1.DataController.CreateAllItems(True);
  finally
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmPedidosVenda.rgrPedidoPesquisarClick(Sender: TObject);
begin
  case rgrPedidoPesquisar.ItemIndex of
    0:
      begin
        lblPedidoChave.Caption := 'Código ou Data do Pedido';
      end;
    1:
      begin
        lblPedidoChave.Caption := 'Código ou Nome do Cliente';
      end;
  end;

end;

procedure TFrmPedidosVenda.SetOperacaoItem(const Value: TOperacao);
begin
  FOperacaoItem := Value;
end;

procedure TFrmPedidosVenda.SetOperacaoPedido(const Value: TOperacao);
begin
  FOperacaoPedido := Value;
end;

end.
