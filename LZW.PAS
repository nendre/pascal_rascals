uses crt ;

Type buff = array[0..60000] of byte;

Var be,ki  : ^buff ;
    tbl    : array[0..255] of string[100];
    f      : file;
    cnt    : word;
    kind,bs: word;
    a      : string[100];
    ind    : byte;
    sind   : byte;
    oe     : byte;
    intable: byte;
Procedure AddToTable ;
Begin
End;

procedure int;
var i:integer;
begin
intable:=1;
 for i:=0 to 255 do
 if a=tbl[i] then begin intable:=0;oe:=i;exit;end;
 if bs>(cnt-5) then bs:=cnt+1;
end;

Begin
if paramcount=0 then halt;
assign(f,paramstr(1));
reset(f,1);
new(be);
new(ki);
blockread(f,be^,60000,cnt);
close(f);
bs:=0;
clrscr;
repeat
 a:=chr(be^[bs]);
 ind:=1;
 repeat
 a:=a+chr(be^[bs+ind]);
 inc(ind);
 int;
 until (intable=1);
 bs:=bs+ind-1;
 inc(sind);
 tbl[sind]:=a;
 ki^[kind]:=oe;
 inc(kind);
gotoxy(1,1);
writeln('Akt:',(bs*100/cnt):3:1,' %');
Writeln('BS :',bs);
Writeln('OE :',kind);
inc(bs);

until bs>=cnt ;

assign(f,'my.dat');
rewrite(f,1);
blockwrite(f,ki^,kind);
close(f);
dispose(be);
dispose(ki);
End.