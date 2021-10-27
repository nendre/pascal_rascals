uses crt,graph,dsp;
type a=array[1..30000] of byte;
var i,j,k,gd,gm:integer;
    b:array[0..320] of byte;
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
repeat
putpixel(k,b[k],black);
b[k]:=b[k];
putpixel(k,b[k],white);
k:=k+1;
if k>310 then k:=0;

until keypressed;
readkey;
speakeroff;

closegraph;
end.


