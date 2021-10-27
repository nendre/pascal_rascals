uses crt,vga;
var i,j,k:word;
    a:array[0..320] of byte;
    h,p,max:integer;

procedure switch(a:integer);
begin
{for i:=120 to 160 do
for j:=0 to 20 do
xpont(i,j);}
a:=a div 10;
szinbeallit(100,a div 4,a div 4,a div 4);
end;

begin
vmode($13);
for i:=0 to 64000-1 do
mem[$a000:i]:=0;
k:=0;
szin:=100;
for i:=120 to 160 do
for j:=0 to 20 do
xpont(i,j);
h:=0;
repeat
j:=port[$220+10];
szin:=0;
xpont(k,a[k]);
szin:=white;
xpont(k,j);
a[k]:=j;
if k>320 then begin k:=0;h:=0;delay(1);end;
p:=abs(j-128);
if h<1 then if p<0 then switch(max);
if h<1 then if p>25 then begin max:=2500;switch(max);h:=200;end;
if max>10 then max:=max-1;
k:=k+1;
{if h>0 then h:=h-1;}
until keypressed;
readkey;
vmode($03);
end.
