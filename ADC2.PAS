uses crt,vga,dsp;
var m,i,j,k,gd,gm:integer;
w:word;
   ch:char;
   d:shortint;
    b:array[0..320] of byte;
    p:pointer;
    f:file;
    sint:array[0..1000] of integer;
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

procedure cr(m:integer);
begin
for i:=0 to 1000 do
sint[i]:=round(15*sin(i*pi/m));
end;
begin
vmode($13);
k:=0;
m:=0;
resetdsp(2);
delay(100);
speakeron;
p:=ptr($a000,0);
setmixerreg($220,$0c,4*0+2*0+  32*0+16*0+8*0);
setmixerreg($220,$22,255);
setmixerreg($220,$04,16*8+8);
SETMIXERREG($220,$2e,0);
for i:=0 to 1000 do
sint[i]:=round(60*sin(i*pi/180));
m:=0;
for i:=0 to 255 do
szinbeallit(i,i div 4,i div 4,i div 4);
repeat
{szin:=black;
xpont(k,b[k]);
b[k]:=b[k];
b[k]:=readdac;
szin:=white;
xpont(k,b[k+m]);
ch:=' ';
}
m:=m+1;
szin:=0;
for i:=0 to 320 do
for j:=0 to 200 do
xpont(i,j);

d:=readdac-128;
  if d<0 then
           begin
           d:=abs(d);
           for j:=100-d to 100 do
           begin
           szin:=d+j;
           xpont(m,j);
           end;
           end
          else
           begin
           d:=abs(d);
           for j:=100 to 100+d do
           begin
           szin:=d+j;
           xpont(m,j);
           end;
           end;

m:=m+1;
if m>320 then m:=0;

until keypressed;
readkey;
speakeroff;
vmode($03);
end.


