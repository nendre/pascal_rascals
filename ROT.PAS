uses crt,graph,gr1;
var si,co:array[0..360] of real;
    x0,y0,gd,gm:integer;
    x,y,z:real;
    j,k,i:longint;
    q,w,a,b,c:integer;
    r1,g1,b1,r2,b2,g2:byte;
    rr:array[1..365] of byte;
   dd:array[1..320] of byte;

procedure rotx;
var xt,yt,zt:real;
begin
xt:=x;
x:=x*co[a]+y*si[a];
y:=-xt*si[a]+y*co[a];
end;
procedure roty;
var xt,yt,zt:real;
begin
yt:=y;
y:=y*co[b]+z*si[b];
z:=-yt*si[b]+z*co[b];
end;
procedure rotz;
var xt,yt,zt:real;
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
x0:=300;
y0:=200;
gd:=installuserdriver('svga256',nil);
gm:=3;
initgraph(gd,gm,'c:\bp\bgi');
for i:=1 to 255 do setrgbpalette(i,255,255,255);
putpixel(x0,y0,white);
a:=0;b:=0;c:=25;
for i:=1 to 360*200 do
begin
x:=0;y:=100;z:=0;
rotx;roty;rotz;
q:=round(x0+x);
w:=round(y0+y);
putpixel(q,w,round(255*si[a]));
b:=b+1;
if b=1 then begin a:=a+1;end;
if c>359 then begin c:=0;end;
if a>359 then begin a:=0;end;
if b>359 then begin b:=0;end;
end;
k:=0;
repeat
for i:=0 to 255 do
setpal(i,0,0,0);
for i:=1 to 100 do
begin
setpal(254,255,255,255);
del;
setpal(254,0,0,0);
del;
del;
del;
del;
del;
end;
for i:=0 to 255 do
setpal(i,0,0,0);
for j:=1 to 245 div 10 do
for k:=1 to 10 do
begin
del;
setpal(j*10+k,255,255,255);
setpal(j*10+k-10,0,0,0);
end;
for j:=1 to 245 div 10 do
for k:=1 to 10 do
begin
del;
setpal(255-(j*10+k),255,255,255);
setpal(255-(j*10+k-10),0,0,0);
end;
for i:=1 to 253 do
begin
del;
setpal(i,255,255,255);
end;
for i:=1 to 253 do
begin
del;
setpal(i,0,0,0);
end;

for i:=0 to 255 do
begin
del;
for j:=1 to 253 do
setpal(j,i div 4,i div 4,i div 4);
end;
k:=0;
for j:=0 to 1000 do
begin
del;
for i:=1 to 253 do
begin
setpal(i,(k+i) div 4,(k+i) div 4,(k+i) div 4);
inc(k,10);
end;
end;
k:=0;
for j:=1 to 3000 do

begin
for i:=1 to 120 do
setpal(i*2+random(2),(i+k) div 4,(i+k) div 4,(j+i)div 4);
inc(k,2);
end;

for j:=0 to 30 do
begin
for r1:=1 to 20 do
begin
del;
g1:=random(2);
for i:=1 to 253 do
begin
setpal(abs((254*g1)-i),(k+i) div 4,(k+i) div 4,(k+i) div 4);
inc(k,2);
end;
end;
for r1:=1 to 20 do
begin
del;
g1:=random(2);
for i:=1 to 253 do
begin
setpal(abs((254*g1)-i),(k+i) div 4,(k+i) div 4,(k+i) div 4);
dec(k,4);
end;
end;




end;


for j:=0 to 2000 do
begin
del;
for i:=1 to 253 do
begin
setpal(i,(rr[k]+i) div 4,(rr[k]+i) div 4,(rr[k]+i) div 4);
inc(k,j div 90);
if(k>250) then k:=0;
end;
end;

for i:=255 downto 0 do
begin
del;
for j:=1 to 253 do
setpal(j,i div 4,i div 4,i div 4);
end;
for i:=1 to 5 do
begin
j:=0;
del;
while j<250 do
begin
del;
setpal(i+j,255,255,255);
inc(j,5);
end;
end;

for i:=0 to 255 do
begin
del;
setpal(255,i div 4,i div 4,i div 4);
setpal(254,i div 4,i div 4,i div 4);
end;
for i:=255 downto 0 do
begin
del;
setpal(255,i div 4,i div 4,i div 4);
setpal(254,i div 4,i div 4,i div 4);

end;
until keypressed;

closegraph;
end.


