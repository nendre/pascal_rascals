{
From: marcel.hoogeveen@hacom.wlink.nl (Marcel Hoogeveen)

GR> FFT stands for Fast Fourier Transform.  It is a quick way to conver
GR> time domain data (ie oscilliscopy data with time on the x-axis) to
GR> frequency domain (frequency on the x-axis, like a frequency spectrum
GR> analyzer).  This is a usefull data analysis method.  I would also like
GR> to get some source for this.


This is what i have of FFT source code, it should work if you tweak it a bit.
(It did for me when i used it in my analasis program).
Don't ask me how it works, i know how a DFT works but a FFT well .. just use
the source. :)

}
Program FFT;
uses crt,vga;
Const Twopi=6.283185303;
const nfft=8;
Type Curve=array[1..nfft] of real;


Procedure RFFT (VAR XR,XI:Curve;  N:integer;  ISI:Integer);
Var
vv,x,y,M,NV2,LE,LE1,IP,I,J,K,L: Integer;
C,THETA,UR,UI,TR,TI:Real;

Begin

{init}

M:=Round(LN(N)/LN(2));
NV2:= N DIV 2;
J:=1;

{stage 1}

For I:= 1 to N-1 do
Begin
If (I<J) then
Begin
TR:=XR[J];            TI:=XI[J];
XR[J]:=XR[I];         XI[J]:=XI[I];
XR[I]:=TR;            XI[I]:=TI;
End;

K:=NV2;
While (K<J) do
Begin
J:=J-K;
K:=K DIV 2;
End;
J:=J+K;
End;

 for vv:=1 to 8 do
 Begin
  write(xr[vv]:3:0,' ');
 end;
 writeln;
 for vv:=1 to 8 do
 Begin
  write(xi[vv]:3:0,' ');
 end;
 writeln;


{stage 2}

LE:=1;
C:=TWOPI;
 x:=wherex;y:=wherey;
For L:=1 TO M do
Begin
 LE1:=LE;
 LE:=LE*2;
 For J:=1 TO LE1 do
  Begin
  THETA:=-2*pi*(J-1)/LE;
  UR:=COS(tHETA*1);
  UI:=SIN(THETA*1);
  I:=J;

   Repeat
   IP:=I+LE1;
   TR:=XR[IP]*UR-XI[IP]*UI;
   TI:=XR[IP]*UI+XI[IP]*UR;
   XR[IP]:=XR[I]-TR;           XI[IP]:=XI[I]-TI;
   XR[I]:=XR[I]+TR;            XI[I]:=XI[I]+TI;


  gotoxy(x,y);

 for vv:=1 to 8 do
 Begin
  textcolor(white);if (vv=i) or (vv=(ip)) then textcolor(yellow);
  write(xr[vv]:3:0,' ');
 end;
 writeln;
 for vv:=1 to 8 do
 Begin
  textcolor(white);if (vv=i) or (vv=(ip)) then textcolor(yellow);

  write(xi[vv]:3:0,' ');
 end;
 writeln;
 gotoxy(1,10);
 textcolor (white);
   writeln('Real[',i ,']=Real[',i,'] + ( Real[',ip,'] *  COS(2*PI*',
  (j-1)/le:1:2,' - Img[',ip,'] * SIN(2*PI*',((j-1)/le):1:2,' )');


  writeln('Real[',ip,']=Real[',i,'] - ( Real[',ip,'] *  COS(2*PI*',
  (j-1)/le:1:2,' - Img[',ip,'] * SIN(2*PI*',((j-1)/le):1:2,' )');


  writeln('Img[',i,']=Img[',i,'] + ( Real[',ip,'] *  SIN(2*PI*',
  (j-1)/le:1:2,' + Img[',ip,'] * COS(2*PI*',((j-1)/le):1:2,' )');


  writeln('Img[',ip,']=Img[',i,'] - ( Real[',ip,'] *  SIN(2*PI*',
  (j-1)/le:1:2,' + Img[',ip,'] * COS(2*PI*',((j-1)/le):1:2,' )');

  writeln('Ur:',UR:2:2);
  writeln('Ui:',UI:2:2);
{   TR:=XR[IP]*UR-XI[IP]*UI;
   TI:=XR[IP]*UI+XI[IP]*UR;
   XR[IP]:=XR[I]-TR;           XI[IP]:=XI[I]-TI;
   XR[I]:=XR[I]+TR;            XI[I]:=XI[I]+TI;
}


 readkey;


   I:=I+LE;


   Until (I>=N)
  End;
 End;

 Begin
  For I:= 1 TO N do
  Begin
   XR[I]:=4*XR[I]/N;             XI[I]:=4*XI[I]/N;
  End;
End;

 gotoxy(x,y);
 for vv:=1 to 8 do
 Begin
  write(xr[vv]:3:0,' ');
 end;
 writeln;
 for vv:=1 to 8 do
 Begin

  write(xi[vv]:3:0,' ');
 end;
 writeln;

End;

const numsam=8;
var k,i:word;
  samplebuffer,freal,fimag:curve;
  dc:real;
{vmode($13);}
Begin
clrscr;
 writeln;
 for i:=1 to 8 do
 Begin
  samplebuffer[i]:=round(10*sin(5*2*pi*(i-1)/8));
  write(samplebuffer[i]:5:0,' ');
 end;
 writeln;
 szin:=white;

For I := 1 to NUMSAM do
Begin
FREAL[I]:=SAMPLEBUFFER[I];
FIMAG[I]:=0;
End;

RFFT(FREAL,FIMAG,NUMSAM,1);
DC:=FREAL[1]/2;

For I:= 1 to NUMSAM dO
FREAL[I]:=FREAL[I]*FREAL[I]+fIMAG[I]*FIMAG[I];



{readkey;}
{vmode($03);}
End.
