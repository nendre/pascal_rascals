{ ------------------------------------------------ }
{ PROGRAM FOR VIEW LINE IN - AUDIO DATA IN OSCILLOSCOPE }
{ ------------------------------------------------ }

uses crt,vga,dsp;

{------------}
{ Variables  }
{------------}

var  linecont  :integer;
     i,j       :integer;
     buffer    :array[0..800] of byte;
     rgb       :integer;

{--------------------------}
{ Functions and Procedures }
{--------------------------}

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
  vmode($5e);
  resetdsp(2);
  speakeron;
  setmixerreg($220,$0c,255)     ; {Input Source and Filter}
  setmixerreg($220,$22,255)   ; {Master volume          }
  setmixerreg($220,$04,0)     ; {Voice volume           }
  setmixerreg($220,$2e,255)     ; {Line volume            }
  setmixerreg($220,$28,0)   ; {CD volume              }
  for i:=0 to 255 do            {Palette initialisation }
  szinbeallit(i,i div 4,i div 4,i div 4);
  linecont:=200;

  szin:=100;
  For i:=0 to maxx do
  for j:=0 to 20 do
  pont(i,j);
  rgb:=0;
{------}
{Ciklus}
{------}
repeat
  szin:=0;
  pont(linecont,200+buffer[linecont]);    {Toroljuk }
  buffer[linecont]:=readdac;              {Read data}
  szin:=255;
  pont(linecont,200+buffer[linecont]);    {Irjuk    }
  inc(linecont);
  if linecont>598 then
   Begin
    linecont:=200;
    if rgb>1 then dec(rgb,2);
   End;
   szinbeallit(100,rgb,rgb,rgb);
   if abs(buffer[linecont]-127)>80 then rgb:=60;
until keypressed;
readkey;
  {------}
  {Ending}
  {------}
  speakeroff;
  vmode($03);
end.


