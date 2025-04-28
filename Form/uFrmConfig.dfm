object frmConfig: TfrmConfig
  Left = 0
  Top = 0
  Caption = 'Configura'#231#245'es'
  ClientHeight = 604
  ClientWidth = 613
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 315
    Width = 613
    Height = 105
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label3: TLabel
      Left = 16
      Top = 5
      Width = 30
      Height = 16
      Caption = 'Porta'
    end
    object Label4: TLabel
      Left = 340
      Top = 5
      Width = 62
      Height = 16
      Caption = 'Velocidade'
    end
    object cbComPorts: TComComboBox
      Left = 8
      Top = 27
      Width = 265
      Height = 24
      Text = ''
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 0
    end
    object ComboBoxBaud: TComComboBox
      Left = 340
      Top = 27
      Width = 265
      Height = 24
      Text = ''
      Style = csDropDownList
      ItemIndex = -1
      TabOrder = 1
    end
    object BitBtn1: TBitBtn
      Left = 440
      Top = 72
      Width = 149
      Height = 25
      Caption = 'Testar Comunica'#231#227'o'
      TabOrder = 2
      OnClick = BitBtn1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 613
    Height = 249
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 60
      Width = 141
      Height = 16
      Caption = 'WEBSERVCE PRODU'#199#195'O'
    end
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 168
      Height = 16
      Caption = 'WEBSERVCE HOMOLOGA'#199#195'O'
    end
    object Label5: TLabel
      Left = 8
      Top = 187
      Width = 43
      Height = 16
      Caption = 'Usu'#225'rio'
    end
    object Label6: TLabel
      Left = 340
      Top = 187
      Width = 36
      Height = 16
      Caption = 'Senha'
    end
    object rdbAmbiente: TRadioGroup
      Left = 8
      Top = 112
      Width = 597
      Height = 69
      Caption = 'Ambiente'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Produ'#231#227'o'
        'Homologa'#231#227'o')
      TabOrder = 0
    end
    object edtWebProd: TEdit
      Left = 8
      Top = 82
      Width = 597
      Height = 24
      TabOrder = 1
    end
    object edtWebHomo: TEdit
      Left = 8
      Top = 30
      Width = 597
      Height = 24
      TabOrder = 2
    end
    object EdtUsuario: TEdit
      Left = 8
      Top = 209
      Width = 265
      Height = 24
      TabOrder = 3
    end
    object edtSenha: TEdit
      Left = 340
      Top = 209
      Width = 265
      Height = 24
      TabOrder = 4
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 249
    Width = 613
    Height = 66
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label7: TLabel
      Left = 6
      Top = 8
      Width = 67
      Height = 16
      Caption = 'Pluviometro'
    end
    object Label8: TLabel
      Left = 340
      Top = 8
      Width = 67
      Height = 16
      Caption = 'Fluviometro'
    end
    object edtPluviometro: TEdit
      Left = 8
      Top = 30
      Width = 265
      Height = 24
      TabOrder = 0
    end
    object edtFluviometro: TEdit
      Left = 340
      Top = 30
      Width = 265
      Height = 24
      TabOrder = 1
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 543
    Width = 613
    Height = 61
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object BitBtn2: TBitBtn
      Left = 528
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Sair'
      TabOrder = 0
      OnClick = BitBtn2Click
    end
    object BitBtn3: TBitBtn
      Left = 447
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Gravar'
      TabOrder = 1
      OnClick = BitBtn3Click
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 420
    Width = 613
    Height = 123
    Align = alTop
    TabOrder = 4
    object Label9: TLabel
      Left = 16
      Top = 6
      Width = 91
      Height = 16
      Caption = 'Banco de Dados'
    end
    object Label10: TLabel
      Left = 16
      Top = 64
      Width = 43
      Height = 16
      Caption = 'Usu'#225'rio'
    end
    object Label11: TLabel
      Left = 322
      Top = 64
      Width = 36
      Height = 16
      Caption = 'Senha'
    end
    object edtBanco: TEdit
      Left = 16
      Top = 28
      Width = 589
      Height = 24
      TabOrder = 0
    end
    object edtUsuarioDB: TEdit
      Left = 16
      Top = 86
      Width = 281
      Height = 24
      TabOrder = 1
    end
    object edtSenhaDB: TEdit
      Left = 322
      Top = 86
      Width = 281
      Height = 24
      TabOrder = 2
    end
  end
  object ComPort1: TComPort
    BaudRate = br38400
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbTwoStopBits
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = [spBasic]
    TriggersOnRxChar = True
    Left = 288
    Top = 368
  end
end
