{$G+}
program DontKnow;   { (c) 1996, TMA Knight }
const cht : Array[1..26,1..5] of Byte =
            ((126,231,255,231,231), (254,231,252,231,254),
             (127,224,224,224,127), (254,231,231,231,254),
             (255,224,252,224,255), (255,224,252,224,224),
             (126,224,231,231,126), (231,231,255,231,231),
             (28,28,28,28,28),      (124,28,60,28,120),
             (231,238,252,238,231), (224,224,224,224,255),
             (118,219,219,195,195), (115,219,219,219,206),
             (126,231,231,231,126), (254,231,254,224,224),
             (126,231,231,231,119), (254,231,254,231,231),
             (127,224,126,7,254),   (255,28,28,28,28),
             (231,231,231,231,126), (199,199,239,110,60),
             (195,195,219,219,118), (231,231,62,231,231),
             (231,231,127,7,254),   (255,7,126,224,255));
      bt : Array[1..8] of Byte = (128,64,32,16,8,4,2,1);
type t_kp = Array[0..63999] of Byte;
var kep   : t_kp absolute $a000:0;
    k1,k2 : ^t_kp;
    i,j   : Word;
    xx    : Word;
    pal   : Array[0..255] of Record R,G,B : Byte; End;
    vt    : Array[0..199] of Word;

procedure Aver; Assembler;
ASM
  mov DI,xx; mov ES,DI; mov DI,63679; mov CX,63679; xor DH,DH
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
  mov ES:[DI],AL; dec DI; dec CX; JNZ @Loop
END;

procedure VerticalRetrace; Assembler;
ASM
     mov dx,03DAh
 @1: in al,dx; test al,8; jz @1
 @2: in al,dx; test al,8; jnz @2
END;

procedure Move2(VAR source,dest; size : Word); Assembler;
ASM
  push ds; push es; lds si, source; les di, dest; mov cx, size
  cld; shr cx,1; jnc @word1; movsb
 @word1:
  shr cx,1; jnc @word2; movsw
 @word2: db 0f3h,066h,0a5h
 pop es; pop ds
END;

procedure Stri(x,y : Integer; st : String; xx,pl : Byte);
var k,ii,jj,kk : Byte;
    z          : Word;

begin
  k := 0;
  for kk := 1 to Ord(st[0]) do
  for ii := 0 to 15 do
  for jj := 1 to 8 do
  begin
    case ii of
      0: k := 1;  1..6: k := 2;  7: k := 3; 8..14: k := 4; 15: k := 5;
    end;
    z := ( x+(kk-1)*10+jj-1 )+vt[y+ii];
    if (cht[Ord(st[kk])-64,k] and bt[jj]>0) and
       (st[kk]<>#32) then
       case xx of
         0: k1^[z] := 255;
         1: k2^[z] := pl+Random(15)+k1^[z];
       end;
  end;
end;

begin
  ASM mov ax,13h; int 10h; END; New(k1); New(k2); xx := Seg(k1^);

  for i := 0 to 127 do
  begin
    with pal[i] do
    begin R := i div 4; G := i div 3; B := i div 2; end;
    pal[255-i] := pal[i];
  end;

  port[$3c8] := 0;
  for i := 0 to 255 do
  with pal[i] do
  begin port[$3c9] := R; port[$3c9] := G; port[$3c9] := B; end;

  FillChar(k1^[0],64000,0);
  for i := 0 to 199 do vt[i] := 320*i; j := 0;

  repeat
    Stri(10,30,'THE MIGHTY ARON KNIGHT',0,0);
    Stri(240,160,'MCMXCVI',0,0);

    for i := 1 to j*7 do k1^[3200+Random(57600)] := 200;

    Aver; FillChar(k1^[0],3200,0); FillChar(k1^[60800],3200,0);
    Move2(k1^[0],k2^[0],64000);

    Stri(10,30,'THE MIGHTY ARON KNIGHT',1,j);
    Stri(240,160,'MCMXCVI',1,j);

    VerticalRetrace; Move2(k2^[0],kep[0],64000);

    Inc(j); if j>=128 then j := 128;
  until port[$60]=1; port[$60] := 0; port[$20] := 1;

  for i := 80 downto 0 do
  begin
    Aver; FillChar(k1^[0],3200,0); FillChar(k1^[60800],3200,0);
    Move2(k1^[0],k2^[0],64000);

    Stri(10,30,'THE MIGHTY ARON KNIGHT',1,i);
    Stri(240,160,'MCMXCVI',1,i);

    if i mod 2=0 then VerticalRetrace; Move2(k2^[0],kep[0],64000);
  end;

  ASM mov ax,3; int 10h; END;
  Dispose(k1); Dispose(k2);
end.