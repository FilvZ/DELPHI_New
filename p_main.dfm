object f_main: Tf_main
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = '2048'
  ClientHeight = 600
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 171
    Top = 8
    Width = 75
    Height = 25
    Caption = #19978#19968#27493
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #24494#36719#38597#40657
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 248
    Top = 8
    Width = 75
    Height = 25
    Caption = #25512#33616
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #24494#36719#38597#40657
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btn2Click
  end
  object btn3: TButton
    Left = 326
    Top = 8
    Width = 75
    Height = 25
    Caption = #35835#21462
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #24494#36719#38597#40657
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object btn4: TButton
    Left = 94
    Top = 8
    Width = 75
    Height = 25
    Caption = 'NEWS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #24494#36719#38597#40657
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btn4Click
  end
  object btn5: TButton
    Left = 403
    Top = 8
    Width = 75
    Height = 25
    Caption = #27979#35797
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #24494#36719#38597#40657
    Font.Style = [fsBold]
    ParentFont = False
    PopupMenu = pm1
    TabOrder = 4
  end
  object btn6: TButton
    Left = 480
    Top = 8
    Width = 75
    Height = 25
    Caption = 'show'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #24494#36719#38597#40657
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = btn6Click
  end
  object pm1: TPopupMenu
    Left = 448
    Top = 48
    object w1: TMenuItem
      Caption = 'w'
      OnClick = w1Click
    end
    object a1: TMenuItem
      Caption = 'a'
      OnClick = a1Click
    end
    object s1: TMenuItem
      Caption = 's'
      OnClick = s1Click
    end
    object d1: TMenuItem
      Caption = 'd'
      OnClick = d1Click
    end
    object N11: TMenuItem
      Caption = '1'
      OnClick = N11Click
    end
    object N21: TMenuItem
      Caption = '2'
      OnClick = N21Click
    end
  end
end
