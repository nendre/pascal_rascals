uses crt,vga,graph,dos ;
var o,i,j,k,m,n:integer ;
    gd,gm,x1,y1,x,y:integer;
    v:integer;
    f:integer;
        old:procedure;
        r:integer;
     si,co:array[0..5*360] of real;
procedure paletteanim;
interrupt;
var i:integer;
k:integer;
z,b:byte;
procedure delayed;
assembler;
asm
 mov dx,3daH
 @a1:
 in al,dx
 test al,8
 jne @a1
 mov dx,3daH
 @a2:
 in al,dx
 test al,8
 je @a2

end;
begin
{ k:=abs(k-1);
 szinbeallit(0,k*63,k*63,k*63);}
 delayed;
 for i:=0 to 127 do
 begin
 b:=i+z;
 if b<>0 then
 szinbeallit(b,i div v,i div (v+1),i div (v+2));
 end;
  delayed;
  for i:=0 to 127 do
  begin
  b:=256-i+z;
 if b<>0 then
 szinbeallit(b,i div v,i div (v+1),i div (v+2));
 end;
 {for i:=(f+1) to 255 do
 szinbeallit(i+l,i div 4,i div 4,i div 4);}
{ szinbeallit(0,z,z,z);}
 z:=z+f;
{ if z>30 then z:=0;}
inline($9c);
end;




Begin

  for i:=0 to 5*360 do
  begin
  si[i]:=sin(i*pi/180);
  co[i]:=cos(i*pi/180);
  end;

v:=2;
f:=20;
gd:=installuserdriver('svga256',nil);
gm:=0;
initgraph(gd,gm,'c:\bp\bgi');
cleardevice;
 vmode($13);
 getintvec($1c,@old);
 setintvec($1c,@paletteanim);
  m:=0;
  n:=5;
   o:=1;
  repeat
    i:=1;
  k:=50;

  for j:=1 to 60 do
  Begin
  i:=1;
   repeat
   r:=j+round((10+m)*sin(i*pi/(1+o)) );
   x:=round((30+r)*si[i]);
   y:=round((30+r)*co[i]);
   x1:=round((30+r)*si[i-1]);
   y1:=round((30+r)*co[i-1]);
   setcolor(k);
   line(x+160,y+100,x1+160,y1+100);
   szin:=k;
   xpont(160+x,100+y);
   k:=k+1+n;
   i:=i+1+m;

   until i>360;
  n:=n+1;
  End;
   o:=o+5;
   if o>300 then o:=1;
   m:=m+1;
   if o>5 then begin  m:=0;n:=n+1; end;

{  k:=k-5-m;}
{  if m>10 then begin m:=0;n:=n+1;end;}
  if n>25 then n:=5;
  until keypressed;
  readkey;
    setintvec($1c,@old);
 vmode($03);
End.