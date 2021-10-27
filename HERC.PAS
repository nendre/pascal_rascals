{ ------------------------------------------------ }
{ PROGRAM FOR VIEW LINE IN - AUDIO DATA IN OSCILLOSCOPE }
{ ------------------------------------------------ }

uses crt,dsp,dos,graph;

{------------}
{ Variables  }
{------------}
Type data = record
            frek,cfrek,amp,camp:integer ;
            End;
var  linecont  :integer;
     gd,gm,delta,i,j,k,l     :integer;
     buffer    :array[0..1000] of byte;
     rgb       :integer;
     Old       : Procedure;
     ok:boolean;
     pos:array[0..255] of data;
     FrekTab:array[1..1000] of integer;
     Sig:array[0..1000] of byte;

var      a,b,c,v     : byte;

{--------------------------}
{ Functions and Procedures }
{--------------------------}

Procedure Getit;interrupt;
var      a,b,c     : byte;
         i,j:longint;
Begin
a:=readdac;
a:=abs(a-122);
if a=0 then
 Begin
  {If i>1 then} ok:=true ;
  i:=0;
 End
 else
 i:=i+a;
{for j:=0 to 150 do begin end;}
inline($9c);
Old;
End;



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

{----------------}
{  Main Program  }
{----------------}

begin
 {--------------}
 {Initialisation}
 {--------------}
  resetdsp(2);
  speakeron;
  setmixerreg($220,$0c,255)     ; {Input Source and Filter}
  setmixerreg($220,$22,255)   ; {Master volume          }
  setmixerreg($220,$04,0)     ; {Voice volume           }
  setmixerreg($220,$2e,255)     ; {Line volume            }
  setmixerreg($220,$28,0)   ; {CD volume              }
  linecont:=200;
{  Getintvec($1c,@old);
  Setintvec($1c,@Getit);}
 i:=00;
gd:=detect;
initgraph(gd,gm,'d:\bp\bgi');
Repeat
putpixel(i*2,buffer[i],black);
buffer[i]:=readdac;
putpixel(i*2,buffer[i],white);
i:=i+1;
if i>360 then i:=0;
Until Keypressed;


readkey;
closegraph;
  {------}
  {Ending}
  {------}
{  Setintvec($1c,@Old);}
  speakeroff;
end.


