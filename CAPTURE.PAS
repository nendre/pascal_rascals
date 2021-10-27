{$M 2048,0,0}
{$G+}
{$F+}
uses dos;
var int1csave:procedure;
    f:file;
    i:word;
    a:array[1..9000] of byte;
procedure captureaza;forward;
procedure tratareintrerupere;interrupt;
begin
     captureaza;
     inline ($9C) ;
     Int1cSave ;
end;
procedure scrie;
begin
assign(f,'muzica');
rewrite(f,1);
blockwrite(f,a,9000);
close(f);
end;
procedure captureaza;
begin
inc(i);if i>9000 then scrie;
a[i]:=port[$42];
end;
begin
getintvec($1c,@int1csave);
setintvec($1c,addr(tratareintrerupere));
keep(0);
end.
