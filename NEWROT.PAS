(*

   .......       . . . .     . . . . .             .......     .......
   .      .     .        .       .                .       .     .      .
   .      .     .        .       .                        .     .       .
   .......      .        .       .       . . .         ..       .       .
   .   .        .        .       .                        .     .       .
   .     .      .        .       .                .       .     .      .
   .      .      . . . .         .                  ......     ........


*)

uses crt,vga,fgraph3d,bmp,graph,dos;

{ C o n s t a n t s - for 3D }

Const Number_of_bodies = 1 ;
      Maxrot           = 10 ;
      MaxLines         = 25;
      RotStep          = 360 div MaxRot;
      MaxPoints        = MaxRot * MaxLines;
      MaxFaces         = 2*MaxRot * (MaxLines-1);
      AddXRot          = 6;
      AddYRot          = 14;
      AddZRot          = 8;

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


{ V a r i a b l e s   f o r   3D }

var ExpBody,
    TempBody,
    TVnormal,
    VNormal  :^TExpBody;
    ProjBody,
    OldBody  :^TProjBody;
    Faces,
    FNormal  :^TFaces;
    Sort     :^TSort;
    Screen,
    alap,texture,TempScreen:^Scr;
    Xrot,Yrot,Zrot:integer;
    Initial_memory:longint;
    Cbody    :^TComprBody;
    i,j,k,l:integer;
    sq:array[0..20000] of word;
    g:word;
    old:procedure;
    aktpal:integer;
    oldpal:paletta;
    mc:byte;
{-------------------------------------------------------------------------}
{ And now the procedures and functions }
{-------------------------------------------------------------------------}

Procedure Panim;interrupt;
var i:integer;
    j:byte;
begin
if aktpal>200 then aktpal:=1;
palbeallit(pal);
szinbeallit(aktpal,mc,mc,mc);
inc(aktpal);
inc(mc,25);
if mc<50 then mc:=150;
inline($9c);
old;
end;

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

function mos(a:real;b:integer):real;
var i:integer;
    c:real;
begin
 c:=a;
for i:=0 to b do
 a:=a*c;
 mos:=a;
end; {func}


function qsqrt(a:integer):integer;
begin
qsqrt:=sq[a];
end;{func}


Procedure fractal;
var i,j,k:word;
    textstart,textrot:word;

procedure upscr;assembler;
asm
 pusha
 push es
 push ds
 mov ax,0a000h
 mov es,ax
 mov ds,ax
 mov si,640{280h}
 xor di,di
 mov cx,16160
 add cx,cx
 rep movsw

 mov di,0fc80h
 mov si,640{280h}
@mut:
 mov ax,textstart
 mov cx,textrot
 add ax,cx
 rol ax,cl
 add cx,5678h
 ror cx,1
 mov textstart,ax
 mov textrot,cx
 add ax,textrot
 dec(textrot)

 sar ax,0ch
 inc ax
{ sub dx,dx
 sub bx,bx}
 xor dx,dx
 xor bx,bx
 mov dl,es:[di+0fec0h]
 mov bl,es:[di+0fec1h]
 add bx,dx
{ sar bx,1}
 shr bx,1
 add ax,bx
 stosb
 dec si
 jnz @mut


 pop ds
 pop es
 popa
end;{Proc}

procedure text;assembler;
asm
pusha
push di
push si
 mov di,0fc80h
 mov si,280h
@mut:
 mov ax,textstart
 mov cx,textrot
 add ax,cx
 rol ax,cl
 add cx,5678h
 ror cx,1
 mov textstart,ax
 mov textrot,cx
 add ax,textrot
 dec(textrot)

 sar ax,0ch
 inc ax
 sub dx,dx
 sub bx,bx
 mov dl,es:[di+0fec0h]
 mov bl,es:[di+0fec1h]
 add bx,dx
 sar bx,1
 add ax,bx
 stosb
 dec si
 jnz @mut
pop si
pop di
popa
end;{Proc}

begin
 textstart:=190;
 textrot:=110;
 j:=0;
for k:=1 to 105 do
begin
 upscr;
end;{for}
end;

Procedure GenerateBodys;
var i,j,k,r:integer;
begin
 randomize;
 r:=10;
 j:=360 div 24;
 k:=0;
 for i:=1 to 25 do
 begin
 cbody^[i].r:=30+round(50*sin(k*pi/180));
 cbody^[i].y:=-round(40*cos(k*pi/180));
 k:=k+j;
 end;{for}
end; {proc}


Procedure Createtexture;
var i,j,k:integer;
     a,b,c,d,e:word;
     q,w:byte;
     r,t:integer;
     lum:array[0..255] of byte;
begin

{M a p i n i t}
for i:=0 to 199 do
for j:=0 to 255 do
begin
   {szin:=(si[i]*co[j]);   }
   {f szin=1 then szin:=2;}
  szin:=0;
  xpont(j,i);
end; {for}


{bmpbetolt('new-4.bmp');}

{ Set Palette }
  for i:=1 to 255 do
  szinbeallit(i,i div 4,i div 4,i div 4);

 {Shift image}

for i:=0 to 200 do
for j:=0 to 260 do
begin
 mem[$a000:i*320+j]:=mem[$a000:i*320+j+60];
 mem[$a000:i*320+j+60]:=0;
end;

{M a p - l i g t h}
a:=200;
j:=-100;
for r:=200 downto 0 do
begin
  b:=sqr(j);
  k:=-128;
  for t:=255 downto 0 do
  begin
   c:=sqr(k);
   d:=round(sqrt(b+c));
   if d<127 then
   begin
{    q:=64-d;
    q:=pontle(t,r)+q{+lum[d+1]}
    {q:=255-d*2+pontle(t,r);}
    q:=15+round(80*cos((d*70/128)*pi/180)+(160*mos(cos((d*90/128)*pi/180),100)));
      szin:=q;
{    szin:=(q+pontle(t,r)) div 2;}

    xpont(t,r);
    texture^[t+r*256]:=szin;
   end
    else
   begin
   texture^[t+r*256]:=0;szin:=0;xpont(t,r);
   end;{if}
    k:=k+1;
   end;{for}
   j:=j+1;
  end;{for}

{P a l e t t e  -  a n i m }
for k:=1 to 10 do
 for i:=0 to 255 do
 begin
 for j:=1 to 255 do
 begin
 szinbeallit(i+j,j div 4,j div 4,j div 4);
 end;{for}
 end;{for}

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

procedure xxpont(x,y:word;sg,ofs:word);assembler;
asm
 mov ax,x
 mov bx,y
 mov cl,white
 shl bx,6
 add ax,bx
 shl bx,2
 add bx,ax
 mov ax,sg
 mov es,ax
 mov ax,ofs
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
    i,j,k:word;
    envMiny,envMaxy:integer;
    envxinc,envnxinc,envnyinc:real;
    envScanStart,
    envScanStop,
    envScanLeftx,
    envScanLefty,
    envScanRightx,
    envScanRighty:array[1..200] of integer;
    z:integer;
    sc,scnx,scny:real;
Procedure Scan(a,b:integer);
var i,j,k:integer;
len:integer;
begin
if (envsc[a].y=envsc[b].y) then exit;
if (envsc[a].y<envsc[b].y) then
  begin
       z:=a;
       a:=b;
       b:=z;
  end;
len:=envsc[a].y-envsc[b].y;
envXinc:=(envsc[a].x-envsc[b].x)/len;
envnXinc:=(envnsc[a].x-envnsc[b].x)/len;
envnyinc:=(envnsc[a].y-envnsc[b].y)/len;
sc:=envsc[b].x;
scnx:=envnsc[b].x;
scny:=envnsc[b].y;
for i:=envsc[b].y to envsc[b].y+len-1 do
begin
 sc:=sc+envxinc;
 scnx:=scnx+envnxinc;
 scny:=scny+envnyinc;
 if (envscanstart[i]=16000) then
 begin
 envscanstart[i]:=round(sc);
 envscanleftx[i]:=round(scnx);
 envscanlefty[i]:=round(scny);
 end
 else
 begin
 envscanstop[i]:=round(sc);
 envscanrightx[i]:=round(scnx);
 envscanrighty[i]:=round(scny);
 end;
end;


end; {scan}

Procedure Draw(a:integer);
var x,y,b:integer;
    xx,yy:real;
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
 envnxinc:=(envscanrightx[a]-envscanleftx[a])/(envscanstop[a]-envscanstart[a]);
 envnyinc:=(envscanrighty[a]-envscanlefty[a])/(envscanstop[a]-envscanstart[a]);
 xx:=envscanleftx[a];
 yy:=envscanlefty[a];
 for k:=envscanstart[a] to envscanstop[a] do
 begin
  xx:=xx+envnxinc;
  yy:=yy+envnyinc;
  x:=round(xx+128);
  y:=round(yy+100);
  szin:=texture^[x+y*256];
  xxpont(k,a,seg(tempscreen^),ofs(tempscreen^));
end;


end; {Draw}


Begin

 { load projected data and normals  }
 envsc[1].x:=ProjBody^[faces^[l].a].x+160;
 envsc[2].x:=ProjBody^[faces^[l].b].x+160;
 envsc[3].x:=ProjBody^[faces^[l].c].x+160;
 envsc[1].y:=ProjBody^[faces^[l].a].y+100;
 envsc[2].y:=ProjBody^[faces^[l].b].y+100;
 envsc[3].y:=ProjBody^[faces^[l].c].y+100;
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

Procedure DrawObj;
var q1,w1,q2,w2,q3,w3:integer;
   qmin,qmax,wmin,wmax:integer;
   i,j,k:word;
   a,b,c:integer;
   table:array[0..2000] of integer;
   po:array[1..2,1..3] of integer;
     nxr,nyr,nzr:longint;
procedure scanline(q,w:word);
var cx,m:integer;
    s,nx,ny,nxinc,nyinc,xinc:real;
begin
if po[2,q]>po[2,w] then begin m:=q;q:=w;w:=m;end;
cx:=po[2,w]-po[2,q];
if cx=0 then exit;
xinc:=((po[1,w]-po[1,q])/cx);
s:=po[1,q];
m:=po[2,q];
repeat
s:=s+xinc;
 if table[m]=10000 then
 begin
  table[m]:=round(s);
 end
   else
 begin
 table[m+1000]:=round(s);

 end;
 m:=m+1;
dec(cx);
until cx=0;
end;

begin
szin:=l;
  q1:=ProjBody^[faces^[l].a].x+160;
  q2:=ProjBody^[faces^[l].b].x+160;
  q3:=ProjBody^[faces^[l].c].x+160;
  w1:=ProjBody^[faces^[l].a].y+100;
  w2:=ProjBody^[faces^[l].b].y+100;
  w3:=ProjBody^[faces^[l].c].y+100;
po[1,1]:=q1;
po[1,2]:=q2;
po[1,3]:=q3;
po[2,1]:=w1;
po[2,2]:=w2;
po[2,3]:=w3;


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
for i:=wmin to wmin+(wmax-wmin)+1 do
table[i]:=10000;
scanline(1,2);
scanline(2,3);
scanline(1,3);
  szin:=l;

for i:=wmin to wmin+(wmax-wmin) do
begin
if table[i]=10000 then continue;
if table[i]>table[i+1000] then
begin
a:=table[i];
b:=table[i+1000];
end
else
begin
a:=table[i+1000];
b:=table[i];
end;
if b=a then continue;
for j:=b to a do
 xpont(j,i{,seg(TempScreen^),ofs(TempScreen^)});
end;
end;


Procedure DrawObject;
var q1,q2,q3,w1,w2,w3,wmin,wmax,qmin,qmax:integer;
    a,b,c,k,j:integer;
    nxr,nyr,nzr:longint;
begin
  q1:=ProjBody^[faces^[l].a].x+160;
  q2:=ProjBody^[faces^[l].b].x+160;
  q3:=ProjBody^[faces^[l].c].x+160;
  w1:=ProjBody^[faces^[l].a].y+100;
  w2:=ProjBody^[faces^[l].b].y+100;
  w3:=ProjBody^[faces^[l].c].y+100;
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

  nxr:=round((Vnormal^[faces^[l].a].x)+
            (Vnormal^[faces^[l].b].x)
            {(Vnormal^[faces^[l].c].x )});
  nyr:=round((Vnormal^[faces^[l].a].y)+
            (Vnormal^[faces^[l].b].y)
            {(Vnormal^[faces^[l].c].y )});
  nzr:=round((Vnormal^[faces^[l].a].z)+
            (Vnormal^[faces^[l].b].z)
            {(Vnormal^[faces^[l].c].z )});
  nxr:=nxr div 2;
  nyr:=nyr div 2;
  nzr:=nzr div 2;
  nxr:=sqr(nxr);
  nyr:=sqr(nyr);
  nzr:=sqr(nzr);

  nxr:=round(sqrt(nxr+nyr+nzr));
      nzr:=round((Vnormal^[faces^[l].a].z)+
             (Vnormal^[faces^[l].b].z)
             {(Vnormal^[faces^[l].c].z )}) div 2;

  nxr:=round(127*((nzr/nxr)+1));
  szin:=nxr;
  for k:=qmin to qmax do
  begin
  for j:=wmin to wmax do
  begin
  a:=(k-q1)*(w2-w1)-(q2-q1)*(j-w1);
  b:=(k-q2)*(w3-w2)-(q3-q2)*(j-w2);
  c:=(k-q3)*(w1-w3)-(q1-q3)*(j-w3);
 if  ((b<1) and (c<1) and (a<1)) then
    xxpont(k,j,seg(TempScreen^),ofs(TempScreen^));
 end;
 end;
end;

Procedure Sorting;
var i,j,k,l:integer;
Begin
 l:=0;
 for i:=1 to MaxFaces do
 begin
  Sort^[i].y:=i;
  Sort^[i].x:=TempBody^[Faces^[i].a].z+
              TempBody^[Faces^[i].b].z+
              TempBody^[Faces^[i].c].z ;
 end;

 for i:=MaxFaces downto 2 do
 begin
  l:=0;
  for k:=1 to (i-1) do
  begin
   if ((Sort^[k].x)>(Sort^[k+1].x)) then
    begin
     l            := 1;
     j            := Sort^[k].x;
     Sort^[k].x   := Sort^[k+1].x;
     Sort^[k+1].x := j;
     j            := Sort^[k].y;
     Sort^[k].y   := Sort^[k+1].y;
     Sort^[k+1].y := j;
    end;
   end;
   if (l=0) then exit;
  end;
end;


Procedure CreateFNormals;
var i,j,k:integer;
Begin
 for i:=1 to MaxFaces do
 begin
  FNormal^[i].a:=((ExpBody^[Faces^[i].a].y-
                   ExpBody^[Faces^[i].b].y)*
                  (ExpBody^[Faces^[i].a].z-
                   ExpBody^[Faces^[i].c].z)-
                  (ExpBody^[Faces^[i].a].z-
                   ExpBody^[Faces^[i].b].z)*
                  (ExpBody^[Faces^[i].a].y-
                   ExpBody^[Faces^[i].c].y));

  FNormal^[i].b:=((ExpBody^[Faces^[i].a].z-
                   ExpBody^[Faces^[i].b].z)*
                  (ExpBody^[Faces^[i].a].x-
                   ExpBody^[Faces^[i].c].x)-
                  (ExpBody^[Faces^[i].a].x-
                   ExpBody^[Faces^[i].b].x)*
                  (ExpBody^[Faces^[i].a].z-
                   ExpBody^[Faces^[i].c].z));

  FNormal^[i].c:=((ExpBody^[Faces^[i].a].x-
                   ExpBody^[Faces^[i].b].x)*
                  (ExpBody^[Faces^[i].a].y-
                   ExpBody^[Faces^[i].c].y)-
                  (ExpBody^[Faces^[i].a].y-
                   ExpBody^[Faces^[i].b].y)*
                  (ExpBody^[Faces^[i].a].x-
                   ExpBody^[Faces^[i].c].x));

 end;
end;


Procedure CreateVNormals;
var i,j,k:integer;
    NX,NY,NZ:integer;
begin
 for i:=1 to MaxPoints do
 Begin
  nx:=0;
  ny:=0;
  nz:=0;
  for j:=1 to MaxFaces do
  Begin
   if ((faces^[j].a=i) or
       (faces^[j].b=i) or
       (faces^[j].c=i)) then
      begin
      nx:=nx+fnormal^[j].a;
      ny:=ny+fnormal^[j].b;
      nz:=nz+fnormal^[j].c;
      end;
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
  eax:=vnormal^[i].x;
  eax:=eax*eax;
  ecx:=eax;
  eax:=vnormal^[i].y;
  eax:=eax*eax;
  ecx:=ecx+eax;
  eax:=vnormal^[i].z;
  eax:=eax*eax;
  ecx:=ecx+eax;
  eax:=round(sqrt(ecx));
{  if eax=0 then eax:=1;}
  begin
  x:=(99*vnormal^[i].x div eax);
  y:=(99*vnormal^[i].y div eax);
  z:=(99*vnormal^[i].z div eax);
  end;
  vnormal^[i].x:=x;
  vnormal^[i].y:=y;
  vnormal^[i].z:=z;
 end;
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
  tempBody^:=ExpBody^;
  l:=1;
  start:=1;
  for j:=1 to MaxLines-1 do
  begin
  xx:=0;
  for k:=1 to MaxRot-1 do
  begin
  faces^[l+0].a:=start+xx;
  faces^[l+0].b:=start+xx+Maxrot;
  faces^[l+0].c:=start+xx+maxrot+1;
  faces^[l+1].a:=start+xx+1;
  faces^[l+1].b:=start+xx;
  faces^[l+1].c:=start+xx+maxrot+1;
  xx:=xx+1;
  l:=l+2;
  end;
  faces^[l+0].a:=start+maxrot-1;
  faces^[l+0].b:=start+Maxrot-1+maxrot;
  faces^[l+0].c:=start+maxrot;
  faces^[l+1].a:=start;
  faces^[l+1].b:=start+maxrot-1;
  faces^[l+1].c:=start+maxrot;
  l:=l+2;
  start:=start+maxrot;
 end;
end;


Procedure Projectx;
Var i:integer;
Begin
For i:=1 to MaxPoints do
Begin
 Pix3d.x:=TempBody^[i].x;
 Pix3d.y:=TempBody^[i].y;
 Pix3d.z:=TempBody^[i].z;
 Project;
 ProjBody^[i].x:=pix2d.x;
 ProjBody^[i].y:=pix2d.y;
end;
end;


Procedure Rotate;
Var i:integer;
Begin
for i:=1 to MaxPoints do
begin
 Pix3d.x:=ExpBody^[i].x;
 Pix3d.y:=ExpBody^[i].y;
 Pix3d.z:=ExpBody^[i].z;
 Rotx(Xrot);
 Roty(Yrot);
 Rotz(Zrot);
 TempBody^[i].x:=Pix3d.x;
 TempBody^[i].y:=Pix3d.y;
 TempBody^[i].z:=Pix3d.z;
end;
for i:=1 to MaxPoints do
begin
 pix3d.x:=TVnormal^[i].x;
 pix3d.y:=TVnormal^[i].y;
 pix3d.z:=TVnormal^[i].z;
 Rotx(Xrot);
 Roty(Yrot);
 Rotz(Zrot);
 vnormal^[i].x:=Pix3d.x;
 vnormal^[i].y:=Pix3d.y;
 vnormal^[i].z:=Pix3d.z;
end;
end;


Procedure TempToScreen;
var s1,s2,o1,o2:word;
begin
  s1:=seg(Screen^);
  s2:=seg(TempScreen^);
  o1:=ofs(Screen^);
  o2:=ofs(TempScreen^);
{asm
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
; mov ax,s2
; mov es,ax
; mov di,o2
; mov cx,32000
; mov ax,356
; rep stosw
pop si
pop ds
pop di
pop es
popa
end;}
screen^:=tempscreen^;
tempscreen^:=alap^;
end;

procedure loadalap;
begin
{bmpbetolt('tajkep04.bmp');}
alap^:=screen^;
end;

procedure fire;
type a = array[0..64000] of byte;
var v,f,n,i,j,k,l:word;
     gd,gm:integer;
    p4,p3,p1,p2:^a;
    s:array[0..10] of string[20];
begin
new(p1);
p2:=ptr($a000,0);
p4:=ptr(seg(p1^),ofs(p1^)+320);
gd:=installuserdriver('svga256',nil);
gm:=0;
initgraph(gd,gm,'d:\pascal\bgi');
vmode($13);
s[0]:='TRUBO';
s[1]:='PASCAL';
s[2]:='present';
s[3]:=' ';
s[4]:='the';
s[5]:='intro';
s[6]:='GRAPH';
s[8]:='3D';

settextstyle(defaultfont,horizdir,4);
setcolor(255);
cleardevice;

{outtextxy(30,70,'ASM - 97');}
{outtextxy(30,70,'ASM - 97');}
bmpbetolt('kep1.bmp');
p1^:=p2^;
n:=1;
for i:=0 to 255 do
szinbeallit(i,i div 4,i div 4,i div 4);
l:=0;
f:=0;
for v:=1 to 6*11 do
begin
f:=f+1;
if f>6 then f:=0;
{n:=n+1;}
for i:=70 to 125 do
begin
for j:=20 to 285 do
begin
szin:=(p1^[i*320+j+n]+p1^[i*320+j-n]+p1^[(i+n)*320+j-n]+p1^[(i+n)*320+j+n]
+ p1^[(i-n)*320+j+n]+p1^[(i-n)*320+j-n]+p1^[(i-n)*320+j]+p1^[(i+n)*320+j]) div 8; if p1^[i*320+j]>15 then dec(p1^[i*320+j],15);
szin:=(szin+p1^[i*320+j]) div 2;
xpont(j,i);
end;

end;
{for j:=0 to 255 do
szinbeallit(j+k,j div 4,j div 4,j div 4);
k:=k+50;}
{outtextxy(30,70,'ASM - 97');}
randomize;
settextstyle(0,horizdir,3);
settextjustify(centertext,centertext);
if f=5 then begin outtextxy(getmaxx div 2,getmaxy div 2,s[l]);l:=l+1;end;
if l>9 then l:=0;

{for i:=21 to 284 do
begin
szin:=random(255);
xpont(i,164);
end;}

p1^:=p2^;

{for i:=0 to 199 do
for j:=0 to 319 do
p1^[j+i*320]:=p1^[j+(i+1)*320];}
{p1^:=p4^;}
{for i:=320*199-319 downto 320*199-4*319 do
p1^[i]:=random(255);}
end;
{vmode($03);}
dispose(p1);

end;





{----------------------------------------------------------------------------}
{|                                                                          |}
{|                         M A I N   P R O G R A M                          |}
{|                                                                          |}
{----------------------------------------------------------------------------}

BEGIN
 {INITIAL}
 Clrscr;
 Writeln('Free mem before:',memavail);
 Initial_Memory:=64000+4*12*MaxPoints+2*8*MaxPoints+
                 2*12*MaxFaces+8*MaxFaces+20000+25*4;
 Writeln('Wanted memory  :',Initial_Memory);
 if Initial_Memory>MemAvail then
     Begin
      Writeln('Not enough memory...');
      Halt(1);
     End;
  New(CBody);
  New(ExpBody);
  New(TempBody);
  New(VNormal);
  New(TVnormal);
  New(ProjBody);
  New(OldBody);
  New(Faces);
  New(FNormal);
  New(Sort);
  New(TempScreen);
  new(texture);
  new(alap);
  Screen:=Ptr($a000,0);
  Writeln('Free mem After :',memavail);
  {Create Sinus Table}
   for i:=0 to 2*360-1 do
   begin
   si[i]:=round(100*sin(i*pi/180));
   co[i]:=round(100*cos(i*pi/180));
   end;
{   Fire;}
   Vmode($13);
   palleolvas(oldpal);
  {Initial settings}
   Dist:=100;
   Cor:=0;
{   CBody^:=Body;}

   generatebodys;
   Decomp;
   Xrot:=0;
   Yrot:=0;
   zrot:=0;
   CreateFnormals;
   CreateVNormals;
{   for i:=0 to 20000 do
   sq[i]:=round(sqrt(i));}


   Rotate;
   Normalize;
   Projectx;
   Sorting;

{  for i:=1 to 255 do
  szinbeallit(i,0,0,0);}
       for i:=1 to 255 do
  szinbeallit(i,i div 4,i div 4,i div 4);
  bmpbetolt('texture.dat');
  for i:=0 to 256 do
  for j:=0 to 200 do
  texture^[j*256+i]:=screen^[j*320+i];
{  createtexture;
  bmpment('texture.dat');}
     FillChar(Screen^,64000,Chr(0));
     for i:=1 to 255 do
  szinbeallit(i,i div 4,i div 4,i div 4);

   fractal;
   FillChar(Screen^,64000,Chr(0));
   palleolvas(pal);
   szinbeallit(0,40,40,40);
   for g:=0 to 64000 do
   if mem[$a000:g]>40 then mem[$a000:g]:=mem[$a000:g]-40 else mem[$a000:g]:=0;
  loadalap;
  tempscreen^:=screen^;

{  readkey;}

 {MAIN   }
Repeat

   Rotate;
   Normalize;
   Projectx;
   Sorting;
  for i:=MaxFaces downto 1 do
  If Visible then Enviroment;
   TempToScreen;
   inc(Xrot,AddXRot);
 { inc(Yrot,AddYRot);}
   inc(Zrot,AddZRot);
   if Xrot>359 then Xrot:=0;
   if Yrot>359 then Yrot:=0;
   if Zrot>359 then Zrot:=0;
Until Keypressed;
 {END    }

  Readkey;
  palbeallit(oldpal);
  VMode($03);
  Dispose(CBody);
  Dispose(ExpBody);
  Dispose(TempBody);
  Dispose(VNormal);
  Dispose(TvNormal);
  Dispose(ProjBody);
  Dispose(OldBody);
  Dispose(Faces);
  Dispose(FNormal);
  Dispose(Sort);
  Dispose(TempScreen);
  dispose(texture);
  dispose(alap);

 Writeln('Normal shutdown.');
 Writeln('Free mem end   :',memavail);

END.
