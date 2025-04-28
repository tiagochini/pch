unit uClassMedidas;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Dialogs,
  ZAbstractConnection,
  ZConnection,
  ZAbstractRODataset,
  ZAbstractDataset,
  ZDataset;

type
  TMedidas = class;
  TMedidasArray = TArray<TMedidas>;

  TMedidas = class
  private
    ConnectionDB: TZConnection;
    F_id: Integer;
    F_Data: TDate;
    F_Hora: TTime;
    F_Fluviometro: Integer;
    F_Pluviometro: Integer;
    F_Created_at: TDateTime;
    F_Updated_at: TDateTime;
    F_Enviado: Boolean;
    F_Data_envio: TDateTime;
    F_Retorno: String;

    function GetCode: Integer;
    function GetData: TDate;
    function GetHora: TTime;
    function GetFluviometro: Integer;
    function GetPluviometro: Integer;
    function GetCreatedAt: TDateTime;
    function GetUpdatedAt: TDateTime;
    function GetEnviado: Boolean;
    function GetDataEnvio: TDateTime;
    function GetRetorno: String;

    procedure SetCode(const Value: Integer);
    procedure SetData(const Value: TDate);
    procedure SetHora(const Value: TTime);
    procedure SetFluviometro(const Value: Integer);
    procedure SetPluviometro(const Value: Integer);
    procedure SetCreatedAt(const Value: TDateTime);
    procedure SetUpdatetedAt(const Value: TDateTime);
    procedure SetEnviado(const Value: Boolean);
    procedure SetDataEnvio(const Value: TDateTime);
    procedure SetRetorno(const Value: String);

  public
    constructor Create(aConnectionDB: TZConnection);
    destructor Destroy; override;
    function Insert: Boolean;
    function Read(id: Integer): Boolean;
    function Find(data, hora: String): Boolean;
    function Update: Boolean;
    function Exclude: Boolean;
    function InserirMedicao(Chuva_2, Sonda_2: Integer): Boolean;
    function FindNotSend: TMedidasArray;
  published
    property id: Integer read GetCode write SetCode;
    property data: TDate read GetData write SetData;
    property hora: TTime read GetHora write SetHora;
    property fluviometro: Integer read GetFluviometro write SetFluviometro;
    property pluviometro: Integer read GetPluviometro write SetPluviometro;
    property created_at: TDateTime read GetCreatedAt write SetCreatedAt;
    property updated_at: TDateTime read GetUpdatedAt write SetUpdatetedAt;
    property enviado: Boolean read GetEnviado write SetEnviado;
    property data_envio: TDateTime read GetDataEnvio write SetDataEnvio;
    property retorno: String read GetRetorno write SetRetorno;
  end;

implementation

// Constructor and Destruction
{$REGION 'Contructor and Destruction'}

constructor TMedidas.Create(aConnectionDB: TZConnection);
begin
  ConnectionDB := aConnectionDB;
end;

destructor TMedidas.Destroy;
begin

  inherited;
end;
{$ENDREGION}
{$REGION 'Methods'}

function TMedidas.InserirMedicao(Chuva_2, Sonda_2: Integer): Boolean;
var
  Qry: TZQuery;
  hora: TTime;
  id: Integer;
begin
  Qry := TZQuery.Create(nil);
  try
    Qry.Connection := ConnectionDB;
    hora := EncodeTime(HourOf(Now), 0, 0, 0);
    // Verificar se já existe medição para a data/hora atual
    Qry.SQL.Text :=
      'SELECT ID FROM MEDIDAS WHERE DATA = :DATA AND HORA = :HORA';
    Qry.ParamByName('DATA').AsDate := Date;
    Qry.ParamByName('HORA').AsTime := hora;
    Qry.Open;
    // Se encontrar um registro existente, atualiza os valores
    if not Qry.IsEmpty then
    begin
      id := Qry.FieldByName('ID').AsInteger;
      Qry.SQL.Clear;
      Qry.SQL.Add('UPDATE MEDIDAS ' + 'SET FLUVIOMETRO = :FLUVIOMETRO, ' +
        'PLUVIOMETRO = :PLUVIOMETRO, ' + 'UPDATED_AT = :UPDATED_AT ' +
        'WHERE ID = :ID');

      Qry.ParamByName('FLUVIOMETRO').AsInteger := Sonda_2; // Atualiza Sonda_2
      Qry.ParamByName('PLUVIOMETRO').AsInteger := Chuva_2; // Atualiza Chuva_2
      Qry.ParamByName('UPDATED_AT').AsDateTime := Now;
      Qry.ParamByName('ID').AsInteger := id;
      Qry.ExecSQL;
    end
    else
    begin
      // Caso não exista, insere um novo registro
      Qry.SQL.Clear;
      Qry.SQL.Add
        ('INSERT INTO MEDIDAS (DATA, HORA, FLUVIOMETRO, PLUVIOMETRO, CREATED_AT, ENVIADO) '
        + 'VALUES (:DATA, :HORA, :FLUVIOMETRO, :PLUVIOMETRO, :CREATED_AT, :ENVIADO)');

      Qry.ParamByName('DATA').AsDate := Date;
      Qry.ParamByName('HORA').AsTime := hora;
      Qry.ParamByName('FLUVIOMETRO').AsInteger := Sonda_2; // Insere Sonda_2
      Qry.ParamByName('PLUVIOMETRO').AsInteger := Chuva_2; // Insere Chuva_2
      Qry.ParamByName('CREATED_AT').AsDateTime := Now;
      Qry.ParamByName('ENVIADO').AsBoolean := False;
      // Assume que ainda não foi enviado
      Qry.ExecSQL;

    end;
  finally
    if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

function TMedidas.Insert: Boolean;
var
  Qry: TZQuery;
begin
  try
    Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConnectionDB;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('INSERT INTO medidas (id, data, hora, fluviometro, pluviometro) ' +
      'values (0, :data, :hora, :fluviometro, :pluviometro)');
    Qry.ParamByName('data').AsDate := Self.F_Data;
    Qry.ParamByName('hora').AsTime := Self.F_Hora;
    Qry.ParamByName('fluviometro').AsInteger := Self.F_Fluviometro;
    Qry.ParamByName('pluviometro').AsInteger := Self.F_Pluviometro;
    try
      Qry.ExecSQL;
    except
      Result := False;
    end;

  finally
    if Assigned(Qry) then
      FreeAndNil(Qry);
  end;

end;

function TMedidas.Read(id: Integer): Boolean;
var
  Qry: TZQuery;
begin
  try
    Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConnectionDB;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('SELECT id, data, hora, fluviometro, pluviometro, created_at, updated_at, enviado, data_envio, retorno FROM medidas WHERE id=:id');
    Qry.ParamByName('id').AsInteger := id;
    try
      Qry.Open;

      Self.F_id := Qry.FieldByName('id').AsInteger;
      Self.F_Data := Qry.FieldByName('data').AsDateTime;
      Self.F_Hora := Qry.FieldByName('hora').AsDateTime;
      Self.F_Fluviometro := Qry.FieldByName('fluviometro').AsInteger;
      Self.F_Pluviometro := Qry.FieldByName('pluviometro').AsInteger;
      Self.F_Created_at := Qry.FieldByName('created_at').AsDateTime;
      Self.F_Updated_at := Qry.FieldByName('updated_at').AsDateTime;
      Self.F_Enviado := Qry.FieldByName('enviado').AsBoolean;
      Self.F_Data_envio := Qry.FieldByName('data_envio').AsDateTime;
      Self.F_Retorno := Qry.FieldByName('retorno').AsString;
    except
      Result := False;
    end;

  finally
    if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

function TMedidas.Find(data: string; hora: string): Boolean;
var
  Qry: TZQuery;
begin
  try
    Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConnectionDB;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('SELECT id, data, hora, fluviometro, pluviometro, created_at, updated_at,'
      + ' enviado, data_envio, retorno FROM medidas WHERE data=:data AND hora=:hora');
    Qry.ParamByName('data').AsDate := StrToDate(data);
    Qry.ParamByName('hora').AsTime := StrToTime(hora);
    try
      Qry.Open;

      Self.id := Qry.FieldByName('id').AsInteger;
      Self.data := Qry.FieldByName('data').AsDateTime;
      Self.hora := Qry.FieldByName('hora').AsDateTime;
      Self.fluviometro := Qry.FieldByName('fluviometro').AsInteger;
      Self.pluviometro := Qry.FieldByName('pluviometro').AsInteger;
      Self.created_at := Qry.FieldByName('created_at').AsDateTime;
      Self.updated_at := Qry.FieldByName('updated_at').AsDateTime;
      Self.enviado := Qry.FieldByName('enviado').AsBoolean;
      Self.data_envio := Qry.FieldByName('data_envio').AsDateTime;
      Self.retorno := Qry.FieldByName('retorno').AsString;
    except
      on E: Exception do
      begin
        Result := False;
        ShowMessage('Error: ' + E.Message);
      end;
    end;

  finally
    if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

function TMedidas.FindNotSend: TMedidasArray;
var
  Lista: TObjectList<TMedidas>;
  // Usando TObjectList pra gerenciar a memória melhor
  Medida: TMedidas;
  Qry: TZQuery;
  DataHora, hora: TDateTime;
begin
  Lista := TObjectList<TMedidas>.Create(False);
  // False para não liberar os objetos automaticamente
  Qry := TZQuery.Create(nil);
  try
    hora := EncodeTime(HourOf(Now), MinuteOf(0), SecondOf(0), 0);

    Qry.Connection := ConnectionDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT ID, DATA, HORA, FLUVIOMETRO, PLUVIOMETRO, CREATED_AT,UPDATED_AT, ENVIADO,DATA_ENVIO,RETORNO FROM MEDIDAS ' +
      'WHERE ENVIADO = :ENVIADO AND NOT (DATA = :DATA AND HORA = :HORA)  ORDER BY DATA, HORA');
    Qry.ParamByName('ENVIADO').AsBoolean := False;
    Qry.ParamByName('DATA').AsDate := Date;
    Qry.ParamByName('HORA').AsTime := hora;
    Qry.Open;

    while not Qry.Eof do
    begin
      Medida := TMedidas.Create(ConnectionDB);
      // Carregar os dados de forma segura
      Medida.F_id := Qry.FieldByName('id').AsInteger;
      Medida.F_Data := Qry.FieldByName('data').AsDateTime;
      Medida.F_Hora := Qry.FieldByName('hora').AsDateTime;
      Medida.F_Fluviometro := Qry.FieldByName('fluviometro').AsInteger;
      Medida.F_Pluviometro := Qry.FieldByName('pluviometro').AsInteger;
      Medida.F_Created_at := Qry.FieldByName('created_at').AsDateTime;
      Medida.F_Updated_at := Qry.FieldByName('updated_at').AsDateTime;
      Medida.F_Enviado := Qry.FieldByName('enviado').AsBoolean;

      if not Qry.FieldByName('data_envio').IsNull then
        Medida.F_Data_envio := Qry.FieldByName('data_envio').AsDateTime
      else
        Medida.F_Data_envio := 0; // ou Now, ou outro valor padrão

      if not Qry.FieldByName('retorno').IsNull then
        Medida.F_Retorno := Qry.FieldByName('retorno').AsString
      else
        Medida.F_Retorno := '';

      Lista.Add(Medida);
      Qry.Next;
    end;

    Result := Lista.ToArray; // Copiamos a lista para o array
  finally
    FreeAndNil(Qry);
    FreeAndNil(Lista);
  end;
end;

function TMedidas.Update: Boolean;
var
  Qry: TZQuery;
begin
  try
    Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConnectionDB;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('UPDATE medidas SET enviado=:enviado, data_envio=:data_envio, retorno=:retorno WHERE id=:id');
    Qry.ParamByName('id').AsInteger := Self.id;
    Qry.ParamByName('enviado').AsBoolean := Self.enviado;
    Qry.ParamByName('data_envio').AsDateTime := Self.data_envio;
    Qry.ParamByName('retorno').AsString := Self.retorno;
    try
      Qry.ExecSQL;
    except
      Result := False;
    end;

  finally
    if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

function TMedidas.Exclude: Boolean;
var
  Qry: TZQuery;
begin
  if MessageDlg('Apagar o Registro: ' + #13 + #13 + 'Código ' + IntToStr(F_id) +
    #13 + 'Data: ' + DateToStr(Self.F_Data) + #13 + 'Hora: ' +
    TimeToStr(Self.F_Hora) + #13 + 'Pluviometro: ' +
    IntToStr(Self.F_Pluviometro) + #13 + 'Fluviometro: ' +
    IntToStr(Self.F_Fluviometro), TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrNo then
  begin
    Result := False;
    Abort;
  end;

  try
    Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConnectionDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('DELETE FROM medidas WHERE id=:id');
    Qry.ParamByName('id').AsInteger := F_id;
    try
      Qry.ExecSQL;
    except
      Result := False;
    end;

  finally
    if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;
{$ENDREGION}
// Get
{$REGION 'GET'}

function TMedidas.GetCode(): Integer;
begin
  Result := Self.F_id;
end;

function TMedidas.GetData(): TDate;
begin
  Result := Self.F_Data;
end;

function TMedidas.GetHora(): TTime;
begin
  Result := Self.F_Hora;
end;

function TMedidas.GetPluviometro(): Integer;
begin
  Result := Self.F_Pluviometro;
end;

function TMedidas.GetFluviometro(): Integer;
begin
  Result := Self.F_Fluviometro;
end;

function TMedidas.GetCreatedAt: TDateTime;
begin
  Result := Self.F_Created_at;
end;

function TMedidas.GetUpdatedAt: TDateTime;
begin
  Result := Self.F_Updated_at;
end;

function TMedidas.GetEnviado: Boolean;
begin
  Result := Self.F_Enviado;
end;

function TMedidas.GetDataEnvio: TDateTime;
begin
  Result := Self.F_Data_envio;
end;

function TMedidas.GetRetorno: string;
begin
  Result := Self.F_Retorno;
end;
{$ENDREGION}
// Set
{$REGION 'SET'}

procedure TMedidas.SetCode(Const Value: Integer);
begin
  Self.F_id := Value;
end;

procedure TMedidas.SetData(const Value: TDate);
begin
  Self.F_Data := Value;
end;

procedure TMedidas.SetHora(const Value: TTime);
begin
  Self.F_Hora := Value;
end;

procedure TMedidas.SetFluviometro(const Value: Integer);
begin
  Self.F_Fluviometro := Value;
end;

procedure TMedidas.SetPluviometro(const Value: Integer);
begin
  Self.F_Pluviometro := Value;
end;

procedure TMedidas.SetCreatedAt(const Value: TDateTime);
begin
  Self.F_Created_at := Value;
end;

procedure TMedidas.SetUpdatetedAt(const Value: TDateTime);
begin
  Self.F_Updated_at := Value;
end;

procedure TMedidas.SetEnviado(const Value: Boolean);
begin
  Self.F_Enviado := Value;
end;

procedure TMedidas.SetDataEnvio(const Value: TDateTime);
begin
  Self.F_Data_envio := Value;
end;

procedure TMedidas.SetRetorno(const Value: string);
begin
  Self.F_Retorno := Value;
end;
{$ENDREGION}

end.
