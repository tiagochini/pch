unit uDtmPrincipal;

interface

uses
  System.SysUtils, System.Classes, Vcl.Menus, Vcl.Forms, Vcl.ExtCtrls,
  ZAbstractConnection,
  ZConnection, uFrmConfig, CPort, uFrmPrincipal, System.IniFiles, DB, DateUtils,
  inserirMedicoesHomologacao, inserirMedicoesProducao, SoapHTTPClient,
  System.JSON, Vcl.Dialogs, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  uDtmConnection, Windows, uClassMedidas, uTransmicao;

type
  TdtmPrincipal = class(TDataModule)

    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Configurar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Timer1: TTimer;
    ComPort1: TComPort;
    tmrCLP: TTimer;
    tmrWebService: TTimer;
    tmrTimeout: TTimer;
    tmrIniti: TTimer;
    procedure Sair1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure Configurar1Click(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure tmrWebServiceTimer(Sender: TObject);
    procedure tmrCLPTimer(Sender: TObject);
    procedure tmrTimeoutTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure tmrInitiTimer(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
  private
    sWebProd: String;
    sWebHomo: String;
    iAmbiente: Int32;
    sUsuario: String;
    sSenha: String;
    sPluviometro: String;
    sFluviometro: String;

    FBufferRx: TBytes;
    FUltimaRecepcao: TDateTime;
    oMedidas: TMedidas;
    uTransmicao: TTransmicao;

    { Private declarations }
    procedure CarregarConfiguracoesSerial;
    procedure EnviarLeituraRegistradores;
    function CalcularCRC(const Dados: TBytes): Word;
    procedure CreateConnection(dtmConnection: TdtmConnection);
  public
    { Public declarations }

    sBanco: String;
    sUserDB: String;
    sSenhaDB: String;
  end;

var
  dtmPrincipal: TdtmPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TdtmPrincipal.ComPort1RxChar(Sender: TObject; Count: Integer);
var
  Buffer: array [0 .. 255] of Byte;
  i: Integer;
  Reg1, Reg2: Word;
  BytesRead: Integer;
  HexStr, MsgTraduzida: string;
begin
  // Lê os dados brutos como bytes
  BytesRead := ComPort1.Read(Buffer, Count);

  // Converte para string hexadecimal (opcional, só para debug)
  HexStr := '';
  for i := 0 to BytesRead - 1 do
    HexStr := HexStr + IntToHex(Buffer[i], 2) + ' ';

  // Verifica se tem pelo menos os 7 bytes esperados
  if BytesRead >= 7 then
  begin
    // Extrai os registradores (assumindo resposta padrão 01 03 04 XX XX YY YY CRC)
    Reg1 := (Buffer[3] shl 8) or Buffer[4]; // Primeiro registrador
    Reg2 := (Buffer[5] shl 8) or Buffer[6]; // Segundo registrador
    oMedidas := TMedidas.Create(dtmConnection.Connection);
    oMedidas.InserirMedicao(Reg1, Reg2);
    if Assigned(oMedidas) then
      FreeAndNil(oMedidas);
    // Cria mensagem traduzida

    frmPrincipal.filterQry;
  end;

end;

procedure TdtmPrincipal.Configurar1Click(Sender: TObject);
begin
  frmConfig := TfrmConfig.Create(Self);
  frmConfig.Show;
end;

procedure TdtmPrincipal.DataModuleCreate(Sender: TObject);
begin
  dtmConnection := TdtmConnection.Create(Self);
  CreateConnection(dtmConnection);
  CarregarConfiguracoesSerial;
end;

procedure TdtmPrincipal.CreateConnection(dtmConnection: TdtmConnection);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    try
      dtmConnection.sBanco := Ini.ReadString('Banco', 'caminho', '');
      dtmConnection.sUserDB := Ini.ReadString('Banco', 'usuario', '');
      dtmConnection.sSenhaDB := Ini.ReadString('Banco', 'senha', '');

      dtmConnection.Connection.Database := dtmConnection.sBanco;
      dtmConnection.Connection.User := dtmConnection.sUserDB;
      dtmConnection.Connection.Password := dtmConnection.sSenhaDB;
      dtmConnection.Connection.Connect;
    except
      frmConfig := TfrmConfig.Create(Self);
      frmConfig.ShowModal;

      if Assigned(frmConfig) then
        FreeAndNil(frmConfig);
    end;
  finally
    Ini.Free;
  end;
end;

procedure TdtmPrincipal.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(frmConfig) then
    FreeAndNil(frmConfig);

  if ComPort1.Connected then
    ComPort1.Close;

end;

procedure TdtmPrincipal.Sair1Click(Sender: TObject);
begin
  frmPrincipal.Close;
end;

procedure TdtmPrincipal.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  frmPrincipal.Hide;
  frmPrincipal.Qry.Connection := dtmConnection.Connection;
  frmPrincipal.filterQry;
end;

procedure TdtmPrincipal.tmrCLPTimer(Sender: TObject);
begin
  if Length(FBufferRx) > 0 then
    Exit;

  if not(ComPort1.Connected) then
  begin
    ComPort1.Open;
  end;

  if ComPort1.Connected then
  begin
    EnviarLeituraRegistradores;
  end;
end;

procedure TdtmPrincipal.tmrInitiTimer(Sender: TObject);
begin
  if dtmConnection.Connection.Connected then
  begin
    tmrCLP.Enabled := True;
    if iAmbiente = 0 then
    begin
      tmrWebService.Enabled := True;
    end;

  end;
end;

procedure TdtmPrincipal.tmrTimeoutTimer(Sender: TObject);
begin
  if (Length(FBufferRx) > 0) and (SecondsBetween(Now, FUltimaRecepcao) > 2) then
  begin
    ShowMessage('Timeout na resposta do CLP');
    FBufferRx := nil;
  end;
end;

procedure TdtmPrincipal.tmrWebServiceTimer(Sender: TObject);
begin
  uTransmicao := TTransmicao.Create(dtmConnection.Connection);
  uTransmicao.ProcessarEnvioMedicoes();

  if Assigned(uTransmicao) then
    FreeAndNil(uTransmicao);
end;

procedure TdtmPrincipal.TrayIcon1DblClick(Sender: TObject);
begin
  frmPrincipal.Show;
end;

procedure TdtmPrincipal.CarregarConfiguracoesSerial;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    ComPort1.Port := Ini.ReadString('Serial', 'Porta', 'COM1');

    // Parâmetros WebService
    sWebProd := Ini.ReadString('WS', 'EndProd', '');
    sWebHomo := Ini.ReadString('WS', 'EndHomo', '');
    iAmbiente := Ini.ReadInteger('WS', 'Type', 0);

    // Parâmetros Gerais
    sUsuario := Ini.ReadString('Parametros', 'Usuario', '');
    sSenha := Ini.ReadString('Parametros', 'Senha', '');
    sPluviometro := Ini.ReadString('Parametros', 'Pluviometro', '');
    sFluviometro := Ini.ReadString('Parametros', 'Fluiviometro', '');

    // Temporizações
    tmrCLP.Interval := Ini.ReadInteger('Config', 'Leitura', 5000);
    tmrWebService.Interval := Ini.ReadInteger('Config', 'Transmicao', 3600000);

    sBanco := Ini.ReadString('Banco', 'caminho', '');
    sUserDB := Ini.ReadString('Banco', 'usuario', '');
    sSenhaDB := Ini.ReadString('Banco', 'senha', '');
  finally
    Ini.Free;
  end;
end;

procedure TdtmPrincipal.EnviarLeituraRegistradores;
var
  Bytes: TBytes;
  i: Integer;
  ByteStr, HexComando: string;
begin
  HexComando := '01 03 00 13 00 02 35 CE';
  // Converte string tipo "01 03 00 13 00 02 35 CE" em array de bytes
  ByteStr := StringReplace(HexComando, ' ', '', [rfReplaceAll]);
  SetLength(Bytes, Length(ByteStr) div 2);

  for i := 0 to Length(Bytes) - 1 do
    Bytes[i] := StrToInt('$' + Copy(ByteStr, i * 2 + 1, 2));

  ComPort1.Write(Bytes[0], Length(Bytes));
end;

function TdtmPrincipal.CalcularCRC(const Dados: TBytes): Word;
var
  i, j: Integer;
  CRC: Word;
begin
  CRC := $FFFF;
  for i := 0 to High(Dados) do
  begin
    CRC := CRC xor Dados[i];
    for j := 0 to 7 do
    begin
      if (CRC and $0001) <> 0 then
        CRC := (CRC shr 1) xor $A001
      else
        CRC := CRC shr 1;
    end;
  end;
  Result := CRC;
end;

end.
