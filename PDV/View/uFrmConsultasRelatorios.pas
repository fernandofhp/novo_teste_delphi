unit uFrmConsultasRelatorios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, Calendar, DB, DBClient, DBGrids;

type
  TFrmConultasRelatorios = class(TForm)
    Panel5: TPanel;
    StaticText3: TStaticText;
    edVendedorChave: TEdit;
    StaticText4: TStaticText;
    Panel6: TPanel;
    StaticText6: TStaticText;
    edClienteChave: TEdit;
    StaticText7: TStaticText;
    btnClientes: TBitBtn;
    Panel7: TPanel;
    Image4: TImage;
    StaticText10: TStaticText;
    btnProdutos: TBitBtn;
    Panel1: TPanel;
    CalendarioInicio: TCalendar;
    CalendarioFim: TCalendar;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DADOS: TClientDataSet;
    dsDADOS: TDataSource;
    Panel8: TPanel;
    btnFechar: TBitBtn;
    btnVendedores: TBitBtn;
    DBGrid1: TDBGrid;
    procedure btnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    procedure InicializarConfiguracoes;
    procedure ConsultarPedidosPorVendedor;
    procedure ConsultarProdutosPorCliente;
    procedure ConsultarProdutosMaisVendidos;
  public
    { Public declarations }
  end;

var
  FrmConultasRelatorios: TFrmConultasRelatorios;

implementation

uses uControladorPedido, uControladorProduto, uControladorCliente,
  uFrmRelatorioPorVendedor;
{$R *.dfm}

procedure TFrmConultasRelatorios.BitBtn1Click(Sender: TObject);
begin
  ConsultarPedidosPorVendedor;
  FrmRelatorioPorVendedor.DADOS.Data := DADOS.Data;
  FrmRelatorioPorVendedor.Relatorio.Prepare;
  FrmRelatorioPorVendedor.Relatorio.Preview;
end;

procedure TFrmConultasRelatorios.btnFecharClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmConultasRelatorios.ConsultarPedidosPorVendedor;
var
  Motor: TControladorPedido;
  Chave: string;
begin
  Motor := TControladorPedido.Create;
  try
    Motor.Inicio := CalendarioInicio.CalendarDate;
    Motor.Fim := CalendarioFim.CalendarDate;
    Motor.PesquisarPor := porVendedor;
    Chave := edVendedorChave.Text;
    Motor.Pesquisar(Chave, DADOS);
  finally
    FreeAndNil(Motor);
  end;
end;

procedure TFrmConultasRelatorios.ConsultarProdutosMaisVendidos;
begin

end;

procedure TFrmConultasRelatorios.ConsultarProdutosPorCliente;
begin

end;

procedure TFrmConultasRelatorios.FormShow(Sender: TObject);
begin
  InicializarConfiguracoes;
end;

procedure TFrmConultasRelatorios.InicializarConfiguracoes;
begin
  CalendarioInicio.CalendarDate := Now;
  CalendarioFim.CalendarDate := Now + 7;
end;

end.
