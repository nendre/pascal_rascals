uses crt,graph;
var i,j,k,gd,gm:integer ;

Procedure egavgadriver;external;
{$l egavga.obj}
Begin
clrscr;
 if registerbgidriver(@egavgadriver)<0 then begin writeln('Error registering!');halt;end
 else
 writeln('O.K.');
 gd:=vga;
 gm:=vgahi;
 initgraph(gd,gm,'');
 cleardevice;
 for i:=1 to 1000 do
 putpixel(random(getmaxx),random(getmaxy),random(getmaxcolor));
 readkey;
 closegraph;
End.