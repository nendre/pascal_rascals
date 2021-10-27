uses crt,vga;
var f    : file                    ;
    i,j,k: integer                 ;
    a    : array[0..255] of longint;
    b    : array[1..10000] of byte ;
    cnt  : integer                 ;
    max  : longint                 ;
    size : longint                 ;
    pos  : integer                 ;
begin
 if paramcount=0 then halt;
 assign(f,paramstr(1));
 reset(f,1);
 size:=filesize(f);
 cnt:=0;
 max:=0;
 pos:=wherey;
 repeat
  blockread(f,b,10000,cnt);
  for i:=1 to cnt do
  inc(a[b[i]]);
  inc(max,10000);
  gotoxy(1,pos);
  write('Reading :',max*100 div size :3,'%');
 until cnt<10000 ;
 close(f);
 max:=0;
 for i:=0 to 255 do
 if a[i]>max then max:=a[i];


 vmode($13);
 szin:=white;
 for i:=0 to 200 do
 xpont(10,i);
 for i:=0 to 320 do
 xpont(i,190);
 for i:=0 to 255 do
 xpont(i+11,190-(150*a[i] div max));
 readkey;
 vmode($03);
End.


