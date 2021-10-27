uses crt;
type arbore=^arb;
     arb=record
         s:string;
         ad,as:arbore;
         end;

var p:arbore;
    x:string;
    c:char;
    ma,mb:longint;
    niv:integer;

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

Procedure Traversare(p:arbore;mod_t:byte);
begin
case mod_t of
0:begin
  if p<> nil then
   begin
        writeln(p^.s);
        traversare(p^.as,mod_t);
        traversare(p^.ad,mod_t);
   end;
 end;
1:begin
  if p<> nil then
   begin
       traversare(p^.as,mod_t);
       writeln(p^.s);
       traversare(p^.ad,mod_t);
   end;
 end;
2:begin
  if p<> nil then
   begin
        traversare(p^.as,mod_t);
        traversare(p^.ad,mod_t);
        writeln(p^.s);
   end;
 end;
end;
end;

procedure GetNivel(p:arbore);
begin
if p<>nil then
begin
inc(niv);
Getnivel(p^.as);
Getnivel(p^.ad);
end;
end;




procedure Meniu;
begin
clrscr;
writeln;
writeln('1.Creare Arbore Binar');
writeln('2.Traversare in Preordine');
writeln('3.Traversare in Inordine');
writeln('4.Traversare in Postordine');
writeln('5.Cautare element');
writeln('6.Stergere Arbore Binar');
writeln('7.Iesire din program');
writeln;
write('Optiunea d-vs:');
end;

begin
ma:=memavail;
mb:=memavail;
repeat
mb:=memavail;
niv:=0;
meniu;
gotoxy(1,24);write(ma);
gotoxy(70,24);write(mb);
getnivel(p);
gotoxy(30,24);write(niv);
gotoxy(15,10);
readln(c);
case c of
'1':begin
    clrscr;
    writeln('Introduceti elementele arborelui');
    readln(x);
    while x<>'' do
    begin
    Creare(p,x);
    readln(x);
    end;
    end;
'2':begin
    clrscr;
    writeln('Traversare in Preordine');
    traversare(p,0);
    readln;
    end;
'3':begin
    clrscr;
    writeln('Traversare in Inordine');
    traversare(p,1);
    readln;
    end;
'4':begin
    clrscr;
    writeln('Traversare in postordine');
    traversare(p,2);
    readln;
    end;
'5':begin
    clrscr;
    Write('Cuvantul cautat:');readln(x);
    if Cauta(x,p) then writeln('Cuvant gasit') else writeln('Cuvant negasit');
    readln;
    end;
'6':begin
    end;
end;
until c='7';
end.