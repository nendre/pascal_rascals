{$G+}
var f:file;
    k:array[0..319 ] of byte;
    pal:array[0..1024] of byte;
    n,j:integer;
    p,p1,p2:pointer;
    x,y,t,i:word;
procedure delayed;assembler;
asm
mov dx,3dah
@1:in al,dx
   test al,08
   je @1
@2:in al,dx
   test al,08
   jne @2
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
procedure draw_to_mem(t:word);
begin
p:=ptr($8000,0);
p1:=ptr($9000,0);
move(p^,p1^,16000);
for i:=0 to 16000 do
begin
if mem[$7000:i]<>15 then mem[$9000:i+t]:=mem[$7000:i];
end;
end;
procedure draw;
begin
p:=ptr($9000,0);
p1:=ptr($a000,0);
move(p^,p1^,16000);
end;
begin
asm
mov ax,0013h
int 10h
end;
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
p:=ptr($a000,320*i);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
p:=ptr($a000,0);
p1:=ptr($8000,0);
move(p^,p1^,64000);
assign(f,'ball.bmp');
reset(f,1);
seek(f,54);
blockread(f,pal,1024);
t:=0;
{for i:=0 to 255 do
begin
setrgb(i,pal[t+2] div 4,pal[t+1] div 4,pal[t] div 4);
inc(t,4);
end;}
seek(f,1078);
for i:=199 downto 0 do
begin
p:=ptr($a000,320*i);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
p:=ptr($a000,0);
p2:=ptr($7000,0);
move(p^,p2^,64000);
p:=ptr($8000,0);
p1:=ptr($a000,0);
move(p^,p1^,64000);
t:=0;
while t<300 do
begin
draw_to_mem(t);
delayed;
draw;
inc(t,4);
end;
readln;
asm
mov ax,003h
int 10h
end;
end.
