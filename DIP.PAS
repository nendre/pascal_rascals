{$m $9000,0,6000}
uses crt,vga;
var i,j,k:integer;

procedure rajz(x,y,x1,y1:integer);
var a,b,c,d,s,p:integer;
begin
 s:=x+(x1-x) div 2;
 p:=y+(y1-y) div 2;
 if (not((s-x)<1)) then if (not ((p-y)<1)) then
 begin
 a:=pontle(x,y);
 b:=pontle(x1,y);
 c:=pontle(x1,y1);
 d:=pontle(x,y1);
 szin:=(a+b) div 2;
 pont(s,y);
{ pont(s+1,y);}
 szin:=(c+d) div 2;
 pont(s,y1);
{ pont(s+1,y1);}
 szin:=(a+d) div 2;
 pont(x,p);
{ pont(x,p+1);}
 szin:=(b+c) div 2;
 pont(x1,p);
{ pont(x1,p+1);}
 szin:=(a+c) div 2;
 pont(s,p);
{ pont(s+1,p+1);}
 szin:=(b+d) div 2;
 pont(s+1,p);
{ pont(s,p+1);}
 rajz(x,y,s,p);
 rajz(s,y,x1,p);
 rajz(s,p,x1,y1);
 rajz(x,p,s,y1);
end;
end;

begin
randomize;
vmode($13);
for i:=1 to 255 do
szinbeallit(i,i div 4,i div 4,i div 4);
repeat
szin:=random(255);
pont(0,0);
szin:=random(255);
pont(319,199);
szin:=random(255);
pont(0,199);
szin:=random(255);
pont(319,0);
rajz(0,0,319,199);
repeat
for i:=0 to 255 do
for j:=0 to 255 do
begin
 szinbeallit(i+j,j div 4,j div 4,j div 4);
end;
until keypressed;
readkey;
until keypressed;
readkey;
vmode($04);
end.
