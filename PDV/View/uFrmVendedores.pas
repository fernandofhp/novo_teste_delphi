unit uFrmVendedores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, Provider,
  ComCtrls, Menus, cxLookAndFeelPainters, cxButtons, IBCustomDataSet, IBQuery;

type
  TOperacao = (opVer, opInserir, opAlterar);

type
  TFrmVendedores = class(TForm)
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
    edID: TEdit;
    edNome: TEdit;
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
  FrmVendedores: TFrmVendedores;

implementation

uses uControladorVendedor, uVendedor, uConexao;
{$R *.dfm}

procedure TFrmVendedores.Alterar(Codigo: Integer);
var
  Vendedor: TVendedor;
  Controlador: TControladorVendedor;
begin
  Vendedor := TVendedor.Create;
  Controlador := TControladorVendedor.Create;
  try
    with Vendedor do
    begin
      ID := StrToIntDef(edID.Text, -1);
      Nome := edNome.Text;
    end;
    Controlador.Alterar(Vendedor);
    Pesquisar('');
    LimparCampos;
    InicializarConfiguracoes;
  finally
    FreeAndNil(Vendedor);
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmVendedores.btnAlterarClick(Sender: TObject);
begin
  Operacao := opAlterar;
  PermitirEditarCampos;
  BtnCancelar.Enabled := True;
  if (edNome.CanFocus) then
  begin
    edNome.SetFocus;
  end;
end;

procedure TFrmVendedores.BtnCancelarClick(Sender: TObject);
begin
  Operacao := opVer;
  PermitirEditarCampos;
  CarregarDados(cdLista.FieldByName('ID').AsInteger);
end;

procedure TFrmVendedores.BtnDetalharClick(Sender: TObject);
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

procedure TFrmVendedores.BtnExcluirClick(Sender: TObject);
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

procedure TFrmVendedores.btnFecharClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmVendedores.BtnGravarClick(Sender: TObject);
begin
  Gravar;
end;

procedure TFrmVendedores.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  Operacao := opInserir;
  PermitirEditarCampos;
  btnAlterar.Enabled := False;
  BtnCancelar.Enabled := True;
  if (edNome.CanFocus) then
  begin
    edNome.SetFocus;
  end;
end;

procedure TFrmVendedores.btnPesquisaClick(Sender: TObject);
begin
  InicializarConfiguracoes;
end;

procedure TFrmVendedores.btnPesquisarClick(Sender: TObject);
begin
  Pesquisar(edChave.Text);
end;

procedure TFrmVendedores.CarregarDados(Codigo: Integer);
var
  Controlador: TControladorVendedor;
  Vendedor: TVendedor;
begin
  Controlador := TControladorVendedor.Create;
  Vendedor := TVendedor.Create;
  try
    Controlador.CarregarDados(Codigo, Vendedor);
    edID.Text := IntToStr(Vendedor.ID);
    edNome.Text := Vendedor.Nome;
    pgAbas.ActivePage := TabDetahe;
    PermitirAlterar;
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Vendedor);
  end;
end;

procedure TFrmVendedores.editPermitirGravar(Sender: TObject);
begin
  PermitirGravar;
end;

procedure TFrmVendedores.Excluir(Codigo: Integer);
var
  Controlador: TControladorVendedor;
begin
  Controlador := TControladorVendedor.Create;
  try
    Controlador.Excluir(Codigo);
    InicializarConfiguracoes;
    Pesquisar('');
  finally
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmVendedores.FormShow(Sender: TObject);
begin
  InicializarConfiguracoes;
end;

procedure TFrmVendedores.Gravar;
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

procedure TFrmVendedores.grdListaDblClick(Sender: TObject);
begin
  // grdLista.Tag := cdLista.FieldByName('ID').AsInteger;
  grdLista.Tag := cdLista.FieldByName('ID').AsInteger;
  CarregarDados(grdLista.Tag);
end;

procedure TFrmVendedores.grdListaDrawColumnCell
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

procedure TFrmVendedores.InicializarConfiguracoes;
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

procedure TFrmVendedores.Inserir;
var
  Vendedor: TVendedor;
  Controlador: TControladorVendedor;
  Codigo: Integer;
begin
  Vendedor := TVendedor.Create;
  Controlador := TControladorVendedor.Create;
  try
    with Vendedor do
    begin
      Nome := edNome.Text;
    end;
    Codigo := Controlador.Inserir(Vendedor);
    edChave.Text := IntToStr(Codigo);
    Pesquisar(IntToStr(Codigo));
    LimparCampos;
    InicializarConfiguracoes;
  finally
    FreeAndNil(Vendedor);
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmVendedores.LimparCampos;
begin
  edID.Text := EmptyStr;
  edNome.Text := EmptyStr;
end;

procedure TFrmVendedores.PermitirAlterar;
begin
  btnAlterar.Enabled := True;
end;

procedure TFrmVendedores.PermitirEditarCampos;
begin
  case Operacao of
    opVer:
      begin
        edID.Enabled := False;
        edNome.Enabled := False;
      end;
    opInserir, opAlterar:
      begin
        edID.Enabled := False;
        edNome.Enabled := True;
      end;
  end;
end;

procedure TFrmVendedores.PermitirGravar;
var
  Permitir: Boolean;
begin
  Permitir := (Operacao <> opVer);
  Permitir := Permitir and (edNome.Text <> EmptyStr);
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

procedure TFrmVendedores.Pesquisar(Chave: string);
var
  Controlador: TControladorVendedor;
begin
  Controlador := TControladorVendedor.Create;
  try
    Controlador.Pesquisar(Chave, cdLista);
    // Controlador.Pesquisar(Chave, QryLista);
  finally
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmVendedores.pgAbasChange(Sender: TObject);
begin
  PermitirEditarCampos;
  if pgAbas.ActivePage = TabDetahe then
  begin
    BtnDetalhar.Click;
  end;
end;

procedure TFrmVendedores.SetOperacao(const Value: TOperacao);
begin
  FOperacao := Value;
end;

end.
