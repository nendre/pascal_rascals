{$G+}
unit vga256;
interface
type palette=array [0..767] of byte;
procedure initVGA;
procedure getpalette(p:palette);
procedure setpalette(p:palette);
procedure setrgb(c,r,g,b:byte);
procedure getrgb(c,r,g,b:byte);
procedure putpixel(x,y:word;c:byte);
function getpixel(x,y:word):byte;
procedure circle(x,y,r:word;c:byte);
procedure rectangle(x,y,x1,y1:integer;c:byte);
procedure bar(x,y,x1,y1:integer;c:byte);
procedure closeVGA;
implementation
procedure initVGA;assembler;
asm
mov ax,0013h
int 10h
end;
procedure getpalette(p:palette);assembler;
asm
mov di,offset p
mov cx,256
mov bl,0
@1:mov dx,3c8h
   mov al,bl
   out dx,al
   inc dx
   in al,dx
   stosb
   in al,dx
   stosb
   in al,dx
   stosb
   inc bl
   loop @1
end;
procedure setpalette(p:palette);assembler;
asm
mov si,offset p
mov cx,256
mov bl,0
@2:mov dx,3c8h
   mov al,bl
   out dx,al
   inc dx
   lodsb
   out dx,al
   lodsb
   out dx,al
   lodsb
   out dx,al
   loop @2
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
procedure getrgb(c,r,g,b:byte);assembler;
asm
mov dx,3c8h
mov al,c
out dx,al
inc dx
in al,dx
mov r,al
in al,dx
mov g,al
in al,dx
mov b,al
end;
procedure putpixel(x,y:word;c:byte);
begin
asm cli end;
mem[$A000:320*y+x]:=c;
asm sti end;
end;
function getpixel(x,y:word):byte;
begin
getpixel:=mem[$A000:320*y+x];
end;
procedure circle(x,y,r:word;c:byte);
var i,j,n:word;
begin
for n:=0 to 360 do
begin
i:=round(x+r*cos(n*pi/180));
j:=round(y+r*sin(n*pi/180));
putpixel(i,j,c);
end;
end;
procedure rectangle(x,y,x1,y1:integer;c:byte);
var cnt:word;
begin
for cnt:=x to x1 do
begin
putpixel(cnt,y,c);
putpixel(cnt,y1,c);
end;
for cnt:=y to y1 do
begin
putpixel(x,cnt,c);
putpixel(x1,cnt,c);
end;
end;
procedure bar(x,y,x1,y1:integer;c:byte);
var cnt,cnt1:word;
begin
for cnt:=y to y1 do
for cnt1:=x to x1 do
begin
putpixel(cnt1,cnt,c);
end;
end;
procedure closeVGA;assembler;
asm
mov ax,003h
int 10h
end;
begin
end.











