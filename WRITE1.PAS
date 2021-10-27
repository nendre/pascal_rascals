{$G+}
uses vga256,crt;
var k:array[0..320] of byte;
    f:file;
    i,j,t:word;
    p,p1,p2:pointer;
    pal:array[0..1024] of byte;
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
p:=ptr($7000,320*i);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
for i:=0 to 319 do k[i]:=0;
for i:=0 to 64000 do mem[$8000:i]:=0;
j:=0;
while j<=64000 do
begin
p:=ptr($9000,j);
p1:=ptr($8000,j);
move(p1^,p^,320);
p:=ptr($9000,0);
p1:=ptr($7000,j);
move(p1^,p^,64000-j);
p:=ptr($a000,0);
{delayed;}
p1:=ptr($9000,j);
move(p1^,p^,64000-j);
inc(j,320);
end;
readln;
closevga;
end.

