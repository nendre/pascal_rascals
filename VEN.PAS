uses crt,dsp;
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
setmixerreg($220,$0c,0);
setmixerreg($220,$22,255);
setmixerreg($220,$04,16*8+8);
SETMIXERREG($220,$2e,15*5+5);
i:=0;
k:=0;
repeat
{writedac(b[i]);

b[i]:=b[i]+readdac;
if (b[i]>120) and (b[i]<130) then b[i]:=127;
inc(i);
inc(k);
if i>1020 then i:=0;
if k>320 then k:=0;}
for i:=1 to 370 do
begin
 b[i]:=readdac;
 for k:=1 to 200 do begin end;
 writedac(b[i]);
 for k:=1 to 200 do begin end;
 writedac(b[i]);
 for k:=1 to 200 do begin end;
 writedac(b[i]);
 for k:=1 to 200 do begin end;
End;
{for i:=1 to 370 do
begin
 writedac(b[i]);
 for k:=1 to 110 do begin end;
End;
}
until keypressed;
readkey;
end.


