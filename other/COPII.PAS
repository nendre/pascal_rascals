uses crt;
var st:array[1..100] of byte;
		 j,z,max,n,m,k,i:byte;
		 c,gasit:boolean;
		nume:array[1..100] of string;
		jucarii:array[1..100] of string;
		 KM:ARRAY[1..10,1..10] OF BYTE;
Function Succesor:byte;
Var max:byte;
Begin
 max:=1;
 if k>1 then
 for i:=1 to k-1 do
 if max<st[i] then max:=st[i];
 succesor:=max;
End;

Function Solutie:boolean;
Var c:boolean;
Begin
 c:=(k=n);
 if c then begin
 max:=succesor;
 if max<st[n] then max:=st[n];
 if max=m then c:=true else c:=false;
 end;
 solutie:=c;
End;

Begin
 clrscr;
 write('n:');readln(n);
 For i:=1 to n do
 Begin
	Write('Jucaria:');readln(jucarii[i]);
 End;
 write('m:');readln(m);
 For i:=1 to m do
 Begin
	Write('Numele:');readln(nume[i]);
 End;

 k:=1;
 st[k]:=0;
 while (k>0) do
 Begin
	inc(st[k]);
	gasit:=false;
	if (st[k]<=k) and (st[k]<=succesor+1) then gasit:=true;
	if gasit then
	 if solutie then
		 Begin
{       i-juc st[i] nuev}
		for i:=1 to n do for j:=1 to n do km[i,j]:=0;

		for i:=1 to n do
		km[st[i],i]:=1;

		for i:=1 to m do
		Begin
		 Write(nume[i],' --');
		for j:=1 to n do
		if km[i,j]<>0 then write(jucarii[j],',');
		writeln;
		end;
		 end
		 else
			if k<n then
		 begin k:=k+1;st[k]:=0;end
	 else else k:=k-1;
 End; {while}
End.

