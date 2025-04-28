unit uDtmConnection;

interface

uses
  System.SysUtils, System.Classes, ZAbstractConnection, ZConnection,
  System.IniFiles, uFrmConfig, Vcl.Dialogs, Vcl.Forms;

type
  TdtmConnection = class(TDataModule)
    Connection: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }

    sBanco: String;
    sUserDB: String;
    sSenhaDB: String;
  end;

var
  dtmConnection: TdtmConnection;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TdtmConnection.DataModuleCreate(Sender: TObject);
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
      on E: Exception do
        ShowMessage('Erro: ' + E.Message);
    end;
  finally
    Ini.Free;
  end;
end;

end.
