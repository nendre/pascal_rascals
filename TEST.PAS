uses crt,graph,mouse;
Var gd,gm:integer ;
Begin
 gd:=detect;
 initgraph(gd,gm,'c:\bp\bgi');
 cleardevice;
 resetmouse;
 enablemouse;
 repeat
 if GetButtonRight then Begin
      putpixel(getmousex,getmousey,white);
      setmouse(getmousex-10,getmousey+10);
 end;
 until keypressed;
 readkey;
 disablemouse;
End.