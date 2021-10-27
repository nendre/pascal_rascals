uses crt,graph,vga;
procedure lapoz(page:byte);
assembler;
asm
 mov ah,page
 mov dx,03c4h
 mov al,0eh
 out dx,al
 inc dx
 in al,dx
 and ax,0ff0h
 xor ah,2
 or al,ah
 out dx,al
end;

var j,i,gd,gm:integer;
begin
vmode($13);
readkey;
szin:=white;
for i:=0 to 320 do
for j:=0 to 200 do
begin
xpont(i,j);
end;
readkey;
closegraph;
end.