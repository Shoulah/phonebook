object FrAddContact: TFrAddContact
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Add Contact'
  ClientHeight = 225
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 395
    Height = 207
    TabOrder = 0
    object Label1: TLabel
      Left = 4
      Top = 11
      Width = 55
      Height = 13
      Caption = 'First Name:'
    end
    object Label2: TLabel
      Left = 4
      Top = 38
      Width = 54
      Height = 13
      Caption = 'Last Name:'
    end
    object Label3: TLabel
      Left = 4
      Top = 65
      Width = 40
      Height = 13
      Caption = 'Phone1:'
    end
    object Label4: TLabel
      Left = 4
      Top = 92
      Width = 40
      Height = 13
      Caption = 'Phone2:'
    end
    object Label5: TLabel
      Left = 4
      Top = 119
      Width = 40
      Height = 13
      Caption = 'Phone3:'
    end
    object Label6: TLabel
      Left = 4
      Top = 146
      Width = 40
      Height = 13
      Caption = 'phone4:'
    end
    object Label7: TLabel
      Left = 4
      Top = 173
      Width = 40
      Height = 13
      Caption = 'phone5:'
    end
    object Button1: TButton
      Left = 294
      Top = 168
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 7
      OnClick = Button1Click
    end
    object NumEdit1: TNumEdit
      Left = 64
      Top = 62
      Width = 145
      Height = 21
      TabOrder = 2
      AllowZeroStart = True
    end
    object NumEdit2: TNumEdit
      Left = 64
      Top = 89
      Width = 145
      Height = 21
      TabOrder = 3
      AllowZeroStart = True
    end
    object NumEdit3: TNumEdit
      Left = 64
      Top = 116
      Width = 145
      Height = 21
      TabOrder = 4
      AllowZeroStart = True
    end
    object NumEdit4: TNumEdit
      Left = 64
      Top = 143
      Width = 145
      Height = 21
      TabOrder = 5
      AllowZeroStart = True
    end
    object NumEdit5: TNumEdit
      Left = 64
      Top = 170
      Width = 145
      Height = 21
      TabOrder = 6
      AllowZeroStart = True
    end
    object Edit1: TUpperCaseEdit
      Left = 65
      Top = 8
      Width = 304
      Height = 21
      TabOrder = 0
      UpperFirst = True
    end
    object Edit2: TUpperCaseEdit
      Left = 64
      Top = 35
      Width = 305
      Height = 21
      TabOrder = 1
      UpperFirst = True
    end
  end
  object SQLQuery1: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = FrMain.SQLConnection1
    Left = 88
    Top = 16
  end
end
