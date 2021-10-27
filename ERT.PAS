uses crt,dsp;
var m,i,j,k,l:longint;
   z:integer;
   ch:char;
    b:array[0..320] of byte;
    p:pointer;
    f:file;
    a:array[1..20000] of byte;
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
SETMIXERREG($220,$2e,0);

assign(f,'chimes.wav');
reset(f,1);
j:=filesize(f);
blockread(f,a,j);
close(f);
p:=addr(a);

playback(p,15000,1000);

end.


