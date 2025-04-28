unit uTransmicao;

interface

uses
  inserirMedicoesHomologacao,
  inserirMedicoesProducao,
  SOAPHTTPTrans,
  System.JSON,
  System.DateUtils,
  System.Classes,
  System.SysUtils,
  System.IniFiles,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  ZAbstractConnection,
  ZConnection,
  ZAbstractRODataset,
  ZAbstractDataset,
  ZDataset, uProducao, uHomologacao;

type
  TTransmicao = class
  private
    ConnectionDB: TZConnection;
    sFluviometro: String;
    sPluviometro: String;
    sUsuario: String;
    sSenha: String;
    sWebProd: String;
    sWebHomo: String;
    iAmbiente: Integer;
    oProducao: TProducao;
    oHomologacao: THomologacao;

    procedure CarregarConfiguracoes;

  public
    constructor Create(aConnectionDB: TZConnection);
    destructor Destroy; override;

    procedure ProcessarEnvioMedicoes(showMessage: Boolean = False);

  published
    // publish properties;
  end;

implementation

procedure TTransmicao.ProcessarEnvioMedicoes(showMessage: Boolean = False);
begin

  if iAmbiente = 0 then
  begin
    oProducao := TProducao.Create(ConnectionDB, sFluviometro, sPluviometro,
      sUsuario, sSenha);
    try
      oProducao.ProcessarEnvioMedicoes(showMessage);
    finally
      if Assigned(oProducao) then
        FreeAndNil(oProducao);
    end;
  end
  else
  begin
    oHomologacao := THomologacao.Create(ConnectionDB, sFluviometro,
      sPluviometro, sUsuario, sSenha);
    try
      oHomologacao.ProcessarEnvioMedicoes(showMessage);
    finally
      if Assigned(oHomologacao) then
        FreeAndNil(oHomologacao);
    end;
  end;
end;

{$REGION 'Contructor and Destruction'}

constructor TTransmicao.Create(aConnectionDB: TZConnection);
begin
  ConnectionDB := aConnectionDB;
  CarregarConfiguracoes;
end;

destructor TTransmicao.Destroy;
begin

  inherited;
end;
{$ENDREGION}
{$REGION 'Configurações'}

procedure TTransmicao.CarregarConfiguracoes;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    // Parâmetros WebService
    sWebProd := Ini.ReadString('WS', 'EndProd', '');
    sWebHomo := Ini.ReadString('WS', 'EndHomo', '');
    iAmbiente := Ini.ReadInteger('WS', 'Type', 0);

    // Parâmetros Gerais
    sUsuario := Ini.ReadString('Parametros', 'Usuario', '');
    sSenha := Ini.ReadString('Parametros', 'Senha', '');
    sPluviometro := Ini.ReadString('Parametros', 'Pluviometro', '');
    sFluviometro := Ini.ReadString('Parametros', 'Fluiviometro', '');
  finally
    Ini.Free;
  end;
end;
{$ENDREGION}

end.
