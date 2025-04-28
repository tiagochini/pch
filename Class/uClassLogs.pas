unit uClassLogs;

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
  TLogs = class
  private
    ConnectionDB: TZConnection;
    F_id: Integer;
    F_Data_Hora: TDateTime;
    F_Tipo: String;
    F_Mensagem: String;
    F_Medicoes_Json: String;

    function GetCode: Integer;
    function GetDataHora: TDateTime;
    function GetTipo: String;
    function GetMensagem: String;
    function GetMedicoesJson: String;

    procedure SetCode(const Value: Integer);
    procedure SetDataHora(const Value: TDateTime);
    procedure SetTipo(const Value: String);
    procedure SetMensagem(const Value: String);
    procedure SetMedicoesJson(const Value: String);

  public
    constructor Create(aConnectionDB: TZConnection);
    destructor Destroy; override;
    function Insert: Boolean;
    function Read(id: Integer): Boolean;
    function Update: Boolean;
    function Exclude: Boolean;

  published
    property id: Integer read GetCode write SetCode;
    property data_hora: TDateTime read GetDataHora write SetDataHora;
    property tipo: String read GetTipo write SetTipo;
    property mensagem: String read GetMensagem write SetMensagem;
    property medicoes_json: String read GetMedicoesJson write SetMedicoesJson;
  end;

implementation

// Constructor and Destruction
{$REGION 'Contructor and Destruction'}

constructor TLogs.Create(aConnectionDB: TZConnection);
begin
  ConnectionDB := aConnectionDB;
end;

destructor TLogs.Destroy;
begin

  inherited;
end;
{$ENDREGION}
// Get
{$REGION 'GET'}

function TLogs.GetCode(): Integer;
begin
  Result := Self.F_id;
end;

function TLogs.GetDataHora: TDateTime;
begin
  Result := Self.F_Data_Hora;
end;

function TLogs.GetTipo: string;
begin
  Result := Self.F_Tipo;
end;

function TLogs.GetMensagem: string;
begin
  Result := Self.F_Mensagem;
end;

function TLogs.GetMedicoesJson: string;
begin
  Result := Self.F_Medicoes_Json;
end;
{$ENDREGION}
// Set
{$REGION 'SET'}

procedure TLogs.SetCode(Const Value: Integer);
begin
  Self.F_id := Value;
end;

procedure TLogs.SetDataHora(const Value: TDateTime);
begin
  Self.F_Data_Hora := Value;
end;

procedure TLogs.SetTipo(const Value: string);
begin
  Self.F_Tipo := Value;
end;

procedure TLogs.SetMensagem(const Value: string);
begin
  Self.F_Mensagem := Value;
end;

procedure TLogs.SetMedicoesJson(const Value: string);
begin
  Self.F_Medicoes_Json := Value;
end;
{$ENDREGION}
// methods
{$REGION 'Methods'}

function TLogs.Insert: Boolean;
var
  Qry: TZQuery;
begin
  try
    Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConnectionDB;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('insert into log_envio_medicoes (tipo, mensagem, medicoes_json)'
      + 'values (:tipo, :mensagem, :medicoes_json)');
    Qry.ParamByName('tipo').AsString := Self.F_Tipo;
    Qry.ParamByName('mensagem').AsString := Self.F_Mensagem;
    Qry.ParamByName('medicoes_json').AsString := Self.F_Medicoes_Json;
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

function TLogs.Read(id: Integer): Boolean;
var
  Qry: TZQuery;
begin
  try
    Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConnectionDB;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('select id, data_hora, tipo, mensagem, medicoes_json from log_envio_medicoes WHERE id=:id');
    Qry.ParamByName('id').AsInteger := id;
    try
      Qry.Open;

      Self.F_id := Qry.FieldByName('id').AsInteger;
      Self.F_Data_Hora := Qry.FieldByName('data_hora').AsDateTime;
      Self.F_Tipo := Qry.FieldByName('tipo').AsString;
      Self.F_Mensagem := Qry.FieldByName('mensagem').AsString;
      Self.F_Medicoes_Json := Qry.FieldByName('medicoes_json').AsString;
    except
      Result := False;
    end;

  finally
    if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

function TLogs.Update: Boolean;
var
  Qry: TZQuery;
begin
  try
    Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConnectionDB;
    Qry.SQL.Clear;
    Qry.SQL.Add
      (' update log_envio_medicoes set data_hora = :data_hora, tipo = :tipo, mensagem = :mensagem, medicoes_json = :medicoes_json where (id = :id)');
    Qry.ParamByName('id').AsInteger := Self.id;
    Qry.ParamByName('data_hora').AsDateTime := Self.data_hora;
    Qry.ParamByName('tipo').AsString := Self.tipo;
    Qry.ParamByName('mensagem').AsString := Self.mensagem;
    Qry.ParamByName('medicoes_json').AsString := Self.medicoes_json;
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

function TLogs.Exclude: Boolean;
var
  Qry: TZQuery;
begin
  if MessageDlg('Apagar o Registro: ' + #13 + #13 + 'Código ' + IntToStr(F_id) +
    #13 + 'Data e Hora: ' + DateToStr(Self.F_Data_Hora) + #13 + 'Mensagem: ' +
    Self.F_Mensagem, TMsgDlgType.mtConfirmation,
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
    Qry.SQL.Add('DELETE FROM log_envio_medicoes WHERE id=:id');
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

end.
