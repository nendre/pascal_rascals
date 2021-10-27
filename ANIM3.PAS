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
procedure mem_to_mem(ad:word);
begin
pnt:=ptr($8000,ad);
pnt1:=ptr($9000,ad);
move(pnt^,pnt1^,28000);
for t:=0 to 28000 do
begin
if mem[$7000:t]<>0 then mem[$9000:t+ad]:=mem[$7000:t];
end;
delayed;
pnt:=ptr($9000,ad);
pnt1:=ptr($a000,ad);
move(pnt^,pnt1^,28000);
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
for t:=0 to 64000 do mem[$7000:t]:=0;
for t:=0 to 32000 do
begin
mem[$7000:t]:=mem[$a000:t+16000];
end;
assign(f,'c:\graphics\picture\00000003.bmp');
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
p:=ptr($8000,320*i);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
pnt:=ptr($8000,0);
pnt1:=ptr($A000,0);
move(pnt^,pnt1^,64000);
cnt:=0;
while cnt<32000 do
begin
inc(cnt,320);
mem_to_mem(cnt);
end;
readln;
closevga;
end.


