unit p_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DateUtils, IniFiles, Menus;

type
  news = (G_Left, G_Right, G_Up, G_Down, G_Nil); //左，右，上，下，无

  dt = array[0..3, 0..3] of Integer;

type
  Tf_main = class(TForm)
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    pm1: TPopupMenu;
    w1: TMenuItem;
    a1: TMenuItem;
    s1: TMenuItem;
    d1: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure w1Click(Sender: TObject);
    procedure a1Click(Sender: TObject);
    procedure s1Click(Sender: TObject);
    procedure d1Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
  private
    ydx, ydy: Integer;
    jgx, jgy: Integer;
    bjw, bjh: Integer;
    gzw, gzh: Integer;
    x, y: Integer;      //该坐标添加数据
    G_key: Integer;     //键值是否有效
    G_move: Integer;    //移动是否有效
    G_move2: Integer;   //再次移动
    G_add: Integer;     //数值是否累加
    G_new: Integer;     //是否新增数值
    G_news: Integer;    //游戏开始
    G_over: Integer;    //游戏是否结束
    g_zt: Integer;      //可调字体
    map: dt; //游戏 当前数据
    m_ls: dt;
    bekeup: dt; //游戏 备份数据
    before: news;
    Now: news;
    //自动化
    w, a, s, d: Boolean;  //可移动方向
    //
    procedure left;
    procedure right;
    procedure show;
    procedure replis; overload;
    procedure operation;
    procedure Testing(w: Word);
    procedure Ready_add;
    procedure AddDB;
    procedure Left_Zero;    //去除0
    procedure right_Zero;       //添加0
    procedure gz(i: Integer; str: string; col: TColor);
    //自动化
    procedure fx(loc: string);
    procedure cs1;
    procedure cs2;
    //
    function Random_: Integer; //取随机值方法 返回 2/4
    function MColor(i: Integer): TColor; //返回指定颜色值
    function replis(map: dt): dt; overload;
    function IsMove(num1, num2: Integer): Boolean;
    function ergodic(num: Integer): Integer;  //通过遍历数组 确定是否可以添加基础数字
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_main: Tf_main;
  dw: array[0..3, 0..3] of Integer = ((2, 0, 4, 0), (4, 0, 2, 0), (0, 0, 0, 0), (0, 0, 0, 0));
  ds: array[0..3, 0..3] of Integer = ((2, 0, 0, 0), (4, 4, 0, 0), (8, 2, 0, 0), (4, 4, 0, 0));
  dd: array[0..3, 0..3] of Integer = ((2, 4, 8, 2), (2, 4, 2, 8), (0, 0, 4, 2), (0, 0, 0, 0));
  da: array[0..3, 0..3] of Integer = ((2, 0, 0, 0), (2, 4, 2, 0), (4, 2, 0, 0), (4, 0, 0, 0));

implementation

{$R *.dfm}
uses
  util2048;
//  GDIPOBJ, GDIPAPI;

function Tf_main.Random_;
begin
  Randomize;
  if Random(4) = 3 then
    Result := 4
  else
    Result := 2
end;

procedure Tf_main.FormCreate(Sender: TObject);
begin
  //创建默认赋值 为-1 运行时 0/1 False / True
  G_key := -1;
  G_move := -1;
  G_move2 := -1;
  G_add := -1;
  G_new := -1;
  G_news := -1;
  G_over := -1;
  G_zt := -1;
  Now := G_Nil;
  ydx := 50;
  ydy := 50;
  jgx := 15;
  jgy := 15;
  bjw := 500;
  bjh := 500;
  gzw := 106;
  gzh := 106;
  Canvas.Font.Size := 38
end;

procedure Tf_main.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  a: TBitmap;
begin
  if key = VK_UP then       //可以改变字体大小
    g_zt := 1
  else if key = VK_DOWN then  //不能改变字体大小
    g_zt := 0
  else if key = VK_SCROLL then
  begin
    a := tbitmap.Create;
    a.Width := 500;
    a.Height := 500;
    a.Canvas.CopyRect(a.Canvas.ClipRect, Canvas, Rect(50, 50, 550, 550));
    a.SaveToFile(ExtractFilePath(Application.ExeName) + inttostr(2048) + '.bmp');
  end
  else if key in [65, 68, 83, 87] then
  begin
    Testing(key);
    if G_move = 1 then
    begin
      bekeup := map;
      before := Now;
      if key = $57 then       //UP        87
      begin
        Now := G_Up;
        replis;
        left;
        map := replis(map);
      end
      else if key = $44 then  //Right    68
      begin
        Now := G_Right;
        Right;
      end
      else if key = $41 then  //Left      65
      begin
        Now := G_Left;
        left;
      end
      else if key = $53 then  //Down       83
      begin
        Now := G_Down;
        replis;
        Right;
        map := replis(map);
      end;
    end;
    //是否可添加数据
    Ready_add;
    if (G_move = 1) then
    begin
      if G_new = 1 then
      begin
      //添加数据
        AddDB;
      end;
      //显示
      show;
    end
    else if (G_new = 0) and (G_move2 = 0) then
    begin
      G_over := 1;
      Application.MessageBox(PChar('游戏结束'), '提示', MB_OK + MB_ICONQUESTION);
    end;
  end;
end;

procedure Tf_main.FormPaint(Sender: TObject);
begin
  if G_over <> 1 then
  begin
    Canvas.Pen.Color := TColor($A0adbb);
    Canvas.Brush.Color := TColor($A0adbb);
    Canvas.RoundRect(ydx, ydy, bjw + ydx, bjh + ydy, 10, 10);  //500*500
    operation;
  end;
end;

procedure Tf_main.btn1Click(Sender: TObject);
var
  ls: news;
begin
  //重新开始游戏

  //地图
  map := bekeup;
  G_news := 1;
  g_zt := 0;
  map := dt(bekeup);
  //重新绘制
  show;
end;

procedure Tf_main.fx(loc: string);
var
  zx, zy: Integer;
  now_K, Upper_latter, Lower_latter, Left_latter, Right_latter: Integer;
begin
  zy := StrToInt(copy(loc, pos(',', loc) + 1, Length(loc)));
  zx := StrToInt(copy(loc, 0, pos(',', loc) - 1));
  w := False;
  a := False;
  s := False;
  d := False;
  now_K := map[zx][zy];
  if zx > 0 then
  begin
    if zx < 3 then
    begin
      Lower_latter := map[zx + 1][zy];
    end;
    Upper_latter := map[zx - 1][zy];
  end
  else if zx = 0 then
  begin
    Upper_latter := -1;
    Lower_latter := map[zx + 1][zy];
  end
  else if zx < 0 then
  begin
    OutputDebugString(PChar('游戏错误'));
  end;

  if zy > 0 then
  begin
    if zy < 3 then
    begin
      Right_latter := map[zx][zy + 1];
    end;
    Left_latter := map[zx][zy - 1];
  end
  else if zy = 0 then
  begin
    Left_latter := -1;
    Right_latter := map[zx][zy + 1];
  end
  else if zy < 0 then
  begin
    OutputDebugString(PChar('游戏错误'));
  end;

  if IsMove(Left_latter, now_K) then
    a := True;
  if IsMove(Right_latter, now_K) then
    d := True;
  if IsMove(Upper_latter, now_K) then
    w := True;
  if IsMove(Lower_latter, now_K) then
    s := True;
end;

procedure Tf_main.cs2;
var
  i, j: Integer;
  Location: integer;
  num: Integer;
  max: Integer;
  no1, no2: Integer;
  Loc_s: string;
  key: Word;
begin
  num := 4;
  key := 0;
  max := -1;
  Location := map[0][0];
  if Location = 0 then
  begin
    for I := 0 to 3 do
    begin
      no1 := map[0][i];
      no2 := map[i][0];
      if no1 > max then
      begin
        max := no1;
        Loc_s := IntToStr(i) + ',' + IntToStr(j);
        Break;
      end;
      if no2 > max then
      begin
        max := no1;
        Loc_s := IntToStr(i) + ',' + IntToStr(j);
        Break;
      end;
    end;
  end
  else
  begin
  end;
end;

procedure Tf_main.cs1;
var
  key: Word;
begin
//  util2048.map := map;
//  key := util2048.cs1;
  FormKeyDown(nil, key, []);
end;

procedure Tf_main.btn2Click(Sender: TObject);
begin
//  cs1;
//  cs2;

end;

procedure Tf_main.btn4Click(Sender: TObject);
var
  i, j: Integer;
begin
  //重新开始游戏
  G_news := 1;
  g_zt := 0;
  //清除map数据
  for i := 0 to 3 do
    for j := 0 to 3 do
    begin
      map[i][j] := 0;
    end;
  //清除备份数据
  //添加数据
  if G_news = 1 then
  begin
    for I := 0 to 1 do
    begin
      Ready_add;
      AddDB;
    end;
    G_news := 0;
  end;
  //重新绘制
  show;
end;

procedure Tf_main.btn6Click(Sender: TObject);
begin
  show;
end;

procedure Tf_main.right_Zero;
var
  e, i, j: Integer;
  now: Integer;
begin
  if G_move = 1 then
  begin
    for I := 0 to 3 do
    begin
      e := 4;
      for j := 3 downto 0 do
      begin
        now := map[i][j];
        if now <> 0 then
        begin
          e := e - 1;
          if j < e then
          begin
            map[i][e] := now;
            map[i][j] := 0;
          end;
        end;
      end;
    end;
  end;
end;

procedure Tf_main.Left_Zero;
var
  e, i, j: Integer;
  now: Integer;
begin
  for I := 0 to 3 do
  begin
    e := -1;
    for j := 0 to 3 do
    begin
      now := map[i][j];
      if now <> 0 then
      begin
        e := e + 1;
        if j > e then
        begin
          map[i][e] := now;
          map[i][j] := 0;
        end;
      end;
    end;
  end;
end;

procedure Tf_main.a1Click(Sender: TObject);
begin
  //重新开始游戏
  G_news := 1;
  g_zt := 0;
  map := dt(da);
  //重新绘制
  show;
end;

procedure Tf_main.d1Click(Sender: TObject);
begin
  //重新开始游戏
  G_news := 1;
  g_zt := 0;
  map := dt(dd);
  //重新绘制
  show;
end;

procedure Tf_main.w1Click(Sender: TObject);
var
  bf, pf: TColor;
begin
//  //重新开始游戏
//  G_news := 1;
//  g_zt := 0;
//  map := dt(dw);
//  //重新绘制
//  show;
  bf := Canvas.Brush.Color;
  pf := Canvas.Pen.Color;
  Canvas.Pen.Color:=clRed;
  Canvas.MoveTo(150,150);
  Canvas.LineTo(250,150);
//  Canvas.Polyline();

  Canvas.Brush.Color := bf;
  Canvas.Pen.Color := pf;

end;

procedure Tf_main.s1Click(Sender: TObject);
begin
  //重新开始游戏
  G_news := 1;
  g_zt := 0;
  map := dt(ds);
  //重新绘制
  show;
end;

procedure Tf_main.show;
begin
  Canvas.Pen.Color := TColor($A0adbb);
  Canvas.Brush.Color := TColor($A0adbb);
  Canvas.RoundRect(ydx, ydy, bjw + ydx, bjh + ydy, 10, 10);  //500*500
  operation;
end;

procedure Tf_main.replis;
var
  e, i, j: Integer;
begin
  for I := 0 to 3 do
    for j := 0 to 3 do
      if j < i then
      begin
        e := map[i][j];
        map[i][j] := map[j][i];
        map[j][i] := e;
      end;
end;

function Tf_main.MColor(i: Integer): TColor;
begin
  if i = 0 then
    Result := TColor($b4c1cd)
  else if i = 2 then
    Result := TColor($dae4ee)
  else if i = 4 then
    Result := TColor($c8e0ed)
  else if i = 8 then
    Result := TColor($79abf2)
  else if i = 16 then
    Result := TColor($6395f5)
  else if i = 32 then
    Result := TColor($5f7cf6)
  else if i = 64 then
    Result := TColor($3c5ff6)
  else if i = 128 then
    Result := TColor($72cfed)
  else if i = 256 then
    Result := TColor($61cced)
  else if i = 512 then
    Result := TColor($50c8ed)
  else if i = 1024 then
    Result := TColor($3fc5ed)
  else if i = 2048 then
    Result := TColor($2ec2ed)
  else if i >= 4096 then
    Result := TColor($323a3c);
end;

procedure Tf_main.N11Click(Sender: TObject);
begin
  Self.BorderStyle := bsNone;
  Self.Color := clBlack;
  Self.TransparentColor := True;
  Self.TransparentColorValue := clBlack;
end;

procedure Tf_main.N21Click(Sender: TObject);
begin
  Self.BorderStyle := bsToolWindow;
  Self.TransparentColor := False;
  Self.TransparentColorValue := clBlack;
end;

function Tf_main.IsMove(num1, num2: Integer): Boolean;
begin
  if ((num1 = 0) and (num2 > 0)) or     //num1>0 & num2=0    左
    ((num2 > 0) and (num2 = num1)) then //num1=num2 & num2>0
    Result := True
  else
    Result := False;
end;

function Tf_main.replis(map: dt): dt;
var
  i, j: Integer;
//  SysTime: TSystemTime;
//  start, stop: TDateTime;
//  s: string;
  n: dt;
begin
//  GetLocalTime(SysTime);
//  start := SystemTimeToDateTime(SysTime);
  for I := 0 to 3 do
    for j := 0 to 3 do
      n[i][j] := 0;
  for I := 0 to 3 do
    for j := 0 to 3 do
      n[j][i] := map[i][j];
  Result := n;
//  stop := SystemTimeToDateTime(SysTime);
//  s := '方法共运行了 ' + IntToStr(MilliSecondsBetween(start, stop)) + ' 毫秒';
//  Application.MessageBox(PChar(s), '提示', MB_OK + MB_ICONQUESTION);
end;

procedure Tf_main.Ready_add;
var
  e, i, j: Integer;
  strary: array[0..15] of string;
  str: string;
begin
  //重置计数器
  e := 0;
  //遍历map
  for i := 0 to 3 do
    for j := 0 to 3 do
    begin
      //统计值为 0 的个数
      if map[i][j] = 0 then
      begin
        strary[e] := IntToStr(i) + ',' + IntToStr(j);
        e := e + 1;
      end;
    end;
  //获取是否可添加 以及 添加值
  e := ergodic(e);
  if e <> -1 then
  begin
    str := strary[e];
    y := StrToInt(copy(str, pos(',', str) + 1, Length(str)));
    x := StrToInt(copy(str, 0, pos(',', str) - 1));
  end;
end;

function Tf_main.ergodic(num: Integer): Integer;
begin
  if num > 0 then
  begin
    Randomize;
    num := random(num);
    Result := num;
    G_new := 1;
  end
  else
  begin
    Result := -1;
    G_new := 0;
  end;
end;

procedure Tf_main.AddDB;
var
  e: Integer;
begin
  if (G_new = 1) or (G_news = 1) then
  begin      
    //重置是否可新增
    G_new := 0;
    //获取添加数值
    e := Random_;
    //待添加数值位置 赋值
    map[x][y] := e;
  end
  else
  begin
    OutputDebugString(PChar('不能添加新数据'));
  end;
end;

procedure Tf_main.operation;
var
  str: string;
  i, j, e: Integer;
begin
  //取得颜色
  //绘画格子 gz(第几个；内容；颜色) 例 gz(3,inttostr(4),TColor($dae4ee))
  for I := 0 to 3 do
    for j := 0 to 3 do
    begin
      e := map[i][j];
      str := IntToStr(e);
      gz(i * 4 + j, str, MColor(e));
    end;
end;

procedure Tf_main.gz(i: Integer; str: string; col: TColor);
var
  xd, yd, w, h: Integer;
  zw, zh: Integer;
  qx, qy: Integer;
  e: Integer;
label
  l1;
begin
  xd := ydx + jgx + (gzw + jgx) * (i mod 4);
  yd := ydy + jgy + (gzh + jgy) * (i div 4);
  w := xd + gzw;
  h := yd + gzh;

  Self.Canvas.Font.Style := [fsBold];
  Canvas.Brush.Color := col;
  Canvas.Pen.Color := col;
  Canvas.Font.Name := '微软雅黑';
  Canvas.Pen.Width := 1;
  Canvas.RoundRect(xd, yd, w, h, 10, 10);

  e := StrToInt(str);
  if e <> 0 then
  begin
    if e < 8 then
    begin
      Canvas.Font.Color := TColor($776e65);
    end
    else
    begin
      Canvas.Font.Color := TColor($f2f6f9);
    end;
//  if (G_ZT = -1) or (g_zt = 1) then
//    Canvas.Font.Size := Canvas.Font.Size
//  else
//  begin
    if e < 1024 then
      Canvas.Font.Size := 38
    else if e < 8192 then
      Canvas.Font.Size := 23
    else
      Canvas.Font.Size := 21;
l1:
    zw := Canvas.TextWidth(str);
    zh := Canvas.TextHeight(str);
    if (zw > gzw) or (zh > gzh) then
    begin
      Canvas.Font.Size := Canvas.Font.Size - 1;
      goto l1;
    end;
    qx := xd + (gzw div 2) - (zw div 2);
    qy := yd + (gzh div 2) - (zh div 2);
    Canvas.TextOut(qx, qy, str);
  end;
//  end;
end;

procedure Tf_main.left;
var
  i, j: Integer;
//  count: Integer;
  now, bef: Integer;
begin
  Left_Zero;
  if G_move = 1 then
  begin
//    count := -1;
    for I := 0 to 3 do
    begin
      for j := 0 to 2 do
      begin
        now := map[i][j];
        bef := map[i][j + 1];
        if (now = bef) and (now <> 0) then
        begin
          map[i][j] := now * 2;
          map[i][j + 1] := 0;
//          count := count + 1;
        end;
      end;
    end;
    Left_Zero;
  end;
end;

procedure Tf_main.right;
var
  i, j: Integer;
  now, bef: Integer;
begin
  right_Zero;
  if G_move = 1 then
  begin
    for I := 0 to 3 do
    begin
      for j := 3 downto 1 do
      begin
        now := map[i][j];
        bef := map[i][j - 1];
        if (now = bef) and (now <> 0) then
        begin
          map[i][j] := now * 2;
          map[i][j - 1] := 0;
        end;
      end;
    end;
    right_Zero;
  end;
end;

procedure Tf_main.Testing(w: Word);
var
  i, j: Integer;
  now_K, Upper_latter, Lower_latter, Left_latter, Right_latter: Integer;
  w_c, s_c, a_c, d_c: Integer; //
begin
  w_c := -1;
  s_c := -1;
  a_c := -1;
  d_c := -1;
  G_move2 := 0;
  for I := 0 to 3 do
  begin
    for j := 0 to 3 do
    begin
      Upper_latter := -1;
      Left_latter := -1;
      Lower_latter := -1;
      Right_latter := -1;
      now_K := map[i][j];
      if i > 0 then
      begin
        if i < 3 then
        begin
          Lower_latter := map[i + 1][j];
        end;
        Upper_latter := map[i - 1][j];
      end
      else if i = 0 then
      begin
        Upper_latter := -1;
        Lower_latter := map[i + 1][j];
      end
      else if i < 0 then
      begin
        OutputDebugString(PChar('游戏错误'));
      end;

      if j > 0 then
      begin
        if j < 3 then
        begin
          Right_latter := map[i][j + 1];
        end;
        Left_latter := map[i][j - 1];
      end
      else if j = 0 then
      begin
        Left_latter := -1;
        Right_latter := map[i][j + 1];
      end
      else if j < 0 then
      begin
        OutputDebugString(PChar('游戏错误'));
      end;

      if IsMove(Left_latter, now_K) then
        a_c := a_c + 1;
      if IsMove(Right_latter, now_K) then
        d_c := d_c + 1;
      if IsMove(Upper_latter, now_K) then
        w_c := w_c + 1;
      if IsMove(Lower_latter, now_K) then
        s_c := s_c + 1;
    end;
  end;
  if w_c + s_c + a_c + d_c > -1 then
    G_move2 := 1;
  if w = $57 then
  begin
    if w_c <> -1 then     //UP
    begin
      Now := G_Up;
      G_move := 1;
    end
    else
    begin
      G_move := 0;
      OutputDebugString(PChar('不能向上移动'));
    end;
  end
  else if w = $44 then  //Right
  begin
    if d_c <> -1 then
    begin
      Now := G_Right;
      G_move := 1;
    end
    else
    begin
      G_move := 0;
      OutputDebugString(PChar('不能向右移动'));
    end;
  end
  else if w = $41 then  //Left
  begin
    if a_c <> -1 then
    begin
      Now := G_Left;
      G_move := 1;
    end
    else
    begin
      G_move := 0;
      OutputDebugString(PChar('不能向左移动'));
    end;
  end
  else if w = $53 then  //Down
  begin
    if s_c <> -1 then
    begin
      Now := G_Down;
      G_move := 1;
    end
    else
    begin
      G_move := 0;
      OutputDebugString(PChar('不能向下移动'));
    end;
  end;
  if G_move2 = 0 then
  begin
    OutputDebugString(PChar('不能移动'));
  end;
end;

end.

