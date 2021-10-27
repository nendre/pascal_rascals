{$G+,N+}
program Bump2D;   { Original (c) Orpheas/HELiX. This (c) 1997, P.RoTTeR }
uses Dos{,FPack};   { FPack (c) Asphyxia }
const bin : Array[1..8] of Byte = (128,64,32,16,8,4,2,1);
type t_kp = Array[0..63999] of Byte;

     t_fnt = Array[1..4096] of Byte;
     t_chr = Array[1..16] of Byte;

{ vlx,vly -> Light Vector (Origin 0,0)
  lx,ly   -> A point representing the position of the light source
  nx,ny   -> To store the Pseudo-normal }
var x,y,vlx,vly,
    lx,ly,nx,ny : Integer;
    l1,k1a,k2a  : Word;
    k1,k2       : ^t_kp;

    i,j   : Integer;
    vt    : Array[0..199] of Word;
    ct,sn : Array[0..720] of Integer;

    ftb : t_fnt;
    ctb : t_chr;

procedure Move2(VAR source,dest; size : Word); Assembler;
ASM
  push ds; push es; lds si, source; les di, dest; mov cx, size
  cld; shr cx,1; jnc @word1; movsb
 @word1:
  shr cx,1; jnc @word2; movsw
 @word2: db 0f3h,066h,0a5h
 pop es; pop ds
END;

procedure SetPal(cl,R,G,B : Byte);
begin
  port[$3c8] := cl; port[$3c9] := R; port[$3c9] := G; port[$3c9] := B;
end;

procedure Init;   { Allocate memory for virtual screens }
begin
  New(k1); FillChar(k1^,SizeOf(k1^),0); k1a := Seg(k1^);
  New(k2); FillChar(k2^,SizeOf(k2^),0); k2a := Seg(k2^);

  for i := 0 to 199 do vt[i] := i*320;

  for i := 0 to 720 do
  begin
    ct[i] := Round(5000*Cos(i/24)*(pi/180));
    sn[i] := Round(3000*Sin(i/12)*(pi/180));
  end;
end;

procedure DeInit;   { Free up memory }
begin
  Dispose(k1); Dispose(k2);
end;

procedure DoPalette;
begin
  for i := 0 to 255 do SetPal(i,0,0,0);

  for i := 63 downto 0 do SetPal(128+65-i , 32-i div 2,0,32-i div 2);
  for i := 0 to 63 do SetPal(128+64+i , 32+i div 2,i,32+i div 2);
end;

(*procedure L_PCX(fn : String; where : Word);   { Load PCX to memory }
var bo : Boolean;

begin
  total := 1; infodat[1] := fn; bo := LoadPCX(1,where,True);
end;*)



procedure DoBump;   { This is "THE BUMP" }
{ difx,dify -> X,Y axis difference }
var difx,dify,col : Byte;
    pv            : Integer;

begin
  pv := 0;

  repeat
    Inc(pv); if pv>150 then pv := 0;
    lx := ct[pv]+160; { The path of the light }
    ly := sn[pv]+100; { -""- }

    for x := 1 to 318 do
    for y := 1 to 198 do
    begin
      { Here we will light the point x,y if lx,ly is the light position }
      vlx := x-lx; vly := y-ly; {Calculate the L vector}

      if ((vlx<150) and (vlx>-150)) and
         ((vly<140) and (vly>-140)) then
      begin   { The heart of bumping }
        nx := k1^[x+1 + vt[y]]-k1^[x-1 + vt[y]];
        ny := k1^[x + vt[y+1]]-k1^[x + vt[y-1]];
        { nx<0 (Normal facing right)
          nx>0 (Normal facing left)
          nx=0 (Normal sticking out of the screen) + also with ny }

        col := Abs(vlx+nx); if col>127 then col := 127;
        difx := 255-col;
        if difx<=0 then difx := 1;

        col := Abs(vly+ny); if col>127 then col := 127;
        dify := 255-col; if dify<=0 then dify := 1;

        col := (difx+dify); if col>255 then col := 255;
        if col>=128 then k2^[x + vt[y]] := 118+col mod 128;
      end;
    end;
    Move2(k2^,mem[$a000:0],SizeOf(k2^)); FillChar(k2^,SizeOf(k2^),0);
  until port[$60]=1; port[$60] := 0; port[$20] := 1;
end;

procedure Aver(sg : Word); Assembler;
ASM
  mov DI,sg; mov ES,DI; mov DI,64000; mov CX,64000; xor DH,DH
 @Loop:
  mov al,es:[di-321]; mov dl,es:[di-320]; add ax,dx;
  mov dl,es:[di-319]; add ax,dx; mov dl,es:[di-1]; add ax,dx;
  mov dl,es:[di+1]; add ax,dx; mov DL,ES:[DI+319]; add AX,DX;
  mov DL,ES:[DI+320]; add AX,DX; mov DL,ES:[DI+321]; add AX,DX;

  xor ax,dx; shr AX,3; JZ @End; dec AL
 @End:
  mov ES:[DI],AL; dec DI; dec CX; JNZ @Loop
END;

procedure GetFont(var fnt : t_fnt);
var rg : Registers;

begin
  rg.AH := $11; rg.AL := $30; rg.BH := 6; Intr($10,rg);
  Move2(mem[rg.ES:rg.BP],fnt,4096);
end;

procedure WStr(x,y : Word; st : String; cl : Byte);
var xi,xj,xk : Byte;

begin
  for xi := 1 to Length(st) do
  begin
    Move2(ftb[Succ(Ord(st[xi]) shl 4)],ctb,16);
    for xj := 1 to 16 do
      for xk := 1 to 8 do if ctb[xj] and bin[xk]>0 then
        k1^[vt[y+(xj-1)] + x+(xi-1) shl 3+(xk-1)] := cl;
  end;
end;





begin
  ASM mov ax,13h; int 10h; END; Init; GetFont(ftb);

  {L_PCX('remap2.pcx',k1a);}

  for i := 0 to 319 do
  for j := 0 to 199 do k1^[i+vt[j]] := (i*i+j*j);
  for i := 1 to 3 do Aver(k1a);

  for i := 5 to 26 do FillChar(k1^[50+vt[i+45]],122,120);
  WStr(55,55,'Plastic RoTTeR',100);

  DoPalette; DoBump;

  DeInit; ASM mov ax,3; int 10h; END;
  WriteLn('(c) 1997, Plastic RoTTeR - Algorithm by Orpheas/HELiX');
end.