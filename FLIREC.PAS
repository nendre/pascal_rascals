uses crt,vga,dos,bmp;
Type
  Chunkheadertype=record
     Size:longint;
     tip :word;
     end;
  FileHeaderType = Record
    Size   : Longint ;
    Magic  : Word ;
    Frames : Word ;
    Width  : Word ;
    Height : Word ;
    Depth  : Word ;
    Flags  : Word ;
    Speed  : Word ;
    Next   : Longint ;
    Frit   : Longint ;
    Expand : Array[0..101] Of Byte ;
  End ;

  FrameHeaderType = Record
    Size   : Longint ;
    Magic  : Word ;
    Chunks : Word ;
    Expand : Array[0..7] Of Byte ;
  End ;

var oldpal          : paletta;
    packets         : word;
    lines           : word;
    firstlines      : word;
    firstcolor      : byte;
    nrcolors        : byte;
    chunk           : chunkheadertype;
    Flihead         : fileheadertype;
    Frame           : frameheadertype;
    p1,p2,p3        : pointer;
    x,y             : word;
    flifile,bmpfile : file;
    names           : array[1..1000] of string[12];
    nrbmp           : word;
    i               : word;
    fliname         : string[12];
    nrframe         : word;
    cursize         : longint;
    compr           : byte;
procedure colorproc;
begin
Frame.size:=16+6+4+768;
blockwrite(flifile,frame,16);
chunk.size:=6+4+768;
chunk.tip:=11;
blockwrite(flifile,chunk,6);
packets:=1;
blockwrite(flifile,packets,2);
firstcolor:=0;
blockwrite(flifile,firstcolor,1);
nrcolors:=0;
blockwrite(flifile,nrcolors,1);
blockwrite(flifile,pal,sizeof(pal));
oldpal:=pal;
inc(nrframe);
end;
procedure flicopy;
begin
Frame.size:=16+6+64000;
blockwrite(flifile,frame,16);
chunk.size:=6+64000;
chunk.tip:=16;
blockwrite(flifile,chunk,6);
blockwrite(flifile,p2^,64000);
inc(nrframe);
end;



begin
clrscr;
write('BMP file-ok szama:');readln(nrbmp);
for i:=1 to nrbmp do
begin
repeat
write('BMP ',i,' :');readln(names[i]);
names[i]:=names[i]+'.bmp';
assign(bmpfile,names[i]);
{$i-}
reset(bmpfile,1);
{$i+}
until ioresult=0;
close(bmpfile);
end;
write('FLI File neve:');readln(fliname);

if memavail<(2*65535) then begin writeln('Sorry,not enough memory to complete this operation...');halt(1);end;
getmem(p1,65535);
getmem(p2,65535);
p2:=ptr($a000,0);
assign(flifile,fliname);
rewrite(flifile,1);
blockwrite(flifile,flihead,128);
vmode($13);
bmpbetolt(names[1]);
Frame.magic:=$f1fa;
Frame.chunks:=1;
colorproc;
{   First picture   }
flicopy;
nrframe:=1;


{   Next pictures   }


for i:=1 to nrbmp do
begin
bmpbetolt(names[i]);
cursize:=64000;
compr:=16;
y:=0;
for x:=0 to 255 do
begin
if pal[x].red<>oldpal[x].red then y:=60000;
if pal[x].blue<>oldpal[x].blue then y:=60000;
if pal[x].green<>oldpal[x].green then y:=60000;
end;
if y>50000 then colorproc;
{case compr do
16:copy;
15:brun;
12:lc;}
flicopy;
end;

flihead.magic:=$af11;
flihead.size:=filesize(flifile);
flihead.width:=320;
flihead.height:=200;
flihead.depth:=8;
flihead.speed:=1;
flihead.frames:=nrframe;
seek(flifile,0);
blockwrite(flifile,flihead,128);
close(flifile);
vmode(04);
writeln('All o.k.');
end.
