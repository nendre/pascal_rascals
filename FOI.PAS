uses crt,vga;
var i,j,k:integer;
    f:file;
    tab:array[1..512] of byte;
    r,m,n:real;
Begin
 vmode($13);
 assign(f,'hc.wav');
 reset(f,1);
  for i:=0 to 255 do szinbeallit(i,i div 4,i div 10,0);
  for i:=1 to 320 do
  Begin
  seek(f,i);
  blockread(f,tab,512);
  m:=0;
    for k:=1 to 200 do
    Begin
  for j:=1 to 512 do

  m:=(m+tab[j]*(1/sin(2*pi*k*10*(j-1)/512)+1/cos(2*pi*k*10*(j-1)/512))/2);

  szin:=round(m);
  xpont(i,k);
end;
  end;
 readkey;
 vmode($03);
end.