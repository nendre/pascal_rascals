Unit BMP;

Interface

Type

 tBitmapFileHeader = Record  {A file fejlece}
             bfType : word;
             bfSize : longint;
             bfreserved1 : word;
             bfreserved2 : word;
             bfOffBits : longint;
            End;
 tBitmapInfoHeader=Record    {Az informacios resz}
            biSize : longint;
            biWidth : longint;
            biHeight : longint;
            biPlanes : word;
            biBitCount : word;
            biCompression : longint;
            biSizeImage : longint;
            bixpelspermeter : longint;
            biypelspermeter : longint;
            biClrUsed : longint;
            biClrImportant : longint;
           End;
 tRGBquad = Record   {A szin kezelo rekord}
           rgbBlue : byte;
           rgbGreen : byte;
           rgbRed : byte;
           rgbreserved : byte;
          End;

Var

 BFH       :tBitmapFileHeader;
 BIH       :tBitmapInfoHeader;
 RGBColor  :tRGBquad;

Procedure BMPBetolt(s:string);   {BMP file betoltese }
Procedure BMPMent(s:string);     {BMP file mentese}

Implementation

Uses CRT,VGA;

procedure Error;
begin
 VMODE(3);  {Hiba a file hivasnal ! }
 Write('Hiba a filekezelesnel !');
 Halt(1);
End;

Var ff: file;
    res : word;
    i,j : integer;
    kep:array[0..1024] of byte;

Procedure BMPBetolt(s:string);
begin
 assign(ff,s);
 {$I-}
 reset(ff,1);
 {$I+}
 if ioresult <> 0 then error;
 blockread(ff,BFH,sizeof(BFH),res);
 if res <> sizeof(bfh) then error;
 blockread(ff,BIH,sizeof(BIH),res);
 if res <> sizeof(BIH) then error;
 for i:=0 to 255 do
 begin
  blockread(ff,rgbcolor,sizeof(rgbcolor),res);
  if res<>sizeof(rgbcolor) then error;
  pal[i].blue:=rgbcolor.rgbblue div 4;
  pal[i].green:=rgbcolor.rgbgreen div 4;
  pal[i].red:=rgbcolor.rgbred div 4;
 end;
 palbeallit(pal);
 for j:=bih.biheight-1 downto 0 do
 begin
  blockread(ff,kep,maxx,res);if res <> maxx then error;
  for i:=0 to bih.biwidth-1 do
  begin
  szin:=kep[i];
  pont(i,j);
 end;
end;
close(ff);
End;

Procedure BMPMent(s:string);
Begin
assign(ff,s);
rewrite(ff,1);
with BFH do
begin
 bftype:=19778;
 bfsize:=maxx*maxy+1078;
 bfreserved1:=0;
 bfreserved2:=0;
 bfoffbits:=sizeof(BFH)+sizeof(BIH)+256*sizeof(rgbcolor);
 end;
 blockwrite(ff,BFH,sizeof(BFH),res);
 if res<> sizeof(bfh) then error;
 with bih do
 begin
  bisize:=sizeof(bih);
  biwidth:=maxx;
  biheight:=maxy;
  biplanes:=1;
  bibitcount:=8;
  bicompression:=0;
  bisizeimage:=maxx*maxy;
  bixpelspermeter:=0;
  biypelspermeter:=0;
  biclrused:=0;
  biclrimportant:=0;
 end;
 blockwrite(ff,bih,sizeof(bih),res);
 if res <> sizeof(bih) then error;
 palleolvas(pal);
 for i:=0 to 255 do
 begin
   rgbcolor.rgbblue:=pal[i].blue*4;
   rgbcolor.rgbgreen:=pal[i].green*4;
   rgbcolor.rgbreserved:=0;
   blockwrite(ff,rgbcolor,sizeof(rgbcolor),res);
   if res<>sizeof(rgbcolor) then error;
  end;
  for j:=bih.biheight-1 downto 0 do
  begin
  for i:=0 to bih.biwidth do kep[i]:=pontle(i,j);
  blockwrite(ff,kep,maxx,res);
  if res<>maxx then error;
  end;
 close(ff);
end;

end.



