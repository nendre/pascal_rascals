uses crt,vga,dos;
type aa = array[0..64000] of byte;
var l,i,j,k:word;
    a,b,c,d:word;
    m,n:longint;
    p3,p4,p1,p2:^aa;
    p:pointer;

procedure dd;
assembler;
asm
     cli
     mov dx,3daH
@@t: in al,dx
     test al,8
     jne @@t
@@y: in al,dx
     test al,8
     je @@y
     sti
end;

Begin

 vmode($13);
for i:=0 to 255 do
szinbeallit(i,0,0,i div 4);
for i:=0 to 64000 do
mem[$a000:i]:=random(255);
  p1:=ptr($a000,0);
  p2:=ptr($8000,0);
  asm
    mov ax,0A000H
    mov es,ax
    mov di,0
    mov ax,08000H
    mov dx,ax
    mov si,0
    mov cx,30000
@kk:
    mov di,cx
    mov si,cx
    mov ax,es:[di-1]
    add ax,es:[di+1]
    add ax,es:[di+320]
    add ax,es:[di-320]
    shr ax,2
    jz @gg
    dec ax
@gg:
    mov ds:[si],al
    dec cx
    cmp cx,1000
    jne @kk
   end;
{   p1^:=p2^;}
  readkey;
  vmode($03);
  p2:=nil;
  p1:=nil;
End.
