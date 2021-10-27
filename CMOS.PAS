uses crt;
var i:integer;
begin
 for i:=1 to 255 do
 begin
 port[$70]:=i;
 port[$71]:=0;
 end;
end.