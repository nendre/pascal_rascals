program MegaSkroll;   { (c) 1995-97, The Mighty Aron Knight }
uses Crt;
const ct : Array[0..15] of Byte=(0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
var mega  : Array[1..100,1..160,1..2] of Byte;
    kep   : Array[1..50,1..80,1..2] of Byte absolute $b800:$0;
    i,j,k : Integer;
    sint,
    cost  : Array[0..360] of Integer;

procedure SetC(c : Integer; r,g,b : Byte); Assembler;
ASM
  MOV AH,$10; MOV AL,$10; MOV BX,c; MOV DH,r; MOV CH,g; MOV CL,b; INT $10
END;

procedure VerticalRetrace; Assembler;
ASM
        mov dx,$3da
@1:     in al,dx
        test al,8
        jz @1
@2:     in al,dx
        test al,8
        jnz @2
END;

begin
  for i := 0 to 360 do
  begin
    sint[i] := Round(10*(sin(i/10)));
    cost[i] := Round(15*(cos(i/10)));
  end;
  for i := 1 to 100 do
  for j := 1 to 160 do
  begin
    mega[i,j,1] := 176+((i*j) div (i+j+1)) mod 3; mega[i,j,2] := (i*j) div (i+j+1);
  end;

  k := 0; TextMode(265);
  for i := 1 to 15 do SetC(ct[i],i*2,16+i*2,i*4);

  repeat
    VerticalRetrace;
    for i := 1 to 50 do
    for j := 1 to 80 do
    begin
      kep[i,j,1] := mega[25+sint[k]+i+cost[k+i],40+cost[k]+j+sint[k+j],1];
      kep[i,j,2] := mega[25+sint[k]+i+cost[k+j],40+cost[k]+j+sint[k+i],2];
    end;
    Inc(k); if k>62 then k := 0;
  until KeyPressed;
  ReadKey; TextMode(co80); ClrScr; Halt(0);
end.