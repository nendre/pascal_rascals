uses crt;
type arbore=^arb;
     arb=record
         s:string[30];
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


procedure Creare(var p:arbore;x:string);
begin
if p=nil then
begin
new(p);
p^.s:=x;
p^.ad:=nil;
p^.as:=nil;
end
else
begin
if x<p^.s then Creare(p^.as,x);
if x>p^.s then Creare(p^.ad,x);
end;
end;


function Cauta(e:string;p:arbore):boolean;
begin
cauta:=false;
if p<>nil then
begin
if e>p^.s then cauta:=cauta(e,p^.ad);
if e<p^.s then cauta:=cauta(e,p^.as);
if e=p^.s then cauta:=true;
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


Procedure Traversare(p:arbore);
begin
  if p<> nil then
   begin
        writeln(f,p^.s,'  ');
        traversare(p^.as);
        traversare(p^.ad);
   end;
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
assign(f,'aad.txt');
reset(f);
while not eof(f) do
begin
readln(f,s);
k:=100;
while k<>0 do
begin
k:=pos(' ',s);
cuv:=copy(s,1,k-1);
creare(p,cuv);
delete(s,1,k);
end;
cuv:=s;
creare(p,cuv);
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
gotoxy(1,1);
write('Cuvantul Cautat:');
gotoxy(25,1);
write('            ');
gotoxy(25,1);
readln(x);
if cauta(x,p) then writeln('Cuvant gasit  ') else writeln('Cuvant negasit');
until x='';
{assign(f,'aad.tmp');
rewrite(f);
traversare(p);
close(f);}
readln;
end.
