var f:file;
    k:byte;
    i:integer;
begin
assign(f,'port.dat');
reset(f,1);
for i:=0 to 17 do
begin
blockread(f,k,1);
writeln(' 3D4h	',i,'	     ',' 3D5h  ',k);
end;
close(f);
readln;
end.
