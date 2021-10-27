{$g+}
uses crt,graph,gr1;
var si,co:array[0..360] of real;
    x0,y0,gd,gm:integer;
    u,x,y,z:real;
    j,k,i:longint;
    q,w,a,b,c:integer;
    r1,g1,b1,r2,b2,g2:byte;
    rr:array[1..365] of byte;
   dd:array[1..320] of byte;
   f:array[1..3,1..100] of integer;
   g:array[1..2,1..100] of integer;
   dis,cor:integer;
   ch:char;
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
gm:=0;
initgraph(gd,gm,'c:\bp\bgi');
for i:=0 to 3 do
begin
for j:=1 to 10 do
begin
f[1,i*10+j]:=-22+i*15;
f[2,i*10+j]:=-10+round(20*sin(((j*36)+j*5)*pi/180));
f[3,i*10+j]:=-10+round(20*cos(((j*36)+j*5)*pi/180));
end;
end;
a:=0;b:=0;c:=45;
cor:=0;
dis:=300;
repeat
begin
for i:=1 to 40 do
begin
x:=f[1,i];y:=f[2,i];z:=f[3,i];
rotx;roty;rotz;
if (dis-z)<0.00001 then u:=100000 else u:=1+(cor*z)/(dis-z);
x:=x*u;y:=y*u;
putpixel(g[1,i],g[2,i],black);
putpixel(round(x)+160,round(y)+100,white);
g[1,i]:=round(x)+160;
g[2,i]:=round(y)+100;
end;
b:=b+5;
{a:=a+1;}
c:=c+1;
if c>359 then begin c:=0;end;
if a>359 then begin a:=0;end;
if b>359 then begin b:=0;end;
ch:=' ';
if keypressed then ch:=readkey;
if ch='1' then cor:=cor+1;
if ch='2' then cor:=cor-1;
if ch='3' then dis:=dis+1;
if ch='4' then dis:=dis-1;
end;
until ch='0';
closegraph;
end.


