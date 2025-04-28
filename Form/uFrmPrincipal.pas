unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.Menus, Data.DB, Vcl.Grids, Vcl.DBGrids, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, uDtmConnection,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.WinXPickers, DateUtils, System.ImageList,
  Vcl.ImgList, Vcl.Buttons, uFrmImportFile, System.IniFiles, uFrmConfig,
  uTransmicao;

type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Grid: TDBGrid;
    Qry: TZQuery;
    DataSource1: TDataSource;
    Label1: TLabel;
    cbmSend: TComboBox;
    dtpInitial: TDateTimePicker;
    dtpFinal: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    bntInportFile: TBitBtn;
    ImageList1: TImageList;
    QryID: TZIntegerField;
    QryDATA: TZDateField;
    QryHORA: TZTimeField;
    QryFLUVIOMETRO: TZIntegerField;
    QryPLUVIOMETRO: TZIntegerField;
    QryCREATED_AT: TZDateTimeField;
    QryUPDATED_AT: TZDateTimeField;
    QryENVIADO: TZBooleanField;
    QryDATA_ENVIO: TZDateTimeField;
    QryRETORNO: TZUnicodeStringField;
    btnReload: TBitBtn;
    btnSendWs: TBitBtn;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure cbmSendChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dtpInitialChange(Sender: TObject);
    procedure dtpFinalChange(Sender: TObject);
    procedure bntInportFileClick(Sender: TObject);
    procedure btnReloadClick(Sender: TObject);
    procedure btnSendWsClick(Sender: TObject);
    procedure GridTitleClick(Column: TColumn);
  private
    uTransmicao: TTransmicao;
    { Private declarations }
    SQL, sSQL, sSendSQL, sDateSQL: String;
    IndiceAtual: string;
    procedure filterSendQry();
    procedure filterDataQry();

    procedure CreateConnection(dtmConnection: TdtmConnection);
  public
    { Public declarations }
    procedure filterQry();
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}
{$REGION('FORM')}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  now: TDateTime;
begin
  dtmConnection := TdtmConnection.Create(Self);
  CreateConnection(dtmConnection);

  now := Date.now;
  SQL := 'select id, data, hora, fluviometro, pluviometro, created_at, updated_at, enviado, data_envio, retorno from medidas';
  dtpInitial.DateTime := StartOfTheMonth(now);
  dtpFinal.DateTime := EndOfTheMonth(now);
  IndiceAtual := 'id';
  Self.filterQry;
  Qry.Open;
end;

procedure TfrmPrincipal.CreateConnection(dtmConnection: TdtmConnection);
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

procedure TfrmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Application.MessageBox(pchar('Você realmente deseja sair do programa?'),
    pchar('Aviso:'), MB_YESNO) = mrNo then
  begin
    CanClose := False;
    Self.Hide;
  end;
end;
{$ENDREGION}
{$REGION('FILTERS QUERY')}

procedure TfrmPrincipal.filterSendQry();
begin
  var
    search, filter: String;
  begin

    filter := cbmSend.Text;
    if filter = 'Sim' then
    begin
      search := ' enviado = true';
    end;

    if filter = 'Não' then
    begin
      search := ' enviado = false';
    end;

    if not search.IsEmpty then
    begin
      if Pos('WHERE', sSQL) <> 0 then
      begin
        sSendSQL := ' AND ' + search;
      end
      else
      begin
        sSendSQL := ' WHERE ' + search;
      end;
    end
    else
    begin
      sSendSQL := sSendSQL.Empty;
    end;

  end;

  sSQL := sSQL + sSendSQL;
end;

procedure TfrmPrincipal.filterDataQry;
var
  sqlWhere, sqlFild, dateIni, dateFim: String;

begin

  dateIni := YearOf(dtpInitial.DateTime).ToString + '-' +
    MonthOf(dtpInitial.DateTime).ToString + '-' +
    DayOf(dtpInitial.DateTime).ToString;

  dateFim := YearOf(dtpFinal.DateTime).ToString + '-' +
    MonthOf(dtpFinal.DateTime).ToString + '-' +
    DayOf(dtpFinal.DateTime).ToString;

  if cbmSend.Text = 'Sim' then
  begin
    sqlFild := ' data_envio ';
  end
  else
  begin
    sqlFild := ' data ';
  end;

  sqlWhere := sqlFild + ' BETWEEN ' + QuotedStr(dateIni) + ' AND ' +
    QuotedStr(dateFim) + ' ';

  if Pos('WHERE', sSQL) <> 0 then
  begin
    sDateSQL := ' AND ' + sqlWhere;
  end
  else
  begin
    sDateSQL := ' WHERE ' + sqlWhere;
  end;

  sSQL := sSQL + sDateSQL;
end;

procedure TfrmPrincipal.filterQry;
begin
  try
    Qry.Active := False;
    Qry.SQL.Clear;
    sSQL := SQL;
    Self.filterSendQry;
    Self.filterDataQry;
    Qry.SQL.Text := sSQL;
    Qry.IndexFieldNames := IndiceAtual;
    Qry.Active := True;
  except
    ShowMessage('Erro ao fazer pesquisa');
  end;
end;
{$ENDREGION}
{$REGION('ONCHANGE')}

procedure TfrmPrincipal.bntInportFileClick(Sender: TObject);
begin
  frmImportFile := TfrmImportFile.Create(Self);
  frmImportFile.ShowModal;

  if Assigned(frmImportFile) then
    frmImportFile.FreeOnRelease;
end;

procedure TfrmPrincipal.btnReloadClick(Sender: TObject);
begin
  Qry.CommitUpdates;
  Qry.Refresh;
end;

procedure TfrmPrincipal.btnSendWsClick(Sender: TObject);
begin
  ShowMessage
    ('Transmitindo as informações, Aguarde até a mensagem de confirmação.');
  uTransmicao := TTransmicao.Create(dtmConnection.Connection);
  uTransmicao.ProcessarEnvioMedicoes();
  ShowMessage('Transmição concluida com sucesso.');
  Self.filterQry;
end;

procedure TfrmPrincipal.cbmSendChange(Sender: TObject);
begin
  Self.filterQry;
end;

procedure TfrmPrincipal.dtpFinalChange(Sender: TObject);
begin
  Self.filterQry;
end;

procedure TfrmPrincipal.dtpInitialChange(Sender: TObject);
begin
  Self.filterQry;
end;

{$ENDREGION}

procedure TfrmPrincipal.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
Var
  S: String;
  aRect: TRect;
begin
  aRect := Rect;
  if Column.FieldName = 'ENVIADO' then
  begin

    if Column.Field.AsBoolean then
    begin
      Grid.Canvas.FillRect(Rect);
      DrawText(Grid.Canvas.Handle, pchar('Sim'), Length('Sim'), aRect,
        DT_SINGLELINE or DT_LEFT or DT_VCENTER);
    end
    else if Column.Field.AsBoolean = False then
    begin
      Grid.Canvas.FillRect(Rect);
      DrawText(Grid.Canvas.Handle, pchar('Não'), Length('Não'), aRect,
        DT_SINGLELINE or DT_LEFT or DT_VCENTER);
    end;

  end;

end;

procedure TfrmPrincipal.GridTitleClick(Column: TColumn);
begin
  IndiceAtual := Column.FieldName;
  Qry.IndexFieldNames := IndiceAtual;
end;

end.
