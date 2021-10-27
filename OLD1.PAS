{$G+}
(*

   .......       . . . .     . . . . .             .......     .......
   .      .     .        .       .                .       .     .      .
   .      .     .        .       .                        .     .       .
   .......      .        .       .       . . .         ..       .       .
   .   .        .        .       .                        .     .       .
   .     .      .        .       .                .       .     .      .
   .      .      . . . .         .                  ......     ........


*)
{$M 60000,0,600000}
uses crt,vga,fgraph3d,bmp,dos;

{ C o n s t a n t s - for 3D }


Const Number_of_bodies = 1 ;
      Maxrot           = 5 ;
      MaxLines         = 25;
      RotStep          = 360 div MaxRot;
      MaxPoints        = MaxRot * MaxLines;
      MaxFaces         = 2*MaxRot * (MaxLines-1);
      AddXRot          = 17;
      AddYRot          = 13;
      AddZRot          = 15;

{ T y p e s  for   3D }

type ComprType  = record
                  r,y : integer;
                  end;
     TComprBody = array[1..Maxlines]  of ComprType;
     TExpBody   = array[1..MaxPoints] of TPix3d;
     TProjBody  = array[1..MaxPoints] of TPix2d;
     TFace      = record
                  a,b,c:integer;
                  end;
     TFaces     = array[1..MaxFaces] of TFace;
     tsort      = array[1..MaxFaces] of TPix2d;
     Scr        = array[1..64000] of byte;
     qsqr        = array[1..55000] of byte;


{ V a r i a b l e s   f o r   3D }

const Body : TComprBody =
 ((r:0 ;y:-6 ),(r:8 ;y:-6 ),(r:13;y:-10),(r:18;y:-18),(r:21;y:-25),
 (r:23;y:-32),(r:27;y:-34),(r:31;y:-32),(r:30;y:-24),(r:27;y:-17),
 (r:23;y:-9 ),(r:19;y:-4 ),(r:14;y:0  ),(r:10;y:3  ),(r:9 ;y:7  ),(r:8;y:12),
 (r:8 ;y:17 ),(r:10;y:23 ),(r:16;y:26 ),(r:23;y:27 ),(r:25;y:30),
 (r:22;y:32 ),(r:16;y:30 ),(r:7 ;y:27 ),(r:0 ;y:26 ));

{
((r:0;y:-60),( r:7;y:-55  ),(r: 13;y:-50 ),(r:19;y:-45 ),(r:25;y:-40),
(r:31;y:-34 ),(r:38;y:-27),(r:44;y:-21),(r:49;y:-15),(r:54;y:-8),
(r:58;y:-2) ,(r:61;y:5) ,(r:63;y:11),(r:65;y:18),(r:66;y:23),
(r:66;y:27),(r:64;y:33),(r:59;y:39),(r:55;y:43),(r:47;y:48),(r:36;y:53),
(r:26;y:57),(r:16;y:59),(r:8;y:60),(r:0;y:60));
}
{
((r:18;y:0),(r:19;y:-8),(r:22;y:-14),(r:27;y:-18),(r:31;y:-22),
 (r:37;y:-26),(r:42;y:-26),(r:49;y:-23),(r:53;y:-18),(r:59;y:-15),
(r:62;y:-12),(r:69;y:-10),(r:75;y:-6),(r:85;y:-5),(r:90;y:-3),(r:92;y:0),
(r:85;y:4),(r:68;y:7),(r:51;y:10),(r:42;y:8),(r:37;y:6),(r:33;y:4),
(r:28;y:6),(r:22;y:5),(r:18;y:0));
}

var ExpBody,TempBody,TVnormal,VNormal:^TExpBody;
    ProjBody,OldBody:^TProjBody;Faces,FNormal:^TFaces;
    Sort:^TSort;didi:longint;rr,gg,bb:integer;
    b1,b2,b3:boolean;Screen,alap,texture,TempScreen:^Scr;
    Xrot,Yrot,Zrot:integer;Initial_memory:longint;Cbody:^TComprBody;
    pan,i,j,k,l:integer;sq:^qsqr;g:word;old:procedure;frame,tk,tv:longint;
    aktpal:integer;oldpal:paletta;mc:byte;wars:integer;t1,t2,t3,t4:word;


{-------------------------------------------------------------------------}
{ And now the procedures and functions }
{-------------------------------------------------------------------------}

procedure delayed;
assembler;
 asm
  @t1:
   mov dx,3dah
   in al,dx
   test al,8
   jne @t1
  @t2:
   mov dx,3dah
   in al,dx
   test al,8
   je @t1
 end; {Proc}


Procedure Palani;interrupt;
var i,j,k:integer ;
Begin
inc(pan);
if pan>10 then
Begin
 palleolvas(pal);
 for i:=64 to 2*64 do
 Begin
  pal[i].red:=(rr*(i-64)) div 64;
  pal[i].green:=(gg*(i-64)) div 64;
  pal[i].blue:=(bb*(i-64)) div 64;
 end;
 for i:=2*64 to 3*64 do
 Begin
  pal[i].red:=rr+((63-rr)*(i-128)) div 64;
  pal[i].green:=gg+((63-gg)*(i-128)) div 64;
  pal[i].blue:=bb+((63-bb)*(i-128)) div 64;
 end;
 palbeallit(pal);
 if (rr>61) then Begin b1:=true;b2:=false;b3:=false;end;
 if (gg>61) then Begin b1:=false;b2:=true;b3:=false;end;
 if (bb>61) then Begin b1:=false;b2:=false;b3:=true;end;
 if b1 then Begin rr:=rr-1;gg:=gg+1;end;
 if b2 then Begin gg:=gg-1;bb:=bb+1;end;
 if b3 then begin bb:=bb-1;rr:=rr+1;end;
 if (b1) and (rr<2) then gg:=62;
 if (b2) and (gg<2) then bb:=62;
 if (b3) and (bb<2) then rr:=62;
 pan:=0;
End;
{ inline($9c);
 old;}

End;


procedure Move32(var source,dest;count:word);assembler;

asm
                PUSH    DS
                LDS     SI,source
                LES     DI,dest
                MOV     CX,count
                SHR     CX,1
                JNC     @@1
                MOVSB
@@1:            SHR     CX,1
                JNC     @@2
                MOVSW
@@2:            DB      66h
                REP     MOVSW
                POP     DS
end;


function mos(a:real;b:integer):real;
var i:integer;c:real;
begin c:=a;for i:=0 to b do a:=a*c;mos:=a;end; {func}


function qsqrt(a:word):word;
begin qsqrt:=sq^[a];end;{func}

Procedure GenerateBodys;
var i,j,k,r:integer;
begin
 r:=10;j:=360 div 23;k:=0;
 for i:=1 to 25 do
 begin
 cbody^[i].r:=45+round((30+round(3*sin(i*pi/2)))*sin(i*pi/12));
 cbody^[i].y:=-round((30+round(3*sin(i*pi/2)))*cos(i*pi/12));
 k:=k+j;
 end;
end;

Procedure Createtexture;
var i,j,k:integer;a,b,c,d,e:word;q,w:byte;r,t:integer;
    lum:array[0..255] of byte;
begin
 {M a p i n i t}
 for i:=0 to 199 do for j:=0 to 255 do
 begin  szin:=0;xpont(j,i);end; {for}
 {Shift image}
 for i:=0 to 200 do
 for j:=0 to 260 do
 begin mem[$a000:i*320+j]:=mem[$a000:i*320+j+60];
 mem[$a000:i*320+j+60]:=0;end;
{M a p - l i g t h}
a:=200;j:=-100;
for r:=200 downto 0 do
begin
  b:=sqr(j);k:=-128;
  for t:=255 downto 0 do
  begin c:=sqr(k);d:=round(sqrt(b+c));
   if d<127 then
   begin q:=0+round(100*cos((d*70/128)*pi/180)+
   (150*mos(cos((d*90/128)*pi/180),100)));szin:=q;
   xpont(t,r);
   texture^[t+r*256]:=szin;
   end
   else
   begin
   texture^[t+r*256]:=0;szin:=0;xpont(t,r);
 end;{if} k:=k+1;end;{for}j:=j+1;end;{for}
end; {Proc}

procedure lapoz(lap:byte);
assembler;
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

procedure view(h:integer);
begin
 port[$3d4]:=$0c;
 port[$3d5]:=hi(h);
 port[$2d4]:=$0d;
 port[$3d5]:=lo(h);
end;

procedure xxpont(x,y:word{;sg,ofs:word});assembler;
asm
 mov ax,x
 mov bx,y
 mov cl,white
 shl bx,6
 add ax,bx
 shl bx,2
 add ax,bx
 les bx,tempscreen
 add bx,ax
 mov al,szin
 mov es:[bx],al
end;

Function Visible:boolean;
var env1x,env1y,env2x,
env2y,env3x,env3y:integer;
begin
 Visible:=False;
 l:=sort^[i].y;
 env1x:=TempBody^[faces^[l].a].x;
 env1y:=TempBody^[faces^[l].a].y;
 env2x:=TempBody^[faces^[l].b].x;
 env2y:=TempBody^[faces^[l].b].y;
 env3x:=TempBody^[faces^[l].c].x;
 env3y:=TempBody^[faces^[l].c].y;
 if (((env1x*(env2y-env3y))+
     (env2x*(env3y-env1y))+
     (env3x*(env1y-env2y )))>0) then Visible:=true;
end;

Procedure Enviroment;
type env = record
            x,y:integer;
          end;
var envnsc,envsc:array[1..3] of env;
    i,j,k:word;envMiny,envMaxy:integer;
    envxinc,envnxinc,envnyinc:integer;
    envScanStart,envScanStop,envScanLeftx,
    envScanLefty,envScanRightx,envScanRighty:array[1..200] of integer;
    z:integer;sc,scnx,scny:integer;

Procedure Scan(a,b:integer);
var i,j,k:integer;len:integer;
begin
if (envsc[a].y=envsc[b].y) then exit;
if (envsc[a].y<envsc[b].y) then
  begin z:=a;a:=b;b:=z;end;
 len:=envsc[a].y-envsc[b].y;
 envXinc:=100*(envsc[a].x-envsc[b].x) div len;
 envnXinc:=100*(envnsc[a].x-envnsc[b].x) div len;
 envnyinc:=100*(envnsc[a].y-envnsc[b].y) div len;
 sc:=envsc[b].x*100;scnx:=envnsc[b].x*100;
 scny:=envnsc[b].y*100;
 for i:=envsc[b].y to envsc[b].y+len-1 do
 begin
 sc:=sc+envxinc;scnx:=scnx+envnxinc;
 scny:=scny+envnyinc;
 if (envscanstart[i]=16000) then
 begin
 envscanstart[i]:=sc div 100;
 envscanleftx[i]:=scnx div 100;
 envscanlefty[i]:=scny div 100;
 end
 else
 begin
 envscanstop[i]:=sc div 100;
 envscanrightx[i]:=scnx div 100;
 envscanrighty[i]:=scny div 100;
 end;
end;


end; {scan}

Procedure Draw(a:integer);
var x,y,b:integer;
    xx,yy:integer;
    i,j,k:integer;
begin
if envscanstart[a]=16000 then exit;
if (envscanstart[a]=envscanstop[a]) then exit;
if (envscanstart[a]>envscanstop[a]) then
begin
 b:=envscanstart[a];
 envscanstart[a]:=envscanstop[a];
 envscanstop[a]:=b;
 b:=envscanleftx[a];
 envscanleftx[a]:=envscanrightx[a];
 envscanrightx[a]:=b;
 b:=envscanlefty[a];
 envscanlefty[a]:=envscanrighty[a];
 envscanrighty[a]:=b;
end;
 envnxinc:=100*(envscanrightx[a]-envscanleftx[a]) div (envscanstop[a]-envscanstart[a]);
 envnyinc:=100*(envscanrighty[a]-envscanlefty[a]) div (envscanstop[a]-envscanstart[a]);
 xx:=envscanleftx[a]*100;
 yy:=envscanlefty[a]*100;
 for k:=envscanstart[a] to envscanstop[a] do
 begin
  xx:=xx+envnxinc;
  yy:=yy+envnyinc;
  x:=(xx div 100)+127;
  y:=(yy div 100)+99;
  szin:=texture^[x+y*256];
  k:=abs(k mod 320);a:=abs(a mod 200);
  xxpont(k,a);
 end;
end; {Draw}

Begin
 { load projected data and normals  }
 envsc[1].x:=(ProjBody^[faces^[l].a].x+160) MOD 320;
 envsc[2].x:=(ProjBody^[faces^[l].b].x+160) MOD 320;
 envsc[3].x:=(ProjBody^[faces^[l].c].x+160) MOD 320;
 envsc[1].y:=(ProjBody^[faces^[l].a].y+100) MOD 200;
 envsc[2].y:=(ProjBody^[faces^[l].b].y+100) MOD 200;
 envsc[3].y:=(ProjBody^[faces^[l].c].y+100) MOD 200;
 envnsc[1].x:=VNormal^[faces^[l].a].x;
 envnsc[2].x:=VNormal^[faces^[l].b].x;
 envnsc[3].x:=VNormal^[faces^[l].c].x;
 envnsc[1].y:=VNormal^[faces^[l].a].y;
 envnsc[2].y:=VNormal^[faces^[l].b].y;
 envnsc[3].y:=VNormal^[faces^[l].c].y;
 { minimum - maximum }
 envminy:=envsc[1].y;
 if envsc[2].y<envminy then envminy:=envsc[2].y;
 if envsc[3].y<envminy then envminy:=envsc[3].y;
 envmaxy:=envsc[1].y;
 if envsc[2].y>envmaxy then envmaxy:=envsc[2].y;
 if envsc[3].y>envmaxy then envmaxy:=envsc[3].y;
{ scan buffer }
 for i:=envminy to envminy+(envmaxy-envminy)+1 do
 envscanstart[i]:=16000;
 scan(1,2);
 scan(2,3);
 scan(1,3);
 for i:=envminy to envmaxy+1 do
 draw(i);
end;

Procedure Sorting;
var i,j,k,l:integer;
 Procedure QuickSort (first,last:word) ;
 Var Splitp1,splitp2:integer;
   Procedure Split(first,last:integer);
   Var splitval,temp:integer;
  Begin
    splitval:=sort^[(first+last) div 2].x;
    Repeat
     while sort^[first].x<splitval do inc(first);
     while sort^[last].x>splitval do dec(last);
     if first<=last then
      Begin
      temp:=sort^[first].x;
      sort^[first].x:=sort^[last].x;
      sort^[last].x:=temp;
      temp:=sort^[first].y;
      sort^[first].y:=sort^[last].y;
      sort^[last].y:=temp;
      inc(first);
      dec(last);
      end;
     until first>last;
     splitp1:=first;
     splitp2:=last;
   End;
Begin
  if first<last then Split(first,last);
  if splitp1<last then Quicksort(splitp1,last);
  if first<splitp2 then quicksort(first,splitp2);
End;


Begin
 l:=0;
 for i:=1 to MaxFaces do
 begin
  Sort^[i].y:=i;
  Sort^[i].x:=TempBody^[Faces^[i].a].z+
              TempBody^[Faces^[i].b].z+
              TempBody^[Faces^[i].c].z ;
 end;
 QuickSort(1,maxfaces);
end;


Procedure CreateFNormals;
var i,j,k:integer;
Begin
 for i:=1 to MaxFaces do
 begin
  FNormal^[i].a:=((ExpBody^[Faces^[i].a].y-ExpBody^[Faces^[i].b].y)*
  (ExpBody^[Faces^[i].a].z-ExpBody^[Faces^[i].c].z)-(ExpBody^[Faces^[i].a].z-
  ExpBody^[Faces^[i].b].z)*(ExpBody^[Faces^[i].a].y-ExpBody^[Faces^[i].c].y));
  FNormal^[i].b:=((ExpBody^[Faces^[i].a].z-ExpBody^[Faces^[i].b].z)*
  (ExpBody^[Faces^[i].a].x-ExpBody^[Faces^[i].c].x)-(ExpBody^[Faces^[i].a].x-
  ExpBody^[Faces^[i].b].x)*(ExpBody^[Faces^[i].a].z-ExpBody^[Faces^[i].c].z));
  FNormal^[i].c:=((ExpBody^[Faces^[i].a].x-ExpBody^[Faces^[i].b].x)*
 (ExpBody^[Faces^[i].a].y-ExpBody^[Faces^[i].c].y)-(ExpBody^[Faces^[i].a].y-
 ExpBody^[Faces^[i].b].y)*(ExpBody^[Faces^[i].a].x-ExpBody^[Faces^[i].c].x));
 end;
end;


Procedure CreateVNormals;
var i,j,k:integer;
    NX,NY,NZ:integer;
begin
 for i:=1 to MaxPoints do
 Begin
  nx:=0;ny:=0;nz:=0;
  for j:=1 to MaxFaces do
  Begin
   if ((faces^[j].a=i) or (faces^[j].b=i) or (faces^[j].c=i)) then
      begin nx:=nx+fnormal^[j].a;ny:=ny+fnormal^[j].b;
      nz:=nz+fnormal^[j].c;end;
  end;
  vnormal^[i].x:=nx div 4;
  vnormal^[i].y:=ny div 4;
  vnormal^[i].z:=nz div 4;
 end;
 TVnormal^:=Vnormal^;
end;


Procedure Normalize;
var i,j,k:integer;
    x,y,z:integer;
    ecx,eax:longint;
Begin
 for i:=1 to MaxPoints do
 begin
  eax:=vnormal^[i].x;eax:=eax*eax;ecx:=eax;eax:=vnormal^[i].y;
  eax:=eax*eax;ecx:=ecx+eax;eax:=vnormal^[i].z;eax:=eax*eax;
  ecx:=ecx+eax;
  eax:=1+5*round(qsqrt(ecx div 22));
  x:=(97*vnormal^[i].x div eax);y:=(97*vnormal^[i].y div eax);
  z:=(97*vnormal^[i].z div eax);
  vnormal^[i].x:=x;vnormal^[i].y:=y;vnormal^[i].z:=z;end;
end;


procedure Decomp ;
Var start,xx,i,j,k,l,RotAdd:integer;
Begin
 for j:=0 to MaxLines-1 do
 Begin
  RotAdd:=0;
 For k:=1 to Maxrot do
  Begin
   ExpBody^[j*Maxrot+k].y:=cBody^[j+1].y;
   ExpBody^[j*Maxrot+k].x:=round(cBody^[j+1].r*sin(RotAdd*Pi/180));
   ExpBody^[j*Maxrot+k].z:=round(cBody^[j+1].r*cos(RotAdd*Pi/180));
   ProjBody^[j*Maxrot+k].x:=ExpBody^[j*Maxrot+k].x;
   ProjBody^[j*Maxrot+k].y:=ExpBody^[j*Maxrot+k].y;
   RotAdd:=RotAdd+RotStep;
  End;
 end;
  tempBody^:=ExpBody^;l:=1;start:=1;
  for j:=1 to MaxLines-1 do begin xx:=0;
  for k:=1 to MaxRot-1 do
  begin faces^[l+0].a:=start+xx;faces^[l+0].b:=start+xx+Maxrot;
  faces^[l+0].c:=start+xx+maxrot+1;faces^[l+1].a:=start+xx+1;
  faces^[l+1].b:=start+xx;faces^[l+1].c:=start+xx+maxrot+1;
  xx:=xx+1;l:=l+2;end;
  faces^[l+0].a:=start+maxrot-1;faces^[l+0].b:=start+Maxrot-1+maxrot;
  faces^[l+0].c:=start+maxrot;faces^[l+1].a:=start;
  faces^[l+1].b:=start+maxrot-1;faces^[l+1].c:=start+maxrot;
  l:=l+2;start:=start+maxrot;end;
end;


Procedure Projectx;
Var i:integer;
Begin
For i:=1 to MaxPoints do
Begin Pix3d.x:=TempBody^[i].x;Pix3d.y:=TempBody^[i].y;
 Pix3d.z:=TempBody^[i].z;Project;ProjBody^[i].x:=pix2d.x;
 ProjBody^[i].y:=pix2d.y;end;
end;


Procedure Rotate;
Var i:integer;
    x,y,z:integer;
Begin
x:=xrot mod 360;y:=yrot mod 360;z:=zrot mod 360;
for i:=1 to MaxPoints do
begin Pix3d.x:=ExpBody^[i].x;Pix3d.y:=ExpBody^[i].y;
 Pix3d.z:=ExpBody^[i].z;Rotx(X);Roty(Y);Rotz(Z);
 TempBody^[i].x:=Pix3d.x;TempBody^[i].y:=Pix3d.y;
 TempBody^[i].z:=Pix3d.z;end;
for i:=1 to MaxPoints do
begin pix3d.x:=TVnormal^[i].x;pix3d.y:=TVnormal^[i].y;
 pix3d.z:=TVnormal^[i].z;Rotx(X);Roty(Y);Rotz(Z);
 vnormal^[i].x:=Pix3d.x;vnormal^[i].y:=Pix3d.y;vnormal^[i].z:=Pix3d.z;
end;
end;


Procedure TempToScreen;
begin
   move32(tempscreen^,screen^,64000);
{  for i:=1 to 100 do for j:=1 to 120 do
  alap^[i+110+320*(30+j-1)]:=(tempscreen^[109+i+2+320*(j+30)]+
  tempscreen^[111+i-1+320*(j+30)]+tempscreen^[110+i+320*(j+30+2)]+
  tempscreen^[110+i+320*(j-2+30)]) div 4;                         }
{  move32(alap^,screen^,64000);}
  move32(alap^,tempscreen^,64000);
end;

procedure loadalap;
begin
alap^:=screen^;
end;

{----------------------------------------------------------------------------}
{|                                                                          |}
{|                         M A I N   P R O G R A M                          |}
{|                                                                          |}
{----------------------------------------------------------------------------}

BEGIN
{INITIAL}
  Clrscr;
{Memory init}
  New(CBody);New(ExpBody);New(TempBody);New(VNormal);New(TVnormal);
  New(ProjBody);New(OldBody);New(Faces);New(FNormal);New(Sort);
  New(TempScreen);New(texture);New(alap);New(sq);
  Screen:=Ptr($a000,0);
{init 3d stuff}
 {Create Sinus Table}
   for i:=0 to 2*360-1 do
   begin
   si[i]:=round(100*sin(i*pi/180));
   co[i]:=round(100*cos(i*pi/180));
   end;
 {Objects constans }
   Dist:=100;
   Cor:=0;
   cordist:=cor+dist;
 {Load body}
   CBody^:=Body;{Generatebodys;}
   Decomp;
   Xrot:=0;Yrot:=0;Zrot:=0;
   CreateFnormals;
   CreateVNormals;
 {Init sqrt table}
   for didi:=0 to 55000 do
   Begin
   sq^[didi]:=round(sqrt(didi));
    if (didi div 1000)=(didi/1000)
     then Begin gotoxy(1,1);writeln(didi*100/55000:3:0,'% O.K.!');end;
   End;
 {Load texture }
  vmode($13);
  bmpbetolt('texture.dat');
  for i:=0 to 256 do for j:=0 to 200 do
  texture^[j*256+i]:=screen^[j*320+i];
  rr:=63;bb:=0;gg:=0;b1:=true;b2:=false;b3:=false;
  getintvec($1c,@old);
  setintvec($1c,@palani);
 {createtexture;bmpment('texture.dat');}
 {set palette}
  for i:=1 to 63 do
  szinbeallit(i,0,0,0);
  for i:=0 to 63 do
  szinbeallit(i+64,i,0,0);
  for i:=0 to 63 do
  szinbeallit(i+64*2,63,i,i);
  for i:=0 to 63 do
  szinbeallit(i+64*3,255,255,255);
  szinbeallit(0,0,0,0);
  FillChar(Screen^,64000,Chr(0));
  loadalap;
  tempscreen^:=screen^;
 {MAIN LOOP UNTIL A KEY IS PRESSED  }
 gettime(t1,t2,t3,t4);
        {hh,mm,ss,ms}
 tk:=t4+t3*100+t2*60*100+t1*3600*100;
 frame:=0;
Repeat
 {Transforms }
   Rotate;Normalize;Projectx;Sorting;
 {Show}
  for i:=MaxFaces downto 1 do
  If Visible then Enviroment;
  TempToScreen;
 {Change rotate parameters}
  inc(Xrot,AddXRot);inc(Yrot,AddYRot);inc(Zrot,AddZRot);
  inc(frame);
Until Keypressed;
  gettime(t1,t2,t3,t4);
  tv:=t4+t3*100+t2*60*100+t1*3600*100;
 {END  Main }
  setintvec($1c,@old);
  Readkey;VMode($03);
 {Free memory}
  Dispose(CBody);Dispose(ExpBody);Dispose(TempBody);Dispose(VNormal);
  Dispose(TvNormal);Dispose(ProjBody);Dispose(OldBody);Dispose(Faces);
  Dispose(FNormal);Dispose(Sort);Dispose(TempScreen);dispose(texture);
  dispose(alap);dispose(sq);
  Writeln(frame/((tv-tk)/100):2:2,' frame/sec.');
END.
