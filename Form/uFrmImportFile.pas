unit uFrmImportFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.StdCtrls, Vcl.Buttons, uClassMedidas,
  uDtmConnection;

type
  TfrmImportFile = class(TForm)
    Label1: TLabel;
    edtFile: TEdit;
    btnBuscar: TBitBtn;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    PB: TProgressBar;
    lblProgress: TLabel;
    btnSair: TBitBtn;
    btnImportart: TBitBtn;
    tmrPB: TTimer;
    procedure btnBuscarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure leCsv(sFile: String);
    function carregaArquivo(sFile: String): Boolean;
    procedure btnImportartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrPBTimer(Sender: TObject);
  private
    { Private declarations }
    oMedidas: TMedidas;
  public
    { Public declarations }
  end;

var
  frmImportFile: TfrmImportFile;

implementation

var
  arq: TextFile;

{$R *.dfm}

procedure TfrmImportFile.btnBuscarClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  Begin
    edtFile.Text := OpenDialog1.FileName;
  End;
end;

procedure TfrmImportFile.btnImportartClick(Sender: TObject);
begin
  btnImportart.Enabled := False;
  btnSair.Enabled := False;
  btnBuscar.Enabled := False;
  PB.Enabled := True;
  tmrPB.Enabled := True;

  lblProgress.Caption := 'Importando Arquivos, Aguarde ...';
  ShowMessage('Importando Arquivo, aquarde até a mensagem de conclusão!');
  Self.leCsv(edtFile.Text);

  btnImportart.Enabled := True;
  btnSair.Enabled := True;
  btnBuscar.Enabled := True;
  tmrPB.Enabled := False;
  PB.Enabled := False;
  lblProgress.Caption := 'Concluido.';
end;

procedure TfrmImportFile.btnSairClick(Sender: TObject);
begin
  ModalResult := mrOk;
  Close;
end;

procedure TfrmImportFile.leCsv(sFile: string);
var
  Linha: string;
  Colunas: TStringList;
  nreg: integer;
begin
  Colunas := TStringList.Create;
  try
    if not Self.carregaArquivo(sFile) then
    begin
      ShowMessage('O Arquivo não pode ser aberto, ou esta corrompido!!');
      Abort;
    end;

    Append(arq);
    Reset(arq); { abre o arquivo texto para leitura }

    nreg := 0;

    while (not Eof(arq)) do { enquanto não atingir a marca de final de arquivo }
    begin
      try
        Readln(arq, Linha);

        Colunas.Text := StringReplace(Linha, ';', #13, [rfReplaceAll]);
        nreg := nreg + 1;

        if nreg = 58038 then
          ShowMessage(nreg.ToString);

        if (Colunas.Count >= 4) AND not(Colunas[1].IsEmpty) AND
          (Length(Colunas[0]) < 10) then
        begin
          oMedidas := TMedidas.Create(dtmConnection.Connection);
          oMedidas.Find(Colunas[1], Colunas[0]);

          if not(oMedidas.id > 0) then
          begin
            oMedidas.hora := StrToTime(Colunas[0]);
            oMedidas.data := StrToDate(Colunas[1]);
            oMedidas.fluviometro := StrToInt(Colunas[2]);
            oMedidas.pluviometro := StrToInt(Colunas[3]);
            oMedidas.Insert();
          end;

          if Assigned(oMedidas) then
            oMedidas.Free;
        end;
        Application.ProcessMessages;
      except
        on ex: Exception do
          ShowMessage('Error: ' + ex.Message);
      end;
    end;

  finally
    CloseFile(arq);
    Colunas.Free;

  end;
end;

procedure TfrmImportFile.tmrPBTimer(Sender: TObject);
begin
  if PB.Position >= 100 then
  begin
    PB.Position := 0;
  end
  else
  begin
    PB.Position := PB.Position + 5;
  end;
  Application.ProcessMessages;
end;

function TfrmImportFile.carregaArquivo(sFile: string): Boolean;
begin
  AssignFile(arq, sFile);
{$I-}
  Reset(arq);
{$I+}
  if (IOResult <> 0) then
  begin
    Result := False;
  end
  else
  begin
    CloseFile(arq);
    Append(arq); { o arquivo existe e será aberto para saídas adicionais }
    Result := True;
  end;
end;

procedure TfrmImportFile.FormCreate(Sender: TObject);
begin
  lblProgress.Caption := 'Aguardando arquivo para ser importado.';
end;

end.
