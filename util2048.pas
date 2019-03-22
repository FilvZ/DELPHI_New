unit util2048;

interface

uses
  SysUtils;

type
  dt = array[0..3, 0..3] of Integer;

procedure fx(loc: string);

function cs1: Integer;

function cs2: Integer;

function IsMove(num1, num2: Integer): Boolean;

implementation

var
  map: dt;

function IsMove(num1, num2: Integer): Boolean;
begin
  if ((num1 = 0) and (num2 > 0)) or     //num1>0 & num2=0    左
    ((num2 > 0) and (num2 = num1)) then //num1=num2 & num2>0
    Result := True
  else
    Result := False;
end;

function cs1: Integer;
var
  i, j: Integer;
  Location: integer;
  num: Integer;
  max: Integer;
  no1: Integer;
  Loc_s: string;
  key: Word;
  w, a, s, d: Boolean;
begin
//自动游戏 最佳选择
//定点 0，0
//高分原则
//优先 向上 左
//最大值在定点上是不能移动的
//也就是当定点无值 选择最大值 为定点预值 并向定点移动
  num := 4;
  key := 0;
  max := -1;
  Location := map[0][0];
  if Location = 0 then
  begin
    for i := 0 to 3 do
    begin
      for j := 0 to 3 do
      begin
        no1 := map[i][j];
        if no1 > max then
        begin
          max := no1;
          Loc_s := IntToStr(i) + ',' + IntToStr(j);
        end;
      end;
    end;
    fx(loc_s);
 //w=87 d=68 s=83 a=65
    if a then
    begin
      key := 65;
    end
    else
    begin
      if w then
      begin
        key := 87;
      end
      else
      begin
        key := 68;
      end;
    end;           
 //w=87 d=68 s=83 a=65
  end
  else
  begin
    if Location < num then
    begin
      for i := 0 to 3 do
      begin
        for j := 0 to 3 do
        begin
          no1 := map[i][j];
          if no1 > max then
          begin
            max := no1;
            Loc_s := IntToStr(i) + ',' + IntToStr(j);
          end;
        end;
      end;
      fx(loc_s);
      //w=87 d=68 s=83 a=65
      if a then
      begin
        key := 65;
      end
      else
      begin
        if w then
        begin
          key := 87;
        end
        else
        begin
          key := 68;
        end;
      end;
    end; 
 //w=87 d=68 s=83 a=65
  end;
end;

function cs2: Integer;
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

procedure fx(loc: string);
var
  zx, zy: Integer;
  now_K, Upper_latter, Lower_latter, Left_latter, Right_latter: Integer;
  w, a, s, d: Boolean;
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
  end;
//  else if zx < 0 then
//  begin
//    OutputDebugString(PChar('游戏错误'));
//  end;
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
  end;
//  else if zy < 0 then
//  begin
//    OutputDebugString(PChar('游戏错误'));
//  end;
  if IsMove(Left_latter, now_K) then
    a := True;
  if IsMove(Right_latter, now_K) then
    d := True;
  if IsMove(Upper_latter, now_K) then
    w := True;
  if IsMove(Lower_latter, now_K) then
    s := True;
end;

end.

