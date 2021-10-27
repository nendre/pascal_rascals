program NewLife;   { (c) 1996, The Mighty Aron Knight }
uses Crt{,Amouse};
type t_lt = Array[0..63999] of Byte;
var i,j,k : Integer;
    lt,
    lt2   : ^t_lt;
    kep   : t_lt absolute $a000:0;
    vt    : Array[0..199] of Word;
    x,y,b : Word;
    ch    : Char;

procedure Pal(cl,r,g,b : Byte);
begin
  port[$3c8] := cl; port[$3c9] := r; port[$3c9] := g; port[$3c9] := b;
end;

{$DEFINE USE386}
procedure Move2(VAR source,dest; size : Word); Assembler;
ASM   { Move-Replacement }
  push ds; push es; lds si, source; les di, dest; mov cx, size
  cld; shr cx,1; jnc @word1; movsb
 @word1: {$IFDEF USE386}
  shr cx,1; jnc @word2; movsw
 @word2: db 0f3h,066h,0a5h
 {$ELSE} rep movsw
 {$ENDIF} pop es; pop ds
END;

procedure Draw;
var px,py,pb : Word;
    st       : String;
    ff       : File;

begin
  {GetMousePos(px,py,pb);}
  repeat
    Pal(0,0,0,20); Pal(1,63,63,63);
    Move2(lt2^[0],kep[0],SizeOf(lt2^));
    repeat
      kep[vt[py]+px div 2] := Random(255);
      {GetMousePos(x,y,b);}
    until ((x<>px) or (y<>py) or (b<>pb)) or KeyPressed;
    if KeyPressed then ch := UpCase(ReadKey)
                  else ch := #1;
    case ch of
      'S': begin
             ASM mov ax,3; int 10h; END;
             Write('Filename: '); ReadLn(st);
             if st<>'' then
             begin
               Assign(ff,st); {$I-} Reset(ff,1); {$I+}
               if IOResult<>0 then
               begin
                 ReWrite(ff,1); BlockWrite(ff,lt2^,SizeOf(lt2^))
               end else begin
                          Write('File is exists. Overwrite? (Y/N) ');
                          repeat ch := UpCase(ReadKey); until ch in ['Y','N'];
                          if ch='Y' then BlockWrite(ff,lt2^,SizeOf(lt2^));
                        end;
             end;
             ASM mov ax,13h; int 10h; END; Close(ff);
             {HideMouseCursor; SetMouseWindow(40,20,600,180);}
           end;
      'L': begin
             ASM mov ax,3; int 10h; END;
             Write('Filename: '); ReadLn(st);
             if st<>'' then
             begin
               Assign(ff,st); {$I-} Reset(ff,1); {$I+}
               if IOResult=0 then
               begin
                 BlockRead(ff,lt2^,SizeOf(lt2^)); Close(ff);
               end;
             end;
             ASM mov ax,13h; int 10h; END;
             {HideMouseCursor; SetMouseWindow(40,20,600,180);}
           end;
    end;
    px := x; py := y; pb := b;
    if b=1 then lt2^[vt[y]+x div 2] := 1;
    if b=2 then lt2^[vt[y]+x div 2] := 0;
  until ch=' '; ch := ' ';
  for i := 20 to 180 do
  for j := 20 to 300 do lt^[vt[i]+j] := lt2^[vt[i]+j];
  Sound(500); Delay(50); NoSound;
end;

procedure Life;
var s,x : Word;

begin
  for i := 20 to 180 do
  for j := 20 to 300 do
  begin
    s := lt^[vt[i-1]+(j-1)]+lt^[vt[i-1]+j]+lt^[vt[i-1]+(j+1)]+
         lt^[vt[i]+(j-1)]+lt^[vt[i]+(j+1)]+lt^[vt[i+1]+j]+
         lt^[vt[i+1]+(j+1)]+lt^[vt[i+1]+(j-1)];
    x := vt[i]+j;
    lt2^[x] := lt^[x]; if (s<2) or (s>3) then lt2^[x] := 0;
    if s=3 then lt2^[x] := 1;
  end;
end;

procedure VerticalRetrace; Assembler;
ASM
     mov dx,$3da
 @1: in al,dx; test al,8; jz @1
 @2: in al,dx; test al,8; jnz @2
END;

procedure Display;
begin
  Move2(lt2^,lt^,SizeOf(lt2^));
  VerticalRetrace; Move2(lt^[0],kep[0],SizeOf(lt^));
end;

procedure CharOut(x,y,c,ct : Byte); Assembler;
ASM
  mov ah,2; mov bh,0; mov dh,x; mov dl,y; int 10h
  mov ah,9; mov al,c; mov bh,0; mov bl,ct; mov cx,1; int 10h
END;

procedure Stri(x,y : Byte; st : String);
begin
  for i := 1 to Length(st) do CharOut(x,y+i-1,Ord(st[i]),15);
end;

begin
  New(lt); New(lt2); for i := 0 to 199 do vt[i] := i*320;
  ASM mov ax,13h; int 10h; END;

  {InitMouse; HideMouseCursor; SetMouseWindow(40,20,600,180);}
  {SetMousePos(160,100);}

  Pal(1,63,63,63); FillChar(lt2^,SizeOf(lt2^),0); Pal(15,0,0,0);
  Stri(1,4,'NEW LIFE! ú (c) 1996, TMA Knight');
  for i := 0 to 19 do
  begin
    for j := 0 to 199 do
    begin
      k := 31-((i*2 div 3)+Random(2));
      lt2^[vt[j]+i] := k; lt2^[vt[j]+(319-i)] := k;
    end;

    for j := 0 to 319 do
    begin
      k := 31-((i*2 div 3)+Random(2));
      if kep[vt[i]+j]<>15 then lt2^[vt[i]+j] := k
                          else lt2^[vt[i]+j] := 64+i;
      lt2^[vt[199-i]+j] := k;
    end;
  end;

  repeat
    Draw; Pal(0,0,0,30);
    repeat
      Life; Display;
    until KeyPressed;
    ch := ReadKey;
  until ch=#27;

  ASM mov ax,3; int 10h; END; Dispose(lt); Dispose(lt2);
end.