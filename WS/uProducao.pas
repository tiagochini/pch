unit uProducao;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  Vcl.Dialogs,
  SOAPHTTPTrans,
  System.JSON,
  inserirMedicoesProducao,
  ZAbstractConnection,
  ZConnection,
  ZAbstractRODataset,
  ZAbstractDataset,
  ZDataset, uClassMedidas, uClassLogs;

type
  TProducao = class
  private
    ConnectionDB: TZConnection;
    oMedidas: TMedidas;
    oLogs: TLogs;
    sFluviometro: String;
    sPluviometro: String;
    sUsuario: String;
    sSenha: String;

    function CarregarMedicoesPendentes: Array_Of_medicaoTO;
    function CriarEstacaoComMedicoes(const CodigoFlu, CodigoPlu: string;
      const Medicoes: Array_Of_medicaoTO): estacaoTO;
    function EnviarMedicoesSOAP(const Usuario, Senha: string;
      const Estacoes: Array_Of_estacaoTO): retornoService;
    procedure RegistrarLogEnvio(const Tipo, Mensagem: String;
      const Medicoes: Array_Of_medicaoTO);
    procedure MarcarMedicoesComoEnviadasPorDataMedicao(const medicoesInseridas
      : Array_Of_estacaoTO; const RetornoMensagem: String);

  public
    constructor Create(aConnectionDB: TZConnection;
      fluviometro, pluviometro, Usuario, Senha: String);
    destructor Destroy; override;

    procedure ProcessarEnvioMedicoes(showMessage: Boolean = False);

  published
    // publish properties;
  end;

implementation

{$REGION 'Contructor and Destruction'}

constructor TProducao.Create(aConnectionDB: TZConnection;
  fluviometro, pluviometro, Usuario, Senha: String);
begin
  ConnectionDB := aConnectionDB;
  sFluviometro := fluviometro;
  sPluviometro := pluviometro;
  sUsuario := Usuario;
  sSenha := Senha;
end;

destructor TProducao.Destroy;
begin

  inherited;
end;
{$ENDREGION}

function TProducao.CarregarMedicoesPendentes: Array_Of_medicaoTO;
var
  Lista: Array_Of_medicaoTO;
  dados: TMedidasArray;
  oMedidas: TMedidas;
  medicao: medicaoTO;
  DataHora: TDateTime;
  i: Integer;
begin
  SetLength(Lista, 0); // Inicializa o array vazio
  try
    oMedidas := TMedidas.Create(ConnectionDB);
    dados := oMedidas.FindNotSend; // Agora é um array de TMedidas

    // Percorre o array
    for i := Low(dados) to High(dados) do
    begin
      // Aumenta o tamanho do array para adicionar uma nova medição
      SetLength(Lista, Length(Lista) + 1);

      medicao := medicaoTO.Create;

      // Montar data completa no formato ISO 8601
      DataHora := dados[i].data + dados[i].hora;
      medicao.dataMedicao := FormatDateTime('dd"/"mm"/"yyyy" "hh:nn:ss',
        DataHora);

      // Atribuir valores de nível, chuva e vazão
      medicao.nivel := dados[i].fluviometro;
      medicao.chuva := dados[i].pluviometro;
      medicao.vazao := 0; // ou conforme sua lógica

      // Atribuindo medição ao array
      Lista[High(Lista)] := medicao; // coloca no final
    end;

  finally
    oMedidas.Free; // Libera o objeto oMedidas
  end;
  Result := Lista;
end;

function TProducao.CriarEstacaoComMedicoes(const CodigoFlu, CodigoPlu: string;
  const Medicoes: Array_Of_medicaoTO): estacaoTO;
var
  Estacao: estacaoTO;
begin
  Estacao := estacaoTO.Create;
  Estacao.CodigoFlu := CodigoFlu;
  Estacao.CodigoPlu := CodigoPlu;
  Estacao.medicao := Medicoes;
  Result := Estacao;
end;

function TProducao.EnviarMedicoesSOAP(const Usuario, Senha: string;
  const Estacoes: Array_Of_estacaoTO): retornoService;
var
  WS: DadoHidrologicoService;
begin
  WS := GetDadoHidrologicoService(True, '', nil);
  try

    Result := WS.inserirMedicao(Usuario, Senha, Estacoes);
  except
    on E: ESOAPHTTPException do
    begin
      showMessage('Erro de comunicação com servidor: ' + E.Message);
      // Aqui você pode também logar ou tentar reenviar
    end;
    on E: Exception do
    begin
      showMessage('Erro inesperado: ' + E.Message);
    end;
  end;
end;

procedure TProducao.ProcessarEnvioMedicoes(showMessage: Boolean = False);
var
  Medicoes: Array_Of_medicaoTO;
  Estacao: estacaoTO;
  retorno: retornoService;
  Mensagem: string;
begin
  Medicoes := CarregarMedicoesPendentes;
  if Length(Medicoes) = 0 then
    Exit;

  Estacao := CriarEstacaoComMedicoes(sFluviometro, sPluviometro, Medicoes);
  retorno := EnviarMedicoesSOAP(sUsuario, sSenha, [Estacao]);

  if Length(retorno.Mensagem) > 0 then
    Mensagem := retorno.Mensagem[0]
  else
    Mensagem := 'Sem mensagem de retorno';

  if Length(retorno.medicoesInseridas) > 0 then
  begin
    MarcarMedicoesComoEnviadasPorDataMedicao(retorno.medicoesInseridas,
      Mensagem);
    RegistrarLogEnvio('SUCESSO', Mensagem, Medicoes);
    if showMessage then
      Vcl.Dialogs.showMessage('Transmição realizada com sucesso!');
  end
  else
  begin
    RegistrarLogEnvio('ERRO', Mensagem, Medicoes);
    if showMessage then
      Vcl.Dialogs.showMessage
        ('Falha na Transmição verifique o Log de registros');
  end;

end;

procedure TProducao.MarcarMedicoesComoEnviadasPorDataMedicao
  (const medicoesInseridas: Array_Of_estacaoTO; const RetornoMensagem: String);
var
  i, j: Integer;
  dataMedicao: TDateTime;
  DataParte, HoraParte: TDateTime;
  FmtSettings: TFormatSettings;
begin
  if Length(medicoesInseridas) = 0 then
    Exit; // Nada para fazer

  oMedidas := TMedidas.Create(ConnectionDB);
  try
    for i := Low(medicoesInseridas) to High(medicoesInseridas) do
    begin
      for j := Low(medicoesInseridas[i].medicao)
        to High(medicoesInseridas[i].medicao) do
      begin
        FmtSettings := TFormatSettings.Create;
        FmtSettings.DateSeparator := '/';
        FmtSettings.TimeSeparator := ':';
        FmtSettings.ShortDateFormat := 'dd/MM/yyyy';
        FmtSettings.LongTimeFormat := 'hh:nn:ss';
        if (TryStrToDateTime(medicoesInseridas[i].medicao[j].dataMedicao,
          dataMedicao, FmtSettings)) then
        begin
          DataParte := DateOf(dataMedicao);
          HoraParte := TimeOf(dataMedicao);
          oMedidas.Find(DateToStr(DataParte), TimeToStr(HoraParte));
          oMedidas.enviado := True;
          oMedidas.data_envio := Now;
          oMedidas.retorno := RetornoMensagem;
          oMedidas.Update;
        end;
      end;
    end;
  finally
    if Assigned(oMedidas) then
      FreeAndNil(oMedidas);
  end;
end;

procedure TProducao.RegistrarLogEnvio(const Tipo, Mensagem: string;
  const Medicoes: Array_Of_medicaoTO);
var
  JsonTexto: string;
  JSONArr: TJSONArray;
  medicao: medicaoTO;
  Obj: TJSONObject;
begin
  // Monta JSON com as medições (simples e legível)
  JSONArr := TJSONArray.Create;
  try
    for medicao in Medicoes do
    begin
      Obj := TJSONObject.Create;
      Obj.AddPair('dataMedicao', medicao.dataMedicao);
      Obj.AddPair('nivel', TJSONNumber.Create(medicao.nivel));
      Obj.AddPair('chuva', TJSONNumber.Create(medicao.chuva));
      Obj.AddPair('vazao', TJSONNumber.Create(medicao.vazao));
      JSONArr.AddElement(Obj);
    end;
    JsonTexto := JSONArr.ToJSON;
  finally
    JSONArr.Free;
  end;

  // Inserir no banco Firebird
  try
    oLogs := TLogs.Create(ConnectionDB);
    oLogs.Tipo := Tipo;
    oLogs.Mensagem := Mensagem;
    oLogs.medicoes_json := JsonTexto;
    oLogs.Insert;

  finally
    if Assigned(oLogs) then
      FreeAndNil(oLogs);
  end;
end;

end.
