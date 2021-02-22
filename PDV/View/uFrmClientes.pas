unit uFrmClientes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, Provider,
  ComCtrls, Menus, cxLookAndFeelPainters, cxButtons, IBCustomDataSet, IBQuery;

type
  TOperacao = (opVer, opInserir, opAlterar);

type
  TFrmClientes = class(TForm)
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
    StaticText3: TStaticText;
    edID: TEdit;
    edNome: TEdit;
    edEmail: TEdit;
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
  FrmClientes: TFrmClientes;

implementation

uses uControladorCliente, uCliente, uConexao;
{$R *.dfm}

procedure TFrmClientes.Alterar(Codigo: Integer);
var
  Cliente: TCliente;
  Controlador: TControladorCliente;
begin
  Cliente := TCliente.Create;
  Controlador := TControladorCliente.Create;
  try
    with Cliente do
    begin
      ID := StrToIntDef(edID.Text, -1);
      Nome := edNome.Text;
      Email := edEmail.Text;
    end;
    Controlador.Alterar(Cliente);
    Pesquisar('');
    LimparCampos;
    InicializarConfiguracoes;
  finally
    FreeAndNil(Cliente);
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmClientes.btnAlterarClick(Sender: TObject);
begin
  Operacao := opAlterar;
  PermitirEditarCampos;
  BtnCancelar.Enabled := True;
  if (edNome.CanFocus) then
  begin
    edNome.SetFocus;
  end;
end;

procedure TFrmClientes.BtnCancelarClick(Sender: TObject);
begin
  Operacao := opVer;
  PermitirEditarCampos;
  CarregarDados(cdLista.FieldByName('ID').AsInteger);
end;

procedure TFrmClientes.BtnDetalharClick(Sender: TObject);
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

procedure TFrmClientes.BtnExcluirClick(Sender: TObject);
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

procedure TFrmClientes.btnFecharClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmClientes.BtnGravarClick(Sender: TObject);
begin
  Gravar;
end;

procedure TFrmClientes.btnNovoClick(Sender: TObject);
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

procedure TFrmClientes.btnPesquisaClick(Sender: TObject);
begin
  InicializarConfiguracoes;
end;

procedure TFrmClientes.btnPesquisarClick(Sender: TObject);
begin
  Pesquisar(edChave.Text);
end;

procedure TFrmClientes.CarregarDados(Codigo: Integer);
var
  Controlador: TControladorCliente;
  Cliente: TCliente;
begin
  Controlador := TControladorCliente.Create;
  Cliente := TCliente.Create;
  try
    Controlador.CarregarDados(Codigo, Cliente);
    edID.Text := IntToStr(Cliente.ID);
    edNome.Text := Cliente.Nome;
    edEmail.Text := Cliente.Email;
    pgAbas.ActivePage := TabDetahe;
    PermitirAlterar;
  finally
    FreeAndNil(Controlador);
    FreeAndNil(Cliente);
  end;
end;

procedure TFrmClientes.editPermitirGravar(Sender: TObject);
begin
  PermitirGravar;
end;

procedure TFrmClientes.Excluir(Codigo: Integer);
var
  Controlador: TControladorCliente;
begin
  Controlador := TControladorCliente.Create;
  try
    Controlador.Excluir(Codigo);
    InicializarConfiguracoes;
    Pesquisar('');
  finally
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmClientes.FormShow(Sender: TObject);
begin
  InicializarConfiguracoes;
end;

procedure TFrmClientes.Gravar;
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

procedure TFrmClientes.grdListaDblClick(Sender: TObject);
begin
  // grdLista.Tag := cdLista.FieldByName('ID').AsInteger;
  grdLista.Tag := cdLista.FieldByName('ID').AsInteger;
  CarregarDados(grdLista.Tag);
end;

procedure TFrmClientes.grdListaDrawColumnCell
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

procedure TFrmClientes.InicializarConfiguracoes;
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

procedure TFrmClientes.Inserir;
var
  Cliente: TCliente;
  Controlador: TControladorCliente;
  Codigo: Integer;
begin
  Cliente := TCliente.Create;
  Controlador := TControladorCliente.Create;
  try
    with Cliente do
    begin
      Nome := edNome.Text;
      Email := edEmail.Text;
    end;
    Codigo := Controlador.Inserir(Cliente);
    edChave.Text := IntToStr(Codigo);
    Pesquisar(IntToStr(Codigo));
    LimparCampos;
    InicializarConfiguracoes;
  finally
    FreeAndNil(Cliente);
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmClientes.LimparCampos;
begin
  edID.Text := EmptyStr;
  edNome.Text := EmptyStr;
  edEmail.Text := EmptyStr;
end;

procedure TFrmClientes.PermitirAlterar;
begin
  btnAlterar.Enabled := True;
end;

procedure TFrmClientes.PermitirEditarCampos;
begin
  case Operacao of
    opVer:
      begin
        edID.Enabled := False;
        edNome.Enabled := False;
        edEmail.Enabled := False;
      end;
    opInserir, opAlterar:
      begin
        edID.Enabled := False;
        edNome.Enabled := True;
        edEmail.Enabled := True;
      end;
  end;
end;

procedure TFrmClientes.PermitirGravar;
var
  Permitir: Boolean;
begin
  Permitir := (Operacao <> opVer);
  Permitir := Permitir and (edNome.Text <> EmptyStr);
  Permitir := Permitir and (edEmail.Text <> EmptyStr);
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

procedure TFrmClientes.Pesquisar(Chave: string);
var
  Controlador: TControladorCliente;
begin
  Controlador := TControladorCliente.Create;
  try
    Controlador.Pesquisar(Chave, cdLista);
    // Controlador.Pesquisar(Chave, QryLista);
  finally
    FreeAndNil(Controlador);
  end;
end;

procedure TFrmClientes.pgAbasChange(Sender: TObject);
begin
  PermitirEditarCampos;
  if pgAbas.ActivePage = TabDetahe then
  begin
    BtnDetalhar.Click;
  end;
end;

procedure TFrmClientes.SetOperacao(const Value: TOperacao);
begin
  FOperacao := Value;
end;

end.
