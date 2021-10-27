{$G+}
{$F+}
uses vga256,crt;
var n,i,j,t:word;
    f:file;
    k:array[0..320] of byte;
    p:pointer;
    pal:array[0..1204] of byte;
    pl,plt,p1:array[0..768] of byte;
    vga:real;
    ind,ind1:boolean;
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
procedure setcolor;assembler;
asm
pusha
mov si,offset p1
mov dx,3c8h
mov al,0
out dx,al
mov dx,3c9h
mov cx,768
rep outsb
popa
end;
procedure muta(adresa:word);assembler;
asm
pusha
push ds
push es
mov ax,adresa
mov ds,ax
mov ax,0a000h
mov es,ax
mov si,0
mov di,0
mov cx,32000
rep movsw
pop es
pop ds
popa
end;

begin
asm
mov ax,0013h
int 10h
end;
for i:=0 to 768 do p1[i]:=0;
setcolor;
assign(f,'c:\bc\prog\td.bmp');
reset(f,1);
seek(f,54);
blockread(f,pal,1024);
t:=0;n:=0;
for i:=0 to 255 do
begin
setrgb(i,pal[t+2] div 4,pal[t+1] div 4,pal[t] div 4);
pl[n]:=pal[t+2] div 4;
inc(n);
pl[n]:=pal[t+1] div 4;
inc(n);
pl[n]:=pal[t] div 4;
inc(n);
inc(t,4);
end;
for i:=199 downto 0 do
begin
p:=ptr($8000,320*i);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
assign(f,'c:\tp\prog\pups.bmp');
reset(f,1);
seek(f,54);
blockread(f,pal,1024);
t:=0;n:=0;
for i:=0 to 255 do
begin
plt[n]:=pal[t+2] div 4;
inc(n);
plt[n]:=pal[t+1] div 4;
inc(n);
plt[n]:=pal[t] div 4;
inc(n);
inc(t,4);
end;
for i:=199 downto 0 do
begin
p:=ptr($9000,320*i);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
ind:=false;ind1:=false;
repeat
if ind=false then muta($8000) else muta($9000);
n:=1;
vga:=1.0;
repeat
t:=0;
repeat
if ind=false then
p1[t]:=round(pl[t]*vga)
else
p1[t]:=round(plt[t]*vga);
inc(t);
until t>767;
delayed;
setcolor;
vga:=vga-0.01;
inc(n);
until n=90;
ind:=not(ind);
if ind=true then ind1:=false else ind1:=true;
if ind1=false then muta($9000) else muta($8000);
n:=1;
repeat
t:=0;
repeat
if ind1=false then
p1[t]:=round(plt[t]*vga)
else
p1[t]:=round(pl[t]*vga);
inc(t);
until t>767;
delayed;
setcolor;
vga:=vga+0.01;
inc(n);
until n=90;
ind1:=false;
until keypressed;
readln;
asm
mov ax,003h
int 10h
end;
end.
