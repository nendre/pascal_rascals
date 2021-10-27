{$G+}
uses crt,vga,fgraph3d,graph;

Const Number_of_bodies = 1  ;
      Maxrot           = 10 ;
      MaxLines         = 25 ;
      RotStep          = 360 div MaxRot;
      MaxPoints = MaxRot * MaxLines;
      MaxFaces  = 2*MaxRot * (MaxLines-1);
      Maxlat = 4;

type ComprType = record
                  r,y : integer;
                 end;
     scr = array[1..64000] of byte;
type TComprBody = array[1..Maxlines]  of ComprType;
type TExpBody   = array[1..MaxPoints] of TPix3d;
Type TProjBody  = array[1..MaxPoints] of TPix2d;
Type TFace      = record
                  a,b,c:integer;
                  end;
Type TFaces     = array[1..MaxFaces] of TFace;

const Body:array[1..Number_of_bodies] of TComprBody =
(((r:0 ;y:-6 ),(r:8 ;y:-6 ),(r:13;y:-10),(r:18;y:-18),(r:21;y:-25),
  (r:23;y:-32),(r:27;y:-34),(r:31;y:-32),(r:30;y:-24),(r:27;y:-17),
  (r:23;y:-9 ),(r:19;y:-4 ),(r:14;y:0  ),(r:10;y:3  ),(r:9 ;y:7  ),(r:8;y:12),
  (r:8 ;y:17 ),(r:10;y:23 ),(r:16;y:26 ),(r:23;y:27 ),(r:25;y:30),
  (r:22;y:32 ),(r:16;y:30 ),(r:7 ;y:27 ),(r:0 ;y:26 ) ));

Var ExpBody  : array[1..Number_of_Bodies] of TExpBody;
    ProjBody : array[1..Number_of_Bodies] of TProjBody;
    TempBody : array[1..Number_of_Bodies] of TExpBody;
    OldBody  : array[1..Number_of_Bodies] of TProjBody;
    Faces    : array[1..Number_of_Bodies] of TFaces;
    GenBody  : array[1..Number_of_bodies] of TComprBody;
    AktBody : integer;
    env1x,env1y,env2x,env2y,env3x,env3y:integer;
    centx,centy:integer;
    i : integer;
    Xrot,Yrot,Zrot:integer;
    x,y:integer;
      AddXRot   :integer;
      AddYRot   :integer;
      AddZRot   :integer;
      kimi:integer;
      s1,s2,o1,o2:word;
      page1,page2:^scr;
      viz:integer;
      gd,gm:integer;


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


Procedure GenerateBodys;
var i,j,k,r:integer;
begin
 randomize;
 r:=10+random(80);
 j:=360 div 24;
 k:=0;
 for i:=1 to 25 do
 begin
 genbody[1][i].r:=60+round(30*sin(k*pi/180));
 genbody[1][i].y:=round(30*cos(k*pi/180));
 k:=k+j;
 end;
 genbody[1]:=body[1];
end;

Procedure delayed;
assembler;
asm
 mov dx,3daH
@t1:
 in al,dx
 test al,8
 je @t1
@t2:
 in al,dx
 test al,8
 jne @t2
end;


Procedure Decomp ;
Var start,xx,i,j,k,l,RotAdd:integer;
Begin
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
    RotAdd:=RotAdd+RotStep;
  End;
 end;
 end;

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
end;

begin
 for i:=0 to 2*360-1 do
 begin
 si[i]:=round(100*sin(i*pi/180));
 co[i]:=round(100*cos(i*pi/180));
 end;
 Dist:=100;
 Cor:=-45;
 generatebodys;
 Decomp;

 AktBody:=1;
 Xrot:=0;
 Yrot:=0;
 Zrot:=0;
 vmode($13);
 gd:=installuserdriver('svga256',nil);
 gm:=0;
 initgraph(gd,gm,'c:\bp\bgi');
 centx:=maxx div 2;
 centy:=maxy div 2;
  for i:=1 to 255 do
  szinbeallit(i,i div 4,i div 4,i div 4);
 szin:=255;
   AddXRot := 2 ;
   AddYRot := 3 ;
   AddZRot := 4 ;

kimi:=1;
{ new(page2);
 page1:=ptr($a000,0);}
 {             M A I N              }
{ centx:=-50;}
 view(64);
for i:=1 to 255 do
szinbeallit(i,i div 4,i div 4,i div 4);
{cleardevice;}
 repeat
 lapoz(0);
 Rotate(AktBody);
 Projectx(AktBody);
 Szin:=0;
setcolor(black);
for i:=1 to MaxFaces do
begin
 line(centx+oldBody[aktbody][faces[aktbody][i].a].x,
        centy+oldBody[aktbody][faces[aktbody][i].a].y,
        centx+oldBody[aktbody][faces[aktbody][i].b].x,
        centy+oldBody[aktbody][faces[aktbody][i].b].y);

{ line19(centx+oldBody[aktbody][faces[aktbody][i].b].x,
        centy+oldBody[aktbody][faces[aktbody][i].b].y,
        centx+oldBody[aktbody][faces[aktbody][i].c].x,
        centy+oldBody[aktbody][faces[aktbody][i].c].y,0);

line19(centx+oldBody[aktbody][faces[aktbody][i].a].x,
        centy+oldBody[aktbody][faces[aktbody][i].a].y,
        centx+oldBody[aktbody][faces[aktbody][i].c].x,
        centy+oldBody[aktbody][faces[aktbody][i].c].y,0);
}
end;

{clearscreen19_386;}

 szin:=255;
setcolor(white);
for i:=1 to MaxFaces do
begin
 line(centx+projBody[aktbody][faces[aktbody][i].a].x,
        centy+projBody[aktbody][faces[aktbody][i].a].y,
        centx+projBody[aktbody][faces[aktbody][i].b].x,
        centy+projBody[aktbody][faces[aktbody][i].b].y);

{line19(centx+projBody[aktbody][faces[aktbody][i].b].x,
        centy+projBody[aktbody][faces[aktbody][i].b].y,
        centx+projBody[aktbody][faces[aktbody][i].c].x,
        centy+projBody[aktbody][faces[aktbody][i].c].y,255);

line19(centx+projBody[aktbody][faces[aktbody][i].a].x,
        centy+projBody[aktbody][faces[aktbody][i].a].y,
        centx+projBody[aktbody][faces[aktbody][i].c].x,
        centy+projBody[aktbody][faces[aktbody][i].c].y,255);
}
end;

{clearscreen19_386;}
{
for i:=Maxfaces downto 1 do
begin
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

   line19(centx+projBody[aktbody][faces[aktbody][i].a].x,
          centy+projBody[aktbody][faces[aktbody][i].a].y,
          centx+projBody[aktbody][faces[aktbody][i].b].x,
          centy+projBody[aktbody][faces[aktbody][i].b].y,255);

   line19(centx+projBody[aktbody][faces[aktbody][i].b].x,
          centy+projBody[aktbody][faces[aktbody][i].b].y,
          centx+projBody[aktbody][faces[aktbody][i].c].x,
          centy+projBody[aktbody][faces[aktbody][i].c].y,255);

  line19(centx+projBody[aktbody][faces[aktbody][i].a].x,
          centy+projBody[aktbody][faces[aktbody][i].a].y,
          centx+projBody[aktbody][faces[aktbody][i].c].x,
          centy+projBody[aktbody][faces[aktbody][i].c].y,255);

end;
end;
}


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

{page2^:=page1^;}

lapoz(1);
view(0);
{delayed;}
{page1^:=page2^;}
{move(p2^,p1^,64000);}
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

 OldBody[AktBody]:=ProjBody[AktBody];
 inc(Xrot,AddXRot);
 inc(Yrot,AddYRot);
 inc(Zrot,AddZRot);
 if Xrot>359 then Xrot:=xrot-360;
 if Yrot>359 then Yrot:=yrot-360;
 if Zrot>359 then Zrot:=zrot-360;
  cor:=cor+kimi;
 if( cor<-40) or (cor>60) then kimi:=-kimi;
 if (cor+dist)=0 then cor:=cor+1;

 until keypressed;
 readkey;
 vmode($03);
end.