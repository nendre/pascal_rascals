uses crt;
var f:file;
    p,p1:pointer;
    page,adr,len:word;
begin
asm
mov ax,0013h
int 10h
end;
assign(f,'c:\asm\sky.map');
reset(f,1);
seek(f,768);
p:=ptr($9000,0);
blockread(f,p^,64000);
close(f);
page:=$a000 shr 12;
adr:=(($a000 and $fff) shl 4);
len:=10000;
port[$8]:=128+64+0+0+8+0+0+1;
port[$a]:=1 or 4;
port[$c]:=0;
port[$b]:=64+12+1;
port[2]:=lo(adr);
port[2]:=hi(adr);
port[$83]:=page;
port[3]:=lo(len);
port[3]:=hi(len);
port[$a]:=1;
readln;
p:=ptr($9000,0);
p1:=ptr($a000,0);
move(p^,p1^,64000);
readln;
asm
mov ax,003h
int 10h
end;
end.
