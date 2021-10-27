uses crt;
var f:file;
a:array[1..2] of byte;
begin
a[1]:=ord('a');
a[2]:=ord('b');
assign(f,'kk.dat');
rewrite(f,1);
blockwrite(f,a,2);
close(f);
end.