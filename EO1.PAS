uses crt,dos,dsp,vga;
Type dat = array[1..20000] of byte;
     fox = array[1..20000] of shortint ;
var
    i,j,k,l:longint;
    old:procedure;
    time:longint;
    p,d:^dat ;
    t: fox ;
    ch:char;



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
new(p);
new(d);

clrscr;
Writeln('Press a key to goo!');
Readkey;
 for i:=1 to 20000 do
 Begin
  for k:=1 to 100 do begin end;
  p^[i]:=readdac;
 End;
 sound(5000);
 delay(100);
 nosound;
 playback(p,20000,22000);
vmode($13);
 readkey;
 j:=10;
 repeat
 for i:=1 to 20000 do d^[i]:=127;

 for i:=1 to 20000 do
 d^[i]:=(p^[i]+127+round(50*sin(i*pi/40))) div 2;

 szin:=white;
 for i:=1 to 320 do
 xpont(i,d^[i]);



 playback(d,20000,11000);

 ch:=readkey;
 for i:=0 to 64000 do mem[$a000:i]:=0;
 j:=j+1000;
 until ch=#27;

dispose(p);
dispose(d);
end.


