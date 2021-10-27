uses crt,dsp;
type rrr=array[0..1320] of byte;
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
  setmixerreg($220,$2e,0)     ; {Line volume            }
  setmixerreg($220,$28,255)   ; {CD volume              }
   setmixerreg($220,$0a,255)   ; {Mic volume              }

i:=0;
k:=0;
k:=100;
repeat
k:=random(100);
  setmixerreg($220,$2e,255)     ; {Line volume            }
  setmixerreg($220,$28,0)   ; {CD volume              }
  delay(k);
    setmixerreg($220,$28,255)   ; {CD volume              }
  setmixerreg($220,$2e,0)     ; {Line volume            }
  delay(k);

until keypressed;
readkey;
dispose(c);
dispose(b);

end.


