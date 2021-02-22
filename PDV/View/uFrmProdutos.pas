unit uFrmProdutos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, Provider,
  ComCtrls, Menus, cxLookAndFeelPainters, cxButtons, IBCustomDataSet, IBQuery;

type
  TOperacao = (opVer, opInserir, opAlterar);

type
  TFrmProdutos = class(TForm)
    Panel3: TPanel;
    btnFechar: TBitBtn;
    pgAbas: TPageControl;
    TabPesquisa: TTabSheet;
    Panel1: TPanel;
    btnPesquisar: TBitBtn;
    StaticText7: TStaticText;
    edChave: TEdit;
    grdLista: TDBGrid;
    Panel4: TPanel;
    TabDetahe: TTabSheet;
    Panel2: TPanel;
    Image1: TImage;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText4: TStaticText;
    edID: TEdit;
    edDescricao: TEdit;
    edPreco: TEdit;
    Panel5: TPanel;
    Image2: TImage;
    BtnDetalhar: TcxButton;
    btnNovo: TcxButton;
    btnAlterar: TcxButton;
    BtnGravar: TcxButton;
    BtnCancelar: TcxButton;
    dsLista: TDataSource;
    BtnExcluir: TcxButton;
    btnPesquisa: TcxButton;
    cdLista: TClientDataSet;
    Shape1: TShape;
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure grdListaDblClick(Sender: TObject);
    procedure grdListaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure editPermitirGravar(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure BtnDetalharClick(Sender: TObject);
    procedure btnPesquisaClick(Sender: TObject);
    procedure pgAbasChange(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
  private
    FOperacao: TOperacao;
    procedure Pesquisar(Chave: string);
    procedure CarregarDados(Codigo: Integer);
    procedure LimparCampos;
    procedure SetOperacao(const Value: TOperacao);
    procedure InicializarConfiguracoes;
    procedure PermitirAlterar;
    procedure Gravar;
    procedure Inserir;
    procedure Alterar(Codigo: Integer);
    procedure Excluir(Codigo: Integer);
    procedure PermitirGravar;
    procedure PermitirEditarCampos;
  public
    property Operacao: TOperacao read FOperacao write SetOperacao;
  end;

var
  FrmProdutos: TFrmProdutos;

implementation

uses uControladorProduto, uProduto, uConexao;
{$R *.dfm}

procedure TFrmProdutos.Alterar(Codigo: Integer);
var
  Produto: TProduto;
  Controlador: TControladorProduto;
begin
  Produto := TProduto.Create;
  Controlador := TControladorProduto.Create;
  try
    with Produto do
    begin
      ID := StrToIntDef(edID.Text, -1);
      Descricao := edDescricao.Text;
      Preco := StrToCurrDef(edPreco.Text, 0);
    end;
    Controlador.Alterar(Produto);
    Pesquisar('');
    LimparCampos;
    InicializarConfiguracoes;
  finally
    FreeAndNil(Produto);
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmProdutos.btnAlterarClick(Sender: TObject);
begin
  Operacao := opAlterar;
  PermitirEditarCampos;
  BtnCancelar.Enabled := True;
  if (edDescricao.CanFocus) then
  begin
    edDescricao.SetFocus;
  end;
end;

procedure TFrmProdutos.BtnCancelarClick(Sender: TObject);
begin
  Operacao := opVer;
  PermitirEditarCampos;
  CarregarDados(cdLista.FieldByName('ID').AsInteger);
end;

procedure TFrmProdutos.BtnDetalharClick(Sender: TObject);
begin
  try
    CarregarDados(cdLista.FieldByName('ID').AsInteger);
  except
    on E: Exception do
    begin
      Beep;
    end;
  end;
end;

procedure TFrmProdutos.BtnExcluirClick(Sender: TObject);
var
  Pode: Boolean;
  Msg: string;
begin
  Msg := 'Atenção!!! ' + #13 + 'Tem certeza em EXCLUIR o registro atual?';
  Pode := (MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes);
  if (Pode) then
  begin
    edID.Tag := StrToIntDef(edID.Text, -1);
    Excluir(edID.Tag);
    LimparCampos;
  end;
end;

procedure TFrmProdutos.btnFecharClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmProdutos.BtnGravarClick(Sender: TObject);
begin
  Gravar;
end;

procedure TFrmProdutos.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  Operacao := opInserir;
  PermitirEditarCampos;
  btnAlterar.Enabled := False;
  BtnCancelar.Enabled := True;
  if (edDescricao.CanFocus) then
  begin
    edDescricao.SetFocus;
  end;
end;

procedure TFrmProdutos.btnPesquisaClick(Sender: TObject);
begin
  InicializarConfiguracoes;
end;

procedure TFrmProdutos.btnPesquisarClick(Sender: TObject);
begin
  Pesquisar(edChave.Text);
end;

procedure TFrmProdutos.CarregarDados(Codigo: Integer);
var
  Controlador: TControladorProduto;
  Produto: TProduto;
begin
  Controlador := TControladorProduto.Create;
  Produto := TProduto.Create;
  try
    Controlador.CarregarDados(Codigo, Produto);
    edID.Text := IntToStr(Produto.ID);
    edDescricao.Text := Produto.Descricao;
    edPreco.Text := CurrToStr(Produto.Preco);
    pgAbas.ActivePage := TabDetahe;
    PermitirAlterar;
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Produto);
  end;
end;

procedure TFrmProdutos.editPermitirGravar(Sender: TObject);
begin
  PermitirGravar;
end;

procedure TFrmProdutos.Excluir(Codigo: Integer);
var
  Controlador: TControladorProduto;
begin
  Controlador := TControladorProduto.Create;
  try
    Controlador.Excluir(Codigo);
    InicializarConfiguracoes;
    Pesquisar('');
  finally
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmProdutos.FormShow(Sender: TObject);
begin
  InicializarConfiguracoes;
end;

procedure TFrmProdutos.Gravar;
begin
  case Operacao of
    opVer:
      begin
        Beep;
      end;
    opInserir:
      begin
        Inserir;
      end;
    opAlterar:
      begin
        Alterar(StrToIntDef(edChave.Text, -1));
      end;
  end;

end;

procedure TFrmProdutos.grdListaDblClick(Sender: TObject);
begin
  // grdLista.Tag := cdLista.FieldByName('ID').AsInteger;
  grdLista.Tag := cdLista.FieldByName('ID').AsInteger;
  CarregarDados(grdLista.Tag);
end;

procedure TFrmProdutos.grdListaDrawColumnCell
  (Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if not odd(grdLista.DataSource.DataSet.RecNo) then
  begin
    if not(gdSelected in State) then
    begin
      grdLista.Canvas.Brush.Color := clBtnFace;
      grdLista.Canvas.FillRect(Rect);
      grdLista.DefaultDrawDataCell(Rect, Column.Field, State);
    end;
  end;

end;

procedure TFrmProdutos.InicializarConfiguracoes;
begin
  Operacao := opVer;
  PermitirEditarCampos;
  pgAbas.ActivePage := TabPesquisa;
  btnNovo.Enabled := True;
  btnAlterar.Enabled := False;
  BtnGravar.Enabled := False;
  BtnCancelar.Enabled := False;
  // QryLista.Database := DM.Banco;
end;

procedure TFrmProdutos.Inserir;
var
  Produto: TProduto;
  Controlador: TControladorProduto;
  Codigo: Integer;
begin
  Produto := TProduto.Create;
  Controlador := TControladorProduto.Create;
  try
    with Produto do
    begin
      Descricao := edDescricao.Text;
      Preco := StrToCurrDef(edPreco.Text, 0);
    end;
    Codigo := Controlador.Inserir(Produto);
    edChave.Text := IntToStr(Codigo);
    Pesquisar(IntToStr(Codigo));
    LimparCampos;
    InicializarConfiguracoes;
  finally
    FreeAndNil(Produto);
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmProdutos.LimparCampos;
begin
  edID.Text := EmptyStr;
  edDescricao.Text := EmptyStr;
  edPreco.Text := EmptyStr;
end;

procedure TFrmProdutos.PermitirAlterar;
begin
  btnAlterar.Enabled := True;
end;

procedure TFrmProdutos.PermitirEditarCampos;
begin
  case Operacao of
    opVer:
      begin
        edID.Enabled := False;
        edDescricao.Enabled := False;
        edPreco.Enabled := False;
      end;
    opInserir, opAlterar:
      begin
        edID.Enabled := False;
        edDescricao.Enabled := True;
        edPreco.Enabled := True;
      end;
  end;
end;

procedure TFrmProdutos.PermitirGravar;
var
  Permitir: Boolean;
begin
  Permitir := (Operacao <> opVer);
  Permitir := Permitir and (edDescricao.Text <> EmptyStr);
  Permitir := Permitir and (edPreco.Text <> EmptyStr);
  if (Permitir) then
  begin
    BtnGravar.Enabled := True;
    BtnCancelar.Enabled := True;
  end
  else
  begin
    BtnGravar.Enabled := False;
    BtnCancelar.Enabled := False;
  end;
end;

procedure TFrmProdutos.Pesquisar(Chave: string);
var
  Controlador: TControladorProduto;
begin
  Controlador := TControladorProduto.Create;
  try
    Controlador.Pesquisar(Chave, cdLista);
    // Controlador.Pesquisar(Chave, QryLista);
  finally
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmProdutos.pgAbasChange(Sender: TObject);
begin
  PermitirEditarCampos;
  if pgAbas.ActivePage = TabDetahe then
  begin
     BtnDetalhar.Click;
  end;
end;

procedure TFrmProdutos.SetOperacao(const Value: TOperacao);
begin
  FOperacao := Value;
end;

end.
