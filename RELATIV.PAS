uses crt,vga;
Const c = 2.99792458 * 100000000 ;
var a,x1,x2,beta,t1,t2,v1,v2:real;
    i:integer;
begin
vmode($13);
szin:=white;
t1:=10;
v1:=c-c/100000000;
a:=0.9;
for i:=0 to 320 do
begin
v1:=c*a;
beta:=(v1*v1)/(c*c);
t1:=1/sqrt(1-beta);
xpont(i,199-round(t1));
a:=a+0.01;
end;
readkey;
vmode($03);
End.