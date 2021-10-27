unit stuff;
Interface
uses graph,mouse;

Var
     Buttons : array[1..20] of record
                                 x,y:integer ;  {Position}
                                 u,v:integer ;  {End Pos}
                                head:string[8]; {Button Name}
                                pr:boolean;
                              end;
     VolButtons : array[1..20] of record
                               x,y:integer ;
                               u,v:integer ;
                               bal:byte ;
                               vol:byte ;
                               head:string[8];
                               bx,by,bu,bv:integer;
                               vx,vy,vu,vv:integer;
                              end;
     Temp : array[1..400] of byte ;
     NrButtons:byte;
     NrVolButtons:byte;
     akt:byte;
     finish:boolean;

{Imports for Main}

 Procedure Alap;
 Procedure LockMouse;

Implementation

{Buttons}

{Volume buttons & Effects}
Procedure setvol(nr:byte);
Begin
with volbuttons[nr] do
 case nr of
 1: Begin end;
 5: Begin end;
 6: Begin end;
 2: Begin end;
 4: Begin end;
 3: Begin end;

 end;
End;

Procedure VolButton(nr:integer);
var y1,y2:integer;
Begin
if (nr>0) and (nr<=Nrvolbuttons) then
Begin
with VolButtons[nr] do
Begin
 setfillstyle(solidfill,green);
 bar(x,y,u,v);
 setcolor(white);
 line(x,y,u,y);
 line(x,y,x,v);
 setcolor(blue);
 line(u,v,u,y);
 line(u,v,x,v);
 outtextxy(x+4,v+2,head);
 line(x+16,y+20,u-16,y+20);
 line(x+16,y+20,x+16,v-10);
 setcolor(white);
 line(u-16,v-10,u-16,y+20);
 line(u-16,v-10,x+16,v-10);
 setfillstyle(solidfill,green);
 y1:=(v-10)-(vol*(v-y-30) div 16-2);
 y2:=y1-7;
 bar(x+4,y1,u-4,y2);
 vx:=x+4;vu:=u-4;vy:=y2;vv:=y1;
 setcolor(white);
 line(x+7,y2,u-7,y2);
 line(x+7,y2,x+7,y1);
 setcolor(blue);
 line(u-7,y1,u-7,y2);
 line(u-7,y1,x+7,y1);

 line(x+2,y+2,u-2,y+2);
 line(x+2,y+2,x+2,y+8);
 setcolor(white);
 line(u-2,y+8,u-2,y+2);
 line(u-2,y+8,x+2,y+8);
 setfillstyle(solidfill,blue);
 y1:=x+4+bal*((u-4)-(x+4)) div 16-2;
 y2:=y1+5;
 bar(y1,y+3,y2,y+7);
 bx:=y1;by:=y+3;bu:=y2;bv:=y+7;
 end;
end;
end;




Procedure NewVolButton(xx,yy:integer;s:string);
Begin
 inc(nrvolbuttons);
 With Volbuttons[nrvolbuttons] do
 Begin
  x:=xx*43-30;
  y:=yy*93;
  u:=x+40;
  v:=y+93;
  bal:=8;
  vol:=7;
  head:=s;
 End;
  Volbutton(nrvolbuttons);
  setvol(nrvolbuttons);
End;

{Normal Buttons }

Procedure Button(nr:integer;press:boolean);
Begin
if (nr>0) and (nr<=Nrbuttons) then
Begin
With buttons[nr] do
 Begin
 if not(press) then setcolor(blue) else setcolor(white);
  line(x,y,u,y);
  line(x,y,x,v);
 if not(press) then setcolor(white) else setcolor(blue);
  line(u,v,u,y);
  line(u,v,x,v);
  setcolor(blue);
  outtextxy(x+2,y+7,head);
 End;
end;
end;


Procedure NewButton(xx,yy:integer;s:string;st:boolean);
Begin
 inc(Nrbuttons);
 with buttons[nrbuttons] do
 Begin
  x:=xx*53+10;
  y:=yy*23+10;
  u:=x+50;
  v:=y+20;
  head:=s;
  Button(nrbuttons,true);
 End;
End;

Procedure LockButton;
Begin
case akt of
  1:Begin finish:=true end;
  2:Begin end;
  3:Begin end;
  5:Begin
    buttons[7].pr:=false;
    buttons[6].pr:=false;
    end;
  6:Begin
     buttons[6].pr:=true;
{     buttons[7].pr:=false;}
    End;
  7:Begin
     buttons[7].pr:=true;
{     buttons[6].pr:=false;}
    End;
 end;
end;


{Lock at the Mouse }

Procedure LockMouse ;
Var i:integer;
Begin
 for i:=1 to Nrbuttons do
  with buttons[i] do
  Begin
   if ((x<=getmousex)and(u>=getmousex)and
       (y<=getmousey)and(v>=getmousey)and(leftbuttonpressed)) then
   Begin
    {Draw Pressed button}
     MouseOff;
      Button(i,false);
     MouseOn;
    {Wait for button relase}
     Repeat
     Until not(leftbuttonPressed);
    {Lock Cursor pos}
     if ((x<=getmousex)and(u>=getmousex)and
         (y<=getmousey)and(v>=getmousey)) then akt:=i;
   {Draw Final Button}
     MouseOff;
     Button(i,true);
     MouseOn;
     LockButton;
   End;
   end;

End;



Procedure Alap;
var i:integer;
Begin
 setfillstyle(solidfill,green);
 bar(0,0,getmaxx,getmaxy);
 setcolor(white);
 rectangle(10,10,800-10,600-10);
 setcolor(black);
 rectangle(12,12,800-8,600-8);
 settextstyle(defaultfont,horizdir,0);
 setcolor(blue);
 outtextxy(15,15,'PALETTE CONTROL');
 setfillstyle(solidfill,black);
 bar(15,25,15+258,25+100);
 for i:=0 to 255 do
 Begin
  setcolor(i);
  line(16+i,26,16+i,99+25);
 end;
 NrButtons:=0;
 NewButton(10,1,' EXIT',false);
End;

Begin
End.