uses crt,graph,vga;
type mn=array[1..64000] of byte;
var si,co:array[0..360] of real;
    x0,y0,gd,gm:integer;
    x,y,z:real;
    f:file;
    p2,p1,p:^mn;
    dd:array[1..640] of integer;
    j,k,i:real;
    q,w,a,b,c:integer;
    d:integer;
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
new(p);
new(p2);
p1:=ptr($a000,0);
for d:=0 to 360 do
begin
si[d]:=sin(d*pi/180);
co[d]:=cos(d*pi/180);
end;
x0:=300;
y0:=200;
{gd:=installuserdriver('svga256',nil);
gm:=3;
initgraph(gd,gm,'c:\bp\bgi');}
vmode($13);
assign(f,'kep.map');
reset(f,1);
blockread(f,pal,sizeof(pal));
palbeallit(pal);
blockread(f,p^,64000);
close(f);
a:=180-45;b:=130;c:=0;
i:=0;
j:=0;
repeat
while i<200 do
begin
while j<360 do
begin
x:=20+i;y:=20;z:=0;
rotx;rotz;roty;
szin:=255;{p^[(320*c div 360)+320*round(i)];}
pont(100+round(x),100+round(y));
a:=a+1;
if a>359 then a:=0;
j:=j+0.5;
end;
j:=0;
i:=i+0.5;
end;
i:=0;
until keypressed;
readkey;
closegraph;
vmode($03);
end.


