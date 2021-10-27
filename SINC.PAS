var f:file;
    x,y:array[0..360] of byte;
    i,n:integer;
begin
for i:=0 to 360 do
begin
x[i]:=round(sin(i*pi/180));
y[i]:=round(cos(i*pi/180));
end;
assign(f,'sincos.dat');
rewrite(f,1);
for i:=0 to 360 do
begin
blockwrite(f,x[i],1);
end;
for i:=0 to 360 do
begin
blockwrite(f,y[i],1);
end;
close(f);
end.
