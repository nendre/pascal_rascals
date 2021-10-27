{$N+}
program SnowFlakes;   { (c) 1996, P. RoTTeR / BCDiv! }
uses Crt,NoPause,CADOff;
const nof = 3000;   { Number of flakes }
type t_k = Array[0..63999] of Byte;   { Screen-type }
var kep   : t_k absolute $a000:0;   { Visual page }
    k1,k2 : ^t_k;   { Virtual pages }
    flk   : Array[1..nof] of Record X,Y : Word; SP,CL : Byte; End;   { Flakes }
    vt    : Array[0..199] of Word;   { Line-start table }
    i,j   : Integer;   { Used variables }

procedure Move2(VAR source,dest; size : Word); Assembler;   { Extended Move }
ASM
  push ds; push es; lds si, source; les di, dest; mov cx, size
  cld; shr cx,1; jnc @word1; movsb
 @word1:
  shr cx,1; jnc @word2; movsw
 @word2: db 0f3h,066h,0a5h
 pop es; pop ds
END;

procedure VerticalRetrace; Assembler;   { Waits for the vertical retrace }
ASM
     mov dx,03DAh
 @1: in al,dx; test al,8; jz @1
 @2: in al,dx; test al,8; jnz @2
END;

procedure Aver(sg : Word); Assembler;   { Own averaging giga-procedure }
ASM
  mov DI,sg; mov ES,DI; mov DI,63679; mov CX,63679; xor DH,DH
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



begin
 { Allocate memory }
  New(k1); New(k2);

 { Generate flakes }
  Randomize;
  for i := 1 to nof do
  with flk[i] do
  begin
    X := Random(320); Y := Random(200) shl 3; SP := Random(5)+3;
    CL := 31-Random(6);
  end;

 { Generate line-start-pos. table }
  for i := 0 to 199 do vt[i] := i*320;

 { Change to 320x200x256 }
  ASM mov ax,13h; int 10h; END;

 { Generate backg. pic }
  for i := 0 to 319 do
  for j := 0 to 199 do k1^[i+vt[j]] := 128+Random(10);
  Aver(Seg(k1^)); FillChar(k1^[0],320,0); FillChar(k1^[vt[199]],320,0);

 { Make "dams" }
  for i := 1 to Random(10)+1 do
  begin
    j := Random(240)+10;
    FillChar(k1^[vt[Random(100)+50] + j],Random(320-j),31);
  end;

 { Make borders }
  for i := 0 to 199 do begin k1^[vt[i]] := 31; k1^[vt[i]+319] := 31; end;
  FillChar(k1^[vt[199]],320,31);

 { Main loop }
  repeat
   { Copy background pic -> mix-page }
    Move2(k1^[0],k2^[0],64000);

   { Move flakes }
    for i := 1 to nof do
    with flk[i] do
    begin
      Y := Y+SP; j := Y shr 3;

     { Can fall left }
      if (j<199) and ( (k2^[X+vt[j]] in [16..31]) and not
                       (k2^[X-1+vt[j]] in [16..31]) {and
                       (Random(2)=0)} ) then
      begin Dec(X); end;

     { Can fall right }
      if (j<199) and ( (k2^[X+vt[j]] in [16..31]) and not
                       (k2^[X+1+vt[j]] in [16..31]) {and
                       (Random(2)=0)} ) then
      begin Inc(X); end;

     { Can't fall }
      if (j>=199) or ( (k2^[X+vt[j+1]] in [16..31]) and
                       (k2^[X-1+vt[j+1]] in [16..31]) and
                       (k2^[X+1+vt[j+1]] in [16..31]) {and
                       (Random(2)=0)} ) then
      begin k1^[X+vt[j]] := 31; Y := 0; X := Random(320); end;

    end;

   { Make flakes visible }
    for i := 1 to nof do
    with flk[i] do k2^[X+vt[Y shr 3]] := CL;

   { Hide unusable lines }
    FillChar(k2^[0],320,0);
    for i := 0 to 199 do begin k2^[vt[i]] := 0; k2^[vt[i]+319] := 0; end;

   { Copy mix-page -> visual page }
    VerticalRetrace; Move2(k2^[0],kep[0],64000);
  until KeyPressed; ReadKey;

 { Change back to text mode }
  ASM mov ax,3; int 10h; END;

 { Free up memory }
  Dispose(k1); Dispose(k2);
end.