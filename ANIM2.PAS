uses crt,vga256;
var f:file;
    antet:array[1..128] of byte;
    pal:palette;
    n,i,j,t,x,y:word;
    k,p,cont:byte;
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
delayed;
pnt:=ptr($8000,0);
pnt1:=ptr($9000,0);
move(pnt^,pnt1^,64000);
for t:=0 to 32000 do
begin
if mem[$7000:t]<>0 then mem[$9000:t+ad]:=mem[$7000:t];
end;
delayed;
pnt:=ptr($9000,0);
pnt1:=ptr($a000,0);
move(pnt^,pnt1^,64000);
end;
begin
initvga;
port[$3c4]:=1;
port[$3c5]:=3;
assign(f,'c:\graphics\neopaint\00000002.pcx');
reset(f,1);
seek(f,filesize(f)-768);
blockread(f,pal,768);
t:=0;
for i:=0 to 255 do
begin
setrgb(i,pal[t] shr 2,pal[t+1] shr 2,pal[t+2] shr 2);
inc(t,3);
end;
seek(f,1);
blockread(f,antet,128);
seek(f,128);
t:=0;
repeat
blockread(f,k,1);
if k and $c0=$c0 then
begin
cont:=k and $3f;
blockread(f,k,1);
for j:=t to t+cont do
begin
mem[$a000:j]:=k
end;
inc(t,cont);
end
else
begin
cont:=1;
mem[$a000:t]:=k;
inc(t);
end;
until t>63999;
close(f);
for t:=44800 to 64000 do mem[$a000:t]:=0;
for t:=0 to 64000 do mem[$7000:t]:=0;
for t:=0 to 32000 do
begin
mem[$7000:t]:=mem[$a000:t+16000];
end;
assign(f,'c:\graphics\neopaint\00000003.pcx');
reset(f,1);
seek(f,filesize(f)-768);
blockread(f,pal,768);
t:=0;
for i:=0 to 255 do
begin
setrgb(i,pal[t] shr 2,pal[t+1] shr 2,pal[t+2] shr 2);
inc(t,3);
end;
seek(f,1);
blockread(f,antet,128);
seek(f,128);
t:=0;
repeat
blockread(f,k,1);
if k and $c0=$c0 then
begin
cont:=k and $3f;
blockread(f,k,1);
for j:=t to t+cont do
begin
mem[$8000:j]:=k
end;
inc(t,cont);
end
else
begin
cont:=1;
mem[$8000:t]:=k;
inc(t);
end;
until t>63999;
close(f);
cnt:=0;
while cnt<32000 do
begin
inc(cnt,320);
mem_to_mem(cnt);
end;
readln;
closevga;
end.


