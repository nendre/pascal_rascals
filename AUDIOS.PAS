uses crt,dsp;
var a:byte;
   i:integer;
   b:array[1..50000] of byte;

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


BEGIN
 resetdsp(2);
  speakerON;
 setmixerreg($220,$0a,0);

 i:=1;
 repeat
 writedac(b[i]);
 b[i]:=readdac;
 i:=i+1;
 if i>5000 then i:=1;
 until keypressed;
 readkey;
 speakeroff;

END.