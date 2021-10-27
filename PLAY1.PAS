{------------------}
{ SB - DMA . . .   }
{------------------}


uses crt,dos,dsp,vga;

Type a = array[1..10000] of byte;

var old :procedure;
    old1:procedure;
    sig :integer;
    zz,v:byte;
    p,o :^a;
    t   :pointer;
    cont:integer;
    f   :file;
    oldint:byte;
    soundend:boolean;
    i,j,k:longint;
    test:byte;

{--------------------------}
{ Functions and Procedures }
{--------------------------}



{ GRAPHICS SECTION }

Procedure Graphics;
var i,j,k:integer;
    x,y:integer;
    b:array[1..2,0..400] of integer;
    si,co:array[0..1000] of real;
    old:procedure;


begin
 sig:=4;
 v  :=4;
 zz :=31;

 {Sinus table}
 for i:=0 to 1000 do
 begin
  si[i]:=sin(i*pi/180);
  co[i]:=cos(i*pi/180);
 end;

 {Graph init }
 k:=1;j:=1;k:=1;

 for x:=5 to 1 do
 begin
 for i:=0 to 319 do
 begin
  szin:=k;
  k:=k+1;
  xpont(i,x);
 end;
 for i:=0 to 199 do
 begin
  szin:=k;
  k:=k+1;
  xpont(319-x,i);
 end;
 for i:=320 downto 0 do
 begin
  szin:=k;
  k:=k+1;
  xpont(i,199-x);
 end;
end;
 k:=1;
 for x:=0 to -1 do
 begin
 k:=x*x;
 for i:=0 to 319 do
 begin
  szin:=k*k;
  k:=k-1;
  xpont(i,x);
 end;
 for i:=0 to 199 do
 begin
  szin:=k*k;
  k:=k-1;
  xpont(319-x,i);
 end;
 for i:=320 downto 0 do
 begin
  szin:=k*k;
  k:=k-1;
  xpont(i,199-x);
 end;

 for i:=199 downto 0 do
 begin
  szin:=k*k;
  k:=k-1;
  xpont(x,i);
 end;
end;
 k:=1;
 {Graph loop}

repeat
 for i:=0 to 360 do
 begin;
  x:=round(50*co[i]+(20+j)*cos(i*pi/k));
  y:=round(50*si[i]+(20+j)*cos(i*pi/k));
  szin:=0;
  xpont(100+b[1,i],100+b[2,i]);
  xpont(b[1,i]+100,100-b[2,i]);
  xpont(200-b[1,i],b[2,i]+100);
  xpont(200-b[1,i],100-b[2,i]);

  szin:=i;
  xpont(x+100,y+100);
  xpont(x+100,100-y);
  xpont(200-x,y+100);
  xpont(200-x,100-y);
  b[1,i]:=x;
  b[2,i]:=y;


 end;
 k:=k+1;
 if k>100 then begin k:=1;j:=j+5;end;
 if j>30 then j:=1;
 zz:=zz+sig;
 if ((zz>40) or (zz<14)) then  sig:=-sig;
 v:=1;
 i:=random(5);
 v:=2
 until keypressed;

 readkey;
end;


procedure paletteanim;
interrupt;
var i:integer;
k:integer;
z,b:byte;
procedure delayed;
assembler;
asm
 mov dx,3daH
 @a1:
 in al,dx
 test al,8
 jne @a1
 mov dx,3daH
 @a2:
 in al,dx
 test al,8
 je @a2

end;
begin

 delayed;
 for i:=0 to 127 do
 begin
 b:=i+z;
 if b<>0 then
 szinbeallit(b,i div v,i div (v+1),i div (v+2));
 end;
  delayed;
  for i:=0 to 127 do
  begin
  b:=256-i+z;
 if b<>0 then
 szinbeallit(b,i div v,i div (v+1),i div (v+2));
 end;
 z:=z+zz;
inline($9c);
end;




{SOUND SECTION}

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
     t:=p;
     p:=o;
     o:=t;
     cont:=cont-1;
     playback(p,10000,11000);
     blockread(f,o^,10000);
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
 new(p);
 new(o);
 soundend:=false;
 {Load DATA}

 assigN(f,'c:\first.iff');
 reset(f,1);
 blockread(f,p^,10000);
 j:=filesize(f);
 cont:=j div 10000;
 cont:=cont-1;
 { Start Playing }

 Playback(p,10000,11000);
 oldint:=port[$21];
 port[$21]:=oldint and (1 shl $0d);
 blockread(f,o^,10000);

 {GRAPHICS}
 v:=1;zz:=1;sig:=1;
 vmode($13);
 getintvec($1c,@old1);
 setintvec($1c,@paletteanim);
 graphics;
 setintvec($1c,@old1);
 vmode($03);
 {GR - END}
 {------}
 {Ending}
 {------}
 if not soundend then
   begin
      DmaStop;
     test:=port[$21];                   { Read sb ack }
     if (oldint and (1 shl $0d))<>0 then
          test:=test or (1 shl $0d)
          else
          test:=test and (1 shl $0d);

     port[$21]:=test;                    { Write interrupt port }
     soundend:=true;
    End;


 dispose(p);
 dispose(o);
 speakeroff;
 setintvec($0D,@old);
END.