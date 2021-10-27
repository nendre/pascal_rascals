uses crt,vga,bmp,xms,dos;
type a = array[1..64000] of byte;
var p:array[1..6] of ^a;
    p1:^a;
    sig:integer;
    f:integer;
    i,j,k:integer;
    s:string;
   hnd,y,x:word;
   poz:longint;
   v:integer;
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
v:=2;
if xmsinstalled then
begin
enableaddra20;
enabledataa20;
allocextmem(1024,hnd);
end else halt;
 f:=0;
 v:=10;
 p1:=ptr($a000,0);
 vmode($13);
   getintvec($1c,@old);
 setintvec($1c,@paletteanim);

 poz:=0;
 for i:=1 to 9 do
 begin
 str(i,s);
 s:='rose'+s+'.bmp';
 bmpbetolt(s);
 writeextmem(p1^,64000,hnd,poz);
 poz:=poz+64000;
 end;
 v:=2;
 f:=5;
 sig:=2;

 repeat
 randomize;

 for j:=1 to 9 do
 begin
  i:=2;
  poz:=64000*4;
  begin
  poz:=i*64000;
  readextmem(64000,hnd,poz,p1^);
  end;
  delay(10);
  i:=0;
   begin
  poz:=i*64000;
  readextmem(64000,hnd,poz,p1^);
  end;
  delay(100);
end;
{ for i:=0 to 80 do
 begin
 poz:=i*8;
 readextmem(64000,hnd,poz,p1^);
 end;}
v:=1;
 v:=v+random(4);
 if f>10 then sig:=-sig;
 if f<2 then sig:=-sig;
 until keypressed;

 readkey;
  setintvec($1c,@old);
 vmode($03);
freeextmem(hnd);
end.
