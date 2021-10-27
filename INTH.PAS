{$G+}
uses graph,crt;
var gd,gm:integer;
    x,y,n,i,j,t:word;
    p:pointer;
    size:word;
    st:string;
begin
gd:=installuserdriver('svga256',nil);
gm:=0;
initgraph(gd,gm,'d:\bp\bgi');
x:=10;y:=10;
port[$43]:=36;
port[$40]:=lo(65530);
port[$40]:=hi(65530);
x:=0;y:=0;
repeat
inc(y);
str(y,st);
outtext(st);
until y<200000;
readln;
closegraph;
end.