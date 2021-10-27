{ ------------------------------------------------ }
{ PROGRAM FOR VIEW LINE IN - AUDIO DATA IN OSCILLOSCOPE }
{ ------------------------------------------------ }

uses crt,vga,dsp;

{------------}
{ Variables  }
{------------}

var  linecont  :integer;
     k,i,j       :integer;
     buffer    :array[0..800] of byte;
     rgb       :integer;
     mm:shortint;

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

{------}
{Ciklus}
{------}
k:=0;
repeat
  szin:=0;
  pont(linecont,200+buffer[linecont]);
  buffer[linecont]:=readdac;
  mm:=buffer[linecont]-128;
  szin:=0;
  for i:=0 to 100 do pont(k,600-i);
  szin:=-abs(mm)*2;
  j:=mm div 10;
  delay(5);

  for i:=0 to abs(mm) do
  Begin
  pont(k,600-i);
  szin:=2*(abs(mm)-i);
  end;
  pont(linecont,200+buffer[linecont]);
  inc(linecont);
  if linecont>598 then
   Begin
    linecont:=200;
   End;
   k:=k+1;
   if k>790 then k:=0;
until keypressed;
readkey;

  {------}
  {Ending}
  {------}
  speakeroff;
  vmode($03);
end.


