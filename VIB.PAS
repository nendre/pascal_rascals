uses crt,graph,dsp;
type a=array[1..30000] of byte;
var i,j,k,gd,gm:integer;
   m,n:longint;
    b:array[0..320] of byte;
    ch:char;
    p:^a;
    f:file;
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

begin
gd:=installuserdriver('svga256',nil);
gm:=0;
initgraph(gd,gm,'d:\pascal\bgi');
cleardevice;
k:=0;
resetdsp(2);
delay(100);
speakeron;
p:=ptr($a000,0);
setmixerreg($220,$0c,4*0+2*0+  32*0+16*0+8*0);
setmixerreg($220,$22,255);
setmixerreg($220,$04,16*8+8);
SETMIXERREG($220,$2e,0);
n:=10;
repeat
ch:='a';

if keypressed then ch:=readkey;
if ch='1' then n:=n+10 else if (n>0) and (ch='2') then n:=n-100;
if ch='5' then n:=n+1000 else if (n>0) and (ch='6') then n:=n-1000;
if ch='3' then n:=n+100 else if (n>0) and (ch='4')
 then n:=n-100;
setmixerreg($220,$2e,250);
for m:=1 to n do begin end;
setmixerreg($220,$2e,0);
for m:=1 to n do begin end;
until ch=' ';
readkey;
speakeroff;

closegraph;
end.


