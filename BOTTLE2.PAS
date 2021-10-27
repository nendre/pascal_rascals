{$G+}
uses crt,vga,fgraph3d;

Const Number_of_bodies = 1 ;
      Maxrot           = 7 ;
      MaxLines         = 25 ;
      RotStep          = 360 div MaxRot;
      MaxPoints = MaxRot * MaxLines;
      MaxFaces  = 2*MaxRot * (MaxLines-1);
      Maxlat = 4;

type ComprType = record
                  r,y : integer;
                 end;
type TComprBody = array[1..Maxlines]  of ComprType;
     TExpBody   = array[1..MaxPoints] of TPix3d;
     TProjBody  = array[1..MaxPoints] of TPix2d;
     TFace      = record
                  a,b,c:integer;
                  end;
     TFaces     = array[1..MaxFaces] of TFace;
     tsort      = array[1..MaxFaces] of TPix2d;


const Body:array[1..Number_of_bodies] of TComprBody =
(((r:0 ;y:-6 ),(r:8 ;y:-6 ),(r:13;y:-10),(r:18;y:-18),(r:21;y:-25),
 (r:23;y:-32),(r:27;y:-34),(r:31;y:-32),(r:30;y:-24),(r:27;y:-17),
  (r:23;y:-9 ),(r:19;y:-4 ),(r:14;y:0  ),(r:10;y:3  ),(r:9 ;y:7  ),(r:8;y:12),
  (r:8 ;y:17 ),(r:10;y:23 ),(r:16;y:26 ),(r:23;y:27 ),(r:25;y:30),
 (r:22;y:32 ),(r:16;y:30 ),(r:7 ;y:27 ),(r:0 ;y:26 ) ));

{
(((r:0;y:-60),( r:7;y:-55  ),(r: 13;y:-50 ),(r:19;y:-45 ),(r:25;y:-40),
(r:31;y:-34 ),(r:38;y:-27),(r:44;y:-21),(r:49;y:-15),(r:54;y:-8),
(r:58;y:-2) ,(r:61;y:5) ,(r:63;y:11),(r:65;y:18),(r:66;y:23),
(r:66;y:27),(r:64;y:33),(r:59;y:39),(r:55;y:43),(r:47;y:48),(r:36;y:53),
(r:26;y:57),(r:16;y:59),(r:8;y:60),(r:0;y:60)));
}
{(((r:18;y:0),(r:19;y:-8),(r:22;y:-14),(r:27;y:-18),(r:31;y:-22),
(r:37;y:-26),(r:42;y:-26),(r:49;y:-23),(r:53;y:-18),(r:59;y:-15),
(r:62;y:-12),(r:69;y:-10),(r:75;y:-6),(r:85;y:-5),(r:90;y:-3),(r:92;y:0),
(r:85;y:4),(r:68;y:7),(r:51;y:10),(r:42;y:8),(r:37;y:6),(r:33;y:4),
(r:28;y:6),(r:22;y:5),(r:18;y:0)));
 }
Type ScreenSize=array[1..64000] of byte;


Var ExpBody  : array[1..Number_of_Bodies] of TExpBody;
    ProjBody : array[1..Number_of_Bodies] of TProjBody;
    TempBody : array[1..Number_of_Bodies] of TExpBody;
    OldBody  : array[1..Number_of_Bodies] of TProjBody;
    Faces    : array[1..Number_of_Bodies] of TFaces;
    VNorm    : array[1..Number_of_Bodies] of TFaces;
    TVNorm   : array[1..Number_of_Bodies] of TFaces;
    Short    : array[1..Number_of_Bodies] of Tsort;
    GenBody  : array[1..Number_of_bodies] of TComprBody;
    page1,page2:^ScreenSize;
    AktBody : integer;
    centx,centy:integer;
    i,j,k,l : word;
    Xrot,Yrot,Zrot:integer;
    x,y:integer;
      AddXRot   :integer;
      AddYRot   :integer;
      AddZRot   :integer;
    viz:integer;
    env1x,env1y,
    env2x,env2y,
    env3x,env3y:integer;
     s1,o1,s2,o2:word;
     q1,w1,q2,w2,q3,w3,qmin,qmax,wmin,wmax:integer;
      a,b,c:integer;
      a1,b1,c1:real;
      nxr,nyr,nzr:longint;
      smin,smax:integer;

Procedure GenerateBodys;
var i,j,k,r:integer;
begin
 randomize;
 r:=10+random(80);
 j:=360 div 24;
 k:=0;
 for i:=1 to 25 do
 begin
 genbody[1][i].r:=50+round(40*sin(k*pi/180));
 genbody[1][i].y:=-round(40*cos(k*pi/180));

 k:=k+j;
 end;
genbody[1]:=body[1];
end;

{Procedure Line19(x1,y1,x2,y2:word;color:byte);external;
Procedure Clearscreen19_386;external;
}
procedure lapoz(lap:byte);
begin
asm
pusha
 mov dl,lap
 mov ah,dl
 mov dx,03c4h
 mov al,0eh
 out dx,al
 inc dx
 in al,dx
 and ax,0ff0h
 xor ah,2
 or al,ah
 out dx,al
popa
end;
end;

procedure view(h:integer);
begin
port[$3d4]:=$0c;
port[$3d5]:=hi(h);
port[$2d4]:=$0d;
port[$3d5]:=lo(h);
end;


Procedure Sorting;
var i,j,k,l:integer;
Begin
l:=0;
for i:=1 to MaxFaces do
begin
 Short[AktBody][i].y:=i;
 Short[AktBody][i].x:=
 TempBody[AktBody][Faces[AktBody][i].a].z+
 TempBody[AktBody][Faces[AktBody][i].b].z+
 TempBody[AktBody][Faces[AktBody][i].c].z;
end;
for i:=MaxFaces downto 2 do
begin
l:=0;
for k:=1 to i-1 do
begin
 if Short[AktBody][k].x>Short[AktBody][k+1].x then
 begin
 l:=1;
  j:=Short[AktBody][k].x;
  Short[AktBody][k].x:=Short[AktBody][k+1].x;
  Short[AktBody][k+1].x:=j;

  j:=Short[AktBody][k].y;
  Short[AktBody][k].y:=Short[AktBody][k+1].y;
  Short[AktBody][k+1].y:=j;
 end;

 end;
  if l=0 then exit;
end;
end;
Procedure FNormals;
var i,j,k:integer;
Begin
for i:=1 to MaxFaces do
begin
 vNorm[AktBody][i].a:=
 ((ExpBody[AktBody][Faces[AktBody][i].a].y-
   ExpBody[AktBody][Faces[AktBody][i].b].y)*
  (ExpBody[AktBody][Faces[AktBody][i].a].z-
   ExpBody[AktBody][Faces[AktBody][i].c].z)-
  (ExpBody[AktBody][Faces[AktBody][i].a].z-
   ExpBody[AktBody][Faces[AktBody][i].b].z)*
  (ExpBody[AktBody][Faces[AktBody][i].a].y-
   ExpBody[AktBody][Faces[AktBody][i].c].y));
 vNorm[AktBody][i].b:=
 ((ExpBody[AktBody][Faces[AktBody][i].a].z-
   ExpBody[AktBody][Faces[AktBody][i].b].z)*
  (ExpBody[AktBody][Faces[AktBody][i].a].x-
   ExpBody[AktBody][Faces[AktBody][i].c].x)-
  (ExpBody[AktBody][Faces[AktBody][i].a].x-
   ExpBody[AktBody][Faces[AktBody][i].b].x)*
  (ExpBody[AktBody][Faces[AktBody][i].a].z-
   ExpBody[AktBody][Faces[AktBody][i].c].z));
 vNorm[AktBody][i].c:=
 ((ExpBody[AktBody][Faces[AktBody][i].a].x-
   ExpBody[AktBody][Faces[AktBody][i].b].x)*
  (ExpBody[AktBody][Faces[AktBody][i].a].y-
   ExpBody[AktBody][Faces[AktBody][i].c].y)-
  (ExpBody[AktBody][Faces[AktBody][i].a].y-
   ExpBody[AktBody][Faces[AktBody][i].b].y)*
  (ExpBody[AktBody][Faces[AktBody][i].a].x-
   ExpBody[AktBody][Faces[AktBody][i].c].x));
  TVNorm[AktBody]:=VNorm[AktBody];
end;

end;

procedure Decomp ;
Var start,xx,i,j,k,l,RotAdd:integer;
Begin
{ for i:=1 to Number_of_Bodies do
 Begin

 for j:=0 to MaxLines-1 do
 Begin
  RotAdd:=0;
 For k:=1 to Maxrot do
  Begin
   ExpBody[i][j*Maxrot+k].y:=Body[i][j+1].y;
   ExpBody[i][j*Maxrot+k].x:=round(Body[i][j+1].r*sin(RotAdd*Pi/180));
   ExpBody[i][j*Maxrot+k].z:=round(Body[i][j+1].r*cos(RotAdd*Pi/180));
   ProjBody[i][j*Maxrot+k].x:=ExpBody[i][j*Maxrot+k].x;
   ProjBody[i][j*Maxrot+k].y:=ExpBody[i][j*Maxrot+k].y;

    RotAdd:=RotAdd+RotStep;
  End;
  tempBody[i]:=ExpBody[i];
 end;
 end;
 }
 {  g e n e r a t e   }
  for i:=1 to Number_of_Bodies do
 Begin
 for j:=0 to MaxLines-1 do
 Begin
  RotAdd:=0;
 For k:=1 to Maxrot do
  Begin
   ExpBody[i][j*Maxrot+k].y:=genBody[i][j+1].y;
   ExpBody[i][j*Maxrot+k].x:=round(genBody[i][j+1].r*sin(RotAdd*Pi/180));
   ExpBody[i][j*Maxrot+k].z:=round(genBody[i][j+1].r*cos(RotAdd*Pi/180));
   ProjBody[i][j*Maxrot+k].x:=ExpBody[i][j*Maxrot+k].x;
   ProjBody[i][j*Maxrot+k].y:=ExpBody[i][j*Maxrot+k].y;
   RotAdd:=RotAdd+RotStep;
  End;
 end;
 tempBody[i]:=ExpBody[i];
 end;

 { G e n e r a t e   e n d }
 l:=1;
 for i:=1 to Number_of_Bodies do
 begin
 start:=1;
  for j:=1 to MaxLines-1 do
  begin
  xx:=0;
  for k:=1 to MaxRot-1 do
  begin
  faces[i][l+0].a:=start+xx;
  faces[i][l+0].b:=start+xx+Maxrot;
  faces[i][l+0].c:=start+xx+maxrot+1;
  faces[i][l+1].a:=start+xx+1;
  faces[i][l+1].b:=start+xx;
  faces[i][l+1].c:=start+xx+maxrot+1;
  xx:=xx+1;
  l:=l+2;
  end;
  faces[i][l+0].a:=start+maxrot-1;
  faces[i][l+0].b:=start+Maxrot-1+maxrot;
  faces[i][l+0].c:=start+maxrot;
  faces[i][l+1].a:=start;
  faces[i][l+1].b:=start+maxrot-1;
  faces[i][l+1].c:=start+maxrot;
  l:=l+2;
  start:=start+maxrot;
  end;
 end;

end;

Procedure Projectx(XBody:integer);
Var i:integer;
Begin
For i:=1 to MaxPoints do
Begin
 Pix3d.x:=TempBody[XBody][i].x;
 Pix3d.y:=TempBody[XBody][i].y;
 Pix3d.z:=TempBody[XBody][i].z;
 Project;
 ProjBody[XBody][i].x:=pix2d.x;
 ProjBody[XBody][i].y:=pix2d.y;
end;
end;

Procedure Rotate(XBody:integer);
Var i:integer;
Begin
for i:=1 to MaxPoints do
begin
 Pix3d.x:=ExpBody[XBody][i].x;
 Pix3d.y:=ExpBody[XBody][i].y;
 Pix3d.z:=ExpBody[XBody][i].z;
 Rotx(Xrot);
 Roty(Yrot);
 Rotz(Zrot);
 TempBody[Xbody][i].x:=Pix3d.x;
 TempBody[Xbody][i].y:=Pix3d.y;
 TempBody[Xbody][i].z:=Pix3d.z;
end;
for i:=1 to maxfaces do
begin
 pix3d.x:=Vnorm[xbody][i].a;
 pix3d.y:=Vnorm[xbody][i].b;
 pix3d.z:=Vnorm[xbody][i].c;
 Rotx(Xrot);
 Roty(Yrot);
 Rotz(Zrot);
 tvnorm[Xbody][i].a:=Pix3d.x;
 tvnorm[Xbody][i].b:=Pix3d.y;
 tvnorm[Xbody][i].c:=Pix3d.z;
end;
end;

    {    S t a r t   t h e  3 - D   A n i m a t i o n   }


begin
{Create Sinus Table}
 for i:=0 to 2*360-1 do
 begin
 si[i]:=round(100*sin(i*pi/180));
 co[i]:=round(100*cos(i*pi/180));
 end;
{Initial settings}
 Dist:=390;
 Cor:=0;
 generateBodys;
 Decomp;
 AktBody:=1;
 Xrot:=0;
 Yrot:=0;
 Zrot:=0;
 vmode($13);
 centx:=maxx div 2;
 centy:=maxy div 2;
 for i:=1 to 255 do
 szinbeallit(i,i div 4,i div 4,i div 4);
 szin:=255;
  AddXRot := 10 ;
  AddYRot := 20 ;
  AddZRot := 30 ;
 fnormals;
 Rotate(AktBody);
 sorting;
 page1:=ptr($a000,0);
 new(page2);
 view(64);
 a1:=0;b1:=10000;c1:=-10000;

 for i:=1 to 64000 do
 mem[$a000:i]:=random(255);


 { M a i n }

 repeat

 Rotate(AktBody);
 Projectx(AktBody);
 sorting;
 lapoz(0);
 Szin:=0;
  for i:=1 to 64000 do
 mem[$a000:i]:=100+random(100);

{clearscreen19_386;}

 szin:=255;

for l:=Maxfaces downto 1 do
begin
i:=short[aktbody][l].y;
 env1x:=TempBody[AktBody][faces[AktBody][i].a].x;
 env1y:=TempBody[AktBody][faces[AktBody][i].a].y;
 env2x:=TempBody[AktBody][faces[AktBody][i].b].x;
 env2y:=TempBody[AktBody][faces[AktBody][i].b].y;
 env3x:=TempBody[AktBody][faces[AktBody][i].c].x;
 env3y:=TempBody[AktBody][faces[AktBody][i].c].y;
 viz:=env1x*(env2y-env3y)+
      env2x*(env3y-env1y)+
      env3x*(env1y-env2y );
 if viz>0 then
 begin

  q1:=ProjBody[AktBody][faces[AktBody][i].a].x+160;
  q2:=ProjBody[AktBody][faces[AktBody][i].b].x+160;
  q3:=ProjBody[AktBody][faces[AktBody][i].c].x+160;
  w1:=ProjBody[AktBody][faces[AktBody][i].a].y+100;
  w2:=ProjBody[AktBody][faces[AktBody][i].b].y+100;
  w3:=ProjBody[AktBody][faces[AktBody][i].c].y+100;
  qmin:=q1;
  if q2<qmin then qmin:=q2;
  if q3<qmin then qmin:=q3;
  wmin:=w1;
  if w2<wmin then wmin:=w2;
  if w3<wmin then wmin:=w3;
  qmax:=q1;
  if q2>qmax then qmax:=q2;
  if q3>qmax then qmax:=q3;
  wmax:=w1;
  if w2>wmax then wmax:=w2;
  if w3>wmax then wmax:=w3;
  if ((wmin>wmax) or (qmin>qmax)) then halt;

  szin:=50+i div 3;
 nxr:=tvnorm[AKtBody][i].a;
 nxr:=sqr(nxr);
 nyr:=tvnorm[AKtBody][i].b;
 nyr:=sqr(nyr);
 nzr:=tvnorm[AKtBody][i].c;
 nzr:=sqr(nzr);
 a1:=nxr+nyr+nzr;
 if a1=0 then a1:=0.001;
 a1:=sqrt(a1);
 a1:=tvnorm[AKtBody][i].b/a1;
 if a1<b1 then b1:=a1;
 if a1>c1 then c1:=a1;

  a1:=0+100*abs(a1+1);
  szin:=round(a1);

  for k:=qmin to qmax do
  begin
  for j:=wmin to wmax do
  begin
  a:=(k-q1)*(w2-w1)-(q2-q1)*(j-w1);
  b:=(k-q2)*(w3-w2)-(q3-q2)*(j-w2);
  c:=(k-q3)*(w1-w3)-(q1-q3)*(j-w3);
 if  ((b<1) and (c<1) and (a<1)) then
 begin
  a:=pontle(k,j);
  szin:=(a+szin) div 2;
  xpont(k,j);
 end;
 end;
 end;
 end;
end;

 OldBody[AktBody]:=ProjBody[AktBody];

s1:=seg(page1^);
s2:=seg(page2^);
o1:=ofs(page1^);
o2:=ofs(page2^);
asm
pusha
push es
push di
push ds
push si
 mov ax,s2
 mov es,ax
 mov di,o2
 mov ax,s1
 mov ds,ax
 mov si,0
 mov cx,32000
 rep movsw
pop si
pop ds
pop di
pop es
popa
end;

lapoz(1);

s1:=seg(page1^);
s2:=seg(page2^);
o1:=ofs(page1^);
o2:=ofs(page2^);

asm
pusha
push es
push di
push ds
push si
 mov ax,s1
 mov es,ax
 mov ax,o1
 mov di,ax
 mov ax,s2
 mov ds,ax
 mov ax,o2
 mov si,0
 mov cx,32000
 rep movsw
pop si
pop ds
pop di
pop es
popa
end;
 inc(Xrot,AddXRot);
 inc(Yrot,AddYRot);
 inc(Zrot,AddZRot);
 if Xrot>359 then Xrot:=0;
 if Yrot>359 then Yrot:=0;
 if Zrot>359 then Zrot:=0;
 until keypressed;


 readkey;
 dispose(page2);
 vmode($03);
end.