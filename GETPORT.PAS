var f:file;
    k:byte;
    i:integer;
begin
assign(f,'port.dat');
rewrite(f,1);
asm
mov ax,13h
int 10h
end;
for i:=0 to 17 do
begin
port[$3d4]:=i;
k:=port[$3d5];
blockwrite(f,k,1);
end;
close(f);
readln;
asm
mov ax,003h
int 10h
end;
end.z
