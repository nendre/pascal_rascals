uses crt,graph;
var gd,gm:integer;
    t,teta,fi,c:integer;
    z,n,d:integer;
    x,a,ax,ay,s:real;
    ch:char;
begin
n:=1;
d:=1;
z:=1;
gd:=detect;
initgraph(gd,gm,'c:\bp\bgi');
repeat
z:=z+30;
t:=0;
c:=0;
delay(1000);
cleardevice;
setviewport(300,150,500,200,false);
setcolor(white);
setbkcolor(black);
repeat
 begin
 teta:=t;
 a:=t*pi/180.0;
 ax:=cos(a)*sin(n*a)*150;
 ay:=sin(a)*sin(n*a)*150;
 moveto(round(ax),round(ay));
 repeat
 begin
 teta:=teta+d;
 teta:=teta-round(teta/z)*z;
 fi:=n*teta;
 fi:=fi-round(fi/z)*z;
 x:=2.0*pi*fi/z;
 s:=2.0*pi*teta/z;
 ax:=sin(x)*cos(s)*150;
 ay:=sin(x)*sin(s)*150;
 lineto(round(ax),round(ay));
 c:=c+1;
 end
 until teta=t;
 t:=t+1;
 end
 until c>=z;
 n:=n+11;
d:=n+11;

 until keypressed;
 readkey;
 closegraph;
 end.

