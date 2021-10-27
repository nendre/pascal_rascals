{$G+}
uses vga256,crt;
var k:array[0..320] of byte;
    f:file;
    i,j,t:word;
    p,p1:pointer;
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
t:=64;
for i:=16 to 255 do
begin
setrgb(i,pal[t+2] div 4,pal[t+1] div 4,pal[t] div 4);
inc(t,4);
end;
for i:=199 downto 0 do
begin
p:=ptr($9000,320*i);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
for i:=0 to 15 do setrgb(i,0,0,i*3);
t:=0;j:=0;
while t<200 do
begin
bar(0,t,319,t+13,j);
inc(j);
inc(t,13);
end;
j:=0;
while j<=48000 do
begin
delayed;
p:=ptr($a000,0);
p1:=ptr($9000,j);
move(p1^,p^,16000);
inc(j,320);
end;
j:=48000;
while j>0 do
begin
delayed;
p:=ptr($a000,0);
p1:=ptr($9000,j);
move(p1^,p^,16000);
dec(j,320);
end;
readln;
closevga;
end.

