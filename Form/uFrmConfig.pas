unit uFrmConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, CPortCtl, CPort, System.Win.Registry, Vcl.Buttons,
  System.IniFiles;

type
  TfrmConfig = class(TForm)
    Label1: TLabel;
    edtWebHomo: TEdit;
    Label2: TLabel;
    edtWebProd: TEdit;
    rdbAmbiente: TRadioGroup;
    ComPort1: TComPort;
    cbComPorts: TComComboBox;
    ComboBoxBaud: TComComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Panel2: TPanel;
    EdtUsuario: TEdit;
    edtSenha: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Panel3: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    edtPluviometro: TEdit;
    edtFluviometro: TEdit;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Panel5: TPanel;
    edtBanco: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    edtUsuarioDB: TEdit;
    edtSenhaDB: TEdit;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    procedure ListarPortasCOM;
    procedure SalvarConfiguracoesSerial;
    procedure CarregarConfiguracoesSerial;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.dfm}

procedure TfrmConfig.BitBtn1Click(Sender: TObject);
begin
  try
    try
      ComPort1.Port := cbComPorts.Text;
      ComPort1.BaudRate := StrToBaudRate(ComboBoxBaud.Text);
      ComPort1.StopBits := sbTwoStopBits;
      ComPort1.DataBits := dbEight;
      ComPort1.Open;
    except
      ShowMessage('Erro Ao Comunicar');
    end;
  finally
    ComPort1.Close;
  end;

end;

procedure TfrmConfig.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmConfig.BitBtn3Click(Sender: TObject);
begin
  SalvarConfiguracoesSerial;
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  ListarPortasCOM;
  CarregarConfiguracoesSerial;
end;

procedure TfrmConfig.ListarPortasCOM;
var
  Reg: TRegistry;
  Lista: TStringList;
  i: Integer;
begin
  cbComPorts.Clear;
  ComboBoxBaud.Items.Clear;
  ComboBoxBaud.Items.Add('110');
  ComboBoxBaud.Items.Add('300');
  ComboBoxBaud.Items.Add('600');
  ComboBoxBaud.Items.Add('1200');
  ComboBoxBaud.Items.Add('2400');
  ComboBoxBaud.Items.Add('4800');
  ComboBoxBaud.Items.Add('9600');
  ComboBoxBaud.Items.Add('14400');
  ComboBoxBaud.Items.Add('19200');
  ComboBoxBaud.Items.Add('38400');
  ComboBoxBaud.Items.Add('56000');
  ComboBoxBaud.Items.Add('57600');
  ComboBoxBaud.Items.Add('115200');
  ComboBoxBaud.Items.Add('128000');
  ComboBoxBaud.Items.Add('256000');

  Reg := TRegistry.Create;
  Lista := TStringList.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('\HARDWARE\DEVICEMAP\SERIALCOMM') then
    begin
      Reg.GetValueNames(Lista);
      for i := 0 to Lista.Count - 1 do
        cbComPorts.Items.Add(Reg.ReadString(Lista[i]));
    end;
  finally
    Reg.Free;
    Lista.Free;
  end;

  if cbComPorts.Items.Count > 0 then
    cbComPorts.ItemIndex := 0;
end;

procedure TfrmConfig.SalvarConfiguracoesSerial;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    Ini.WriteString('Serial', 'Porta', ComPort1.Port);
    Ini.WriteInteger('Serial', 'BaudRate', Ord(ComPort1.BaudRate));
    Ini.WriteInteger('Serial', 'DataBits', Ord(ComPort1.DataBits));
    Ini.WriteInteger('Serial', 'Parity', Ord(ComPort1.Parity.Bits));
    Ini.WriteInteger('Serial', 'StopBits', Ord(ComPort1.StopBits));
    Ini.WriteBool('Serial', 'FlowControl', ComPort1.FlowControl.OutCTSFlow);

    Ini.WriteString('WS', 'EndProd', edtWebProd.Text);
    Ini.WriteString('WS', 'EndHomo', edtWebHomo.Text);
    Ini.WriteInteger('WS', 'Type', rdbAmbiente.ItemIndex);

    Ini.WriteString('Parametros', 'Usuario', EdtUsuario.Text);
    Ini.WriteString('Parametros', 'Senha', edtSenha.Text);
    Ini.WriteString('Parametros', 'Pluviometro', edtPluviometro.Text);
    Ini.WriteString('Parametros', 'Fluiviometro', edtFluviometro.Text);

    Ini.WriteInteger('Config', 'Leitura', 5000);
    Ini.WriteInteger('Config', 'Transmicao', 3600000);

    Ini.WriteString('Banco', 'caminho', edtBanco.Text);
    Ini.WriteString('Banco', 'usuario', edtUsuarioDB.Text);
    Ini.WriteString('Banco', 'senha', edtSenhaDB.Text);
  finally
    Ini.Free;
  end;
end;

procedure TfrmConfig.CarregarConfiguracoesSerial;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    ComPort1.Port := Ini.ReadString('Serial', 'Porta', 'COM1');
    ComPort1.BaudRate := TBaudRate(Ini.ReadInteger('Serial', 'BaudRate',
      Ord(br9600)));
    ComPort1.DataBits := TDataBits(Ini.ReadInteger('Serial', 'DataBits',
      Ord(dbEight)));
    ComPort1.Parity.Bits := TParityBits(Ini.ReadInteger('Serial', 'Parity',
      Ord(prNone)));
    ComPort1.StopBits := TStopBits(Ini.ReadInteger('Serial', 'StopBits',
      Ord(sbOneStopBit)));
    ComPort1.FlowControl.OutCTSFlow := Ini.ReadBool('Serial',
      'FlowControl', False);

    // Parâmetros WebService
    edtWebProd.Text := Ini.ReadString('WS', 'EndProd', '');
    edtWebHomo.Text := Ini.ReadString('WS', 'EndHomo', '');
    rdbAmbiente.ItemIndex := Ini.ReadInteger('WS', 'Type', 0);

    // Parâmetros Gerais
    EdtUsuario.Text := Ini.ReadString('Parametros', 'Usuario', '');
    edtSenha.Text := Ini.ReadString('Parametros', 'Senha', '');
    edtPluviometro.Text := Ini.ReadString('Parametros', 'Pluviometro', '');
    edtFluviometro.Text := Ini.ReadString('Parametros', 'Fluiviometro', '');

    edtBanco.Text :=  Ini.ReadString('Banco', 'caminho', '');
    edtUsuarioDB.Text :=  Ini.ReadString('Banco', 'usuario', '');
    edtSenhaDB.Text :=  Ini.ReadString('Banco', 'senha', '');
  finally
    Ini.Free;
  end;
end;

end.
