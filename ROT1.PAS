uses crt,vga256;
type rr=array[1..64000] of byte;
var f:file;
    si,co:array[0..360] of real;
    pal:array[0..1024] of byte;
    k:array[0..320] of byte;
    p2,p1:^rr;
    p:pointer;
    n,i,j,t:word;
    xt,yt,zt,x,y,z:real;
    a,b,c:integer;
    ii,jj:real;
procedure rotx;
begin
xt:=x;
x:=x*co[a]+y*si[a];
y:=-xt*si[a]+y*co[a];
end;
procedure roty;
begin
yt:=y;
y:=y*co[b]+z*si[b];
z:=-yt*si[b]+z*co[b];
end;
procedure rotz;
begin
zt:=z;
z:=z*co[c]+x*si[c];
x:=-zt*si[c]+x*co[c];
end;
begin
for i:=0 to 360 do
begin
si[i]:=sin(i*pi/180);
co[i]:=cos(i*pi/180);
end;
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
p:=ptr($A000,320*i);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
p1:=ptr($a000,0);
new(p2);
p2^:=p1^;
for i:=0 to 64000 do
mem[$a000:i]:=0;
ii:=50;jj:=50;
a:=0;b:=0;c:=0;
while jj<200-50 do
begin
ii:=50;
inc(c);inc(b);inc(a);
while ii<320-50 do
begin
z:=0;
x:=ii-160;y:=jj-100;
rotx;roty;rotz;
x:=x+160.0;y:=y+100.0;
p1^[round(y)*320+round(x)]:=p2^[round(jj)*320+round(ii)];
ii:=ii+0.5;
end;
jj:=jj+0.05;
end;
readln;
closevga;
end.