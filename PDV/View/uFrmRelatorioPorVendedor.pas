unit uFrmRelatorioPorVendedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, QuickRpt, QRCtrls, DB, DBClient;

type
  TFrmRelatorioPorVendedor = class(TForm)
    Relatorio: TQuickRep;
    QRBand1: TQRBand;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel1: TQRLabel;
    FaixaListagem: TQRSubDetail;
    cmpCODIGO: TQRDBText;
    cmpDESCRICAO: TQRDBText;
    cmpQUANTIDADE: TQRDBText;
    cmpTOTAL: TQRDBText;
    DADOS: TClientDataSet;
    QRLabel2: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmRelatorioPorVendedor: TFrmRelatorioPorVendedor;

implementation

{$R *.dfm}

end.
