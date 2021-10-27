{$G+}
const pln:array[1..4] of byte=(1,2,4,8);
var n,i,j:word;
begin
asm
mov ax,7eh
int 10h
end;
port[$3c4]:=01;
port[$3c5]:=6;
for i:=0 to 64000 do memw[$a000:i]:=23084;
readln;
asm
mov ax,003h
int  10h
end;
end.