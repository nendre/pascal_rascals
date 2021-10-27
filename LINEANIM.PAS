{ Lineanim }

uses crt,graph;

var gd,gm : integer;

Procedure FastPalette(c,r,g,b:byte);
assembler;
asm
 mov dx,3c8H
 mov al,c
 out dx,al
 inc dx
 mov al,r
 out dx,al
 mov al,g
 out dx,al
 mov al,b
 out dx,al
end;

Procedure Grinit;
Begin
 gd:=installuserdriver('svga256',nil);
 gm:=2;
 initgraph(gd,gm,'d:\bp\bgi');
 setcolor(white);
 setbkcolor(black);
 cleardevice;
End;

Procedure GrEnd;
begin
 Closegraph;
 clrscr;
End;

Procedure Anim;
var x1,y1,x2,y2      : integer  ;
    x1p,x2p,y1p,y2p  : integer  ;
    aktcolor         : byte     ;
    x,y              : integer  ;
    pal              : byte     ;
    pon              : boolean  ;
    mp               : byte     ;
Procedure Valt;
Begin
 if x1p>0 then x1p:=(1+random(10)) else x1p:=-(1+random(10));
 if x2p>0 then x2p:=(1+random(10)) else x2p:=-(1+random(10));
 if y1p>0 then y1p:=(1+random(10)) else y1p:=-(1+random(10));
 if y2p>0 then y2p:=(1+random(10)) else y2p:=-(1+random(10));
End;

Begin
 AktColor:=0;
 Randomize;
 x1:=random(getmaxx div 2);
 x2:=random(getmaxx div 2);
 y1:=random(getmaxy div 2);
 y2:=random(getmaxy div 2);
 x1p:=1;
 x2p:=1;
 y1p:=1;
 y2p:=1;
 pon:=false;
 pal:=1;
 repeat
  if pal=0 then pal:=1;
  if pon then fastpalette(pal,pal div 4,pal div 4,pal div 4) else
              fastpalette(pal,0,0,0);
  { inc(pal);}
  x1:=x1+x1p ;
  x2:=x2+x2p ;
  y1:=y1+y1p ;
  y2:=y2+y2p ;
  if ((x1>getmaxx div 2) or (x1<0)) then x1p:=-x1p;
  if ((x2>getmaxx div 2) or (x2<0)) then x2p:=-x2p;
  if ((y1>getmaxy div 2) or (y1<0)) then y1p:=-y1p;
  if ((y2>getmaxy div 2) or (y2<0)) then y2p:=-y2p;
  setcolor(aktcolor);
  inc(aktcolor,3);
  if aktcolor=255 then begin valt;pon:=not(pon) end;
  line(x1,y1,x2,y2);
  line(getmaxx-x1,getmaxy-y1,getmaxx-x2,getmaxy-y2);
  line(getmaxx-x1,y1,getmaxx-x2,y2);
  line(x1,getmaxy-y1,x2,getmaxy-y2);
 until keypressed;
 readkey;
End;

Procedure Palinit;
var i:integer;
Begin
 For i:=0 to 255 do
 fastpalette(i,i div 4,i div 4,i div 4);
End;

Begin
 Grinit;
 Palinit;
 Anim;
 GrEnd;
End.