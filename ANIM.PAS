uses crt,vga256;
var f:file;
    antet:array[1..128] of byte;
    pal:palette;
    n,i,j,t,x,y:word;
    k:array[1..320] of byte;
    p,p1:pointer;
procedure delayed;assembler;
asm
mov dx,3dah
@1:in al,dx
   test al,08
   jnz @1
@2:in al,dx
   test al,08
   jz @2
end;
begin
initvga;
assign(f,'pups.bmp');
reset(f,1);
seek(f,54);
blockread(f,pal,1024);
t:=0;
for i:=0 to 255 do
begin
setrgb(i,pal[t+2] div 4,pal[t+1] div 4,pal[t] div 4);
inc(t,4);
end;
for i:=199 downto 0 do
begin
p:=ptr($8000,320*i);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
p:=ptr($a000,0);
p1:=ptr($8000,0);
move(p1^,p^,64000);
assign(f,'pups.bmp');
reset(f,1);
seek(f,54);
blockread(f,pal,1024);
t:=0;
for i:=0 to 255 do
begin
setrgb(i,pal[t+2] div 4,pal[t+1] div 4,pal[t] div 4);
inc(t,4);
end;
for i:=199 downto 0 do
begin
p:=ptr($9000,320*i);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
repeat
For i:=1 to 79 do
begin
port[$3d4]:=$0d;
port[$3d5]:=i;
n:=i*4;
delayed;
for t:=0 to 199 do
for j:=n to n+7 do
begin
mem[$a000:320*t+j-9]:=mem[$9000:320*t+j-9];
end;
end;
For i:=79 downto 0 do
begin
port[$3d4]:=$0d;
port[$3d5]:=i;
n:=i*4;
delayed;
for t:=0 to 199 do
for j:=n to n+7 do
begin
mem[$a000:320*t+j+9]:=mem[$8000:320*t+j+9];
end;
end;
until keypressed;
readln;
closevga;
end.


