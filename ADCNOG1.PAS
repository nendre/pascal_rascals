uses crt,dsp,dos;
type rrr=array[0..1320] of byte;
var m,i,j,k,l:longint;
   z:integer;
   ch:char;
    c,b:^rrr;
    p:^rrr;
    f:file;
    a:array[1..10000] of byte;
    sp:integer;
    var old:procedure;
   cont:integer;
    oldint:byte;
    soundend:boolean;

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


Procedure Play;
interrupt;
var test:byte;
begin
 test:=port[$22E];
 if cont>1 then
    Begin
{     cont:=cont-1;}
     playback(p,1000,11000);
    End
    else
    {-------------------------------------------}
    {Megallitja a DMA -t ; vege az interruptnak }
    {-------------------------------------------}
    Begin
     DmaStop;
     test:=port[$21];                   { Read sb ack }
     if (oldint and (1 shl $0d))<>0 then
          test:=test or (1 shl $0d)
          else
          test:=test and (1 shl $0d);

     port[$21]:=test;                    { Write interrupt port }
     soundend:=true;
    End;
 port[$20]:=$20;
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
setmixerreg($220,$04,16*8+8);
SETMIXERREG($220,$2e,15*5+5);
{ resetdsp(2);
 speakeron;}
{ getintvec($0D,@old);
 setintvec($0D,@Play);
 cont:=5;
 new(p);
 soundend:=false;
 for i:=0 to 1000 do p^[i]:=0;
 Playback(p,1000,11000);
 oldint:=port[$21];
 port[$21]:=oldint and (1 shl $0d);
}
i:=0;
k:=0;
readkey;
repeat
p^[i]:=i div 20;
i:=i+1;
if i>999 then Begin i:=0;j:=j+1;end;
for k:=1 to 100 do begin end;
until keypressed;
readkey;
dispose(c);
dispose(b);
 dispose(p);
 speakeroff;
 setintvec($0D,@old);

end.


