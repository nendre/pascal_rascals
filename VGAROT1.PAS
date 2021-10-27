uses dos,crt;
const msg:string='ASSEMBLER 96$';
var i,n,t,xa,ya:word;
    s:string;
    k:array[1..16000] of byte;
    psin:array[0..360] of integer;
    contor:integer;
    r:registers;
    cul:array[1..320] of byte;
    p,p1:pointer;
    f:file;
    pal:array[0..1024] of byte;

procedure putpixelmem(x,y:word;c:byte);
begin
mem[$9000:320*y+x]:=c;
end;

function getpixel(x,y:word):byte;
begin
getpixel:=mem[$a000:320*y+x];
end;

procedure muta;assembler;
asm
push ds
push es
mov ax,09000h
mov ds,ax
mov ax,0a000h
mov es,ax
mov si,32000
mov di,32000
mov cx,12000
rep movsw
pop es
pop ds
end;

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

procedure sterge;assembler;
asm
push ds
push es
mov ax,08000h
mov ds,ax
mov ax,09000h
mov es,ax
mov si,32000
mov di,32000
cld
mov cx,12000
rep movsw
pop es
pop ds
end;

procedure setrgb(c,r,g,b:byte);assembler;
asm
mov dx,3c8h
mov al,c
out dx,al
mov dx,3c9h
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
r.ah:=9;
r.ds:=seg(msg);
r.dx:=ofs(msg[1]);
msdos(r);
for contor:=0 to 360 do
begin
psin[contor]:=140+round(14*sin(contor*3*pi/180));
end;
for ya:=0 to 8 do
for xa:=0 to 100 do
begin
k[t]:=getpixel(xa,ya);
inc(t);
end;
assign(f,'td.bmp');
reset(f,1);
seek(f,54);
blockread(f,pal,1024);
t:=0;
for i:=0 to 255 do
begin
setrgb(i,pal[t+2] div 4,pal[t+1] div 4,pal[t] div 4);
inc(t,4);
end;
for i:=0 to 64000 do mem[$8000:i]:=0;
for i:=199 downto 0 do
begin
p:=ptr($8000,320*i);
blockread(f,cul,320);
p1:=ptr($a000,320*i);
move(cul,p^,320);
move(cul,p1^,320);
end;
close(f);
readln;
contor:=320;
repeat
sterge;
setrgb(15,0,63,63);
t:=1;
for ya:=0 to 8 do
for xa:=0 to 100 do
begin
if k[t]=7 then
putpixelmem(xa+contor,psin[xa+contor]+ya,15);
inc(t);
end;
delayed;
muta;
dec(contor);
until contor<1;
readln;
asm
mov ax,003h
int 10h
end;
end.
