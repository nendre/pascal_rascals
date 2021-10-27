uses crt;
const
 fel=1;
 le=2;
 jobb=3;
 bal=4;
var peg:array[1..7,1..7] of byte;
    i,j,k:integer;
    x:array[1..100] of record
       a:integer;
       x,y:integer;
       irany:byte;
      end;
    f:boolean;

function vanlepes:boolean;
var ok,f:boolean;
    i,j:integer;
begin
  f:=true;
  ok:=false;
  repeat
   if (x[k].irany<4) then inc(x[k].irany)
   else
    if (x[k].x<7) then begin inc(x[k].x);x[k].irany:=1; end
      else
        if (x[k].y<7) then begin inc(x[k].y);x[k].irany:=1;x[k].x:=1;end
          else
           f:=false;

  if (peg[x[k].x,x[k].y])=1 then
    case (x[k].irany) of
    fel:begin
          if (x[k].y)>2 then
            if (peg[x[k].x,x[k].y-1]=1) and (peg[x[k].x,x[k].y-2]=0) then
              begin
                ok:=true;
                peg[x[k].x,x[k].y-1]:=0;     {kozbeeso}
                peg[x[k].x,x[k].y-2]:=1;{vegso}
                peg[x[k].x,x[k].y]:=0;       {kezdo}
             end;
       end;
    le:begin
          if (x[k].y)<6 then
            if (peg[x[k].x,x[k].y+1]=1) and (peg[x[k].x,x[k].y+2]=0) then
              begin
                ok:=true;
                peg[x[k].x,x[k].y+1]:=0;     {kozbeeso}
                peg[x[k].x,x[k].y+2]:=1;{vegso}
                peg[x[k].x,x[k].y]:=0;       {kezdo}
             end;
       end;
    bal:begin
          if (x[k].x)>2 then
            if (peg[x[k].x-1,x[k].y]=1) and (peg[x[k].x-2,x[k].y]=0) then
              begin
                ok:=true;
                peg[x[k].x-1,x[k].y]:=0;     {kozbeeso}
                peg[x[k].x-2,x[k].y]:=1;{vegso}
                peg[x[k].x,x[k].y]:=0;       {kezdo}
             end;

        end;
    jobb:begin
          if (x[k].x)<6 then
            if (peg[x[k].x+1,x[k].y]=1) and (peg[x[k].x+2,x[k].y]=0) then
              begin
                ok:=true;
                peg[x[k].x+1,x[k].y]:=0;     {kozbeeso}
                peg[x[k].x+2,x[k].y]:=1;{vegso}
                peg[x[k].x,x[k].y]:=0;       {kezdo}
             end;
         end;
    end;{case}
  until (ok) or (f=false);
  if (not(ok)) then
  begin
   f:=false;
  end;
  vanlepes:=f;
end;

procedure visszalep;
begin
 if (k>0) then
 case x[k].irany of
 fel:begin
      peg[x[k].x,x[k].y]:=1;
      peg[x[k].x,x[k].y-1]:=1;
      peg[x[k].x,x[k].y-2]:=0;
{      x[k].y:=x[k].y+2;}
     end;
 le:begin
      peg[x[k].x,x[k].y]:=1;
      peg[x[k].x,x[k].y+1]:=1;
      peg[x[k].x,x[k].y+2]:=0;
{      x[k].y:=x[k].y-2;}
    end;
 bal:begin
      peg[x[k].x,x[k].y]:=1;
      peg[x[k].x-1,x[k].y]:=1;
      peg[x[k].x-2,x[k].y]:=0;
{      x[k].x:=x[k].x+2;}
 end;
 jobb:begin
      peg[x[k].x,x[k].y]:=1;
      peg[x[k].x+1,x[k].y]:=1;
      peg[x[k].x+2,x[k].y]:=0;
{      x[k].x:=x[k].x+2;}
      end;
    end;{case}
end;

function sol:boolean;
var f:boolean;
    i,j,v:integer;
begin
 f:=false;
  v:=0;
   for i:=1 to 7 do
   for j:=1 to 7 do
   if peg[i,j]=1 then v:=v+1;
  if v=1 then f:=true;
  sol:=f;
end;

begin
   for i:=1 to 7 do
   for j:=1 to 7 do
   peg[i,j]:=1;

   peg[4,4]:=0;

   peg[1,1]:=2;
   peg[1,2]:=2;
   peg[2,1]:=2;
   peg[2,2]:=2;

   peg[6,7]:=2;
   peg[6,6]:=2;
   peg[7,7]:=2;
   peg[7,6]:=2;

   peg[1,6]:=2;
   peg[1,7]:=2;
   peg[2,6]:=2;
   peg[2,7]:=2;

   peg[6,1]:=2;
   peg[6,2]:=2;
   peg[7,1]:=2;
   peg[7,2]:=2;

   clrscr;
   for i:=1 to 7 do
   for j:=1 to 7 do
   begin
   gotoxy(i*3,j);
   if (peg[i,j]=2) then write('F') else
     if(peg[i,j]=1) then write('o')
     else
      write(' ');
   end;

   k:=1;
   x[k].x:=0;x[k].y:=1;x[k].irany:=0;

   while (k>0) do
   begin
    f:=false;
    if vanlepes then f:=true;

{      if f then
      begin
   clrscr;
   for i:=1 to 7 do
   for j:=1 to 7 do
   begin
   gotoxy(i*3,j);
   if (peg[i,j]=2) then write('F') else
     if(peg[i,j]=1) then write('o')
     else
      write(' ');
   end;
   writeln;
   writeln;
   writeln('k=',k);
   readkey;
      end;
 }
      if f then
        if sol then
           begin
             clrscr;
             writeln('Megold!');
             writeln;
             for i:=1 to k do
             begin
              writeln(x[i].x,'  ',x[i].y,'   ',x[i].irany);
              readkey;
             end;
             readkey;
            end
          else
            begin
            k:=k+1;
            x[k].x:=0;x[k].y:=1;x[k].irany:=0;
            end
          else
          begin
          k:=k-1;
          visszalep;
          end;
   end;
end.