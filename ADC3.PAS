uses crt,dsp,vga;
var m,i,j,k,l:longint;
   z:integer;
   ch:char;
    c,b:array[0..1320] of byte;
    p:pointer;
    f:file;
    a:array[1..10000] of byte;
    sp:integer;
label vege;
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
k:=0;
m:=0;
resetdsp(2);
delay(100);
speakeron;
p:=ptr($a000,0);
setmixerreg($220,$0c,4*0+2*0+  32*0+16*0+8*0);
setmixerreg($220,$22,255);
setmixerreg($220,$04,16*8+8);
SETMIXERREG($220,$2e,15);
i:=0;
k:=0;
vmode($13);
szin:=white;
repeat
szin:=white;
writedac(b[i]);
xpont(k,b[i] div 2);
szin:=black;
xpont(k,50+b[i] div 2);

b[i]:=readdac;
szin:=black;
xpont(k,50+b[i] div 2);
if (b[i]>120) and (b[i]<130) then b[i]:=127;
inc(i);
inc(k);
if i>4020 then i:=0;
{for j:=0 to 1000 do begin end;}
if k>320 then k:=0;
until keypressed;
readkey;
end.


