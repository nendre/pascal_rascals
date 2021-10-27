uses crt,vga,dsp;
var m,i,j,k,gd,gm:integer;
   ch:char;
   w:word;
    b:array[0..11120] of byte;
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
for i:=0 to 550 do
sint[i]:=round(60*sin(i*pi/180*100));
for i:=50 to 1000 do sint[i]:=0;
szin:=white;
k:=0;
repeat
k:=k+1;
if k>15 then k:=0;
for w:=0 to 64000 do
mem[$a000:w]:=0;
if k=1 then
for i:=1 to 550 do
begin
 writedac(sint[i]);
 for j:=1 to 1000 do begin end;
end;

for i:=1 to 320 do
begin
delay(1);
b[1]:=readdac;
xpont(i,100-b[1] div 1);
end;
{readkey;}
until keypressed;
readkey;
speakeroff;
vmode($03);
end.


