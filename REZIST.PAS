uses crt;
var i,j,k:integer;
    ro,r:real;
Begin
clrscr;
 r:=3.9;
 ro:=4.7;
 writeln('R1+10%=',(r+(r/10)):2:2);
 writeln('R2-10%=',(ro-(ro/10)):2:2);
 writeln('Elteres:',((r+(r/10))-(ro-(ro/10))):2:2);
{ repeat
  writeln('R:',(r/1000):2:1,' Kohm');
 readkey;
 ro:=r;
 r:=int(100*r*(11/9))/100;

 until keypressed;}
 readkey;
End.