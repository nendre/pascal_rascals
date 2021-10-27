uses crt,dos,dsp;
var
    i,j,k,l:integer;
    old:procedure;
    time:longint;

Procedure mmx;
interrupt;
var a,b,c,d:word;
   ttime:longint;
Begin
i:=i+1;
if i>1 then
Begin
i:=0;
{ gettime(a,b,c,d);
 ttime:=d+c*100+b*6000+a*360000;}
{ if (time-ttime)>1 then}
 Begin
   gotoxy(1,1);
  if readdac>123 then
  Begin
   writeln('C');
   sound(5000);
   delay(100);
   nosound;
  End else writeln(' ');
 End;
 end;
 time:=ttime;
 inline($9c);
 old;
end;

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

getintvec($1c,@old);
setintvec($1c,@mmx);
keep(0);

end.


