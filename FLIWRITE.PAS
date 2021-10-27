uses crt;
type fileheader=record
	       size:longint;
	       magic:word;
	       frames:word;
	       width:word;
	       height:word;
	       depth:word;
	       flags:word;
	       speed:word;
	       next:longint;
	       frit:longint;
	       expand:array[0..101] of byte;
	       end;
     frameheader=record
		 size:longint;
		 magic:word;
		 chunks:word;
		 expand:array[0..7] of byte;
		 end;
var f,g:file;
    m,i,j,t:word;
    k:byte;
    p,p1:pointer;
    fh:fileheader;
    frh:frameheader;
    sz:longint;
    pal:array[0..767] of byte;
procedure colorproc;
begin
Frh.size:=16+6+4+768;
frh.magic:=$F1FA;
frh.chunks:=1;
blockwrite(f,frh,16);
sz:=6+4+768;
blockwrite(f,sz,4);
m:=11;
blockwrite(f,m,2);
m:=1;
blockwrite(f,m,2);
k:=0;
blockwrite(f,k,1);
k:=0;
blockwrite(f,k,1);
blockwrite(f,pal,768);
end;
begin
assign(f,'alin.fli');
rewrite(f,1);
with fh do
begin
size:=192988;
magic:=$AF11;
frames:=3;
width:=319;
height:=199;
depth:=8;
flags:=3;
speed:=34555;
next:=150;
frit:=0;
for j:=0 to 101 do expand[j]:=0;
end;
blockwrite(f,fh,128);
assign(g,'image1.dat');
reset(g,1);
blockread(g,pal,768);
close(g);
colorproc;
with frh do
begin
size:=64022;
magic:=$F1FA;
chunks:=1;
for j:=0 to 7 do expand[j]:=0;
end;
blockwrite(f,frh,16);
sz:=64000;
blockwrite(f,sz,4);
m:=16;
blockwrite(f,m,2);
assign(g,'image1.dat');
reset(g,1);
seek(g,768);
p:=ptr($9000,0);
blockread(g,p^,64000);
close(g);
blockwrite(f,p^,64000);
with frh do
begin
size:=64022;
magic:=$F1FA;
chunks:=1;
for j:=0 to 7 do expand[j]:=0;
end;
blockwrite(f,frh,16);
sz:=64000;
blockwrite(f,sz,4);
m:=16;
blockwrite(f,m,2);
assign(g,'image3.dat');
reset(g,1);
p:=ptr($9000,0);
blockread(g,p^,64000);
close(g);
blockwrite(f,p^,64000);
assign(g,'image4.dat');
reset(g,1);
p:=ptr($9000,0);
blockread(g,p^,64000);
close(g);
with frh do
begin
size:=64022;
magic:=$F1FA;
chunks:=1;
for j:=0 to 7 do expand[j]:=0;
end;
blockwrite(f,frh,16);
sz:=64000;
blockwrite(f,sz,4);
m:=16;
blockwrite(f,m,2);
blockwrite(f,p^,64000);
close(f);
end.
