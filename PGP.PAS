{$G+}
uses crt;
var f:file;
    p:pointer;
    k:array[1..320] of byte;
    n,r,b,g:integer;
    i:word;
    l,h,t:word;
procedure getscr;assembler;
asm
pusha
push ds
push es
mov ax,0A000h
mov ds,ax
mov ax,09000h
mov es,ax
mov si,0
mov di,0
mov cx,15000
rep movsw
pop es
pop ds
popa
end;
procedure putscr;assembler;
asm
pusha
push ds
push es
mov ax,09000h
mov ds,ax
mov ax,0A000h
mov es,ax
mov si,0
mov di,0
mov cx,15000
rep movsw
pop es
pop ds
popa
end;
begin
asm
mov ax,13h
int 10h
end;
assign(f,'pups.bmp');
reset(f,1);
seek(f,1078);
for i:=199 downto 100 do begin
p:=ptr($a000,(i-100)*320);
blockread(f,k,320);
move(k,p^,320);
end;
close(f);
getscr;
for i:=0 to 48000 do mem[$a000:i]:=0;
readln;
putscr;
readln;
asm
mov ax,003h
int 10h
end;
end.