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
pnt:=ptr($8000,16000);
pnt1:=ptr($9000,16000);
move(pnt^,pnt1^,16000);
for t:=16000 to 32000 do
begin
if mem[$7000:t+ad-16000]<>0 then mem[$9000:t]:=mem[$7000:t+ad-16000];
end;
delayed;
pnt:=ptr($9000,16000);
pnt1:=ptr($a000,16000);
move(pnt^,pnt1^,16000);
end;
begin
initvga;
port[$3c4]:=1;
port[$3c5]:=3;
assign(f,'c:\graphics\picture\text.bmp');
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
assign(f,'c:\graphics\picture\00000005.bmp');
reset(f,1);
seek(f,54);
blockread(f,pal,1024);
t:=0;
for i:=0 to 254 do
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
while cnt<48000 do
begin
inc(cnt,320);
mem_to_mem(cnt);
end;
p:=ptr($8000,16000);
p1:=ptr($a000,16000);
move(p^,p1^,320);
readln;
closevga;
end.


