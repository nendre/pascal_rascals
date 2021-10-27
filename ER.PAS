uses crt,vga;
var r,g,b,i,j,k:integer;
procedure delayed;
assembler;
asm
 mov dx,3daH
@l1:
 in al,dx
 test al,8
 jne @l1
@l2:
 in al,dx
 test al,8
 je @l2
end;
Begin
 vmode($13);
{repeat
 for i:=0 to 63 do
 Begin
   delayed;
   szinbeallit(0,i,63-i,0);
 End;
 for i:=0 to 63 do
 Begin
   delayed;
   szinbeallit(0,63-i,0,i);
 End;
 for i:=0 to 63 do
 Begin
   delayed;
   szinbeallit(0,0,i,63-i);
 End;

until keypressed;
}
repeat
{ delayed;}
 szinbeallit(i,0,0,0);
 delay(200);
{  k:=random(3);
  if k=0 then r:=255 else if k=1 then  g:=255 else b:=255;}
{ delayed;}
 szinbeallit(i,255,255,255);
{ r:=0;g:=0;b:=0;}
{ delay(1);}
until keypressed;
 readkey;
 vmode($03);
End.
