uses crt;

var i,j,k:integer;
    f:file;
    s:string;
    c:char;
    a:array[1..30000] of byte;
begin
s:=paramstr(1);
val(s,j,i);
k:=0;
for i:=1 to 30000 do
begin
a[i]:=j+k;
k:=k+1;
end;
assign(f,'dado.dat');
rewrite(f,1);
blockwrite(f,a,30000);
close(f);
end.