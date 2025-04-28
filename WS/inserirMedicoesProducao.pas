// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : https://www.snirh.gov.br/app-ws-telemetria-htc/services/inserirMedicoes?wsdl
//  >Import : https://www.snirh.gov.br/app-ws-telemetria-htc/services/inserirMedicoes?wsdl>0
//  >Import : https://www.snirh.gov.br/app-ws-telemetria-htc/services/inserirMedicoes?xsd=1
// Encoding : UTF-8
// Codegen  : [wfUseSettersAndGetters+]
// Version  : 1.0
// (2025-04-11 22:23:04 - - $Rev: 121536 $)
// ************************************************************************ //

unit inserirMedicoesProducao;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_NLBL = $0004;
  IS_UNQL = $0008;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:double          - "http://www.w3.org/2001/XMLSchema"[Gbl]

  estacaoRetornoTO     = class;                 { "http://ws.integracao.ana.gov.br/"[GblCplx] }
  retornoConsulta      = class;                 { "http://ws.integracao.ana.gov.br/"[GblCplx] }
  retornoService       = class;                 { "http://ws.integracao.ana.gov.br/"[GblCplx] }
  estacaoTO            = class;                 { "http://ws.integracao.ana.gov.br/"[GblCplx] }
  medicaoTO            = class;                 { "http://ws.integracao.ana.gov.br/"[GblCplx] }
  medicaoRetornoTO     = class;                 { "http://ws.integracao.ana.gov.br/"[GblCplx] }

  Array_Of_medicaoTO = array of medicaoTO;      { "http://ws.integracao.ana.gov.br/"[GblUbnd] }
  Array_Of_estacaoTO = array of estacaoTO;      { "http://ws.integracao.ana.gov.br/"[GblUbnd] }
  Array_Of_medicaoRetornoTO = array of medicaoRetornoTO;   { "http://ws.integracao.ana.gov.br/"[GblUbnd] }


  // ************************************************************************ //
  // XML       : estacaoRetornoTO, global, <complexType>
  // Namespace : http://ws.integracao.ana.gov.br/
  // ************************************************************************ //
  estacaoRetornoTO = class(TRemotable)
  private
    FcodigoFlu: string;
    FcodigoFlu_Specified: boolean;
    FcodigoPlu: string;
    FcodigoPlu_Specified: boolean;
    Fmedicao: Array_Of_medicaoRetornoTO;
    Fmedicao_Specified: boolean;
    function  GetcodigoFlu(Index: Integer): string;
    procedure SetcodigoFlu(Index: Integer; const Astring: string);
    function  codigoFlu_Specified(Index: Integer): boolean;
    function  GetcodigoPlu(Index: Integer): string;
    procedure SetcodigoPlu(Index: Integer; const Astring: string);
    function  codigoPlu_Specified(Index: Integer): boolean;
    function  Getmedicao(Index: Integer): Array_Of_medicaoRetornoTO;
    procedure Setmedicao(Index: Integer; const AArray_Of_medicaoRetornoTO: Array_Of_medicaoRetornoTO);
    function  medicao_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property codigoFlu: string                     Index (IS_OPTN or IS_UNQL) read GetcodigoFlu write SetcodigoFlu stored codigoFlu_Specified;
    property codigoPlu: string                     Index (IS_OPTN or IS_UNQL) read GetcodigoPlu write SetcodigoPlu stored codigoPlu_Specified;
    property medicao:   Array_Of_medicaoRetornoTO  Index (IS_OPTN or IS_UNBD or IS_NLBL or IS_UNQL) read Getmedicao write Setmedicao stored medicao_Specified;
  end;

  Array_Of_string = array of string;            { "http://www.w3.org/2001/XMLSchema"[GblUbnd] }


  // ************************************************************************ //
  // XML       : retornoConsulta, global, <complexType>
  // Namespace : http://ws.integracao.ana.gov.br/
  // ************************************************************************ //
  retornoConsulta = class(TRemotable)
  private
    Festacao: estacaoRetornoTO;
    Festacao_Specified: boolean;
    Fmensagem: Array_Of_string;
    Fmensagem_Specified: boolean;
    FquantidadeMedicaoEncontradas: Integer;
    function  Getestacao(Index: Integer): estacaoRetornoTO;
    procedure Setestacao(Index: Integer; const AestacaoRetornoTO: estacaoRetornoTO);
    function  estacao_Specified(Index: Integer): boolean;
    function  Getmensagem(Index: Integer): Array_Of_string;
    procedure Setmensagem(Index: Integer; const AArray_Of_string: Array_Of_string);
    function  mensagem_Specified(Index: Integer): boolean;
    function  GetquantidadeMedicaoEncontradas(Index: Integer): Integer;
    procedure SetquantidadeMedicaoEncontradas(Index: Integer; const AInteger: Integer);
  public
    destructor Destroy; override;
  published
    property estacao:                      estacaoRetornoTO  Index (IS_OPTN or IS_UNQL) read Getestacao write Setestacao stored estacao_Specified;
    property mensagem:                     Array_Of_string   Index (IS_OPTN or IS_UNBD or IS_NLBL or IS_UNQL) read Getmensagem write Setmensagem stored mensagem_Specified;
    property quantidadeMedicaoEncontradas: Integer           Index (IS_UNQL) read GetquantidadeMedicaoEncontradas write SetquantidadeMedicaoEncontradas;
  end;



  // ************************************************************************ //
  // XML       : retornoService, global, <complexType>
  // Namespace : http://ws.integracao.ana.gov.br/
  // ************************************************************************ //
  retornoService = class(TRemotable)
  private
    FmedicoesInseridas: Array_Of_estacaoTO;
    FmedicoesInseridas_Specified: boolean;
    FmedicoesNaoInseridas: Array_Of_estacaoTO;
    FmedicoesNaoInseridas_Specified: boolean;
    Fmensagem: Array_Of_string;
    Fmensagem_Specified: boolean;
    FquantidadeMedicaoInserida: Integer;
    FquantidadeMedicaoNaoInserida: Integer;
    function  GetmedicoesInseridas(Index: Integer): Array_Of_estacaoTO;
    procedure SetmedicoesInseridas(Index: Integer; const AArray_Of_estacaoTO: Array_Of_estacaoTO);
    function  medicoesInseridas_Specified(Index: Integer): boolean;
    function  GetmedicoesNaoInseridas(Index: Integer): Array_Of_estacaoTO;
    procedure SetmedicoesNaoInseridas(Index: Integer; const AArray_Of_estacaoTO: Array_Of_estacaoTO);
    function  medicoesNaoInseridas_Specified(Index: Integer): boolean;
    function  Getmensagem(Index: Integer): Array_Of_string;
    procedure Setmensagem(Index: Integer; const AArray_Of_string: Array_Of_string);
    function  mensagem_Specified(Index: Integer): boolean;
    function  GetquantidadeMedicaoInserida(Index: Integer): Integer;
    procedure SetquantidadeMedicaoInserida(Index: Integer; const AInteger: Integer);
    function  GetquantidadeMedicaoNaoInserida(Index: Integer): Integer;
    procedure SetquantidadeMedicaoNaoInserida(Index: Integer; const AInteger: Integer);
  public
    destructor Destroy; override;
  published
    property medicoesInseridas:            Array_Of_estacaoTO  Index (IS_OPTN or IS_UNBD or IS_NLBL or IS_UNQL) read GetmedicoesInseridas write SetmedicoesInseridas stored medicoesInseridas_Specified;
    property medicoesNaoInseridas:         Array_Of_estacaoTO  Index (IS_OPTN or IS_UNBD or IS_NLBL or IS_UNQL) read GetmedicoesNaoInseridas write SetmedicoesNaoInseridas stored medicoesNaoInseridas_Specified;
    property mensagem:                     Array_Of_string     Index (IS_OPTN or IS_UNBD or IS_NLBL or IS_UNQL) read Getmensagem write Setmensagem stored mensagem_Specified;
    property quantidadeMedicaoInserida:    Integer             Index (IS_UNQL) read GetquantidadeMedicaoInserida write SetquantidadeMedicaoInserida;
    property quantidadeMedicaoNaoInserida: Integer             Index (IS_UNQL) read GetquantidadeMedicaoNaoInserida write SetquantidadeMedicaoNaoInserida;
  end;



  // ************************************************************************ //
  // XML       : estacaoTO, global, <complexType>
  // Namespace : http://ws.integracao.ana.gov.br/
  // ************************************************************************ //
  estacaoTO = class(TRemotable)
  private
    FcodigoFlu: string;
    FcodigoFlu_Specified: boolean;
    FcodigoPlu: string;
    FcodigoPlu_Specified: boolean;
    Fmedicao: Array_Of_medicaoTO;
    Fmedicao_Specified: boolean;
    function  GetcodigoFlu(Index: Integer): string;
    procedure SetcodigoFlu(Index: Integer; const Astring: string);
    function  codigoFlu_Specified(Index: Integer): boolean;
    function  GetcodigoPlu(Index: Integer): string;
    procedure SetcodigoPlu(Index: Integer; const Astring: string);
    function  codigoPlu_Specified(Index: Integer): boolean;
    function  Getmedicao(Index: Integer): Array_Of_medicaoTO;
    procedure Setmedicao(Index: Integer; const AArray_Of_medicaoTO: Array_Of_medicaoTO);
    function  medicao_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property codigoFlu: string              Index (IS_OPTN or IS_UNQL) read GetcodigoFlu write SetcodigoFlu stored codigoFlu_Specified;
    property codigoPlu: string              Index (IS_OPTN or IS_UNQL) read GetcodigoPlu write SetcodigoPlu stored codigoPlu_Specified;
    property medicao:   Array_Of_medicaoTO  Index (IS_OPTN or IS_UNBD or IS_NLBL or IS_UNQL) read Getmedicao write Setmedicao stored medicao_Specified;
  end;



  // ************************************************************************ //
  // XML       : medicaoTO, global, <complexType>
  // Namespace : http://ws.integracao.ana.gov.br/
  // ************************************************************************ //
  medicaoTO = class(TRemotable)
  private
    Fchuva: Double;
    Fchuva_Specified: boolean;
    FdataMedicao: string;
    FdataMedicao_Specified: boolean;
    Fnivel: Double;
    Fnivel_Specified: boolean;
    Fvazao: Double;
    Fvazao_Specified: boolean;
    function  Getchuva(Index: Integer): Double;
    procedure Setchuva(Index: Integer; const ADouble: Double);
    function  chuva_Specified(Index: Integer): boolean;
    function  GetdataMedicao(Index: Integer): string;
    procedure SetdataMedicao(Index: Integer; const Astring: string);
    function  dataMedicao_Specified(Index: Integer): boolean;
    function  Getnivel(Index: Integer): Double;
    procedure Setnivel(Index: Integer; const ADouble: Double);
    function  nivel_Specified(Index: Integer): boolean;
    function  Getvazao(Index: Integer): Double;
    procedure Setvazao(Index: Integer; const ADouble: Double);
    function  vazao_Specified(Index: Integer): boolean;
  published
    property chuva:       Double  Index (IS_OPTN or IS_UNQL) read Getchuva write Setchuva stored chuva_Specified;
    property dataMedicao: string  Index (IS_OPTN or IS_UNQL) read GetdataMedicao write SetdataMedicao stored dataMedicao_Specified;
    property nivel:       Double  Index (IS_OPTN or IS_UNQL) read Getnivel write Setnivel stored nivel_Specified;
    property vazao:       Double  Index (IS_OPTN or IS_UNQL) read Getvazao write Setvazao stored vazao_Specified;
  end;



  // ************************************************************************ //
  // XML       : medicaoRetornoTO, global, <complexType>
  // Namespace : http://ws.integracao.ana.gov.br/
  // ************************************************************************ //
  medicaoRetornoTO = class(TRemotable)
  private
    F_01DataMedicao: string;
    F_01DataMedicao_Specified: boolean;
    F_02DataRecepcaoMedicao: string;
    F_02DataRecepcaoMedicao_Specified: boolean;
    F_03Chuva: Double;
    F_03Chuva_Specified: boolean;
    F_04StatusQualChuva: string;
    F_04StatusQualChuva_Specified: boolean;
    F_05Nivel: Double;
    F_05Nivel_Specified: boolean;
    F_06StatusQualNivel: string;
    F_06StatusQualNivel_Specified: boolean;
    F_07Vazao: Double;
    F_07Vazao_Specified: boolean;
    F_08StatusQualVazao: string;
    F_08StatusQualVazao_Specified: boolean;
    function  Get_01DataMedicao(Index: Integer): string;
    procedure Set_01DataMedicao(Index: Integer; const Astring: string);
    function  _01DataMedicao_Specified(Index: Integer): boolean;
    function  Get_02DataRecepcaoMedicao(Index: Integer): string;
    procedure Set_02DataRecepcaoMedicao(Index: Integer; const Astring: string);
    function  _02DataRecepcaoMedicao_Specified(Index: Integer): boolean;
    function  Get_03Chuva(Index: Integer): Double;
    procedure Set_03Chuva(Index: Integer; const ADouble: Double);
    function  _03Chuva_Specified(Index: Integer): boolean;
    function  Get_04StatusQualChuva(Index: Integer): string;
    procedure Set_04StatusQualChuva(Index: Integer; const Astring: string);
    function  _04StatusQualChuva_Specified(Index: Integer): boolean;
    function  Get_05Nivel(Index: Integer): Double;
    procedure Set_05Nivel(Index: Integer; const ADouble: Double);
    function  _05Nivel_Specified(Index: Integer): boolean;
    function  Get_06StatusQualNivel(Index: Integer): string;
    procedure Set_06StatusQualNivel(Index: Integer; const Astring: string);
    function  _06StatusQualNivel_Specified(Index: Integer): boolean;
    function  Get_07Vazao(Index: Integer): Double;
    procedure Set_07Vazao(Index: Integer; const ADouble: Double);
    function  _07Vazao_Specified(Index: Integer): boolean;
    function  Get_08StatusQualVazao(Index: Integer): string;
    procedure Set_08StatusQualVazao(Index: Integer; const Astring: string);
    function  _08StatusQualVazao_Specified(Index: Integer): boolean;
  published
    property _01DataMedicao:         string  Index (IS_OPTN or IS_UNQL) read Get_01DataMedicao write Set_01DataMedicao stored _01DataMedicao_Specified;
    property _02DataRecepcaoMedicao: string  Index (IS_OPTN or IS_UNQL) read Get_02DataRecepcaoMedicao write Set_02DataRecepcaoMedicao stored _02DataRecepcaoMedicao_Specified;
    property _03Chuva:               Double  Index (IS_OPTN or IS_UNQL) read Get_03Chuva write Set_03Chuva stored _03Chuva_Specified;
    property _04StatusQualChuva:     string  Index (IS_OPTN or IS_UNQL) read Get_04StatusQualChuva write Set_04StatusQualChuva stored _04StatusQualChuva_Specified;
    property _05Nivel:               Double  Index (IS_OPTN or IS_UNQL) read Get_05Nivel write Set_05Nivel stored _05Nivel_Specified;
    property _06StatusQualNivel:     string  Index (IS_OPTN or IS_UNQL) read Get_06StatusQualNivel write Set_06StatusQualNivel stored _06StatusQualNivel_Specified;
    property _07Vazao:               Double  Index (IS_OPTN or IS_UNQL) read Get_07Vazao write Set_07Vazao stored _07Vazao_Specified;
    property _08StatusQualVazao:     string  Index (IS_OPTN or IS_UNQL) read Get_08StatusQualVazao write Set_08StatusQualVazao stored _08StatusQualVazao_Specified;
  end;


  // ************************************************************************ //
  // Namespace : http://ws.integracao.ana.gov.br/
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : DadoHidrologicoServiceImplPortBinding
  // service   : DadoHidrologicoServiceImplService
  // port      : DadoHidrologicoServiceImplPort
  // URL       : https://www.snirh.gov.br/app-ws-telemetria-htc/services/inserirMedicoes
  // ************************************************************************ //
  DadoHidrologicoService = interface(IInvokable)
  ['{1C72AE52-07C7-4917-C475-DC4D05B8723E}']
    function  inserirMedicao(const login: string; const senha: string; const estacao: Array_Of_estacaoTO): retornoService; stdcall;
    function  consultarMedicao(const login: string; const senha: string; const codigoPLU: string; const codigoFLU: string; const dataInicial: string; const dataFinal: string
                               ): retornoConsulta; stdcall;
  end;

function GetDadoHidrologicoService(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): DadoHidrologicoService;


implementation

uses System.SysUtils, System.Generics.Collections;

function GetDadoHidrologicoService(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): DadoHidrologicoService;
const
  defWSDL = 'https://www.snirh.gov.br/app-ws-telemetria-htc/services/inserirMedicoes?wsdl';
  defURL  = 'https://www.snirh.gov.br/app-ws-telemetria-htc/services/inserirMedicoes';
  defSvc  = 'DadoHidrologicoServiceImplService';
  defPrt  = 'DadoHidrologicoServiceImplPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as DadoHidrologicoService);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


destructor estacaoRetornoTO.Destroy;
begin
  TArray.FreeValues(Fmedicao);
  System.SetLength(Fmedicao, 0);
  inherited Destroy;
end;

function estacaoRetornoTO.GetcodigoFlu(Index: Integer): string;
begin
  Result := FcodigoFlu;
end;

procedure estacaoRetornoTO.SetcodigoFlu(Index: Integer; const Astring: string);
begin
  FcodigoFlu := Astring;
  FcodigoFlu_Specified := True;
end;

function estacaoRetornoTO.codigoFlu_Specified(Index: Integer): boolean;
begin
  Result := FcodigoFlu_Specified;
end;

function estacaoRetornoTO.GetcodigoPlu(Index: Integer): string;
begin
  Result := FcodigoPlu;
end;

procedure estacaoRetornoTO.SetcodigoPlu(Index: Integer; const Astring: string);
begin
  FcodigoPlu := Astring;
  FcodigoPlu_Specified := True;
end;

function estacaoRetornoTO.codigoPlu_Specified(Index: Integer): boolean;
begin
  Result := FcodigoPlu_Specified;
end;

function estacaoRetornoTO.Getmedicao(Index: Integer): Array_Of_medicaoRetornoTO;
begin
  Result := Fmedicao;
end;

procedure estacaoRetornoTO.Setmedicao(Index: Integer; const AArray_Of_medicaoRetornoTO: Array_Of_medicaoRetornoTO);
begin
  Fmedicao := AArray_Of_medicaoRetornoTO;
  Fmedicao_Specified := True;
end;

function estacaoRetornoTO.medicao_Specified(Index: Integer): boolean;
begin
  Result := Fmedicao_Specified;
end;

destructor retornoConsulta.Destroy;
begin
  System.SysUtils.FreeAndNil(Festacao);
  inherited Destroy;
end;

function retornoConsulta.Getestacao(Index: Integer): estacaoRetornoTO;
begin
  Result := Festacao;
end;

procedure retornoConsulta.Setestacao(Index: Integer; const AestacaoRetornoTO: estacaoRetornoTO);
begin
  Festacao := AestacaoRetornoTO;
  Festacao_Specified := True;
end;

function retornoConsulta.estacao_Specified(Index: Integer): boolean;
begin
  Result := Festacao_Specified;
end;

function retornoConsulta.Getmensagem(Index: Integer): Array_Of_string;
begin
  Result := Fmensagem;
end;

procedure retornoConsulta.Setmensagem(Index: Integer; const AArray_Of_string: Array_Of_string);
begin
  Fmensagem := AArray_Of_string;
  Fmensagem_Specified := True;
end;

function retornoConsulta.mensagem_Specified(Index: Integer): boolean;
begin
  Result := Fmensagem_Specified;
end;

function retornoConsulta.GetquantidadeMedicaoEncontradas(Index: Integer): Integer;
begin
  Result := FquantidadeMedicaoEncontradas;
end;

procedure retornoConsulta.SetquantidadeMedicaoEncontradas(Index: Integer; const AInteger: Integer);
begin
  FquantidadeMedicaoEncontradas := AInteger;
end;

destructor retornoService.Destroy;
begin
  TArray.FreeValues(FmedicoesInseridas);
  System.SetLength(FmedicoesInseridas, 0);
  TArray.FreeValues(FmedicoesNaoInseridas);
  System.SetLength(FmedicoesNaoInseridas, 0);
  inherited Destroy;
end;

function retornoService.GetmedicoesInseridas(Index: Integer): Array_Of_estacaoTO;
begin
  Result := FmedicoesInseridas;
end;

procedure retornoService.SetmedicoesInseridas(Index: Integer; const AArray_Of_estacaoTO: Array_Of_estacaoTO);
begin
  FmedicoesInseridas := AArray_Of_estacaoTO;
  FmedicoesInseridas_Specified := True;
end;

function retornoService.medicoesInseridas_Specified(Index: Integer): boolean;
begin
  Result := FmedicoesInseridas_Specified;
end;

function retornoService.GetmedicoesNaoInseridas(Index: Integer): Array_Of_estacaoTO;
begin
  Result := FmedicoesNaoInseridas;
end;

procedure retornoService.SetmedicoesNaoInseridas(Index: Integer; const AArray_Of_estacaoTO: Array_Of_estacaoTO);
begin
  FmedicoesNaoInseridas := AArray_Of_estacaoTO;
  FmedicoesNaoInseridas_Specified := True;
end;

function retornoService.medicoesNaoInseridas_Specified(Index: Integer): boolean;
begin
  Result := FmedicoesNaoInseridas_Specified;
end;

function retornoService.Getmensagem(Index: Integer): Array_Of_string;
begin
  Result := Fmensagem;
end;

procedure retornoService.Setmensagem(Index: Integer; const AArray_Of_string: Array_Of_string);
begin
  Fmensagem := AArray_Of_string;
  Fmensagem_Specified := True;
end;

function retornoService.mensagem_Specified(Index: Integer): boolean;
begin
  Result := Fmensagem_Specified;
end;

function retornoService.GetquantidadeMedicaoInserida(Index: Integer): Integer;
begin
  Result := FquantidadeMedicaoInserida;
end;

procedure retornoService.SetquantidadeMedicaoInserida(Index: Integer; const AInteger: Integer);
begin
  FquantidadeMedicaoInserida := AInteger;
end;

function retornoService.GetquantidadeMedicaoNaoInserida(Index: Integer): Integer;
begin
  Result := FquantidadeMedicaoNaoInserida;
end;

procedure retornoService.SetquantidadeMedicaoNaoInserida(Index: Integer; const AInteger: Integer);
begin
  FquantidadeMedicaoNaoInserida := AInteger;
end;

destructor estacaoTO.Destroy;
begin
  TArray.FreeValues(Fmedicao);
  System.SetLength(Fmedicao, 0);
  inherited Destroy;
end;

function estacaoTO.GetcodigoFlu(Index: Integer): string;
begin
  Result := FcodigoFlu;
end;

procedure estacaoTO.SetcodigoFlu(Index: Integer; const Astring: string);
begin
  FcodigoFlu := Astring;
  FcodigoFlu_Specified := True;
end;

function estacaoTO.codigoFlu_Specified(Index: Integer): boolean;
begin
  Result := FcodigoFlu_Specified;
end;

function estacaoTO.GetcodigoPlu(Index: Integer): string;
begin
  Result := FcodigoPlu;
end;

procedure estacaoTO.SetcodigoPlu(Index: Integer; const Astring: string);
begin
  FcodigoPlu := Astring;
  FcodigoPlu_Specified := True;
end;

function estacaoTO.codigoPlu_Specified(Index: Integer): boolean;
begin
  Result := FcodigoPlu_Specified;
end;

function estacaoTO.Getmedicao(Index: Integer): Array_Of_medicaoTO;
begin
  Result := Fmedicao;
end;

procedure estacaoTO.Setmedicao(Index: Integer; const AArray_Of_medicaoTO: Array_Of_medicaoTO);
begin
  Fmedicao := AArray_Of_medicaoTO;
  Fmedicao_Specified := True;
end;

function estacaoTO.medicao_Specified(Index: Integer): boolean;
begin
  Result := Fmedicao_Specified;
end;

function medicaoTO.Getchuva(Index: Integer): Double;
begin
  Result := Fchuva;
end;

procedure medicaoTO.Setchuva(Index: Integer; const ADouble: Double);
begin
  Fchuva := ADouble;
  Fchuva_Specified := True;
end;

function medicaoTO.chuva_Specified(Index: Integer): boolean;
begin
  Result := Fchuva_Specified;
end;

function medicaoTO.GetdataMedicao(Index: Integer): string;
begin
  Result := FdataMedicao;
end;

procedure medicaoTO.SetdataMedicao(Index: Integer; const Astring: string);
begin
  FdataMedicao := Astring;
  FdataMedicao_Specified := True;
end;

function medicaoTO.dataMedicao_Specified(Index: Integer): boolean;
begin
  Result := FdataMedicao_Specified;
end;

function medicaoTO.Getnivel(Index: Integer): Double;
begin
  Result := Fnivel;
end;

procedure medicaoTO.Setnivel(Index: Integer; const ADouble: Double);
begin
  Fnivel := ADouble;
  Fnivel_Specified := True;
end;

function medicaoTO.nivel_Specified(Index: Integer): boolean;
begin
  Result := Fnivel_Specified;
end;

function medicaoTO.Getvazao(Index: Integer): Double;
begin
  Result := Fvazao;
end;

procedure medicaoTO.Setvazao(Index: Integer; const ADouble: Double);
begin
  Fvazao := ADouble;
  Fvazao_Specified := True;
end;

function medicaoTO.vazao_Specified(Index: Integer): boolean;
begin
  Result := Fvazao_Specified;
end;

function medicaoRetornoTO.Get_01DataMedicao(Index: Integer): string;
begin
  Result := F_01DataMedicao;
end;

procedure medicaoRetornoTO.Set_01DataMedicao(Index: Integer; const Astring: string);
begin
  F_01DataMedicao := Astring;
  F_01DataMedicao_Specified := True;
end;

function medicaoRetornoTO._01DataMedicao_Specified(Index: Integer): boolean;
begin
  Result := F_01DataMedicao_Specified;
end;

function medicaoRetornoTO.Get_02DataRecepcaoMedicao(Index: Integer): string;
begin
  Result := F_02DataRecepcaoMedicao;
end;

procedure medicaoRetornoTO.Set_02DataRecepcaoMedicao(Index: Integer; const Astring: string);
begin
  F_02DataRecepcaoMedicao := Astring;
  F_02DataRecepcaoMedicao_Specified := True;
end;

function medicaoRetornoTO._02DataRecepcaoMedicao_Specified(Index: Integer): boolean;
begin
  Result := F_02DataRecepcaoMedicao_Specified;
end;

function medicaoRetornoTO.Get_03Chuva(Index: Integer): Double;
begin
  Result := F_03Chuva;
end;

procedure medicaoRetornoTO.Set_03Chuva(Index: Integer; const ADouble: Double);
begin
  F_03Chuva := ADouble;
  F_03Chuva_Specified := True;
end;

function medicaoRetornoTO._03Chuva_Specified(Index: Integer): boolean;
begin
  Result := F_03Chuva_Specified;
end;

function medicaoRetornoTO.Get_04StatusQualChuva(Index: Integer): string;
begin
  Result := F_04StatusQualChuva;
end;

procedure medicaoRetornoTO.Set_04StatusQualChuva(Index: Integer; const Astring: string);
begin
  F_04StatusQualChuva := Astring;
  F_04StatusQualChuva_Specified := True;
end;

function medicaoRetornoTO._04StatusQualChuva_Specified(Index: Integer): boolean;
begin
  Result := F_04StatusQualChuva_Specified;
end;

function medicaoRetornoTO.Get_05Nivel(Index: Integer): Double;
begin
  Result := F_05Nivel;
end;

procedure medicaoRetornoTO.Set_05Nivel(Index: Integer; const ADouble: Double);
begin
  F_05Nivel := ADouble;
  F_05Nivel_Specified := True;
end;

function medicaoRetornoTO._05Nivel_Specified(Index: Integer): boolean;
begin
  Result := F_05Nivel_Specified;
end;

function medicaoRetornoTO.Get_06StatusQualNivel(Index: Integer): string;
begin
  Result := F_06StatusQualNivel;
end;

procedure medicaoRetornoTO.Set_06StatusQualNivel(Index: Integer; const Astring: string);
begin
  F_06StatusQualNivel := Astring;
  F_06StatusQualNivel_Specified := True;
end;

function medicaoRetornoTO._06StatusQualNivel_Specified(Index: Integer): boolean;
begin
  Result := F_06StatusQualNivel_Specified;
end;

function medicaoRetornoTO.Get_07Vazao(Index: Integer): Double;
begin
  Result := F_07Vazao;
end;

procedure medicaoRetornoTO.Set_07Vazao(Index: Integer; const ADouble: Double);
begin
  F_07Vazao := ADouble;
  F_07Vazao_Specified := True;
end;

function medicaoRetornoTO._07Vazao_Specified(Index: Integer): boolean;
begin
  Result := F_07Vazao_Specified;
end;

function medicaoRetornoTO.Get_08StatusQualVazao(Index: Integer): string;
begin
  Result := F_08StatusQualVazao;
end;

procedure medicaoRetornoTO.Set_08StatusQualVazao(Index: Integer; const Astring: string);
begin
  F_08StatusQualVazao := Astring;
  F_08StatusQualVazao_Specified := True;
end;

function medicaoRetornoTO._08StatusQualVazao_Specified(Index: Integer): boolean;
begin
  Result := F_08StatusQualVazao_Specified;
end;

initialization
  { DadoHidrologicoService }
  InvRegistry.RegisterInterface(TypeInfo(DadoHidrologicoService), 'http://ws.integracao.ana.gov.br/', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(DadoHidrologicoService), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(DadoHidrologicoService), ioDocument);
  { DadoHidrologicoService.inserirMedicao }
  InvRegistry.RegisterMethodInfo(TypeInfo(DadoHidrologicoService), 'inserirMedicao', '',
                                 '[ReturnName="retorno"]', IS_OPTN or IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(DadoHidrologicoService), 'inserirMedicao', 'login', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(DadoHidrologicoService), 'inserirMedicao', 'senha', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(DadoHidrologicoService), 'inserirMedicao', 'estacao', '',
                                '', IS_UNBD or IS_NLBL or IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(DadoHidrologicoService), 'inserirMedicao', 'retorno', '',
                                '', IS_UNQL);
  { DadoHidrologicoService.consultarMedicao }
  InvRegistry.RegisterMethodInfo(TypeInfo(DadoHidrologicoService), 'consultarMedicao', '',
                                 '[ReturnName="retorno"]', IS_OPTN or IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(DadoHidrologicoService), 'consultarMedicao', 'login', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(DadoHidrologicoService), 'consultarMedicao', 'senha', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(DadoHidrologicoService), 'consultarMedicao', 'codigoPLU', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(DadoHidrologicoService), 'consultarMedicao', 'codigoFLU', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(DadoHidrologicoService), 'consultarMedicao', 'dataInicial', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(DadoHidrologicoService), 'consultarMedicao', 'dataFinal', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(DadoHidrologicoService), 'consultarMedicao', 'retorno', '',
                                '', IS_UNQL);
  RemClassRegistry.RegisterXSInfo(TypeInfo(Array_Of_medicaoTO), 'http://ws.integracao.ana.gov.br/', 'Array_Of_medicaoTO');
  RemClassRegistry.RegisterXSInfo(TypeInfo(Array_Of_estacaoTO), 'http://ws.integracao.ana.gov.br/', 'Array_Of_estacaoTO');
  RemClassRegistry.RegisterXSInfo(TypeInfo(Array_Of_medicaoRetornoTO), 'http://ws.integracao.ana.gov.br/', 'Array_Of_medicaoRetornoTO');
  RemClassRegistry.RegisterXSClass(estacaoRetornoTO, 'http://ws.integracao.ana.gov.br/', 'estacaoRetornoTO');
  RemClassRegistry.RegisterXSInfo(TypeInfo(Array_Of_string), 'http://www.w3.org/2001/XMLSchema', 'Array_Of_string');
  RemClassRegistry.RegisterXSClass(retornoConsulta, 'http://ws.integracao.ana.gov.br/', 'retornoConsulta');
  RemClassRegistry.RegisterXSClass(retornoService, 'http://ws.integracao.ana.gov.br/', 'retornoService');
  RemClassRegistry.RegisterXSClass(estacaoTO, 'http://ws.integracao.ana.gov.br/', 'estacaoTO');
  RemClassRegistry.RegisterXSClass(medicaoTO, 'http://ws.integracao.ana.gov.br/', 'medicaoTO');
  RemClassRegistry.RegisterXSClass(medicaoRetornoTO, 'http://ws.integracao.ana.gov.br/', 'medicaoRetornoTO');

end.