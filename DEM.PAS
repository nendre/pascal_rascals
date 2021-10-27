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

Procedure Demo;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++}
{  Constans,Types,Variables For the program           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++}

Const
   MaxRot     =  15 ;
   MaxLines   =  3 ;
   MaxPoints  =  MaxRot * MaxLines ;
   MaxFaces   =  2 * MaxRot * (MaxLines - 1) ;
   Mode320x200 = $13 ;
   Mode800x600 = $5E ;
   TextMode    = $03 ;

Type
   TBodyPix = Record
              r,y : Integer ;
              End;
   TPix2D = Record
            x,y,v,q : Integer ;
            End;
   TPix3D = Record
            x,y,z : Integer ;
            End;
   TFace = Record
            a,b,c : Integer ;
           End;
   TVertex   = Array[1..MaxRot,1..MaxLines] of TPix3D ;
   TProject  = Array[1..MaxRot,1..MaxLines] of TPix2D ;
   TFaces    = Array[1..MaxFaces] of TFace ;
   TBody     = Array[1..MaxLines] of TBodyPix ;
Var
  MaxF,MayF       : Integer   ;
  Dist,Cor        : Integer   ;
  i1,j1,k1,rnd,s1,s2,s3,I,J,K,A,B,C     : Integer   ;
  Vertex,
  TempVertex      : ^TVertex  ;
  Project,
  OldPro          : ^TProject ;
  Face            : ^TFace    ;
  Body            : ^TBody    ;
  co,si           : Array[0..360] Of Integer ;

{++++++++++++++++++++++++++++++++++++}
{  Procedures and functions          }
{++++++++++++++++++++++++++++++++++++}

{GENERATE BODY}
Procedure GenerateBody(x,y,sc,sy:integer);
Var i,Step:integer ;
Begin
 Step:=360 div MaxLines ;
 For i:=1 to MaxLines do
 Begin
  Body^[i].r :=x+(sc * si[i*step]) div 180 ;
  Body^[i].y :=y-(sy * co[i*step]) div 180 ;
 End;
End;

{GENERATE VERTEX}
Procedure GenerateVertex;
Var i,j,step:integer ;
Begin
 step:=360 div MaxRot ;
 For i:=1 to MaxRot do
 For j:=1 to MaxLines do
 Begin
  Vertex^[i,j].x :=Body^[j].r * Si[i*step] div 180 ;
  Vertex^[i,j].y :=Body^[j].y ;
  Vertex^[i,j].z :=Body^[j].r * Co[i*step] div 180 ;
{  Vertex^[i,j].x:=random(100);
  Vertex^[i,j].y:=random(100);
  Vertex^[i,j].z:=random(100);}
 End;
 TempVertex^ := Vertex^;
End;


{DRAWVERTEX}
Procedure DrawVertex ;
Var x,y,i,j : integer ;
Begin
 Szin := 255 ;
 For i:=1 to MaxRot do
 For j:=1 to MaxLines do
 Begin
 Szin:=100;
  x:=(OldPro^[i,j].x+Maxf);
  y:=(oldPro^[i,j].y+Mayf);

  pont(x,y);

  pont(x+1,y);
  pont(x+2,y);
  pont(x+3,y);

  pont(x,y+1);
  pont(x,y+2);
  pont(x,y+3);

  pont(x+4,y+1);
  pont(x+4,y+2);
  pont(x+4,y+3);

  pont(x+4,y+4);

  pont(x+3,y+4);
  pont(x+2,y+4);
  pont(x+1,y+4);

  {x:=200+(x-maxf) div 3;
  y:=150+(y-mayf) div 3;}
  szin:=100;
 x:=Oldpro^[i,j].v;
 y:=Oldpro^[i,j].q;
  pont(x,y);
  pont(800-x,y);
  pont(800-x,600-y);
  pont(x,600-y);
  x:=(Project^[i,j].x+MaxF);
  y:=(Project^[i,j].y+MaYf);
  szin:=200;
  pont(x,y);
  pont(x+1,y);
  pont(x+2,y);
  pont(x+3,y);

  pont(x,y+1);
  pont(x,y+2);
  pont(x,y+3);
{  szin:=0;}
  pont(x+4,y+1);
  pont(x+4,y+2);
  pont(x+4,y+3);

  pont(x+4,y+4);

  pont(x+3,y+4);
  pont(x+2,y+4);
  pont(x+1,y+4);
  oldpro^[i,j].x:=x-maxf;
  oldpro^[i,j].y:=y-mayf;
  x:=maxf+(100*si[rnd]) div 180 + (x-maxf) div 2;
  y:=mayf+(100*co[rnd]) div 180 + (y-mayf) div 2;
  pont(x,y);
  pont(800-x,y);
  pont(800-x,600-y);
  pont(x,600-y);
  Oldpro^[i,j].v:=x;
  OldPro^[i,j].q:=y;
 End;
{ OldPro^:=Project^;}
End;

{START}
Procedure Start ;
Var I:integer ;
Begin
 New(Vertex)                        ;
 New(TempVertex)                    ;
 New(Project)                       ;
 New(Face)                          ;
 New(Body)                          ;
 New(OldPro)                        ;
 Dist:=300 ;
 Cor :=  1 ;
 For i:=0 to 360 do
 Begin
  si[i]:=Round(180*sin(i*Pi/180)) ;
  co[i]:=Round(180*cos(i*Pi/180)) ;
 End;
 GenerateBody(100,1,50,50) ;
 GenerateVertex ;
 VMode(Mode800x600);
 For i:=0 to 255 do
  Szinbeallit(i,i div 4,i div 4,i div 4);
 MaxF:=Maxx div 2;
 MayF:=Maxy div 2;
End;

{FINISH}

Procedure Finish ;
Begin
 Vmode(TextMode)          ;
 Dispose(Vertex)          ;
 Dispose(TempVertex)      ;
 Dispose(Project)         ;
 Dispose(Face)            ;
 Dispose(Body)            ;
 Dispose(OldPro)          ;
End;

{REAL PROJECTING}

Procedure RealProjecting ;
Var I,J:integer;
Begin
 For i:=1 to MaxRot   do
 For j:=1 to MaxLines do
 Begin
  If (Dist + TempVertex^[i,j].z)<>0 then
  Begin
   Project^[i,j].x :=
          Round(TempVertex^[i,j].x * (1 + Cor / (Dist +TempVertex^[i,j].z)));
   Project^[i,j].y :=
          Round(TempVertex^[i,j].y * (1 + Cor / (Dist +TempVertex^[i,j].z)));
  End
  else
  Begin
   Project^[i,j].x:=30000;
   Project^[i,j].y:=30000;
  End;
 End;
End;

{ Rotate X axis }

Procedure Rotx(angle:integer);
var yt:longint;
    i,j:integer;
Begin
 For i:=1 to MaxRot do
 For j:=1 to MaxLines do
 Begin
 yt:=TempVertex^[i,j].y;
 TempVertex^[i,j].y := (yt * co[angle] + TempVertex^[i,j].z * si[angle]) div 180 ;
 TempVertex^[i,j].z := (TempVertex^[i,j].z * co[angle] - yt * si[angle]) div 180;
 End;
end;

{ Rotate Y axis }

Procedure Roty(angle:integer);
var zt:longint;
    i,j:integer;
begin
 For i:=1 to MaxRot do
 For j:=1 to MaxLines do
 Begin
 zt:=TempVertex^[i,j].z;
 TempVertex^[i,j].z := (zt * co[angle] + TempVertex^[i,j].x * si[angle]) div 180 ;
 TempVertex^[i,j].x := (TempVertex^[i,j].x * co[angle] - zt * si[angle]) div 180;
 End;
end;

{ Rotate Z axis }

Procedure Rotz(angle:integer);
var xt:longint;
    i,j:integer;
begin
 For i:=1 to MaxRot do
 For j:=1 to MaxLines do
 Begin
 xt:=TempVertex^[i,j].x;
 TempVertex^[i,j].x := (xt * co[angle] + TempVertex^[i,j].y * si[angle]) div 180;
 TempVertex^[i,j].y := (TempVertex^[i,j].y * co[angle] - xt * si[angle]) div 180;
 End;
end;




{+++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                THE MAIN PROGRAM HERO                }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++}
BEGIN
Start ;
szinbeallit(100,i1 div 5,0,0);
szin:=100;
for i:=0 to 600 do
for j:=0 to 800 do
pont(j,i);
{szin:=200;
for i:=101 to 700-1 do
pont(i,50);
szin:=0;
for i:=101 to 700-1 do
pont(i,550);
szin:=200;
for i:=51 to 550-1 do
pont(100,i);
szin:=0;
for i:=51 to 550-1 do
pont(700,i);
}
a:=0;b:=0;c:=0;
i1:=1;j1:=1;k1:=1;
s1:=1;s2:=1;s3:=1;
rnd:=0;
Repeat
 TempVertex^:=Vertex^;
 rotx(a);roty(b);rotz(c);
 RealProjecting;
 DrawVertex ;
 a:=a+1;b:=b+j1 div 10;c:=c+3;
 if a>355 then a:=0;
 if b>355 then b:=0;
 if c>355 then c:=0;
GenerateBody(i1,1,j1*3,k1*3);
GenerateVertex;

if i1>150 then Begin s1:=-1;i1:=i1-3;end;
if i1<1 then Begin s1:=+1;i1:=i1+3;end;
if j1>100 then Begin s2:=-1;j1:=j1-3;end;
if j1<1 then Begin s2:=1;j1:=j1+3;end;
if k1>100 then Begin s3:=-1;k1:=k1-3;end;
if k1<1 then Begin s3:=1;k1:=k1+3;end;

i1:=i1+s1;
if (i1 div 10)=(i1/10) then
k1:=(k1+s3);
if (k1 div 10)=(k1/10) then
j1:=j1+s2;

rnd:=rnd+j1 div 30;
if rnd>=360 then rnd:=0;
Until KeyPressed ;


Readkey ;
Finish ;
ENd;


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
     playback(p,1000,11000);
     blockread(f,o^,1000);
    End
    else
    {-------------------------------------------}
    {Megallitja a DMA -t ; vege az interruptnak }
    {-------------------------------------------}
    Begin
     DmaStop;
     test:=port[$21];                  { Read sb ack }
{     if (oldint and (1 shl $0d))<>0 then
          test:=test or (1 shl $0d)
          else
          test:=test and (1 shl $0d);}

{   port[$21]:=test;}                    { Write interrupt port }
{     soundend:=true;}
    cont:=1000;
     reset(f,1);
     playback(p,1000,11000);
     blockread(f,o^,1000);
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
 blockread(f,p^,1000);
 j:=filesize(f);
 cont:=j div 1000;
 cont:=cont-1;
 { Start Playing }

 Playback(p,1000,11000);
 oldint:=port[$21];
 port[$21]:=oldint and (1 shl $0d);
 blockread(f,o^,1000);

 {GRAPHICS}
 v:=1;zz:=1;sig:=1;
{ getintvec($1c,@old1);
 setintvec($1c,@paletteanim);}
{ graphics;}
demo;
{ setintvec($1c,@old1);}
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