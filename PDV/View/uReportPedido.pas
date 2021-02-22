unit uReportPedido;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QuickRpt, ExtCtrls, QRCtrls, DB, Provider, DBClient;

type
  TFrmRelatorioPedido = class(TForm)
    Relatorio: TQuickRep;
    QRBand1: TQRBand;
    QRBand2: TQRBand;
    FaixaListagem: TQRSubDetail;
    QRLabel1: TQRLabel;
    cmpID: TQRDBText;
    cmpCODIGO: TQRDBText;
    cmpDESCRICAO: TQRDBText;
    cmpQUANTIDADE: TQRDBText;
    cmpPRECO: TQRDBText;
    cmpTOTAL: TQRDBText;
    CARRINHO: TClientDataSet;
    PROVEDOR: TDataSetProvider;
    DISTRIBUIDOR: TDataSource;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRDBText1: TQRDBText;
    QRLabel8: TQRLabel;
    QRLabel2: TQRLabel;
    QRDBText2: TQRDBText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmRelatorioPedido: TFrmRelatorioPedido;

implementation

{$R *.dfm}

end.
