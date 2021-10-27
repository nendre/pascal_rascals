uses crt;
begin
 writeln('CD stat:',port[$211+$20]);
 port[$212+$20]:=0;
 readkey;
end.