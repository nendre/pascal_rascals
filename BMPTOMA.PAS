uses crt,vga,bmp,graph;
var a:array[0..64000] of byte absolute $A000:0000;
var f:file;
 z,x,y,i,j,k,gd,gm:integer;
Begin
 gd:=installuserdriver('svga256',nil);
 gm:=0;
 initgraph(gd,gm,'c:\bp\bgi');
 vmode($13);
 for i:=0 to 255 do szinbeallit(i,0,0,i div 4);
{ bmpbetolt('texture.bmp');
 readkey;}
 settextstyle(0,0,2);
 setcolor(255);
 for k:=1 to 30 do
  Begin
 x:=random(320);
 y:=random(200);
 z:=random(2);
 if z=0 then z:=-1;
 for i:=1 to 50 do
 Begin
  setcolor(z*round(250*sin(i*(360/50)*pi/(180+k*2))));
  circle(x,y,i);
 End;
 end;
 setcolor(100);
 outtextxy(80,60,'BUMP MAPPING');


 readkey;
 assign(f,'map.dat');
 rewrite(f,1);
 blockwrite(f,a,64000);
 close(f);
 vmode($03);
End.