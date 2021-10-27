{$G+}
uses crt,vga256;
var f:file;
    antet:array[1..128] of byte;
    pal:palette;
    n,i,j,t,x,y:word;
    k:array[0..319] of byte;p,p1,p2:pointer;
    pnt,pnt1:pointer;
    cnt:word;
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
port[$3c4]:=1;
port[$3c5]:=3;
assign(f,'c:\graphics\picture\00000002.bmp');
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
p:=ptr($A000,320*i);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
for t:=44800 to 64000 do mem[$a000:t]:=0;
for t:=0 to 32000 do
begin
mem[$9000:t]:=mem[$a000:t+16000];
end;
for t:=0 to 64000 do mem[$a000:t]:=0;
repeat
cnt:=0;
while cnt<32000 do
begin
pnt:=ptr($9000,0);
pnt1:=ptr($a000,cnt);
delayed;
move(pnt^,pnt1^,30000);
inc(cnt,640);
end;
cnt:=32000;
while cnt >0 do
begin
pnt:=ptr($9000,0);
pnt1:=ptr($a000,cnt);
delayed;
move(pnt^,pnt1^,30000);
dec(cnt,640);
end;
until keypressed;
readln;
closevga;
end.


