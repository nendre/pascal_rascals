{ ------------------------------------------------ }
{ PROGRAM FOR VIEW LINE IN - AUDIO DATA IN OSCILLOSCOPE }
{ ------------------------------------------------ }

uses crt,vga,dsp,dos;

{------------}
{ Variables  }
{------------}
Type data = record
            frek,cfrek,amp,camp:integer ;
            End;
var  linecont  :integer;
     delta,i,j,k,l     :integer;
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


Procedure Box(c:byte);
Var i,j:integer;
Begin
 szin:=c;
 for i:=0 to 10 do
 for j:=0 to 10 do
 xpont(155+i,95+j);
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
  vmode($13);
  resetdsp(2);
  speakeron;
  setmixerreg($220,$0c,0+0+0+0+8+4+0+0)     ; {Input Source and Filter}
  setmixerreg($220,$22,255)   ; {Master volume          }
  setmixerreg($220,$04,0)     ; {Voice volume           }
  setmixerreg($220,$2e,255)     ; {Line volume            }
  setmixerreg($220,$28,0)   ; {CD volume              }
  for i:=0 to 255 do            {Palette initialisation }
  szinbeallit(i,i div 4,i div 4,i div 4);
  linecont:=200;
{  Getintvec($1c,@old);
  Setintvec($1c,@Getit);}
l:=0;j:=0;
Repeat
repeat
l:=readdac;
for k:=0 to 100 do
 Begin
 end;
 k:=readdac;
 for k:=0 to 100 do
 Begin
 end;

until ((k<122) and (l>=122) or (k<=122) and (l>122));
for i:=0 to 320 do
Begin
szin:=0;
xpont(i,buffer[i]);
buffer[i]:=readdac;
for k:=0 to 100 do
 Begin
 end;
 szin:=255;
xpont(i,buffer[i]);
xpont(i,122);
end;

until keypressed;

readkey;
  {------}
  {Ending}
  {------}
{  Setintvec($1c,@Old);}
  speakeroff;
  vmode($03);
end.


