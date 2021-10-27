uses crt,vga,dos;
var i,j,k:integer;
  f,v:integer;
  sig:integer;
   x,y:integer;
   b:array[1..2,0..400] of integer;
   si,co:array[0..1000] of real;
   old:procedure;

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

begin
 sig:=4;
 v:=4;
 f:=31;
 for i:=0 to 1000 do
 begin
  si[i]:=sin(i*pi/180);
  co[i]:=cos(i*pi/180);
 end;
 vmode($13);
  getintvec($1c,@old);
 setintvec($1c,@paletteanim);

 for i:=0 to 255 do
 szinbeallit(i,i div 4,i div 4,i div 4);
 k:=1;
 j:=1;
 k:=1;
 for x:=5 to 1 do
 begin
 for i:=0 to 319 do
 begin
  szin:=k;
  k:=k+1;
  xpont(i,x);
 end;
 for i:=0 to 199 do
 begin
  szin:=k;
  k:=k+1;
  xpont(319-x,i);
 end;
 for i:=320 downto 0 do
 begin
  szin:=k;
  k:=k+1;
  xpont(i,199-x);
 end;
end;
 k:=1;
 for x:=0 to -1 do
 begin
 k:=x*x;
 for i:=0 to 319 do
 begin
  szin:=k*k;
  k:=k-1;
  xpont(i,x);
 end;
 for i:=0 to 199 do
 begin
  szin:=k*k;
  k:=k-1;
  xpont(319-x,i);
 end;
 for i:=320 downto 0 do
 begin
  szin:=k*k;
  k:=k-1;
  xpont(i,199-x);
 end;

 for i:=199 downto 0 do
 begin
  szin:=k*k;
  k:=k-1;
  xpont(x,i);
 end;
end;
k:=1;
repeat
 for i:=0 to 360 do
 begin;
  x:=round(50*co[i]+(20+j)*cos(i*pi/k));
  y:=round(50*si[i]+(20+j)*cos(i*pi/k));
  szin:=0;
  xpont(100+b[1,i],100+b[2,i]);
  xpont(b[1,i]+100,100-b[2,i]);
  xpont(200-b[1,i],b[2,i]+100);
  xpont(200-b[1,i],100-b[2,i]);

  szin:=i;
  xpont(x+100,y+100);
  xpont(x+100,100-y);
  xpont(200-x,y+100);
  xpont(200-x,100-y);
  b[1,i]:=x;
  b[2,i]:=y;


 end;
 k:=k+1;
 if k>100 then begin k:=1;j:=j+5;end;
 if j>30 then j:=1;
 f:=f+sig;
 if ((f>40) or (f<14)) then  sig:=-sig;
 v:=1;
 i:=random(5);
 v:=2
 until keypressed;

 readkey;
 setintvec($1c,@old);
 vmode($03);
end.