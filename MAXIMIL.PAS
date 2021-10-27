program BullShit;
uses Crt,TVGA;
var kep   : Array[0..63999] of Byte absolute $a000:$0;
    pal   : TPalette256;
    i,j,k : Integer;

begin
  Randomize;
  SetMode(tx320y200c256); kep[0] := Random(96);
  kep[320] := kep[0];
  kep[321] := kep[0];
  for i := 1 to 319 do
    kep[i] := kep[0]+i div 2;
  for i := 1 to 199 do
    kep[i*320] := kep[0]+i div 2;

  for i := 0 to 63 do
  begin
    pal[i].Red := i div 3; pal[i].Green := i div 2; pal[i].Blue := i div 1;
    pal[127-i] := pal[i];
  end;
  for i := 128 to 255 do
  begin
    pal[i].Red := (i-128) div 4; pal[i].Green := (i-128) div 3;
    pal[i].Blue := (i-128) div 2;
  end;
  SetPaletteRegisterAll256(@pal);
  for i := 1 to 319 do
  for j := 1 to 199 do
    kep[i+320*j] := (kep[i-1+320*j]+kep[i-1+320*(j-1)]+kep[i+320*(j-1)]) div 3+Random(2);

  ReadKey; SetTextMode;
end.