{$G+}
var f:File;
    pal:array[0..767] of byte;
    n,i,j,t:word;
    p,p1:pointer;
    s:string;
    adr:word;
procedure delayed;assembler;
asm
mov dx,3dah
@1:in al,dx
    test al,08
    jnz @1
@2:in al,dx
    test al,08
    jz @2
end;
procedure movemem(adresa:word);assembler;
asm
push ds
push es
mov ax,adresa
mov ds,ax
mov ax,0a000h
mov es,ax
mov si,0
mov di,0
cld
mov cx,32000
rep movsw
std
pop es
pop ds
end;
begin
asm
mov ax,0013h
int 10h
end;
assign(f,'image1.dat');
reset(f,1);
blockread(f,pal,768);
asm
mov si,offset pal
mov dx,3c8h
mov al,0
out dx,al
mov al,255
inc dx
cld
mov cx,768
rep outsb
end;
p:=ptr($9000,0);
blockread(f,p^,64000);
close(f);
assign(f,'image2.dat');
reset(f,1);
blockread(f,pal,768);
asm
mov si,offset pal
mov dx,3c8h
mov al,0
out dx,al
mov al,255
inc dx
cld
mov cx,768
rep outsb
end;
p:=ptr($8000,0);
blockread(f,p^,64000);
close(f);
adr:=$7000;
for i:=3 to 5 do
begin
str(i,s);
assign(f,'image'+s+'.dat');
reset(f,1);
p:=ptr(adr,0);
blockread(f,p^,64000);
close(f);
dec(adr,$1000);
end;
adr:=$5000;
while adr<$a000 do
begin
for j:=0 to 25 do delayed;
movemem(adr);
inc(adr,$1000);
end;
readln;
asm
mov ax,003h
int 10h
end;
end.


