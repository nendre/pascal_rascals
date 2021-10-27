{------------------}
{ SB - DMA . . .   }
{------------------}


uses crt,dos,dsp,vga;

Type a = array[1..60000] of byte;

var old:procedure;
      p:^a;
   cont:integer;
      f:file;
    oldint:byte;
    soundend:boolean;

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



Procedure Play;
interrupt;
var test:byte;
begin
 test:=port[$22E];
 if cont>1 then
    Begin
     cont:=cont-1;
     playback(p,15000,11000);
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

BEGIN
{----------------}
{ Initialisation }
{----------------}
 resetdsp(2);
 speakeron;
 getintvec($0D,@old);
 setintvec($0D,@Play);
 cont:=5;
 new(p);
 soundend:=false;
 {Load DATA}

 assign(f,'C:\FIRST.wav');
 reset(f,1);
 blockread(f,p^,15000);
 close(f);

 { Start Playing }

 Playback(p,15000,11000);
 oldint:=port[$21];
 port[$21]:=oldint and (1 shl $0d);

 vmode($13);
  repeat
    szin:=random(255);
   xpont(random(320),random(200));
  until keypressed;
 vmode($03);
 readkey;
 repeat until soundend;
 {------}
 {Ending}
 {------}
 dispose(p);
 speakeroff;
 setintvec($0D,@old);
END.