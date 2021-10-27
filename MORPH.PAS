{$N+}
program Morpheus;   {   (c) 1997, Plastic RoTTeR   }
                    { 100% my source and it works! }
const nm=1500;      { Did you hear TERROR.XM ?!?!? }
      mv=100;
type t_mp = Array[1..nm] of Record x,y : Real; End;
     t_mm = Array[1..nm] of Record x,y : Real; End;
     t_kp = Array[0..199,0..319] of Byte;
var m1,m2 : t_mp;
    mm    : t_mm;
    i,j   : Integer;
    kep   : t_kp absolute $a000:0;
    k1    : ^t_kp;
    vv    : Real;

procedure VerticalRetrace; Assembler;
ASM
  mov  dx,3DAh
 @1: in  al,dx; test al,8; jz  @1
 @2: in  al,dx; test al,8; jnz @2
END;

procedure CalcDist;
var ii : Integer;

begin
  for ii := 1 to nm do
  with mm[ii] do
  begin
    x := (m2[ii].x-m1[ii].x)/mv; y := (m2[ii].y-m1[ii].y)/mv;
  end;
end;

procedure Morph;
var ii,jj : Integer;

begin
  for jj := 0 to mv do
  begin
    FillChar(k1^,SizeOf(k1^),0);
    for ii := 1 to nm do
    begin
      if ((m1[ii].x>=0) and (m1[ii].x<=199)) and
         ((m1[ii].y>=0) and (m1[ii].y<=319)) then
      k1^[Round(m1[ii].x),Round(m1[ii].y)] := 31-ii mod 5;

      m1[ii].x := m1[ii].x+mm[ii].x; m1[ii].y := m1[ii].y+mm[ii].y;
    end;
    Move(k1^,kep,SizeOf(k1^));
  end;
end;



begin
  ASM mov ax,13h; int 10h; END; New(k1); Randomize;
  {1}
  for i := 1 to nm do
  begin
    with m1[i] do begin x := Random(150); y := Random(260); end;
    with m2[i] do begin x := 199-i/20-Random(10); y := 319-i/20-Random(10); end;
  end;

  CalcDist; Morph;
  {2}
  for i := 1 to nm do
  with m2[i] do begin x := Random(20); y := Random(20); end;

  CalcDist; Morph;
  {3}
  for i := 1 to nm do
  with m2[i] do begin x := Random(200); y := Random(320); end;

  CalcDist; Morph;
  {4}
  for i := 1 to nm do
  with m2[i] do begin x := 100; y := 160; end;

  CalcDist; Morph;

  ASM mov ax,3; int 10h; END; Dispose(k1);
end.