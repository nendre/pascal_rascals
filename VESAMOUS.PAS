Unit Mouse;
uses crt,vga;

{ mouse pointer }
const seta:array[0..15,0..15] of shortint=(
 (2,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
 (2,1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
 (2,1,1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
 (2,1,1,1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
 (2,1,1,1,1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
 (2,1,1,1,1,1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1),
 (2,1,1,1,1,1,1,2,-1,-1,-1,-1,-1,-1,-1,-1),
 (2,1,1,1,1,1,1,1,2,-1,-1,-1,-1,-1,-1,-1),
 (2,1,1,1,1,1,1,1,1,2,-1,-1,-1,-1,-1,-1),
 (2,1,1,1,1,1,1,1,1,1,2,-1,-1,-1,-1,-1),
 (2,1,1,1,1,2,2,2,2,2,2,-1,-1,-1,-1,-1),
 (2,1,1,1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
 (2,1,1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
 (2,1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
 (2,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
 (-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1));
var mode,co,n,m,xmax,ymax,mxmax:word;
    mx,my,mb:word;
    mask:array[0..15,0..15] of byte;  { mask of mouse pointer }
    oldseg,oldofs,oldmask:word;
    newseg,newofs,newmask:word;
    xcor,ycor:word;

{$F+}

procedure newmouse(Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP : word);interrupt;
var hx,hy,hb,ev:word;
    hn,hm:integer;
begin
 ev:=ax;
 hx:=cx div 4;
 hy:=dx;
 hb:=bx;
 if ((hx<>mx) or (hy<>my)) then
  begin
   for hn:=0 to 15 do
    for hm:=0 to  15 do
    Begin
     szin:=mask[hn,hm];
     pont(hm+mx,hn+my);
    end;
   for hn:=0 to 15 do
    for hm:=0 to 15 do
     mask[hn,hm]:=pontle(hx+hm,hy+hn);
   for hn:=0 to 15 do
    for hm:=0 to 15 do
    Begin
     szin:=seta[hn,hm];
     if szin<3 then pont(hx+hm,hy+hn);
    end;
   mx:=hx;
   my:=hy;
  end;
 inline ($8B/ $E5/ $5D/ $07/ $1F/ $5F/ $5E/ $5A/ $59/$5B/ $58/ $CB);
end;

begin
 vmode($5e);
 { pick up (0,0) mask }
 szinbeallit(1,255,255,255);
 szinbeallit(2,0,0,0);
 for n:=0 to 15 do
 for m:=0 to 15 do
   mask[n,m]:=pontle(n,m);
 for n:=0 to 15 do
 for m:=0 to 15 do
 Begin
  szin:=seta[m,n];
  if szin<3 then pont(n,m);
 end;

 newseg:=seg(newmouse);
 newofs:=ofs(newmouse); { pointing to new mouse routine }
 newmask:=1;

 mxmax:=800*4-100;
 ymax:=600;
 asm
  mov ax,0
  int $33    { mouse ? }
  mov ax,1
  int $33    { Show Mouse }
  mov ax,2
  int $33    { Hide Mouse }
  mov ax,7
  mov cx,0
  mov dx,mxmax
  int $33
  mov ax,8
  mov cx,0
  mov dx,ymax  { Set YMAX for mouse windows }
  int $33
  mov ax,20
  mov cx,newmask
  mov es,newseg
  mov dx,newofs
  int $33      { Active USER Mouse Routine }
  mov ax,$000f
  mov cx,4
  mov dx,4
  int $33
 end;
  repeat
   asm
    mov ax,03H
    int 33H
    mov xcor,cx
    mov ycor,dx
   end;
   szin:=1;
   pont(xcor div 4,ycor-10);
  until keypressed;
 readkey;
 asm
  mov ax,20
  mov cx,oldmask
  mov es,oldseg
  mov dx,oldofs
  int $33   { Restore old Mouse Routine }
 end;
 asm
  mov ax,3
  int $10
 end;

end.
