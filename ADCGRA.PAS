uses crt,dsp,vga;
type rrr=array[1..200,1..200] of shortint;
var
    i,j,k,l:longint;
    c:array[0..200] of byte;
    t:rrr;
{    sint:array[1..40000] of byte;}
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
resetdsp(2);
speakeron;
setmixerreg($220,$0c,0);
setmixerreg($220,$22,255);
setmixerreg($220,$04,255);
  setmixerreg($220,$2e,255)     ; {Line volume            }
  setmixerreg($220,$28,0)   ; {CD volume              }

i:=0;
k:=0;
vmode($13);
{repeat
 for i:=0 to 200 do
 Begin
 c[i]:=readdac;
  for k:=0 to 200 do begin end;
 End;
}
 for i:=0 to 200 do
 c[i]:=127+round(50*sin(i*pi/20+i div 10));

 for i:=1 to 200 do
 for k:=1 to 200-i do
 t[i,k]:=(c[k]-c[k+i]) div 2;


{ for i:=1 to 50 do
 Begin
 for k:=1 to 100-i do
 l:=l+t[i,k];
 t[i,1]:=l div ((100-i)*2);
 end;
}
szin:=white;
repeat
for i:=1 to 200 do
Begin
for j:=1 to 200-i do
 xpont(j*200 div (200-i),100+t[i,j]);
for j:=1 to 200 do
 xpont(j,c[j]-27);
{readkey;}
for l:=0 to 64000 do mem[$a000:l]:=0;
end;
until keypressed;
readkey;
vmode($03);

end.


