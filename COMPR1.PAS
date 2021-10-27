uses crt;
var a:array[1..60000] of byte;
    n,i,j:word;
    k,p,cont:byte;
    f:file;
    s,s1:string[15];
    size:longint;
begin
clrscr;
writeln;
writeln('	-------------------TurboSoft Compressor Version 1.0--------------  ');
writeln;
write('Source file:');readln(s);
write('Destination file:');readln(s1);
assign(f,s);
reset(f,1);
if filesize(f)>=60000 then size:=60000 else size:=filesize(f);
blockread(f,a,size);
close(f);
assign(f,s1);
rewrite(f,1);
cont:=0;
for i:=1 to size do if a[i]=255 then a[i]:=254;
for i:=1 to size do
begin
if cont=255 then
begin
p:=0;
blockwrite(f,p,1);
blockwrite(f,cont,1);
cont:=0;
end;
if a[i]=a[i-1] then inc(cont);
if (cont>3) then
begin
p:=255;
blockwrite(f,p,1);
blockwrite(f,a[i],1);
blockwrite(f,cont,1);
cont:=0;
end
else blockwrite(f,a[i],1);
end;
close(f);
end.