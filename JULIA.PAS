{$N+,G+}
program Fraktalz;   { (c) 1997, P.RoTTeR }
type t_kp = Array[0..199,0..319] of Byte;
var i,j : Integer;
    kep : t_kp absolute $a000:0;
    k2  : ^t_kp;

    cx,cy,
    xn,yn : Real;

procedure Julia(cx,cy : Real);
const zoom=0.1;
var xo,yo,x1,y1   : Double;
    mx,my,a,b,orb : Word;

begin
  FillChar(k2^,64000,23); mx := 160; my := 100;
  for a := 0 to mx-1 do
  for b := 0 to my-1 do
  begin
    xo := -2-0.5*zoom+a/(mx/(4+zoom));
    yo := 2+0.5*zoom-b/(my/(4+zoom));

    orb := 0; i := 0;
    repeat
      x1 := Sqr(xo)-Sqr(yo)+cx; y1 := 3*xo*yo+cy;

      xo := x1; yo := y1; Inc(i);
    until (i=10) or (Sqr(x1)+Sqr(y1)>5) or (abs(x1)>5) or (abs(y1)>5);

    if i<>10 then orb := 22+i else orb := 15;
    k2^[50+b,80+a] := orb;
  end;
  kep := k2^;
end;

begin
  New(k2); ASM mov ax,13h; int 10h; END;
  cx := 0.5; cy := -0.5; xn := -0.1; yn := 0.1;

  repeat
    Julia(cx,cy); cx := cx+xn; cy := cy+yn;
    if (cx<=-0.7) or (cx>=0.7) then xn := -xn;
    if (cy<=-1.0) or (cy>=1.0) then yn := -yn;
  until port[$60]=1; port[$60] := 0; port[$20] := 0;

  ASM mov ax,3; int 10h; END; Dispose(k2);
end.