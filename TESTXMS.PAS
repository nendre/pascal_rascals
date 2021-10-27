{$A+,B-,d-,f-,g+,o-,r-,s-,v-,x-}
{$M 16384,0,655360}

program TestXMS;

uses xms,crt;
type maxarray=array[1..65519] of byte;

var
 ver,intver:word;
 HMAok:boolean;
 MaxFree,MemFree:word;
 GetA20Status:boolean;
 HMATestArray:maxarray absolute $ffff:$0010;

handle:word;
locked:boolean;
Handlelength,FreeHandles:word;
i:word;
j,N:longint;
T:array[0..255] of longint;
pages:word;
BaseAddress:pointer;
type ST2=string[2];

function HexString(number:byte):ST2;
function Hex_Char(Number:word):Char;
begin
 if number<10 then
 Hex_char:=Char(number+48)
 else
 Hex_char:=char(number+55);
end;

var
 s:st2;
 begin
 s:='';
 s:=s+hex_char(number shr 4);
 number:=number and $0f;
 s:=s+hex_char(number);
 hexstring:=s
 end;

procedure error;
var msg:string[40];
begin
 write('Error'+hexstring(xmserror),';');
 case XMSError of
    0:msg:='NoError.';
    $80:msg:='Inexisting function.';
    $81:msg:='VDISK like device present.';
    $82:msg:='A20 handling error.';
    $8e:msg:='Internal Error.';
    $8f:msg:='Fatal internal error.';
    $90:msg:='NoHMA.';
    $91:msg:='HMA already allocated.';
    $92:msg:='Cannot allocate less than /HMAMIN.';
    $03:msg:='HMA not allocated.';
    $a0:msg:='Extended memory totaly allocated.';
    $a1:msg:='No more handles available.';
    $a2:msg:='Bad xms handle.';
    $a3:msg:='Bad source handle.';
    $a4:msg:='Bad source offset.';
    $a5:msg:='Bad destinatoin handle.';
    $a6: msg:='Bad destination offset.';
    $a7:msg:='Length not allowed.';
    $a8:msg:='Bad length with overlapping.';
    $a9:msg:='Parity error.';
    $aa:msg:='Unprotected block.';
    $ab:msg:='Protected block.';
    $ac:msg:='Too many blocks.';
    $ad:msg:='Cannot protected block.';
    $b0:msg:='Not enough upper memory.';
    $b1:msg:='Not available upper memory.';
    $b2:msg:='BadSegment address.';
end;
writeln;
writeln(msg);
if xmserror in [$8e,$8f] then halt(1);
end;

begin
 if xmsinstalled then
 begin
 xmsinfo(ver,intver,hmaok);
 writeln('Found XMS driver version ',Hexstring(hi(ver)),'.',
          Hexstring(lo(ver)),
          '  internal version ',Hexstring(hi(intver)),'.',
          hexstring(lo(intver)));
write('High Memory Area ');
if HMAOk then writeln('available.') else writeln('not available');

freeextmeminfo(maxfree,memfree);
writeln('Free extended memory:',memfree,' Kbytes.');
writeln('Maximum free block:',maxfree,' Kbytes.');
getA20Status:=A20status;
if geta20status then writeln('A20 line enabled.')
    else writeln('A20 line disabled.');

if HMAOk then
begin
 allocHMA(50000);
 if xmserror>0 then error
 else
 begin
   writeln('HMA succesfully allocated.');
   if not GetA20Status then
   begin
    write('Enabling A20 address line.This may take some time...');
    enableAddra20;
    if xmserror>0 then error
    else
    begin
    writeln('OK.');
    write('Enabling A20 data line.This may take some time...');
    enabledataa20;
    if xmserror>0 then error
    else
    begin
     writeln(' OK.');
     write('Testing HMA...');
     for i:=1 to 65519 do
      HMATestArray[i]:=i mod 255;
      i:=1;
      while (HMATestarray[i]=i mod 255) and
      (i<=65519) do inc(i);
      if i<65519 then writeln('HMA Test failed.')
      else writeln(' OK.');
      DisableAddrA20;
      if xmserror>0 then error;
      disableDataA20;
      if xmsError>0 then error
      end
     end
    end;
   FreeHMA;
   if XMSError>0 then error
  end
 end;

write('Allocating ',Maxfree,' kbytes of extended memory...');
allocExtMem(Maxfree,handle);
if xmserror>0 then error
else
begin
 writeln('OK.');
 gethandleinfo(handle,locked,handlelength,freehandles);
 if xmserror>0 then error
 else writeln('Handle ',handle,' allocated;length: ',
            Handlelength,
            ' ; ',Freehandles,'  more free handles.');
writeln('Testing ',Maxfree,' kbytes extended memory.');
write('Writing ',1024,'         bytes');
n:=0;
for i:=1 to maxfree do
begin
 gotoxy(9,wherey);write(n shl 2 +1024);
 for j:=0 to 255 do t[j]:=n+j;
 writeextmem(t,1024,handle,n shl 2);
 inc(n,256);
 if xmserror>0 then
 begin
  i:=maxfree+2
  end
 end;
 if i>succ(maxfree) then error else writeln(' OK.                        ');
 if i<succ(maxfree) then
 begin
 gotoxy(1,wherey);
 write('Reading ',1024,'        bytes');
 n:=0;
 for i:=1 to maxfree do
 begin
 gotoxy(9,wherey);write(n shl 2+1024);
 readextmem(1024,handle,n shl 2,T);
 if XMSError>0 then
 begin
  error;
  i:=maxfree+2;
  end
  else
  begin
   for j:=0 to 255 do
   if t[j]<> j+n then
   begin
    writeln;
    writeln(' Error testing extended memory.');
    i:=maxfree+2
   end
  end;
  inc(n,256);
  end;
  if i<= succ(maxfree) then
  begin
  writeln(' OK.                       ')
  end
 end
end;
write('Deallocating ',Maxfree,' Kbytes of extended memory...');
freeextmem(handle);
if xmserror>0 then error else writeln('OK. ');
end
else writeln('XMS driver not installed.');
end.




