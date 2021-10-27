{$G+}
{$F+}
uses dos,sounds;
var kbdint:procedure;
    f:file;
    n,i,j:word;
    a:array[1..100] of word;
procedure noint;
begin
setintvec($9,@kbdint);
end;
procedure initsound;
begin
port[$61]:=port[$61] or 3;
end;
procedure sound(n:word);
begin
initsound;
port[$42]:=lo(n);
port[$42]:=hi(n);
a[i]:=n;
end;
procedure nosound;
begin
port[$61]:=port[$61] and $fd;
end;
{$F+}
procedure keyb;interrupt;
begin
inc(i);
if i>99 then noint;
while port[$60]<80 do
begin
case port[$60] of
59:sound(ndo);
60:sound(nre);
61:sound(nmi);
62:sound(nfa);
63:sound(nsol);
64:sound(nla);
65:sound(nsi);
66:sound(ndo);
68:noint;
end;
end;
nosound;
inline($9c);
kbdint;
end;
{$f-}
begin
i:=1;
port[$61]:=port[$61] or 3;
port[$43]:=$b6;
getintvec($9,@kbdint);
setintvec($9,addr(keyb));
readln;
assign(f,'song.dat');
rewrite(f,1);
blockwrite(f,a,200);
close(f);
port[$61]:=port[$61] and $fd;
end.


