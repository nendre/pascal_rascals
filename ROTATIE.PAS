var f:file;
    a:array[1..3072] of byte absolute $A000:0;
    j,axc,bxc:integer;
    unghi,n,i,v,x,y:real;
    si,co:array[0..360] of real;
function getpixel(x,y:word):byte;
begin
asm
mov ah,0dh
mov bx,0
mov cx,x
mov dx,y
int 10h
mov @result,al
end;
end;
procedure putpixel(x,y:word;c:byte);assembler;
asm
mov ah,0ch
mov bx,0
mov cx,x
mov dx,y
mov al,c
int 10h
end;
procedure clearscreen;assembler;
asm
push es
mov ax,0a000h
mov es,ax
mov di,0
cld
mov ax,0
mov cx,4000
rep stosw
std
pop es
end;
procedure rx(a,b:real;c:integer);
begin
x:=a*co[c]-b*si[c];
y:=b*co[c]+a*si[c];
end;
begin
for j:=0 to 360 do
begin
si[j]:=sin(j*pi/180);
co[j]:=cos(j*pi/180);
end;
asm
mov ax,000dh
int 10h
end;
assign(f,'sigla.dat');
reset(f,1);
blockread(f,a,3072);
close(f);
j:=0;
for bxc:=0 to 79 do
for axc:=0 to 319 do
begin
mem[$9000:j]:=getpixel(axc,bxc);
inc(j);
end;
clearscreen;
v:=0;
i:=0;
while i<70 do
begin
n:=0;unghi:=0;
while n<320 do
begin
rx(n,i,round(unghi));
putpixel(round(x),round(y),mem[$9000:320*round(i)+round(n)]);
n:=n+0.5;
unghi:=unghi+0.02;
end;
i:=i+0.5;
end;
readln;
asm
mov ax,0003h
int 10h
end;
end.