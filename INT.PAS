{$M $1024,0,0}
uses crt,dos;
var i,j,k:integer;
    old:procedure;
    a1,b1,c1,d1:word;
    l1,l2:longint;

Procedure delayed;
assembler;
asm
cli
 mov dx,3daH
@l1:
 in al,dx
 test al,8
 jne @l1
@l2:
 in al,dx
 test al,8
 je @l2
sti;
end;

{$F+}
Procedure Ora;
interrupt;
var i:integer;
    a,b,c,d:word;
    x,y:integer;
Begin
 i:=i+1;
 if i>15 then
 Begin
  i:=0;
  gettime(a,b,c,d);
  l2:=c+b*60+a*3600;
  x:=wherex;
  y:=wherey;
  gotoxy(1,1);
{  write(a:2,':',b:2,':',c:2);}
{ delayed;}
  write(l2-l1:5,' sec         ');
  gotoxy(x,y);
 end;
 inline($9c);
 old;
End;
{$F-}
Begin
 gettime(a1,b1,c1,d1);
 l1:=c1+b1*60+a1*3600;

 clrscr;
 getintvec($1c,@old);
 setintvec($1c,@ora);
  repeat
   k:=k+1;
   gotoxy(10,10);
   delayed;
   writeln(k:6);
  until (l2-l1)>31;

 setintvec($1c,@old);
End.