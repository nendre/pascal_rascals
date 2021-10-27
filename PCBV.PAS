program PCB_Viewer;   { (c) 1997, P.RoTTeR / BCD! }
uses Crt;             { Cool FREEWAREs from all kind of utils }
const hex : String[16] = '0123456789ABCDEF';
var fl  : Text;
    st  : String;
    ch  : Char;
    i,j : Byte;
    cc  : Word;   { CharCounter }

procedure TC(bc,tc : Byte);
begin
  TextBackGround(bc); TextColor(tc);
end;

function Vll(ch : Char) : ShortInt;
var nm,pv : ShortInt;

begin
  nm := -1; for pv := 1 to 16 do if ch=hex[pv] then nm := pv-1;
  Vll := nm;
end;



begin
  WriteLn(#13#10,'PCB Viewer v1.1a (c) 1997, P.RoTTeR');
  if ParamCount<>1 then
  begin
    WriteLn('Usage: PCBV [filename]'#13#10); Halt(1);
  end;

  FileMode := 0; Assign(fl,ParamStr(1)); {$I-} Reset(fl); {$I+}
  if IOResult<>0 then
  begin
    WriteLn('File not found!'#13#10); Halt(2);
  end;

  TC(0,7); ClrScr; st := #11+#11; j := 0; ch := #0; cc := 0;

  while (not eof(fl)) and (ch<>#27) do
  begin
    if (st<>#11+#11) and (cc<80) then WriteLn; cc := 0;
    ReadLn(fl,st); st := st+#11; TextColor(7);

    i := 1;
    repeat
      if (st[i]='@') and (st[i+1]='X') and (Vll(st[i+2])<>-1) and
         (Vll(st[i+3])<>-1) then
      begin
        TC(Vll(st[i+2]),Vll(st[i+3])); Inc(i,4);
        if i>Length(st) then i := Length(st);
      end;
      if st[i]<>#11 then begin Write(st[i]); Inc(cc); end;
      Inc(i);
    until i>Length(st);

    Inc(j); if j=25 then
            begin ch := ReadKey; if ch=#0 then ch := ReadKey; j := 0; end;
  end;

  Close(fl); if j>0 then ReadKey; TC(0,7); ClrScr;
end.