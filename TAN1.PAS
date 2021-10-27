uses crt,graph,dsp;

Type minmax = record
                amp  : byte;
                dist : word;
               End;
Type afa=array[0..20000] of byte;
     bfb=array[0..20000] of minmax;
Var x,y,i,j,k  :integer;
    max,min:^bfb;
    buf    ,
    temp   ,
    sig    :^afa;
    nrmax,
    nrmin,
    nrbuf  :integer;
    finish : boolean; {Ha true akkor vege }
    f      : file ;
    s      : string;
    ch:char;



Procedure CalcMaxandMin;
Var i,j:integer;
    irany:boolean; {true = fel ,false = le}
    xx,yy,x,y:integer;
Begin

 finish:=false ;

 {sigtabla felepitese}

 for j:=1 to nrbuf do
 if buf^[j-1]<buf^[j] then sig^[j]:=1    {sig    1 - FEL    }
  else                                {       2 - LE     }
 if buf^[j-1]>buf^[j] then sig^[j]:=2    {       0 - STABIL  }
  else
 sig^[j]:=0;

 {Kezdo irany megkeresese}

 i:=1;
 repeat
  if sig^[i]=1 then
   Begin
    irany:=true ;
    i:=0;
   End
   else
  if sig^[i]=2 then
   Begin
    irany:=false ;
    i:=0;
   End;
   i:=i+1;
 until (i=1) or (i>nrbuf) ;
 if i>nrbuf then finish:=true;

 { Maximumok  es minimumok }
if not(finish) then
Begin
 nrmax:=0;
 nrmin:=0;
 for i:=1 to nrbuf do
 Begin
  if (irany=true) and (sig^[i]=2) then {fel tol  le }
  Begin
   nrmax:=nrmax+1;
   max^[nrmax].amp:=buf^[i];
   max^[nrmax].dist:=i;
   irany:=false;
  End;
  if (irany=false) and (sig^[i]=1) then {le  tol  fel }
  Begin
   nrmin:=nrmin+1;
   min^[nrmin].amp:=buf^[i];
   min^[nrmin].dist:=i;
   irany:=true;
  End;
 End;
End;
 x:=0;y:=0;
 xx:=0;yy:=0;
 for i:=0 to nrbuf do
 temp^[i]:=0;
 if nrmax>nrmin then nrmax:=nrmin else nrmin:=nrmax;
 for i:=1 to nrmax do
 Begin
  if max^[i].dist>min^[i].dist then
  Begin
   temp^[min^[i].dist+(max^[i].dist-min^[i].dist) div 2]:=
     min^[i].amp+abs(max^[i].amp-min^[i].amp) div 2;
   x:=min^[i].dist+(max^[i].dist-min^[i].dist) div 2;
   y:=min^[i].amp+abs(max^[i].amp-min^[i].amp) div 2;
   if xx<>0 then
   Begin
    for k:=xx to x do
    Begin
    temp^[k]:=(abs(y-yy)*(k-xx) div abs(x-xx));
    if y<yy then temp^[k]:=yy-temp^[k] else temp^[k]:=yy+temp^[k];
    End;
   End;
   xx:=x;
   yy:=y;
   End
   else
  if max^[i].dist<min^[i].dist then
  Begin
   temp^[max^[i].dist+(min^[i].dist-max^[i].dist) div 2]:=
     min^[i].amp+abs(max^[i].amp-min^[i].amp) div 2;
     x:=max^[i].dist+(min^[i].dist-max^[i].dist) div 2;
     y:=min^[i].amp+abs(max^[i].amp-min^[i].amp) div 2;
    if xx<>0 then
   Begin
    for k:=xx to x do
    Begin
    Begin
    temp^[k]:=(abs(y-yy)*(k-xx) div abs(x-xx));
    if y<yy then temp^[k]:=yy-temp^[k] else temp^[k]:=yy+temp^[k];
    End;
    End;
   End;
   xx:=x;
   yy:=y;

   End;

 End;
End;

{Graphis on}

Procedure GraphOn;
Var gd,gm:integer;
Begin
gd:=detect;
initgraph(gd,gm,'d:\bp\bgi');
if grok<>graphresult then Begin Writeln('Graphic init error!');halt;end;
cleardevice;
End;

{Graphics Off}

Procedure GraphOff;
Begin
closegraph;
clrscr;
End;

Procedure ReadBuffer;
Var i:integer;
Begin
 assign(f,'c:\aaa.wav');
 reset(f,1);
 seek(f,filesize(f) div 8-2000);
 blockread(f,buf^,19000);
 for i:=0 to 1700 do
 buf^[i]:=round(127+(30*sin(i*pi/10)+40*sin(i*pi/150)+20*sin(i*pi/50)));
 nrbuf:=19000;
 close(f);
End;

Procedure DrawBuffer;
Var i:integer;
Begin
 for i:=0 to nrbuf do
 putpixel(i,buf^[i] div 2,white);
End;

Begin
new(max);
new(min);
new(buf);
new(temp);
new(sig);


GraphOn;
ReadBuffer;
Repeat
DrawBuffer;
CalcMaxandmin;
str(nrmax,s);
outtextxy(0,100,'Max:'+s);
str(nrmin,s);
outtextxy(0,120,'Min:'+s);

x:=0;y:=150;
for i:=1 to nrmax do
Begin
 if max^[i].dist<700 then
 Begin
{ putpixel(max[i].dist,150+max[i].amp div 2,white);}
{ line(max[i].dist,0,max[i].dist,getmaxy);}
   line(x,y,max^[i].dist,150+max^[i].amp div 2);
   x:=max^[i].dist;
   y:=150+max^[i].amp div 2;

 End;
End;
setlinestyle(1,0,0);
x:=0;y:=150;
for i:=1 to nrmin do
Begin
 if min^[i].dist<700 then
 Begin
{ putpixel(min[i].dist,150+min[i].amp div 2,white);}
{ line(min[i].dist,0,min[i].dist,getmaxy);}
   line(x,y,min^[i].dist,150+min^[i].amp div 2);
   x:=min^[i].dist;
   y:=150+min^[i].amp div 2;
 End;
End;
x:=0;y:=150;
setlinestyle(2,0,0);
for i:=1 to 700 do
{if temp[i]<>0 then}
   Begin
   putpixel(i,temp^[i] div 2+150,white);
{   line(x,y,i,temp[i] div 2+150);
   x:=i;
   y:=(temp[i] div 2)+150;}
  End;
ch:=Readkey;
for i:=0 to nrbuf do
Begin
{temp[i]:=255-temp[i];}
if ch='1' then buf^[i]:=buf^[i]-temp^[i]-128;
if ch='2' then buf^[i]:=temp^[i];
end;

cleardevice;
until ch=#27;
GraphOff;
dispose(max);
dispose(min);
dispose(buf);
dispose(temp);
dispose(sig);

End.
