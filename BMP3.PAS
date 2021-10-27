{$G+}
var f:file;
    k:array[0..319 ] of byte;
    pal:array[0..1024] of byte;
    i,j:integer;
    p,p1:pointer;
    x1,y1,r,x,y,t:word;
procedure rectangle(x,y,x1,y1:integer);
var i,j:integer;
begin
for  i:=y to y1 do
for j:=x to x1 do
begin
mem[$9000:320*i+j]:=mem[$8000:320*i+j];
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
P:=PTR($A000,0);
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
for i:=0 to 15 do setrgb(i,0,0,i*3);
for t:=0 to 200 do
for j:=0 to 319 do
begin
mem[$a000:320*t+j]:=t div 15;
end;
x:=159;
y:=99;
x1:=161;
y1:=101;
for r:=0 to 80 do
begin
rectangle(x,y,x1,y1);
dec(x,2);dec(y);inc(x1,2);inc(y1);
end;
for r:=0 to 20 do
begin
rectangle(x,y,x1,y1);
dec(y);inc(y1);
end;
for t:=0 to 64000 do mem[$7000:t]:=0;
for y:=0 to 199 do
for x:=0 to 319 do
begin
mem[$7000:320*(y div 2)+(x div 2)]:=mem[$8000:320*y+x];
end;
p:=ptr($7000,0);
p1:=ptr($A000,0);
move(p^,p1^,64000);
for t:=0 to 64000 do mem[$8000:t]:=0;
for y:=0 to 99 do
for x:=0 to 159 do
begin
x1:=50+round(x*cos(15*pi/180)-y*sin(15*pi/180));
y1:=50+round(y*cos(15*pi/180)+x*sin(15*pi/180));
mem[$8000:320*y1+x1]:=mem[$7000:320*y+x];
end;
for t:=0 to 64000 do
begin
if (mem[$8000:t]=0) and (mem[$8000:(t+1)]<>0) and (mem[$8000:(t-1)]<>0) then
mem[$8000:t]:=mem[$8000:(t-1)];
end;
p:=ptr($8000,0);
p1:=ptr($A000,0);
move(p^,p1^,64000);
readln;
asm
mov ax,003h
int 10h
end;
end.
