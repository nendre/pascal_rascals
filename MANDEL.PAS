uses crt,vga;
type a=array[1..64000] of byte;
var mx,my,i,j,k,l:longint;
    xx,yy,fx,fy,dx,dy,xmin,xmax,ymin,ymax:longint;
    p1,p2:^a;
    ll,jj,kk:integer;
Procedure Mandel(cx,cy,v,u:longint);
var x1,y1,p,q,r,x,y:longint;
    i,j,k:integer;

Begin
 for i:=1 to mx do
 for j:=1 to my do
 Begin
 p:=xmin+i*dx;q:=ymin+j*dy;
 k:=0;x:=cx;y:=cy;
 repeat
  k:=k+1;
  x1:=(x*x-y*y) div 100+p;
  y1:=2*x*y div 100+q;
  x:=x1;y:=y1;
  r:=(x*x+y*y) div 100;
 until (k>10) or (r>500);
 szin:=k mod 10;
 p1^[(2*(j+u)+1)*320+2*(i+v)]:=szin;
 p1^[(2*(j+u)+1)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v)]:=szin;

 end;
End;

Procedure Newton(cx,cy,v,u:longint);
var x1,y1,p,q,r,x,y:longint;
    i,j,k:integer;

Begin
 for i:=1 to mx do
 for j:=1 to my do
 Begin
 p:=xmin+i*dx;q:=ymin+j*dy;
 k:=0;x:=cx;y:=cy;
 repeat
  k:=k+1;
  x1:=(x*x*x-y*y*y) div 10000-p;
  y1:=3*x*y*(x+y) div 10000-q;
  x:=x1;y:=y1;
  r:=(x*x+y*y) div 100;
 until (k>10) or (r>500);
 szin:=k mod 10;
 p1^[(2*(j+u)+1)*320+2*(i+v)]:=szin;
 p1^[(2*(j+u)+1)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v)]:=szin;

 end;
End;

Procedure Julia(cx,cy,v,u:longint);
var x1,y1,p,q,r,x,y:longint;
    i,j,k:integer;

Begin
 for i:=1 to mx do
 for j:=1 to my do
 Begin
 x:=xmin+i*dx;y:=ymin+j*dy;
 k:=0;p:=cx;q:=cy;
 repeat
  k:=k+1;
  x1:=(x*x-y*y) div 100+p;
  y1:=2*x*y div 100+q;
  x:=x1;y:=y1;
  r:=(x*x+y*y) div 100;
 until (k>10) or (r>500);
 szin:=k mod 10;
 p1^[(2*(j+u)+1)*320+2*(i+v)]:=szin;
 p1^[(2*(j+u)+1)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v)]:=szin;

{ p1^[(2*(j+u+40)+1)*320+2*(i+v)]:=szin;
 p1^[(2*(j+u+40)+1)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u+40)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u+40)*320+2*(i+v)]:=szin;

 p1^[(2*(j+u+40)+1)*320+2*(i+v+40)]:=szin;
 p1^[(2*(j+u+40)+1)*320+2*(i+v+40)+1]:=szin;
 p1^[2*(j+u+40)*320+2*(i+v+40)+1]:=szin;
 p1^[2*(j+u+40)*320+2*(i+v+40)]:=szin;

 p1^[(2*(j+u)+1)*320+2*(i+v+40)]:=szin;
 p1^[(2*(j+u)+1)*320+2*(i+v+40)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v+40)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v+40)]:=szin;
}
 end;
End;


Procedure Newtonj(cx,cy,v,u:longint);
var x1,y1,p,q,r,x,y:longint;
    i,j,k:integer;

Begin
 for i:=1 to mx do
 for j:=1 to my do
 Begin
 x:=xmin+i*dx;y:=ymin+j*dy;
 k:=0;p:=cx;q:=cy;
 repeat
  k:=k+1;
  x1:=(x*x*x-y*y*y) div 10000 -(x*x-y*y) div 100+p;
  y1:=3*x*y*(x+y) div 10000-2*x*y div 100+q;

  x:=x1;y:=y1;
  r:=(x*x+y*y) div 100;
 until (k>10) or (r>500);
 szin:=k mod 10;
 p1^[(2*(j+u)+1)*320+2*(i+v)]:=szin;
 p1^[(2*(j+u)+1)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v)]:=szin;

{ p1^[(2*(j+u+40)+1)*320+2*(i+v)]:=szin;
 p1^[(2*(j+u+40)+1)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u+40)*320+2*(i+v)+1]:=szin;
 p1^[2*(j+u+40)*320+2*(i+v)]:=szin;

 p1^[(2*(j+u+40)+1)*320+2*(i+v+40)]:=szin;
 p1^[(2*(j+u+40)+1)*320+2*(i+v+40)+1]:=szin;
 p1^[2*(j+u+40)*320+2*(i+v+40)+1]:=szin;
 p1^[2*(j+u+40)*320+2*(i+v+40)]:=szin;

 p1^[(2*(j+u)+1)*320+2*(i+v+40)]:=szin;
 p1^[(2*(j+u)+1)*320+2*(i+v+40)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v+40)+1]:=szin;
 p1^[2*(j+u)*320+2*(i+v+40)]:=szin;
}
 end;
End;

procedure delayed;
assembler;
asm
 cli
 mov dx,3daH
@l1:
 in al,dx
 test al,8
 je @l1
@l2:
 in al,dx
 test al,8
 jne @l2
 sti
end;

Begin
 vmode($13);
 xmin:=-200;xmax:=200;ymin:=-200;ymax:=200;
 mx:=40;my:=40;

 xx:=4;
 yy:=9;
 fx:=0;fy:=0;
 for i:=1 to 10 do szinbeallit(i,0,0,i*6);
 randomize;
 new(p1);
 p2:=ptr($a000,0);
 for i:=1 to 64000 do Begin p2^[i]:=0;p1^[i]:=0;end;
 j:=3;
 k:=48;
 l:=55;
 ll:=1;
 kk:=1;
 jj:=1;
 repeat
{ xmax:=xmax-1;ymax:=ymax-1;xmin:=xmin+1;ymin:=ymin+1;}
 dx:=(xmax-xmin) div mx;dy:=(ymax-ymin) div my;
 fx:=fx+xx;fy:=fy+yy;
 if (fx>200) or (fx<(-200)) then xx:=-xx;
 if (fy>200) or (fy<(-200)) then yy:=-yy;
 julia(fx,fy,0,0);
 k:=random(40);
 if k=0 then
 for i:=1 to 10 do szinbeallit(i,(fx div 4),i*6,(fy div 4));
 if ((j>17) or (j<3)) then jj:=-jj;
 if ((k>17) or (k<3)) then kk:=-kk;
 if ((l>17) or (l<3)) then ll:=-ll;
 j:=j+jj;
 k:=k+kk;
 l:=l+ll;
 p2^:=p1^;
 until keypressed;

 readkey;
 dispose(p1);
 p2:=nil;
 vmode($03);
end.

