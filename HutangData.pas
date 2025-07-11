unit hutangdata;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Menus, 
  Data.DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection,
  ZConnection, HutangDataQuickReport;

type
  TF_HutangData = class(TForm)
    GroupBoxHutangPiutang: TGroupBox;
    ListViewData: TListView;
    LabelJenis: TLabel;
    LabelNama: TLabel;
    ButtonBuat: TButton;
    ButtonHapus: TButton;
    ButtonUbah: TButton;
    ButtonBatal: TButton;
    ButtonKeluar: TButton;
    DateTimePicker: TDateTimePicker;
    LabelCariData: TLabel;
    ButtonPreview: TButton;
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    ButtonSimpan: TButton;
    ComboBoxJenis: TComboBox;
    EditNominal: TEdit;
    LabelNominal: TLabel;
    EditNama: TEdit;
    LabelJatuhTempo: TLabel;
    DateTimePickerJatuhTempo: TDateTimePicker;
    LabelDataHariIni: TLabel;
    
    procedure FormCreate(Sender: TObject);

    
    procedure ButtonBuatClick(Sender: TObject);
    procedure ButtonHapusClick(Sender: TObject);
    procedure ButtonUbahClick(Sender: TObject);
    procedure ButtonBatalClick(Sender: TObject);
    procedure ButtonKeluarClick(Sender: TObject);
    procedure ButtonPreviewClick(Sender: TObject);
    procedure ButtonSimpanClick(Sender: TObject);

    
    procedure ListViewDataItemClick(Sender: TObject; Item: TListItem; Selected: Boolean);

    // sanitasi agar hanya angka yang dapat di input kepada EditNominal
    procedure EditNominalKeyPress(Sender: TObject; var Key: Char);
    
    procedure ConfigureMySQLConnection;
  private
    { Private declarations }
    FMode: string; 
    procedure SetStateAwal;
    procedure SetStateEdit;
    procedure SetStateInputBaru;
    procedure RefreshListView;
    procedure ClearFormFields;
    function RupiahFormat(const Value: string): string;
  public
    { Public declarations }
  end;


var
  F_HutangData: TF_HutangData;

implementation

{$R *.dfm}

function TF_HutangData.RupiahFormat(const Value: string): string;
begin
  // Format as Rupiah, no decimals, no comma, with Rp. prefix
  try
    Result := 'Rp. ' + FormatFloat('#,0', StrToFloat(Value));
  except
    Result := 'Rp. ' + Value;
  end;
end;


procedure TF_HutangData.EditNominalKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TF_HutangData.ClearFormFields;
begin
  ComboBoxJenis.ItemIndex := -1;
  EditNominal.Clear;
  EditNama.Clear;
  DateTimePicker.Date := Now; 
  ListViewData.Selected := nil; 
end;

procedure TF_HutangData.FormCreate(Sender: TObject);
begin
  ConfigureMySQLConnection;
  DateTimePicker.Date := Now;
  EditNama.Clear;
  ComboBoxJenis.Items.Clear;
  ComboBoxJenis.Items.Add('Hutang'); // 0
  ComboBoxJenis.Items.Add('Piutang');   // 1
  ComboBoxJenis.ItemIndex := -1;
  RefreshListView;
  ListViewData.OnSelectItem := ListViewDataItemClick;
  ListViewData.ReadOnly := True; // Prevent editing directly in ListView
  ListViewData.ViewStyle := vsReport;
  ListViewData.RowSelect := True;  
  ButtonBuat.OnClick := ButtonBuatClick;
  ButtonHapus.OnClick := ButtonHapusClick;
  ButtonUbah.OnClick := ButtonUbahClick;
  ButtonBatal.OnClick := ButtonBatalClick;
  ButtonKeluar.OnClick := ButtonKeluarClick;
  ButtonPreview.OnClick := ButtonPreviewClick;
  ButtonSimpan.OnClick := ButtonSimpanClick;
  EditNominal.OnKeyPress := EditNominalKeyPress;
  SetStateAwal;
end;

procedure TF_HutangData.ConfigureMySQLConnection;
begin
  ZConnection.HostName := 'localhost'; 
  ZConnection.Database := 'bayarhutang'; 
  ZConnection.User := 'root'; 
  ZConnection.Password := ''; 
  ZConnection.Protocol := 'mysql'; 
  ZConnection.Port := 3306; 
  ZConnection.Connect;
  ZQuery.Connection := ZConnection;
  if not ZConnection.Connected then
    ShowMessage('Failed to connect to the database.');
end;

procedure TF_HutangData.SetStateAwal;
begin
  ButtonBuat.Enabled := True;
  ButtonSimpan.Enabled := False;
  ButtonUbah.Enabled := False;
  ButtonHapus.Enabled := False;
  ButtonBatal.Enabled := True;
  ButtonKeluar.Enabled := True;
  ButtonPreview.Enabled := True;
  ComboBoxJenis.Enabled := False;
  EditNominal.Enabled := False;
  EditNama.Enabled := False;
  DateTimePickerJatuhTempo.Enabled := False;
  ListViewData.Enabled := True; // Enable ListView for data selection
  ListViewData.Selected := nil; // Clear any selection
  ClearFormFields;
end;

procedure TF_HutangData.SetStateEdit;
begin
  ButtonBuat.Enabled := False;
  ButtonSimpan.Enabled := True;
  ButtonUbah.Enabled := True;
  ButtonHapus.Enabled := True;
  ButtonBatal.Enabled := True;
  ButtonKeluar.Enabled := True;
  ButtonPreview.Enabled := True;
  ComboBoxJenis.Enabled := True;
  EditNominal.Enabled := True;
  EditNama.Enabled := True;
  DateTimePickerJatuhTempo.Enabled := True;
  ListViewData.Enabled := False; // Disable ListView while inputting new data
end;

procedure TF_HutangData.SetStateInputBaru;
begin
  ButtonBuat.Enabled := False;
  ButtonSimpan.Enabled := True;
  ButtonUbah.Enabled := False;
  ButtonHapus.Enabled := False;
  ButtonBatal.Enabled := True;
  ButtonKeluar.Enabled := True;
  ButtonPreview.Enabled := False;
  ComboBoxJenis.Enabled := True;
  EditNominal.Enabled := True;
  EditNama.Enabled := True;
  DateTimePickerJatuhTempo.Enabled := True;
  ListViewData.Selected := nil; 
  ListViewData.Enabled := False; // Disable ListView while inputting new data
  ClearFormFields;
end;

// REVISI
procedure TF_HutangData.RefreshListView;
begin
  ListViewData.Clear;
  ZQuery.SQL.Text := 'SELECT * FROM hutangdata ORDER BY timestamp DESC';
  ZQuery.Open;
  while not ZQuery.Eof do
  begin
    with ListViewData.Items.Add do
    begin
      Caption := FormatDateTime('d mmmm yyyy', ZQuery.FieldByName('timestamp').AsDateTime);
      SubItems.Add(FormatDateTime('d mmmm yyyy', ZQuery.FieldByName('jatuh_tempo').AsDateTime));
      SubItems.Add(ZQuery.FieldByName('nama').AsString);
      if ZQuery.FieldByName('jenis').AsInteger = 0 then
        SubItems.Add('Hutang')
      else
        SubItems.Add('Piutang');
      SubItems.Add(RupiahFormat(ZQuery.FieldByName('nominal').AsString));
      Data := Pointer(ZQuery.FieldByName('id_hutang').AsInteger);
    end;
    ZQuery.Next;
  end;
  ZQuery.Close;
end;

procedure TF_HutangData.ButtonBuatClick(Sender: TObject);
begin
  FMode := 'create';
  SetStateInputBaru;
end;

procedure TF_HutangData.ButtonSimpanClick(Sender: TObject);
var
  jenisTransaksi: Integer;
begin
  if (ComboBoxJenis.ItemIndex = -1) or
     (EditNominal.Text = '') or
     (EditNama.Text = '') then
  begin
    ShowMessage('Silakan lengkapi semua data yang wajib diisi.');
    Exit;
  end;
  if not ZConnection.Connected then
  begin
    ShowMessage('Koneksi ke database belum berhasil.');
    Exit;
  end;
  jenisTransaksi := ComboBoxJenis.ItemIndex; // 0: Hutang, 1: Piutang
  try
    if FMode = 'create' then
    begin
      ZQuery.SQL.Text := 'INSERT INTO hutangdata (timestamp, jatuh_tempo, jenis, nama, nominal) VALUES (NOW(), :jatuh_tempo, :jenis, :nama, :nominal)';
      ZQuery.ParamByName('jatuh_tempo').AsDateTime := DateTimePickerJatuhTempo.DateTime;
      ZQuery.ParamByName('jenis').AsInteger := jenisTransaksi;
      ZQuery.ParamByName('nama').AsString := EditNama.Text;
      ZQuery.ParamByName('nominal').AsString := EditNominal.Text;
      ZQuery.ExecSQL;
      ShowMessage('Data keuangan berhasil ditambahkan.');
    end
    else if (FMode = 'edit') and (ListViewData.Selected <> nil) then
    begin
      ZQuery.SQL.Text := 'UPDATE hutangdata SET jenis = :jenis, nama = :nama, nominal = :nominal WHERE id_hutang = :id_hutang';
      ZQuery.ParamByName('jenis').AsInteger := jenisTransaksi;
      ZQuery.ParamByName('nama').AsString := EditNama.Text;
      ZQuery.ParamByName('nominal').AsString := EditNominal.Text;
      ZQuery.ParamByName('id_hutang').AsInteger := Integer(ListViewData.Selected.Data);
      ZQuery.ExecSQL;
      ShowMessage('Data keuangan berhasil diubah.');
    end;
    RefreshListView;
    SetStateAwal;
    FMode := '';
  except
    on E: Exception do
      ShowMessage('Gagal menyimpan data keuangan: ' + E.Message);
  end;
end;

procedure TF_HutangData.ButtonHapusClick(Sender: TObject);
begin
  
  if ListViewData.Selected = nil then
  begin
    ShowMessage('Silakan pilih data keuangan yang ingin dihapus.');
    Exit;
  end;

  if not ZConnection.Connected then
  begin
    ShowMessage('Koneksi ke database belum berhasil.');
    Exit;
  end;

  if MessageDlg('Apakah Anda yakin ingin menghapus data ini?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      ZQuery.SQL.Text := 'DELETE FROM hutangdata WHERE id_hutang = :id';
      ZQuery.ParamByName('id').AsInteger := Integer(ListViewData.Selected.Data);
      ZQuery.ExecSQL;
      ShowMessage('Data keuangan berhasil dihapus.');
      RefreshListView;
      SetStateAwal;
    except
      on E: Exception do
        ShowMessage('Gagal menghapus data keuangan: ' + E.Message);
    end;
  end;
end;

procedure TF_HutangData.ButtonUbahClick(Sender: TObject);
begin
  if ListViewData.Selected = nil then
  begin
    ShowMessage('Silakan pilih data keuangan yang ingin diubah.');
    Exit;
  end;
  FMode := 'edit';
  SetStateEdit;
end;

procedure TF_HutangData.ButtonPreviewClick(Sender: TObject);
var
  LFinanceReport: TF_HutangDataQuickReport;
begin
  LFinanceReport := TF_HutangDataQuickReport.Create(Self);
  try
    LFinanceReport.GenerateReport(DateTimePicker.Date);
  finally
    LFinanceReport.Free;
  end;
end;

procedure TF_HutangData.ListViewDataItemClick(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  
  if Selected then
  begin
    if Item.SubItems[2] = 'Hutang' then
      ComboBoxJenis.ItemIndex := 0
    else if Item.SubItems[2] = 'Piutang' then
      ComboBoxJenis.ItemIndex := 1
    else
      ComboBoxJenis.ItemIndex := -1;
    EditNama.Text := Item.SubItems[1];
    EditNominal.Text := Item.SubItems[2];
    ButtonUbah.Enabled := True;
    ButtonHapus.Enabled := True;
  end
  else
  begin
    ButtonUbah.Enabled := False;
    ButtonHapus.Enabled := False;
  end;
end;

procedure TF_HutangData.ButtonBatalClick(Sender: TObject);
begin  
  ClearFormFields;
  SetStateAwal;
end;

procedure TF_HutangData.ButtonKeluarClick(Sender: TObject);
begin  
  Application.Terminate;
end;

end.