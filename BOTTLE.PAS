uses crt,vga,graph3d,graph;
const pp:array[1..25,1..2] of integer=
(( 0,-60) ,
( 7,-55  ),
( 13,-50 ),
( 19,-45 ),
( 25,-40 ),
( 31,-34 ),
( 38,-27 ),
( 44,-21 ) ,
( 49,-15 ),
( 54,-8  ) ,
( 58,-2  ) ,
( 61,5   ) ,
( 63,11  ) ,
( 65,18  ) ,
( 66,23  ) ,
( 66,27  ) ,
( 64,33  ) ,
( 59,39  ) ,
( 55,43  ) ,
( 47,48  ) ,
( 36,53  ) ,
( 26,57  ) ,
( 16,59  ) ,
( 8,60   ) ,
( 0,60   ));



const rr:array[1..25,1..2] of integer=
((0,-81),
 (8,-81),
( 14,-80),
( 15,-79),
 (15,-77),
( 14,-75) ,
( 12,-74),
( 12,-50),
( 13,-40),
( 17,-33),
( 29,-23),
( 32,-15),
( 32,-7),
( 32,1),
( 32,8),
( 32,15),
( 32,26),
( 32,35),
( 32,44),
( 32,53),
( 32,63),
( 32,72),
( 26,71),
( 17,70),
( 0,69)
);

ttt:array[1..25,1..2] of integer =
(( 0,-82)  ,
( 11,-82)  ,
( 22,-81 ) ,
( 30,-79)  ,
( 38,-75)  ,
( 43,-69)  ,
( 44,-61)  ,
( 44,-56)  ,
( 42,-47)  ,
( 37,-42)  ,
( 28,-36)  ,
( 23,-35)  ,
( 25,-3 )  ,
( 23,30 )  ,
( 29,31 )  ,
( 38,38 )  ,
( 42,44 )  ,
( 43,51 )  ,
( 43,60 )  ,
( 40,67 )  ,
( 35,71 )  ,
( 30,74 )  ,
( 24,76 )  ,
( 12,78 )  ,
( 0,78  )
);
type st=array[0..10,1..2,1..25] of integer;
type mu=array[1..64000] of byte;
var a:array[1..10,1..3,1..25] of integer;
   d,b,c:st;
   i,j,k:word;
   a1,a2,a3:integer;
   p1,p2:^mu;
  gd,gm,maxrot:integer;
  x,y:real;

begin
gd:=installuserdriver('svga256',nil);
gm:=0;
initgraph(gd,gm,'C:\Bp\bgi');

setcolor(white);
for i:=0 to 400 do
begin
si[i]:=sin(i*pi/180);
co[i]:=cos(i*pi/180);
end;
maxrot:=10;
for i:=1 to 25 do
begin
j:=1;
k:=maxrot;
repeat
a[k,2,i]:=rr[i,2];
a[k,1,i]:=round(rr[i,1]*sin(j*pi/180));
a[k,3,i]:=round(rr[i,1]*cos(j*pi/180));
k:=k-1;
j:=j+(360 div maxrot);
until k<=0;
end;
vmode($13);
{
port[$3d4]:=$0d;
port[$3d5]:=lo(10000);
port[$3d4]:=$0c;
port[$3d5]:=hi(10000);
port[$3c4]:=4;
}
for i:=0 to 255 do
szinbeallit(i,i div 4,i div 4,i div 4);
szin:=white;
dist:=400;
cor:=4;
a1:=0;a2:=0;a3:=0;
k:=100;
p1:=ptr($a000,0);
new(p2);
repeat
a1:=a1+3;
a2:=a2+4;
a3:=a3+5;

{if k=0 then
begin
k:=random(5);
if k=0 then k:=5 else k:=0;
end
else
begin
 i:=random(4);
 if i=0 then k:=k+1 else k:=k-1;
end;
}
for j:=1 to 10 do
for i:=1 to 25 do
begin
{if a[j,1,i]<0 then pix3d.x:=a[j,1,i]-k*2 else pix3d.x:=a[j,1,i]+2*k;
if a[j,2,i]<0 then pix3d.y:=a[j,2,i]-k*2 else pix3d.y:=a[j,2,i]+2*k;
if a[j,3,i]<0 then pix3d.z:=a[j,3,i]-k*2 else pix3d.z:=a[j,3,i]+2*k;}
pix3d.x:=a[j,1,i];
pix3d.y:=a[j,2,i];
pix3d.z:=a[j,3,i];
rotx(a1);
roty(a2);
rotz(a3);
project;
x:=pix2d.x;
y:=pix2d.y;
c[j,1,i]:=round(x+160);
c[j,2,i]:=round(y+100);
end;
{asm
 mov dx,3dah
@l1:
 in al,dx
 and al,8
 je @l1
@l2:
 in al,dx
 and al,8
 jne @l2
 mov ax,0a000h
 mov es,ax
 xor di,di
 mov ax,0
 mov cx,32000
 rep stosw
end;}
c[0]:=c[10];
for j:=1 to 10 do
for i:=2 to 25 do
begin
szin:=black;
setcolor(black);
{pont(b[j,1,i],b[j,2,i]);}
 line(d[j,1,i],d[j,2,i],d[j,1,i-1],d[j,2,i-1]);
 line(d[j,1,i],d[j,2,i],d[j-1,1,i],d[j-1,2,i]);
{b[j,1,i]:=c[j,1,i];
b[j,2,i]:=c[j,2,i];}
end;
for j:=1 to 10 do
for i:=2 to 25 do
begin
szin:=white;
setcolor(230);
{pont(b[j,1,i],b[j,2,i]);}
 line(c[j,1,i],c[j,2,i],c[j,1,i-1],c[j,2,i-1]);
 line(c[j,1,i],c[j,2,i],c[j-1,1,i],c[j-1,2,i]);
end;
d:=c;
if a1>359 then a1:=0;
if a2>359 then a2:=0;
if a3>359 then a3:=0;
until keypressed;
readkey;
dispose(p2);
vmode($03);
end.