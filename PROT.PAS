uses crt,vga;
var i,j,k:integer;
begin
vmode($13);
szin:=white;
j:=0;
i:=0;
repeat
j:=0;
repeat
pont(100+round(50*sin(i*pi/180)+20*sin(j*pi/180))
    ,100+round(50*cos(i*pi/180)+20*sin(i*pi/180)));
j:=j+360 div 20;
until j>=360;
i:=i+360 div 20;

until i>=360;
readkey;
vmode($03);
end.
