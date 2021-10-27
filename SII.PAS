uses crt,vga;
var si,co:array[0..500] of integer;
   i,j,k:integer;
   m:real;
   sz:array[0..200,0..200] of byte;
   qs:array[0..10000] of word;
begin
for i:=0 to 500 do
begin
si[i]:=round(255*sin(i*pi/180));
co[i]:=round(255*cos(i*pi/180));
end;
vmode($13);
for i:=1 to 255 do
szinbeallit(i,i div 4,i div 4,i div 4);
m:=0;
{port[$3d4]:=$9;
port[$3d5]:=10;}
for i:=0 to 10000 do
qs[i]:=round(sqrt(i));
k:=-100;
repeat
for i:=0 to 200 do
begin
for j:=0 to 200 do
begin
sz[i,j]:=i+j+qs[sqr(i-100)+sqr(j-100)];

end;
end;
for i:=0 to 200 do
for j:=0 to 200 do
begin
szin:=sz[i,j];
xpont(i,j);
end;

{for i:=0 to 255 do
szinbeallit(k+i,i div 4,i div 4,i div 4);}
k:=k+1;
until keypressed;

readkey;

repeat
for i:=0 to 255 do
szinbeallit(k+i,i div 4,i div 4,i div 4);
inc(k);
until keypressed;
readkey;
vmode($03);
end.