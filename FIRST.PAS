Unit First;
interface
Uses Crt,Graph,Vga,Mouse,Stuff;
 Procedure Init;
 Procedure Done;
implementation


Procedure Init;
var gd,gm:integer;
Begin
 gd:=installuserdriver('svga256',nil);
 gm:=3;
 initgraph(gd,gm,'c:\bp\bgi');
 vmode($5e);
 cleardevice;
 setbkcolor(0);
 Alap;
 MouseOn;
 Finish:=false;
end;

Procedure Done;
Begin
 MouseOff;
 Closegraph;
 clrscr;
End;

Begin
End.