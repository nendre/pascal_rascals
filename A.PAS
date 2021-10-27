Uses graph,crt;
var i,j,k,gd,gm:integer;
    x,y:integer;
    ch:char;
Procedure Urhajo(x,y:integer);
Begin
 setcolor(green);
 outtextxy(x,y,  '    XXXX     ');
 outtextxy(x,y+7,'   XXXXXX    ');
 outtextxy(x,y+14,'  XXXXXXXX   ');
 outtextxy(x,y+21,' TTTTTTTTTT  ');
end;
Begin
 gd:=detect;
 initgraph(gd,gm,'d:\bp\bgi');
 cleardevice;
 for i:=1 to 1000 do
  putpixel(random(getmaxx),random(getmaxy-30),random(getmaxcolor));
 x:=30;
 y:=getmaxy-30;
 urhajo(x,y);
repeat
 ch:=' ';
 if keypressed then ch:=readkey;
 if ch=#00 then ch:=readkey;
 if (ch='o') and (x>20) then x:=x-7;
 if (ch='p') and (x<getmaxx-40) then x:=x+7;
 setfillstyle(solidfill,0);
 bar(0,getmaxy-30,getmaxx,getmaxy);
 urhajo(x,y);

until ch=#27;
 readkey;
 closegraph;
end.
