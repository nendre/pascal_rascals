uses crt,dsp;
type rrr=array[0..60020] of byte;
var m,i,j,k,l:longint;
   z:integer;
   ch:char;
    c,b:^rrr;
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
new(c);
new(b);
k:=0;
m:=0;
resetdsp(2);
delay(100);
speakeron;
setmixerreg($220,$0c,0);
setmixerreg($220,$22,255);
setmixerreg($220,$04,255);
  setmixerreg($220,$2e,255)     ; {Line volume            }
  setmixerreg($220,$28,0)   ; {CD volume              }

i:=0;
k:=0;
if paramcount<1 then halt;
assign(f,paramstr(1));
reset(f,1);
k:=filesize(f);
if k>30000 then k:=30000;
if k=0 then halt;
blockread(f,c^,k);
close(f);
for i:=1 to k do
Begin
 c^[i]:=c^[i]-128;
End;
playback(c,k,22000);
readkey;
dispose(c);
dispose(b);

end.


