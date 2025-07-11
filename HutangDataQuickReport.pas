unit HutangDataQuickReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QuickRpt, QRCtrls, Vcl.ExtCtrls,
  ZAbstractConnection, ZConnection, Data.DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset;

type
  TF_HutangDataQuickReport = class(TForm)
    QuickRep: TQuickRep;
    TitleBand1: TQRBand;
    DetailBand1: TQRBand;
    LabelTitle: TQRLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    QRLabelTanggal: TQRLabel;
    QRLabelNama: TQRLabel;
    QRLabelJenis: TQRLabel;
    QRLabelNominal: TQRLabel;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    ZQuery: TZQuery;
    ZConnection: TZConnection;
    QRLabelJatuhTempo: TQRLabel;
    Shape10: TShape;
    QRDBText5: TQRDBText;
    Shape12: TShape;
  private
    { Private declarations }
    procedure ConnectionSetup;
    procedure QuerySetup(ATanggal: TDateTime);
    procedure DetailBandSetup;
    function RupiahFormat(const Value: string): string;
    procedure RupiahFormatPrint(sender: TObject; var Value: string);

  public
    { Public declarations }
    procedure GenerateReport(ATanggal: TDateTime);


  end;

var
  F_HutangDataQuickReport: TF_HutangDataQuickReport;

implementation

{$R *.dfm}

procedure TF_HutangDataQuickReport.ConnectionSetup;
begin
  ZConnection.HostName := 'localhost';
  ZConnection.Database := 'bayarhutang';
  ZConnection.User := 'root';
  ZConnection.Password := '';
  ZConnection.Protocol := 'mysql';
  ZConnection.Port := 3306;
  ZConnection.Connect;
  ZQuery.Connection := ZConnection;
  QuickRep.DataSet := ZQuery;
end;

procedure TF_HutangDataQuickReport.QuerySetup(ATanggal: TDateTime);
begin
  ZQuery.SQL.Text :=
    'SELECT timestamp, jatuh_tempo, ' +
    'CASE WHEN jenis = 0 THEN ''Hutang'' ELSE ''Piutang'' END AS jenis_str, ' +
    'nominal, nama ' +
    'FROM hutangdata WHERE DATE(timestamp) = :timestamp';
  ZQuery.ParamByName('timestamp').AsDate := ATanggal;
  ZQuery.Open;
end;

procedure TF_HutangDataQuickReport.GenerateReport(ATanggal: TDateTime);
begin
  ConnectionSetup;
  DetailBandSetup;
  QuerySetup(ATanggal);

  if ZQuery.IsEmpty then
  begin
    ShowMessage('Tidak ada data untuk timestamp yang dipilih.');
    Exit;
  end;

  QuickRep.Preview;
end;

procedure TF_HutangDataQuickReport.DetailBandSetup;
begin
  QRDBText1.DataSet := ZQuery;
  QRDBText2.DataSet := ZQuery;
  QRDBText3.DataSet := ZQuery;
  QRDBText4.DataSet := ZQuery;
  QRDBText5.DataSet := ZQuery;
  QRDBText1.DataField := 'timestamp';
  QRDBText2.DataField := 'jatuh_tempo';
  QRDBText3.DataField := 'nama';
  QRDBText4.DataField := 'jenis_str';
  QRDBText5.DataField := 'nominal';
  QRDBText1.Mask := 'd mmmm yyyy';
  QRDBText2.Mask := 'd mmmm yyyy';
  QRDBText5.OnPrint := RupiahFormatPrint;
end;

function TF_HutangDataQuickReport.RupiahFormat(const Value: string): string;
begin
  // Format as Rupiah, no decimals, no comma, with Rp. prefix
  try
    Result := 'Rp. ' + FormatFloat('#,0', StrToFloat(Value));
  except
    Result := 'Rp. ' + Value;
  end;
end;

procedure TF_HutangDataQuickReport.RupiahFormatPrint(sender: TObject; var Value: string);
begin
  Value := RupiahFormat(Value);
end;


end.