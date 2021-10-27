uses crt ;

Var F,G         : file    ;
    i,j,k       : integer ;
    Hufftab     : array[0..255,1..2] of word;
    loc         : array[0..255] of byte;
    huff        : array[0..255] of byte;
    hufft       : array[0..255] of byte;
    ht          : byte;
    buff        : array[1..10000] of byte;
    dest        : array[1..10000] of byte;
    cnt         : integer;
    opti        : array[0..255] of longint;
    opt         : array[0..255] of byte;
    optt        : array[0..255] of byte;
    ut          : array[0..255] of string[15];
    optn        : array[0..255] of byte;

Function Huffpos(n:word):byte;
var o:integer;
Begin
 o:=0;
 repeat
  if n=hufftab[o,1] then Begin ht:=1;huffpos:=o;exit;end;
  if n=hufftab[o,2] then Begin ht:=2;huffpos:=o;exit;end;
  inc(o);
 until o>254;
 Writeln('Error!');
 halt;
End;

Procedure ShortingOpti;
var i,j:integer;
    c:byte;
Begin
 for i:=0 to 255 do
 opt[i]:=i;
 for i:=0 to 254 do
 for j:=i+1 to 255 do
 if opti[i]<opti[j] then
           Begin
            c:=opti[i];
            opti[i]:=opti[j];
            opti[j]:=c;
            c:=opt[i];
            opt[i]:=opt[j];
            opt[j]:=c;
           End;
 for i:=0 to 255 do
 optt[opt[i]]:=i;
End;


Procedure ShortingHuff;
var i,j:integer;
   c:byte;
   s:string[15];
Begin
for i:=0 to 255 do
huff[i]:=i;
 for i:=0 to 254 do
 for j:=i+1 to 255 do
 if loc[i]>loc[j] then
           Begin
            c:=loc[i];
            loc[i]:=loc[j];
            loc[j]:=c;
            c:=huff[i];
            huff[i]:=huff[j];
            huff[j]:=c;
           End;
for i:=0 to 255 do
hufft[huff[i]]:=i;
End;

Procedure CreatingHufftable;
var i,j,k:integer;
Begin
 for i:=0 to 254 do
 Begin
  if hufftab[i,1]<256 then
   hufftab[i,1]:=opt[huff[hufftab[i,1]]];
  if hufftab[i,2]<256 then
   hufftab[i,2]:=opt[huff[hufftab[i,2]]];

 End;
End;

Procedure Localize ;
var i,j,k:integer;
Begin
 for i:=0 to 255 do
 ut[i]:='';
 for i:=0 to 255 do
 Begin
  k:=i;
  repeat
  j:=huffpos(k);
  inc(loc[i]);
  k:=j+256;
  if ht=1 then ut[i]:=ut[i]+'0' else ut[i]:=ut[i]+'1';
 until j=254;
 if (i/10)=(i div 10) then write('.');
 end;
 writeln;
End;


Procedure Compress;
var sp : integer;
    dp : integer;
    dx,bx:word;
    ak,ch,cl:byte;
    s:string;
    le:byte;
Begin
Writeln('Localize:');
localize;
Write('Try to compress:');
assign(g,'my.dat');
rewrite(g,1);
reset(f,1);
sp:=1;
dp:=1;
ak:=0;
cl:=1;
repeat
 sp:=1;
 blockread(f,buff,10000,cnt);
{ cl:=1;}
{ ak:=0;}
 repeat
 ch:=buff[sp];
 sp:=sp+1;
 s:=ut[ch];
 le:=length(s);
 repeat
  if s[le]='0' then
        Begin
        cl:=cl shl 1;
        if cl=0 then
           Begin
           dest[dp]:=ak;
           ak:=0;
           inc(dp);
           if dp>10000 then begin blockwrite(g,dest,10000);Write('.');dp:=1;end;
           cl:=1;
           End;
        end
        else
        Begin
        ak:=ak or cl;
        cl:=cl shl 1;
        if cl=0 then
           Begin
           dest[dp]:=ak;
           ak:=0;
           inc(dp);
           if dp>10000 then begin blockwrite(g,dest,10000);Write('.');dp:=1;end;
           cl:=1;
           End;
        End;
 dec(le);
 until le<=0;
 until sp>cnt;
until cnt<10000;
dest[dp]:=ak;
if dp<>1 then blockwrite(g,dest,dp);
close(f);
close(g);
End;




Begin
 Clrscr;
 if paramcount=0 then halt;
 assign(f,'vgadict.sod');
 reset(f,1);
 blockread(f,hufftab,1024);
 close(f);
 Write('Positions:');
 Localize;
 Assign(f,paramstr(1));
 reset(f,1);
 Write('Reading & optimizing:');
 repeat
  blockread(f,buff,10000,cnt);
  for i:=1 to cnt do
  inc(opti[buff[i]]);
  write('.');
 until cnt<>10000;
 close(f);
 Writeln;
{ Writeln('Shorting...');
 Shortingopti;
 Shortinghuff;
 Writeln('CreatingHuffTable...');
 Creatinghufftable;}
 Compress;
 Writeln;
 Writeln('Saving hufftab...');
 assign(f,'huff.dat');
 rewrite(f,1);
 blockwrite(f,hufftab,1024);
 close(f);
 Writeln;
 Writeln('O.K.');
End.