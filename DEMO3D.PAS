Program Demo3D ;
Uses Crt,Vga ;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++}
{  Constans,Types,Variables For the program           }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++}

Const
   MaxRot     =  10 ;
   MaxLines   =  10 ;
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
  szin:=i1+i*j;
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
{ For i:=0 to 255 do
  Szinbeallit(i,i div 4,i div 4,i div 4);}
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
 TempVertex^[i,j].x := (xt * co[angle] + TempVertex^[i,j].y * si[angle]) div 180 ;
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
END.
