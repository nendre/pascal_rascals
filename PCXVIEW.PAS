uses crt,vga256;
var f:file;
    antet:array[1..128] of byte;
    pal:palette;
    n,i,j,t,x,y:word;
    k,p,cont:byte;
begin
initvga;
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
readln;
closevga;
end.


