{$F+,X+,R+,Q+}
{$G+}
Unit VGA;

Interface
uses crt,dos;

type paletta = array[0..255] of record
                 red,green,blue:byte;
                End;

Const kepcim : word=$a000;

var
  pal :paletta;
  maxx,maxy :word;
  aktlap:byte;
  szin:byte;

procedure vmode(videomode:byte);
procedure szinbeallit(szin,r,g,b:byte);
procedure palbeallit(p:paletta);
procedure palleolvas(p:paletta);
procedure xpont(x,y:word);
procedure pont(x,y:word);
function pontle(x,y:word):byte;

implementation

procedure vmode;
 procedure xy(xf,yf:word);
 begin
 maxx:=xf;maxy:=yf;
 end;

 begin
  asm
  mov ah,0
  mov al,videomode
  int 16
  end;
 Case videomode of
 $13:xy(320,200);
 $5d:xy(640,480);
 $5e:xy(800,600);
 $62:xy(1024,768);
End;
palleolvas(pal);
end;

procedure szinbeallit;assembler;
asm
 mov al,szin
 mov dx,3c8h
 out dx,al
 inc dx
 mov al,r
 out dx,al
 mov al,g
 out dx,al
 mov al,b
 out dx,al
end;

procedure palbeallit;assembler;
asm
cld
lds si,p
xor al,al
mov cx,256
@cikl:
push ax
mov dx,3c8h
out dx,al
inc dx
lodsb
out dx,al
lodsb
out dx,al
lodsb
out dx,al
pop ax
inc al
loop @cikl
end;

procedure palleolvas;assembler;
asm
 cld
 les di,p
 xor al,al
 mov cx,256
@cikl:
 push ax
 mov dx,3c7h
 out dx,al
 add dl,2
 in al,dx
 stosb
 in al,dx
 stosb
 in al,dx
 stosb
 pop ax
 inc al
 loop @cikl
end;

procedure lapoz;assembler;
asm
 mov ah,dl
 mov dx,03c4h
 mov al,0eh
 out dx,al
 inc dx
 in al,dx
 and ax,0ff0h
 xor ah,2
 or al,ah
 out dx,al
 ret
end;

procedure xpont(x,y:word);assembler;
asm
 mov ax,x
 mov bx,y
 mov cl,white
 shl bx,6
 add ax,bx
 shl bx,2
 add bx,ax
 mov ax,0a000h
 mov es,ax
 mov al,szin
 mov es:[bx],al
end;


procedure pont(x,y:word);assembler;
asm
 mov al,szin
 mov cl,al
 mov ax,y
 mul maxx
 add ax,x
 adc dx,0
 mov bx,ax
 cmp aktlap,dl
 je @jolap
 mov aktlap,dl
 call lapoz
@jolap:
 mov es,kepcim
 mov es:[bx],cl
end;

function pontle;assembler;
asm
mov ax,y
mul maxx
add ax,x
adc dx,0
mov bx,ax
cmp aktlap,dl
je @jolap
mov aktlap,dl
call lapoz
@jolap:
mov es,kepcim
mov al,es:[bx]
end;

begin
end.






