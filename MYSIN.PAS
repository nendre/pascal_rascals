uses crt,graph;
var i,j,l,gd,gm:integer;
    x1,x2,x3,z0,z,x,k,x0:real;
    y:array[1..700] of real;
    b:byte;
    smp,c,r:real;
    f,f1:file;
begin
assign(f,'c:\xxx.raw');
reset(f,1);
assign(f1,'c:\xxx5.raw');
rewrite(f1,1);
 gd:=detect;
 initgraph(gd,gm,'c:\bp\bgi');
 r:=100000; {100k}
 c:=0.000000007; {10 mikroF}
 smp:=44000;
{ k:=0.000012;
 repeat}
 k:=k-0.00000001;
 cleardevice;
 k:=1;
 for i:=1 to 700 do
 begin
{  y[i]:=(100*sin(100*(i*2*pi)/smp));}

  blockread(f,b,1);
  j:=b;
  y[i]:=(j-127) div 1;
{ if (i mod 60)=0 then k:=-k;
  y[i]:=round(i*k) mod 100;
}
 end;
 x:=0;
 z:=0;x0:=0;
 for i:=1 to getmaxx do
 begin
 x0:=x;z0:=z;
  x:=y[i]-(y[i]-x)*exp(-1/(smp*r*c));
  x1:=x-(x-x1)*exp(-1/(smp*r*c));
  z:=y[i]-x;
  y[i]:=x;
  setcolor(white);line(i,getmaxy div 2+round(x),i-1,getmaxy div 2+round(x0));

  setcolor(blue);line(i,getmaxy div 2+round(z),i-1,getmaxy div 2+round(z0));
  setcolor(brown);{  line(i,getmaxy div 2+round(y[i-1]),i-1,getmaxy div 2+round(y[i]));}
{  putpixel(i,getmaxy div 2+round(x),white);
   putpixel(i,getmaxy div 2+round(z),blue);     }
   putpixel(i,getmaxy div 2+round(x1),yellow);
{  putpixel(i,round(y[i])+getmaxy div 2,yellow);}
 end;
{ until keypressed;}
j:=0;
while not eof(f) do
begin

 blockread(f,b,1);
  i:=b;i:=i-127;
  x:=i-(i-x)*exp(-1/(smp*r*c));
  x1:=x-(x-x1)*exp(-1/(smp*r*c));
  x2:=x-(x-x2)*exp(-1/(smp*r*c));
  x3:=x-(x-x3)*exp(-1/(smp*r*c));
  z:=i-x3;
  i:=round(z);i:=i+127;
  b:=i;

 blockwrite(f1,b,1);
end;
close(f);
close(f1);
 readkey;
 closegraph;
end.