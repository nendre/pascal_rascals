{$G+}
uses graph,crt;
var si,co:array[0..360] of real;
    gd,gm:integer;
    x,y,z:real;
    a,b,c:integer;
    d,t,n:integer;
    i,j:real;
    p,p1:pointer;
    vga:word;
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
procedure clearscreen;assembler;
asm
push es
mov ax,08000h
mov es,ax
mov di,0
mov ax,0
mov cx,16000
rep stosw
pop es
end;
procedure movescreen;assembler;
asm
push ds
push es
mov ax,08000h
mov ds,ax
mov ax,0a000h
mov es,ax
mov si,0
mov di,0
mov cx,16000
rep movsw
pop es
pop ds
end;
procedure rx;
var xt:real;
begin
xt:=x;
x:=x*co[a]+y*si[a];
y:=-xt*si[a]+y*co[a];
end;
procedure ry;
var yt:real;
begin
yt:=y;
y:=y*co[b]+z*si[b];
z:=-yt*si[b]+z*co[b];
end;
procedure rz;
var zt:real;
begin
zt:=z;
z:=z*co[c]+x*si[c];
x:=-zt*si[c]+x*co[c];
end;
begin
for d:=0 to 360 do
begin
si[d]:=sin(d*pi/180);
co[d]:=cos(d*pi/180);
end;
gd:=installuserdriver('svga256',nil);
gm:=0;
initgraph(gd,gm,'d:\bp\bgi');
setcolor(15);
settextstyle(4,0,1);
outtextxy(1,1,'W. Axl Rose');
for vga:=0 to 6400 do mem[$9000:vga]:=mem[$a000:vga];
cleardevice;
a:=7;b:=0;c:=360;
while b<90 do
begin
clearscreen;
i:=0;
while i<=15 do
begin
j:=0;
while j<=100 do
begin
z:=0;
x:=j;
y:=i;
rx;ry;rz;
mem[$8000:round(y+50)*320+round(x)+140]:=mem[$9000:round(i)*320+round(j)];
j:=j+0.5;
end;
i:=i+0.5;
end;
delayed;
movescreen;
dec(c,10);
inc(b);
end;
readln;
closegraph;
end.
