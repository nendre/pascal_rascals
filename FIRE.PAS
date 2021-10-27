uses crt,graph,vga;
Type dat = array[1..60000] of byte;
var gd,gm:integer ;
    m,i,j,k:longint;
    p1,p2:^dat;
    s:array[1..20] of string;

procedure Move32(var source,dest;count:word);assembler;

asm
                PUSH    DS
                LDS     SI,source
                LES     DI,dest
                MOV     CX,count
                SHR     CX,1
                JNC     @@1
                MOVSB
@@1:            SHR     CX,1
                JNC     @@2
                MOVSW
@@2:            DB      66h
                REP     MOVSW
                POP     DS
end;



Begin
s[1]:='turbo';
s[2]:='Pascal';
s[3]:='Present';
s[4]:='the';
s[5]:='Program';
s[6]:='coded';
s[7]:='by';
s[8]:='Green';
s[9]:='Rage';
 vmode($13);
 new(p1);
 p2:=ptr($a000,0);

 gd:=installuserdriver('svga256',nil);
 gm:=0;
 initgraph(gd,gm,'c:\bp\bgi');
 cleardevice;
 for i:=0 to 63 do
 szinbeallit(i,i,0,0);
 for i:=64 to 2*64-1 do
 szinbeallit(i,63-i div 2,i div 2,0);
 for i:=2*64 to 3*64-1 do
 szinbeallit(i,i div 3,63,0);
 for i:=3*64 to 4*64-1 do
 szinbeallit(i,63,i div 4,63);

 setbkcolor(0);
 setcolor(255);
 settextstyle(0,0,3);
 p1^:=p2^;
 m:=1;
 repeat
  outtextxy(10,10,s[m]);
  P1^:=P2^;
 for k:=1 to 20 do
 Begin
  for i:=0 to 250 do
  Begin
   szin:=random(255);
  xpont(i,48);
  end;
  for i:=1 to 50 do
  for j:=1 to 50 do
  Begin
   if p2^[(i)*320+j]>11 then p1^[(i-1)*320+j]:=
                           ((p2^[i*320+j+1]+p2^[i*320+j-1]+
                 {            p2^[(i-1)*320+j]+p2^[(i+1)*320+j]+
                             p2^[(i-1)*320+j+1]+p2^[(i+1)*320+j+1]+}
                             p2^[(i-1)*320+j-1]+p2^[(i+1)*320+j-1]) div 4)-4;
  end;
  p2^:=p1^;
 end;
 m:=m+1;
 if m>10 then m:=1;
 until keypressed;
 readkey;
 p2:=nil;
 dispose(p1);
 closegraph;
End.