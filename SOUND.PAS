var f:file;
   a:array[1..63000] of byte;
   n,i,j:word;
   size:longint;
begin
assign(f,paramstr(1));
reset(f,1);
blockread(f,a,63000);
port[$61]:=port[$61] or 3;
port[$43]:=144;
for i:=1 to 63000 do
begin
port[$42]:=a[i];
for j:=0 to 90 do begin end;
end;
blockread(f,a,63000);
for i:=1 to 63000 do
begin
port[$42]:=a[i];
for j:=0 to 90 do begin end;
end;
close(f);
port[$61]:=port[$61] and $fc;
readln;
end.
