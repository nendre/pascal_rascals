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
  setmixerreg($220,$0c,0)     ; {Input Source and Filter}
  setmixerreg($220,$22,255)   ; {Master volume          }
  setmixerreg($220,$04,0)     ; {Voice volume           }
  setmixerreg($220,$2e,255)     ; {Line volume            }
  setmixerreg($220,$28,0)   ; {CD volume              }
  for i:=0 to 255 do            {Palette initialisation }
  szinbeallit(i,i div 4,i div 4,i div 4);
  linecont:=200;
{  Getintvec($1c,@old);
  Setintvec($1c,@Getit);}
Repeat
{ Reading input data }
for i:=0 to 200 do
Begin
 for k:=0 to 100 do
 Begin
 End;
 buffer[i]:=readdac;
end;
{initialising}
for i:=0 to 255 do
Begin
pos[i].frek:=0;
pos[i].amp:=0;
pos[i].camp:=255;
pos[i].cfrek:=200;
end;
for i:=0 to 50 do
frektab[i]:=0;
for i:=0 to 200 do
buffer[i]:=abs(buffer[i]-122);
if buffer[0]>=buffer[1] then j:=-1 else j:=1;

for i:=1 to 200 do
Begin
sig[i]:=0;
if (buffer[i]>buffer[i-1]) and (j=-1) then Begin j:=1;sig[i-1]:=1;end;
if (buffer[i]<buffer[i-1]) and (j=1) then Begin j:=-1;sig[i-1]:=2;end;
End;
{Calculating}
for i:=1 to 199 do
Begin
 k:=(buffer[i]);
 l:=(buffer[i-1]);
 delta:=k-l;
 l:=(buffer[i+1]);
 if sig[i]=1 then
   for j:=0 to k do
   Begin
    pos[j].amp:=k-j;
    pos[j].camp:=pos[j].amp;
   End;
 if sig[i]=1 then
 Begin
 frektab[pos[k].frek]:=(pos[k].amp+frektab[pos[k].frek]) div 2;
 pos[k].frek:=0;
 pos[k].amp:=0;
 pos[k].camp:=255;
 pos[k].cfrek:=200;
 End;
{ pos[k].cfrek:=1;}
 for j:=0 to k do
 Begin
  if  delta<>0  then inc(pos[j].frek);
  if (pos[j].amp<pos[j].camp) and (delta>0) then pos[j].amp:=pos[j].amp+abs(delta);
 End;
 for j:=k+1 to 255 do
 Begin
 pos[j].frek:=0;
 pos[j].amp:=0;
 pos[j].camp:=255;
 End;
End;
{Drawing}
szin:=0;
for i:=0 to 50 do
for j:=0 to 100 do
xpont(i*2,199-j);
szin:=255;
for i:=0 to 50 do
if frektab[i]>50 then frektab[i]:=50;

for i:=3 to 50 do
for j:=0 to frektab[i]  do
xpont(i*2,199-j);
Until Keypressed;


readkey;
  {------}
  {Ending}
  {------}
{  Setintvec($1c,@Old);}
  speakeroff;
  vmode($03);
end.


