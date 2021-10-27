{$G+}
var f:file;
    k:array[0..319 ] of byte;
    pal:array[0..1024] of byte;
    i,j:integer;
    p,p1,p2:pointer;
    t:word;
    c1,c2,c3:byte;
    x1,y1,r:word;
procedure circle(x,y,r:integer);
var m,n,i,j:integer;
begin
x:=round(x*1.37);
for i:=0 to 359 do
begin
m:=round(x+r*cos(i*pi/180));
n:=round(y+r*sin(i*pi/180));
mem[$9000:320*n+m]:=mem[$8000:320*n+m];
end;
p:=ptr($9000,0);
p1:=ptr($A000,0);
move(p^,p1^,64000);
end;
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
begin
asm
mov ax,0013h
int 10h
end;
for i:=0 to 15 do setrgb(i,0,0,i*3);
for t:=0 to 200 do
for j:=0 to 319 do
begin
mem[$a000:320*t+j]:=t div 15;
end;
p:=ptr($a000,0);
p1:=ptr($9000,0);
move(p^,p1^,64000);
assign(f,'jobb1.bmp');
reset(f,1);
seek(f,54);
blockread(f,pal,1024);
t:=64;
for i:=16 to 255 do
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
for r:=0 to 70 do
begin
circle(160,100,r);
end;
readln;
asm
mov ax,003h
int 10h
end;
end.
