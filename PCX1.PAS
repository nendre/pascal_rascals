uses crt,vga256;
var f:file;
    antet:array[1..128] of byte;
    pal:palette;
    n,i,j,x,y:word;
    t:longint;
    k,p,cont:byte;
    minx,miny,maxx,maxy,lx,ly,max,ol:word;
begin
initvga;
assign(f,'c:\graphics\neopaint\jobb.pcx');
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
seek(f,4);
blockread(f,minx,2);
blockread(f,miny,2);
blockread(f,maxx,2);
blockread(f,maxy,2);
lx:=maxx;
ly:=maxy-miny;
seek(f,128);
x:=0;y:=0;t:=0;
repeat
blockread(f,k,1);
if k and $c0=$c0 then
begin
cont:=k and $3f;
blockread(f,k,1);
j:=x;i:=0;
while i<cont do
begin
mem[$a000:320*y+j]:=k;
inc(j);
if j>lx then begin j:=minx;inc(y);end;
inc(i);
end;
x:=j;
end
else
begin
cont:=1;
mem[$a000:320*y+x]:=k;
inc(x);
if x>lx then begin x:=minx;inc(y);end;
end;
t:=320*y+x;
until t>320*ly;
close(f);
readln;
closevga;
end.


