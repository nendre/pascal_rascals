{$G+}
uses vga256,crt;
var k:array[0..320] of byte;
    f:file;
    i,j,t:word;
    p,p1,p2:pointer;
    pal:array[0..1024] of byte;
    x,y,x1,y1:word;
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
assign(f,'jobb1.bmp');
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
x:=0;y:=0;
x1:=319;y1:=199;
t:=0;
for j:=0 to 60 do
begin
rectangle(x,y,x1,y1,t+16);
inc(x);inc(y);dec(x1);dec(y1);
inc(t);
end;
delayed;
for t:=0 to 60 do
begin
delayed;
for j:=y to y1 do
for i:=x to x1 do
begin
mem[$a000:320*j+i]:=mem[$9000:320*(j+t)+i];
end;
end;
for t:=60 downto 0 do
begin
delayed;
for j:=y1 downto y do
for i:=x to x1 do
begin
mem[$a000:320*j+i]:=mem[$9000:320*(j+t)+i];
end;
end;
for t:=0 to 60 do
begin
delayed;
for j:=y to y1 do
for i:=x to x1 do
begin
mem[$a000:320*j+i]:=mem[$9000:320*(t+j)+(i+t)];
end;
end;
for t:=60 downto 0 do
begin
delayed;
for j:=y to y1 do
for i:=x to x1 do
begin
mem[$a000:320*j+i]:=mem[$9000:320*(t+j)+(i+t)];
end;
end;
readln;
closevga;
end.

