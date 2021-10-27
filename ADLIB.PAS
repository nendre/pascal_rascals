uses crt;
const a:array[1..9] of byte = (0,1,2,8,9,$a,$10,$11,$12);
      b:array[1..9] of byte = (3,4,5,$b,$c,$d,$13,$14,$15);
var i:integer;

begin
for i:=1 to 9 do
begin
port[$388]:=$20+a[i];
delay(10);
port[$389]:=$1;
delay(10);

port[$388]:=$40+a[i];
delay(10);
port[$389]:=$10;
delay(10);

port[$388]:=$60+a[i];
delay(10);
port[$389]:=$f0;
delay(10);

port[$388]:=$80+a[i];
delay(10);
port[$389]:=$77;
delay(10);

port[$388]:=$a0+a[i];
delay(10);
port[$389]:=$98;
delay(10);

port[$388]:=$20+b[i];
delay(10);
port[$389]:=$01;
delay(10);

port[$388]:=$40+b[i];
delay(10);
port[$389]:=$00;
delay(10);

port[$388]:=$60+b[i];
delay(10);
port[$389]:=$f0;
delay(10);

port[$388]:=$80+b[i];
delay(10);
port[$389]:=$77;
delay(10);

port[$388]:=$b0+a[i];
delay(10);
port[$389]:=$31;
delay(10);

end;
readkey;
end.
