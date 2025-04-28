object dtmConnection: TdtmConnection
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object Connection: TZConnection
    ControlsCodePage = cCP_UTF16
    ClientCodepage = 'WIN1252'
    Catalog = ''
    Properties.Strings = (
      'RawStringEncoding=DB_CP'
      'codepage=WIN1252')
    SQLHourGlass = True
    DisableSavepoints = False
    HostName = ''
    Port = 3050
    Database = 'C:\CLP\Dados\DADOS.FDB'
    User = 'SYSDBA'
    Password = 'master'
    Protocol = 'firebird'
    Left = 40
    Top = 32
  end
end
