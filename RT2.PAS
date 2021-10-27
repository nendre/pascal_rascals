uses crt,vga,bmp,xms;
type a = array[1..64000] of byte;
var p:array[1..6] of ^a;
    p1:^a;
    i,j,k:integer;
    s:string;
   hnd,y,x:word;
   poz:longint;
begin

if xmsinstalled then
begin
enableaddra20;
enabledataa20;
allocextmem(1024,hnd);
end else halt;

 p1:=ptr($a000,0);
 vmode($13);
 poz:=0;
 for i:=1 to 9 do
 begin
 str(i,s);
 s:='ros'+s+'.bmp';
 bmpbetolt(s);
 writeextmem(p1^,64000,hnd,poz);
 poz:=poz+64000;
 end;

 repeat
 for j:=1 to 4 do
 begin
  poz:=64000*4;
  for i:=4 to 11 do
  begin
  poz:=i*64000;
  readextmem(64000,hnd,poz,p1^);
  delay(10);
  end;

  for i:=11 downto 4 do
   begin
  poz:=i*64000;
  readextmem(64000,hnd,poz,p1^);
  delay(10);
  end;
end;
 for j:=1 to 30 do
 begin
  poz:=64000*4;
  for i:=0 to 2 do
  begin
  poz:=i*64000;
  readextmem(64000,hnd,poz,p1^);
  end;
  delay(10);
  for i:=2 downto 0 do
   begin
  poz:=i*64000;
  readextmem(64000,hnd,poz,p1^);
  end;
  delay(10);
end;

 until keypressed;

 readkey;
 vmode($03);
freeextmem(hnd);
end.
