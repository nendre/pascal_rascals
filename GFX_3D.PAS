{$G+,N+}
program GraphicsIn3d;   { (c) 1997, P.RoTTeR } { Starfield? }
uses Dos;
const np = 500;
      bin : Array[1..8] of Byte = (128,64,32,16,8,4,2,1);

type t_kp = Array[0..199,0..319] of Byte;
     t_pt = Record X,Y,Z : Double; End;

     t_fnt = Array[1..4096] of Byte; t_chr = Array[1..16] of Byte;

var pnt   : Array[1..np] of t_pt;
    sint,
    cost  : Array[0..359] of Double;

    i,j,k,
    xp,yp : Word;
    kep   : t_kp absolute $a000:0;
    k2,k3 : ^t_kp;

    ft  : t_fnt; ct : t_chr;

{ 3D routines }

function DR(deg : Double) : Double;
begin
  DR := Abs(deg)*pi/180.0;
end;

procedure MakeTables;
var pv : Word;

begin
  for pv := 0 to 359 do
  begin sint[pv] := Sin(DR(pv)); cost[pv] := Cos(DR(pv)); end;
end;

procedure RotateXYZ(rx,ry,rz : Integer; VAR ox,oy,oz : Double);
var nx,ny,nz : Double;

begin
  if rx<>0 then
  begin
    nx := ox; ny := (oy*(cost[rx]))-(oz*(sint[rx]));
    nz := (oy*(sint[rx]))+(oz*(cost[rx]));
  end;

  if ry<>0 then
  begin
    nx := (ox*(cost[ry]))+(oz*(sint[ry])); ny := oy;
    nz := -(ox*(sint[ry]))+(oz*(cost[ry]));
  end;

  if rz<>0 then
  begin
    nx := (ox*(cost[rz]))-(oy*(sint[rz]));
    ny := (ox*(sint[rz]))+(oy*(cost[rz])); nz := oz;
  end;

  ox := nx; oy := ny; oz := nz;
end;

procedure C32(ox,oy,oz : Double; ep : Integer; VAR nx,ny : Word);
begin
  nx := Round((ox*ep)/oz); ny := Round((oy*ep)/oz);
end;

{ 3D --- 3D }

procedure HeapSort(nm : Word);

procedure Swap(i,j : Word); var xx : t_pt;
begin
  xx := pnt[i]; pnt[i] := pnt[j]; pnt[j] := xx;
end;

procedure Stack(i,j : Word); var k : Word;
begin
  k := i shl 1;
  if k<=j then
  begin
    if k<j then if pnt[k].Z<pnt[k+1].Z then Inc(k);
    if pnt[i].Z<pnt[k].Z then begin Swap(i,k); Stack(k,j); end;
  end;
end;

begin
  for i := (nm shr 1) downto 1 do Stack(i,nm);
  for i := nm downto 2 do begin Swap(1,i); Stack(1,i-1); end;
end;

procedure Move2(VAR source,dest; size : Word); Assembler; { TMA's }
ASM
  push ds; push es; lds si, source; les di, dest; mov cx, size
  cld; shr cx,1; jnc @word1; movsb
 @word1:
  shr cx,1; jnc @word2; movsw
 @word2: db 0f3h,066h,0a5h
  pop es; pop ds
END;

{ main procs }

procedure VRet; Assembler;
ASM
  mov  dx,3DAh
 @1: in  al,dx; test al,8; jz  @1
 @2: in  al,dx; test al,8; jnz @2
END;

procedure Decr(sg : Word; nd : Byte); Assembler; { PixDecrease (c) PR'97 }
ASM
  mov DI,sg; mov ES,DI; mov DI,64000
 @Loop:
  mov AL,ES:[DI]; mov BL,nd
 @Decr:
  dec AL; JZ @Stop; dec BL; jnz @Decr
 @End:
  mov ES:[DI],AL; dec DI; jnz @Loop; jmp @Ex
 @Stop:
  mov al,1; jmp @End
 @Ex:
END;

procedure Aver(sg : Word); Assembler;
ASM
  mov DI,sg; mov ES,DI; mov DI,64000;
 @Loop:
  mov al,es:[di-321];
  mov dl,es:[di-320]; add ax,dx;
  mov dl,es:[di-319]; add ax,dx;
  mov dl,es:[di-1]; add ax,dx;
  mov dl,es:[di+1]; add ax,dx;
  mov DL,ES:[DI+319]; add AX,DX
  mov DL,ES:[DI+320]; add AX,DX
  mov DL,ES:[DI+321]; add AX,DX;

  shr AX,3; JZ @End; dec AL
 @End:
  mov ES:[DI],AL; dec DI; JNZ @Loop
END;

procedure GetFont(var fnt : t_fnt);
var rg : Registers;

begin
  rg.AH := $11; rg.AL := $30; rg.BH := 6; Intr($10,rg);
  Move(mem[rg.ES:rg.BP],fnt,4096);
end;

procedure WStr(x,y : Word; st : String; cl : Byte);
var xi,xj,xk : Byte;
    aa       : Word;

begin
  for xi := 1 to Length(st) do
  begin
    Move(ft[Succ(Ord(st[xi]) shl 4)],ct,16);
    for xj := 1 to 16 do
    for xk := 1 to 8 do if ct[xj] and bin[xk]>0 then
    begin aa := x+(xi-1) shl 3+(xk-1);
          k2^[y+(xj-1),aa] := cl; end;
  end;
end;

{ procs --- procs }



begin
  MakeTables; New(k2); New(k3); Randomize;

  GetFont(ft);

  { Generate starfield }
  for i := 1 to np do
  with pnt[i] do
  begin
    X := Random(501)/5-50; Y := Random(501)/5-50; Z := Random(200)+1;
  end; { Sort about depth } HeapSort(np);

  ASM mov ax,13h; int 10h; END; j := 0;

  { Generate linear palette }
  port[$3c8] := 1;
  for i := 1 to 255 do
    for k := 0 to 2 do port[$3c9] := i shr 2;

  FillChar(k2^,64000,1);

  repeat
    {FillChar(k2^,64000,0);}

    for i := 1 to np do
    begin
      with pnt[i] do
      begin
        { Rotate / pan starfield }
        RotateXYZ(1,2,359, X,Y,Z);
        X := X-sint[j]/5; Y := Y+cost[j]/3; Z := Z-sint[j]/3;

        { Checkings (limits) }
    {X} if X<-50.0 then X := 50.0;
        if X>50.0 then X := -50.0;
    {Y} if Y<-50.0 then Y := 50.0;
        if Y>50.0 then Y := -50.0;
    {Z} if Z<1.0 then Z := 200.0;
        if Z>200.0 then Z := 1.0;

        { Convert 3D -> displayable 2D }
        C32(X,Y,Z,200,xp,yp);
      end;

      Inc(yp,100); Inc(xp,160);
      if ((xp>=0) and (xp<=319)) and
         ((yp>=0) and (yp<=199)) then k2^[yp,xp] := 255-Round(pnt[i].Z);
    end;

    Decr(Seg(k2^),20); k := Round(sint[j]*100);
    WStr(104+k,10,'Plastic RoTTeR',200);
    WStr(135-k,173,'code:',200);

    k2^[0,0] := 0; Move2(k2^,kep,64000);
    Inc(j); if j>359 then j := 0;
  until port[$60]=1; port[$60] := 0; port[$20] := 1;

  ASM mov ax,3; int 10h; END; Dispose(k2); Dispose(k3);
end.