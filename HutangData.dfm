object F_HutangData: TF_HutangData
  Left = 0
  Top = 0
  Caption = 'Bayar Hutang'
  ClientHeight = 541
  ClientWidth = 884
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object GroupBoxHutangPiutang: TGroupBox
    Left = 11
    Top = 8
    Width = 865
    Height = 521
    Caption = 'Hutang Piutang'
    TabOrder = 0
    object LabelJenis: TLabel
      Left = 15
      Top = 31
      Width = 25
      Height = 15
      Caption = 'Jenis'
    end
    object LabelNama: TLabel
      Left = 15
      Top = 61
      Width = 32
      Height = 15
      Caption = 'Nama'
    end
    object LabelNominal: TLabel
      Left = 15
      Top = 92
      Width = 46
      Height = 15
      Caption = 'Nominal'
    end
    object LabelCariData: TLabel
      Left = 543
      Top = 18
      Width = 48
      Height = 15
      Caption = 'Cari Data'
    end
    object LabelJatuhTempo: TLabel
      Left = 15
      Top = 122
      Width = 68
      Height = 15
      Caption = 'Jatuh Tempo'
    end
    object LabelDataHariIni: TLabel
      Left = 15
      Top = 155
      Width = 65
      Height = 15
      Caption = 'Data Hari Ini'
    end
    object ListViewData: TListView
      Left = 15
      Top = 176
      Width = 834
      Height = 329
      Columns = <
        item
          AutoSize = True
          Caption = 'Tanggal'
        end
        item
          AutoSize = True
          Caption = 'Tanggal Jatuh Tempo'
        end
        item
          AutoSize = True
          Caption = 'Nama'
        end
        item
          AutoSize = True
          Caption = 'Jenis'
        end
        item
          AutoSize = True
          Caption = 'Nominal'
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 10
      TabStop = False
      ViewStyle = vsReport
    end
    object ButtonBuat: TButton
      Left = 340
      Top = 27
      Width = 75
      Height = 23
      Caption = 'Buat'
      TabOrder = 2
    end
    object ButtonHapus: TButton
      Left = 340
      Top = 58
      Width = 75
      Height = 23
      Caption = 'Hapus'
      TabOrder = 4
    end
    object ButtonUbah: TButton
      Left = 421
      Top = 27
      Width = 75
      Height = 23
      Caption = 'Ubah'
      TabOrder = 3
    end
    object ButtonBatal: TButton
      Left = 421
      Top = 58
      Width = 75
      Height = 23
      Caption = 'Batal'
      TabOrder = 5
    end
    object ButtonKeluar: TButton
      Left = 421
      Top = 89
      Width = 75
      Height = 23
      Caption = 'Keluar'
      TabOrder = 7
    end
    object ButtonSimpan: TButton
      Left = 340
      Top = 89
      Width = 75
      Height = 23
      Caption = 'Simpan'
      TabOrder = 6
    end
    object ComboBoxJenis: TComboBox
      Left = 127
      Top = 28
      Width = 185
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object EditNominal: TEdit
      Left = 127
      Top = 89
      Width = 185
      Height = 23
      TabOrder = 1
    end
    object ButtonPreview: TButton
      Left = 744
      Top = 39
      Width = 96
      Height = 25
      Caption = 'Preview'
      TabOrder = 9
    end
    object DateTimePicker: TDateTimePicker
      Left = 543
      Top = 39
      Width = 186
      Height = 25
      Date = 45838.000000000000000000
      Format = 'dd-MMMM-yyyy'
      Time = 0.986119849534588900
      TabOrder = 8
    end
    object EditNama: TEdit
      Left = 127
      Top = 58
      Width = 185
      Height = 23
      TabOrder = 11
    end
    object DateTimePickerJatuhTempo: TDateTimePicker
      Left = 127
      Top = 118
      Width = 185
      Height = 25
      Date = 45838.000000000000000000
      Format = 'dd-MMMM-yyyy'
      Time = 0.986119849534588900
      TabOrder = 12
    end
  end
  object ZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    DisableSavepoints = False
    HostName = ''
    Port = 0
    Database = ''
    User = ''
    Password = ''
    Protocol = ''
    Left = 608
    Top = 88
  end
  object ZQuery: TZQuery
    Params = <>
    Left = 560
    Top = 88
  end
end
