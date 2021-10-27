uses crt,vga;
var  b:array[0..800] of integer;
 i,j,k:integer;
 a:integer;
begin
vmode($5e);
k:=0;
a:=60;
repeat
j:=port[$220+10];
j:=j-127;
j:=j* 3;
a:=abs(j) div 30;
j:=j+300;

szin:=white;
if (k div 35)=(k/35) then
begin
pont(a,0);
pont(a+1,0);
pont(a,1);
pont(a+1,1);

end;
pont(k,j);
szin:=black;
if (k div 35)=(k/35) then
begin
i:=a;
a:=b[799];
b[799]:=i;

pont(a,0);
pont(a+1,0);
pont(a,1);
pont(a+1,1);

end;
pont(k,b[k]);
b[k]:=j;
k:=k+1;
if k>790 then k:=0;
until keypressed;
readkey;
vmode($03);
end.