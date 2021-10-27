uses crt,vga,dsp;
var m,i,j,k,gd,gm:integer;
   ch:char;
    b:array[0..320] of byte;
    p:pointer;
    f:file;
    sint:array[0..1000] of byte;
    fik:integer;
    mm:boolean;
    zz:longint;
    akt:integer;
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
procedure box(c:integer);
var i,j:integer;
begin
szin:=c;
for i:=0 to 10 do
for j:=0 to 10 do
xpont(i,j);
end;


procedure cr(m:integer);
begin
for i:=0 to 1000 do
sint[i]:=round(15*sin(i*pi/m));
end;
begin
vmode($13);
k:=0;
m:=0;
resetdsp(2);
delay(100);
speakeron;
p:=ptr($a000,0);
setmixerreg($220,$0c,4*1+2*1+  32*1+16*1+8*1);
setmixerreg($220,$22,255);
setmixerreg($220,$04,16*8+8);
SETMIXERREG($220,$2e,255);
for i:=0 to 1000 do
sint[i]:=round(15*sin(i*pi/660));
for i:=1 to 255 do
szinbeallit(i,i div 4,i div 4,i div 4);
akt:=0;
fik:=0;
mm:=false;
zz:=0;
repeat
szin:=0;
xpont(k,b[k]);
writedac(b[k]);
{for j:=1 to 500 do begin end;}
b[k]:=readdac;
if ((b[k]-127)>0) then
begin
inc(fik);
zz:=zz+b[k]-127;
end
 else begin fik:=0;zz:=0;end;
if ((akt<>0)) then dec(akt);
if (zz>200) then begin mm:=true;end else mm:=false;
if mm then akt:=255;
szin:=255;

xpont(k,b[k]);
ch:=' ';
if keypressed then ch:=readkey;
if ch='1' then begin m:=m+1;cr(m);end;

k:=k+1;
if k>310 then k:=0;

until ch='4';
readkey;
speakeroff;
vmode($03);
end.


