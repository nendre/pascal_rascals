uses crt;
type cheie=record
           st:string[20];
           line:word;
           end;
     arbore=^arb;
     arb=record
         s:cheie;
         ad,as:arbore;
         end;

var p:arbore;
    x:string;
    c:char;
    ma,mb:longint;
    s:string;
    cuv:string;
    f:text;
    k:byte;
    nrc:longint;
    bb:boolean;
    linie,nl:word;


procedure Creare(var p:arbore;x:string;ll:word);
begin
if p=nil then
begin
new(p);
p^.s.st:=x;
p^.s.line:=ll;
p^.ad:=nil;
p^.as:=nil;
end
else
begin
if x<p^.s.st then Creare(p^.as,x,ll);
if x>p^.s.st then Creare(p^.ad,x,ll);
end;
end;


function Cauta(e:string;p:arbore;var l:word):boolean;
begin
cauta:=false;
if p<>nil then
begin
if e>p^.s.st then cauta:=cauta(e,p^.ad,l);
if e<p^.s.st then cauta:=cauta(e,p^.as,l);
if e=p^.s.st then
begin
cauta:=true;
l:=p^.s.line;
end;
end;
end;


Function Inalt(p:arbore):word;
var hmax:word;
{------}
procedure Mx(q:arbore;nivel:word);
begin
if q=nil then
begin
if nivel>hmax then hmax:=nivel;
end
else
begin
mx(q^.ad,nivel+1);
mx(q^.as,nivel+1);
end;
end;
{------}
begin
hmax:=0;
mx(p,0);
inalt:=hmax;
end;


procedure NrNoduri(p:arbore);
begin
if p<>nil then
begin
inc(nrc);
NrNoduri(p^.as);
NrNoduri(p^.ad);
end;
end;



begin
clrscr;
ma:=memavail;
gotoxy(1,24);write(ma);
p:=nil;
nrc:=0;
linie:=0;
assign(f,'aad.txt');
reset(f);
while not eof(f) do
begin
inc(linie);
readln(f,s);
k:=100;
while k<>0 do
begin
k:=pos(' ',s);
cuv:=copy(s,1,k-1);
creare(p,cuv,linie);
delete(s,1,k);
end;
cuv:=s;
creare(p,cuv,linie);
end;
close(f);
nrc:=0;
NrNoduri(p);
clrscr;
gotoxy(1,24);write(ma);
gotoxy(70,24);write(memavail);
gotoxy(1,22);write('Words in binary tree:',nrc);
gotoxy(65,22);write('Tree Heigth:',inalt(p));
repeat
linie:=0;
gotoxy(1,1);
write('Cuvantul Cautat:');
gotoxy(25,1);
write('            ');
gotoxy(25,1);
readln(x);
if cauta(x,p,linie) then
begin
writeln('Cuvant gasit  ');
assign(f,'aad.txt');
reset(f);
nl:=0;
repeat
readln(f,s);
inc(nl);
until nl=linie;
gotoxy(1,5);
clreol;
writeln(s);
close(f);
end else writeln('Cuvant negasit');
until x='';
readln;
end.
