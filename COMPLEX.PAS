uses crt,graph;
 var i,j,k,gd,gm:integer;
     a,b,c,d:integer;
     m,n:integer;
Begin
gd:=installuserdriver('svga256',nil);
gm:=3;
initgraph(gd,gm,'c:\bp\bgi');
randomize;
repeat
 cleardevice;
 a:=random(100);b:=random(100);c:=random(100);d:=random(100);
 a:=a-50;b:=b-50;c:=c-50;d:=d-50;
 setcolor(white);
 line(0,300,800,300);
 line(400,0,400,600);
 setcolor(blue);
 line(400,300,400+a,300+b);
 line(400,300,400+c,300+d);
 setcolor(cyan);
 m:=a+c;n:=b+d;
 line(400,300,400+m,300+n);
 setcolor(yellow);
 m:=a-c;n:=b-d;
 line(400,300,400+m,300+n);
 m:=c-a;n:=d-b;
 line(400,300,400+m,300+n);
 setcolor(green);
  m:=a*c-b*d;n:=a*d+b*c;
 line(400,300,400+m,300+n);

 readkey;
until keypressed;
closegraph;
end.