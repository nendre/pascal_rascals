{$G+}
program Various;   { (c) 1996, The Mighty Aron Knight / BCDiv / ThT }
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
      Factor : Word = $8405;
      ss : Array[0..66] of Shortint =
           (0,1,2,2,3,3,3,2,2,1,0,-1,-2,-2,-3,-3,-3,-2,-2,-1,
            0,1,2,2,3,3,3,2,2,1,0,-1,-2,-2,-3,-3,-3,-2,-2,-1,
            0,1,2,2,3,3,3,2,2,1,0,-1,-2,-2,-3,-3,-3,-2,-2,-1,
            0,1,2,2,3,3,3);
type t_kp = Array[0..63999] of Byte;
var kep : t_kp absolute $a000:0;
    k2  : t_kp absolute $8000:0;
    k3  : t_kp absolute $7000:0;
    i,j : Word;
    vt  : Array[0..199] of Word;
    cnt : Longint;
    stb : Array[1..100] of Record x : Word; y : Byte; End;
    sv,
    xx  : Byte;
    pal : Array[0..767] of Byte;

procedure Move2(VAR source,dest; size : Word); Assembler;
ASM
  push ds; push es; lds si, source; les di, dest; mov cx, size
  cld; shr cx,1; jnc @word1; movsb
 @word1:
  shr cx,1; jnc @word2; movsw
 @word2: db 0f3h,066h,0a5h
 pop es; pop ds
END;

function NextRand : Longint; Assembler;
ASM
  mov  AX,RandSeed.Word[0]; mov  BX,RandSeed.Word[2]; mov  CX,AX
  mul  Factor.Word[0]; shl  CX,1; shl  CX,1; shl  CX,1; add  CH,CL
  add  DX,CX; add  DX,BX; shl  BX,1; shl  BX,1; add  DX,BX; add  DH,BL
  mov  CL,5; shl  BX,CL; add  DH,BL; add  AX,1; adc  DX,0
  mov  RandSeed.Word[0],AX; mov  RandSeed.Word[2],DX
END;

function Random(Max : Integer) : Integer; Assembler;
ASM
  call NextRand; xor  AX,AX; mov  BX,Max.Word[0]
  or   BX,BX; je   @1; xchg AX,DX; div  BX; xchg AX,DX
 @1:
END;

procedure Aver; Assembler;
ASM
  mov DI,07000h; mov ES,DI; mov DI,63679; mov CX,63679; xor DH,DH
 @Loop:
  mov AL,ES:[DI]; mov DL,ES:[DI+319]; add AX,DX
  mov DL,ES:[DI+320]; add AX,DX
  mov DL,ES:[DI+321]; add AX,DX
  shr AX,2; JZ @End; dec AL
 @End:
  mov ES:[DI],AL; dec DI; dec CX; JNZ @Loop
END;

procedure VerticalRetrace; Assembler;
ASM
     mov dx,03DAh
 @1: in al,dx; test al,8; jz @1
 @2: in al,dx; test al,8; jnz @2
END;

procedure Stri(x,y : Integer; st : String; xx : Byte);
var k,ii,jj,kk : Byte;

begin
  k := 0;
  for kk := 1 to Ord(st[0]) do
  for ii := 0 to 15 do
  for jj := 1 to 8 do
  begin
    case ii of
      0: k := 1;  1..6: k := 2;  7: k := 3; 8..14: k := 4; 15: k := 5;
    end;
    j := ( x+(kk-1)*10+jj-1 + ss[sv+kk] )+vt[y+ii + ss[sv+jj+kk] ];
    if (cht[Ord(st[kk])-64,k] and bt[jj]>0) and
       (st[kk]<>#32) then case xx of
                            0: k2[j] := k3[j] shl 1;
                            1: k2[j] := 255; end;
  end;
end;

procedure SetPal;
var pv : Integer;

begin
  port[$3c8] := 0; for pv := 0 to 767 do port[$3c9] := pal[pv];
end;

procedure S2(x,y,mx : Byte; st : String);
var k : Byte;

begin
  for i := 1 to (mx-1)*3 do VerticalRetrace;

  for i := 1 to Ord(st[0]) do
  for j := 1 to mx do
  begin
    if mx>1 then VerticalRetrace; k := y+i;
    ASM mov ah,2; mov bh,0; mov dh,x; mov dl,k; int 10h; END;
    mem[$b800:((x*80)+k-1) shl 1] := Ord(st[i]);
  end;
end;

begin
  InLine($B8/$03/$00/$CD/$10);
  S2(1,1,1,'C:\>'); S2(1,5,10,'cd windows');
  for i := 1 to 20 do VerticalRetrace;
  S2(3,1,1,'C:\WINDOWS>'); S2(3,12,10,'win');
  for i := 1 to 100 do VerticalRetrace;

  InLine($B8/$13/$00/$CD/$10);

  for i := 15 downto 0 do
  begin
    VerticalRetrace;
    port[$3c8] := 0; port[$3c9] := i shl 2; port[$3c9] := i shl 2;
    port[$3c9] := i shl 2;
  end;

  for i := 0 to 127 do
  begin
    j := i*3; pal[j] := i shr 2; pal[j+1] := i shr 1; pal[j+2] := i shr 2;
    j := (255-i)*3; pal[j] := i shr 1; pal[j+1] := i shr 1; pal[j+2] := i shr 2;
  end; FillChar(pal[765],3,63); SetPal;

  for i := 0 to 199 do vt[i] := i*320; FillChar(k3[0],64000,72);
  for i := 1 to 100 do
  begin stb[i].x := Random(320); stb[i].y := Random(200); end;

  cnt := 0; sv := 0; xx := 255;

  repeat
    if cnt<580 then for i := 0 to 319 do k3[63679+i] := Random(xx);
    Move2(k3[0],k2[0],64000); k2[0] := 0;

    if cnt>20 then for i := 1 to 100 do
    with stb[i] do
    begin
      j := i-140; if (j>cnt) and (cnt<140) then j := cnt; k2[x+vt[y]] := j;
      Dec(x,4-(i shr 5));
    end;

    VerticalRetrace;

    if (cnt>=50){0} and (cnt<=150){50} then
      Stri(54,167,'VARIOUS FOUR KB INTRO',0);
    if (cnt>=200){70} and (cnt<=300){120} then
      Stri(59,167,'CODED IN PURE PASCAL',0);
    if (cnt>=350){140} and (cnt<=500){240} then
      Stri(136,167,'FLAG',0);

    if (cnt>=538){200} and (cnt<=570){232} then
      if xx-8>=0 then Dec(xx,8) else xx := 0;

    if (cnt=150){50} or (cnt=300){120} or
       (cnt=500){240} then Move2(k2[0],k3[0],64000);

    if (cnt>=410){150} and (cnt<580){320} then
      for i := 0 to 199 do
      begin
        j := (i*(cnt-410){150}) shr 3;
        k3[cnt-240{0}+vt[i]] := j; k3[320-(cnt-240){0}+vt[i]] := j;
        k3[320-(cnt-409{149})+vt[199-i]] := j;
        k3[(cnt-409{149})+vt[199-i]] := j;
      end;
    if ((cnt>=590){330} and (cnt<=620){360}) and (cnt mod 3=0) then
    begin
      for i := 0 to 764 do if pal[i]>0 then Dec(pal[i]); SetPal;
    end;
    if (cnt>=589){319} and (cnt<739){469} then
      for i := 0 to 199 do
      begin
        j := ((i*(cnt-590{320})) shr 3) mod 255;
        k3[320-(cnt-590{320})+vt[i]] := j; k3[cnt-590{320}+vt[i]] := j;
      end;
    if cnt=579 {318} then for i := 765 to 767 do pal[i] := 10;
    if (cnt>579){319} then
    begin
      for i := 765 to 767 do if pal[i]<63 then Inc(pal[i]);
      SetPal; Stri(124,40,'VARIOUS',1);
      Stri(9,92,'THIS IS MY CONTRIBUTION TO THE',1);
      Stri(109,140,'FLAG PARTY',1);
    end;
    if (cnt>=820){460} and (cnt<=870){510} then
    begin
      for i := 0 to 764 do if pal[i]>0 then Dec(pal[i]); SetPal;
    end;

    if (cnt>=1020){560} and (cnt<=1220){759} then
    begin
      i := vt[cnt-1020{560}];
      Move2(k2[i],k2[0],64000-i); FillChar(k2[64000-i],i,0);
    end;

    FillChar(k2[63360],640,0);
    if cnt<=579{319} then Aver; VerticalRetrace; Move2(k2[0],kep[0],64000);
    Inc(sv); Inc(cnt); if sv>19 then sv := 0;
  until (port[$60]=1) or (cnt>1220{759}); port[$20] := 0;

  InLine($B8/$03/$00/$CD/$10);

  S2(1,1,1,'C:\>cd windows'); S2(3,1,1,'C:\WINDOWS>win');
  S2(5,1,1,'C:\WINDOWS>'); S2(5,12,10,'type win.ini');
  for i := 1 to 20 do VerticalRetrace;
  S2(7,1,1,'Various! - 4K intro - A contribution to FLAG''96');
  S2(8,1,1,'(c) 1996, TMA Knight / B.C.Div / THiTANiUM  ');
  S2(9,1,1,''); for i := 1 to 50 do VerticalRetrace;
end.