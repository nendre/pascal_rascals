uses crt,vga,dsp,dos ;
Var m,i,j,k:integer ;
   si,co:array[0..5000] of real ;
     f,v:integer;
   b : array[1..3,0..360] of integer ;
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


procedure SetMixerReg(base : word; index, value : byte);
begin
  Port[base + 4] := index;
  Port[base + 5] := value;
end;



function GetMixerReg(base : word; index : byte) : byte;
begin
  Port[base + 4] := index;
  GetMixerReg := Port[base + 5];
end;
Procedure Delayed;
assembler;
asm
 mov dx,3daH
@a1:
 in al,dx
 test al,8
 je @a1
@a2:
 in al,dx
 test al,8
 jne @a2
end;
Begin
resetdsp(2);
delay(100);
speakeron;
setmixerreg($220,$0c,4*0+2*0+  32*0+16*1+8*1);
setmixerreg($220,$0c,255);
setmixerreg($220,$22,255);
setmixerreg($220,$04,16*8+8);
SETMIXERREG($220,$2e,255);
  v:=2;
  vmode($13);
    getintvec($1c,@old);
{ setintvec($1c,@paletteanim);}

  for i:=0 to 5000 do
  begin si[i]:=sin(i*pi/180);co[i]:=cos(i*pi/180);end;
  m:=0;
  for i:=0 to 255 do
  szinbeallit(i,i div 4,i div 4,i div 4);
  f:=29;
{  for j:=0 to 100 do
  begin
    szin:=j*2;
  for i:=0 to 360*2 do
  begin
  xpont(round(160+j*sin(i*pi/360)),round(100+j*cos(i*pi/360)));
  end;
  end;}
  i:=0;
  v:=3;
  Repeat
      szin:=0;
      xpont(b[1,i],b[2,i]);
      xpont(320-b[1,i],b[2,i]);
      xpont(b[1,i],200-b[2,i]);
      xpont(320-b[1,i],200-b[2,i]);
      k:=readdac;
      k:=abs(k-127);
      szin:=(k+b[2,i]) div 1;
      xpont(b[2,i],k);
      xpont(b[2,i],200-k);
      xpont(320-b[2,i],k);
      xpont(320-b[2,i],200-k);

      b[1,i]:=b[2,i];
      b[2,i]:=k;
      i:=i+1;
      if i>200 then i:=0;



  Until keypressed ;
  Readkey;
   setintvec($1c,@old);
  vmode($03);

End.
