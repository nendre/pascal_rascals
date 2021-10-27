uses crt,vga,bmp,fgraph3d;
type buff=array[1..64000] of byte;
var
    p2,p1,p:^buff;
    i,j,k:longint;
    x,y,xw,yw:longint;
    cx,cy,bx,by,bwx,bwy:longint;


BEGIN
{+++++++++++++++++++++++++++++++++++++++++++++}
{Init sin and cos data with integer arithmetic}
{+++++++++++++++++++++++++++++++++++++++++++++}
   for i:=0 to 360 do
    begin
    si[i]:=round(100*sin(i*pi/180));
    co[i]:=round(100*cos(i*pi/180));
   end;
   {Pointers }
   new(p1);
   new(p2);
   p:=ptr($a000,0);
{+++++++++++++++++++++++++++++++++++++++++++++}
{ Init videomode,load image and clear screen  }
{+++++++++++++++++++++++++++++++++++++++++++++}
  vmode($13);
  bmpbetolt('pups.bmp');
  p1^:=p^;
  for i:=0 to 64000 do mem[$a000:i]:=0;
  p2^:=p^;
  {screen viewport}
  x:=50;y:=50;     {x,y upper left corner}
  xw:=150;yw:=100; {xw,yw widht of viewport}
  {buffer viewport}
  bx:=0;by:=0;
  bwx:=319;bwy:=199;
  dist:=100;cor:=1;
  k:=10;
 Repeat
  {ratio settings}
   cx:=100*bwx div xw;
   cy:=100*bwy div yw;

  for i:=x to x+xw do
  for j:=y to y+yw do
  Begin
   pix3d.x:=100*((i-x)-(bx div 2));pix3d.y:=100*((j-y)-(by div 2));
   pix3d.z:=5000;
{   roty(k);}
   project;
   pix2d.x:=pix2d.x div 100;pix2d.y:=pix2d.y div 100;
   p2^[i+320*j]:=p1^[(bx+((pix2d.x-x)*cx div 100))+
                 320*(by+((pix2d.y-y)*cy div 100))];
  End;
  p^:=p2^;
{  k:=k+10;}
 until keypressed;

  readkey; {Ready }

{+++++++++++++++++++++++++++++++++++++++++++++}
{This is the end of the program               }
{+++++++++++++++++++++++++++++++++++++++++++++}
  vmode($03);
  p:=nil;
  dispose(p1);
  dispose(p2);
end.


