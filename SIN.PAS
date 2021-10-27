Uses crt,vga;
var l,i,j,k:integer ;
    r,m,n:real;
    c:array[1..800] of byte;
    b,a:array[1..60] of real;
Begin
 vmode($5e);
 szin:=white;
 randomize;
 for i:=1 to 60 do a[i]:=ln(i)/(ln(2));
 for i:=1 to 60 do b[i]:=random(5);
  for i:=1 to 800 do
   Begin
   m:=0;
   for j:=1 to 10 do
   {m:=m+a[j]*sin(2*pi*j*(i-1)/800)+b[j]*cos(2*pi*j*(i-1)/800);}
   m:=m+((17*50/pi)/(j*17-2)) * sin(2*pi*2*(j*17-2)*(i-1)/800);
   pont(i,300+round(m));
   c[i]:=round(127+m);
  end;
  i:=200;
  repeat
  for j:=1 to 800 do
  Begin
  for k:=1 to i do begin end;
  port[$378]:=c[j];
  end;
  i:=i-1;
  until keypressed;

  readkey;
 vmode($03);

End.
