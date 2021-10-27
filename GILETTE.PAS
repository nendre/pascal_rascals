uses crt,vga,dos;
var f,v,i,j,k:integer;
    x,y:integer;
    z:byte;
    xp,yp:integer;
    m1,m2:boolean;
    xx,yy:integer;
           old:procedure;
procedure paletteanim;
interrupt;
var i:integer;
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
delayed;
 for i:=0 to 127 do
 begin
 b:=i+z;
 if b<>0 then
 szinbeallit(b,0,0,i div (v+2));
 end;
  delayed;
  for i:=0 to 127 do
  begin
  b:=256-i+z;
 if b<>0 then
 szinbeallit(b,0,0,i div (v+2));
 end;
  szinbeallit(0,0,0,0);
 {for i:=(f+1) to 255 do
 szinbeallit(i+l,i div 4,i div 4,i div 4);}
{ szinbeallit(0,z,z,z);}
 z:=z+15;
{ if z>30 then z:=0;}
inline($9c);
end;

begin
v:=3;
f:=1;
 vmode($13);
  getintvec($1c,@old);
setintvec($1c,@paletteanim);

 for i:=0 to 255 do
 szinbeallit(i,i div 4,i div 4,i div 4);
 k:=1;
 xx:=40;
 yy:=60;
 m1:=true;
 m2:=true;
 xp:=1;
 yp:=1;
 repeat
 xx:=xx+xp;
 yy:=yy+yp;
 if xx>208 then xp:=-xp;
 if xx<5 then xp:=-xp;
 if yy>88 then yp:=-yp;
 if yy<5 then yp:=-yp;
 for i:=xx to xx+100 do
 begin
 for j:=yy to yy+100 do
 begin
 x:=i;y:=j;
 z:=x*x+y*y;
 szin:=z;
 if szin=0 then szin:=1;
 xpont(x,y);
 end;
 end;
{ k:=k+15;}
 szin:=k;
 k:=k+1;
 for i:=xx-1 to xx+101 do
 xpont(i,yy-1);
 for i:=xx-1 to xx+101 do
 xpont(i,yy+101);
 for i:=yy-1 to yy+101 do
 xpont(xx-1,i);
 for i:=yy-1 to yy+101 do
 xpont(xx+101,i);

 until keypressed;
 readkey;
  setintvec($1c,@old);
 vmode($03);
end.