const valori:array[1..10] of word=($0d06,$3e07,$4109,$ea10,$ac11,$df12,$0014,
$e715,$0616,$e317);
var i,j,k,x,y:word;
    me:array[0..239,0..79] of byte absolute $A000:0;
procedure setrgb(c,r,g,b:byte);assembler;
asm
mov dx,3c8h
mov al,c
out dx,al
inc dx
mov al,r
out dx,al
mov al,g
out dx,al
mov al,b
out dx,al
end;
procedure calcule(x,y:word);
begin
k:=x and 3;
i:=y;
j:=x div 4;
end;
procedure putpixel(x,y:word;c:byte);
begin
calcule(x,y);
port[$3c4]:=2;
port[$3c5]:=1 shl k;
me[i,j]:=c;
end;
begin
asm
mov ax,0013h
int 10h
end;
portw[$3c4]:=$604;
portw[$3c4]:=$100;
port[$3c2]:=$e3;
portw[$3c4]:=$300;
port[$3d4]:=$11;
port[$3d5]:=port[$3d5] and $7f;
for i:=1 to 10 do portw[$3d4]:=valori[i];
portw[$3c4]:=$f02;
fillchar(me,240*80,#0);
for y:=0 to 239 do
for x:=0 to 319 do
begin
putpixel(x,y,155);
end;
readln;
asm
mov ax,003h
int 10h
end;
end.
