uses dos,crt;
const msg:string='ASSEMBLER$';
var i,n,t,xa,ya:word;
    s:string;
    k:array[1..24000] of byte;
    psin,pcos:array[0..360] of integer;
    contor:integer;
    r:registers;
    culoare:byte;


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
mov si,0
mov di,0
mov cx,10000
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
push es
mov ax,09000h
mov es,ax
mov di,0
mov ax,0
mov cx,10000
rep stosw
pop es
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
psin[contor]:=20+round(10*sin(contor*5*pi/180));
pcos[contor]:=20+round(10*cos(contor*5*pi/180));
end;
for i:=0 to 64000 do mem[$9000:i]:=0;
for ya:=0 to 10 do
for xa:=0 to 70 do
begin
k[t]:=getpixel(xa,ya);
inc(t);
end;
contor:=200;
repeat
sterge;
setrgb(15,63,63,63);
t:=1;
for ya:=0 to 10 do
for xa:=0 to 70 do
begin
if k[t]=7 then
begin
putpixelmem(xa+contor,psin[xa+contor]+ya,15);
putpixelmem(xa+abs(contor-200),pcos[xa+abs(200-contor)]+ya,15);
putpixelmem(xa+abs(contor-200),50+ya,15);
putpixelmem(xa+contor,50+ya,15);
end;
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
