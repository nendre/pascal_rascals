uses crt,vga,dsp;
var i,j,k:integer;
    a,b:array[1..10000] of byte;

Procedure Inita;
var i:integer;
 begin
 for i:=1 to 10000 do
 a[i]:=127;
 end;

Procedure Initb;
var i:integer;
 begin
 for i:=1 to 10000 do
 b[i]:=127;
 end;

Procedure Generatefrec(fr:integer;amp:integer);
var i:integer;
begin
 inita;
 for i:=1 to 10000 do
 a[i]:=a[i]+round(amp*sin(i*pi/fr));
end;

Procedure Addto;
begin
 for i:=1 to 10000 do
 b[i]:=b[i]+a[i]-127;
end;

Procedure plot;
begin
 szin:=white;
 for i:=1 to 320 do
 xpont(i,b[i*5]);
end;

BEGIN
 inita;
 initb;
 vmode($13);
 for k:=1 to 4 do
 begin
 generatefrec(k*20,k*4);
 addto;
 end;
 plot;
 resetdsp(2);
 speakeron;
 repeat
 for i:=1 to 10000 do
 begin
 for k:=1 to 50 do begin end;
 writedac(b[i]);
 end;
 until keypressed;
 readkey;
 speakeroff;
 vmode($03);

END.