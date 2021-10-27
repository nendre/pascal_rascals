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
const nfft=128;
Type Curve=array[1..nfft] of real;
var f:file;
    tab:array[1..nfft] of byte;
    gd,gm:integer;

Procedure ORFFT (VAR XR,XI:Curve;  N:integer;  ISI:Integer);
Var
M,NV2,LE,LE1,IP,I,J,K,L: Integer;
C,THETA,UR,UI,TR,TI:Real;

Begin
M:=Round(LN(N)/LN(2));
NV2:= N DIV 2;
J:=1;

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
LE:=1;
C:=ISI*TWOPI;
For L:=1 TO M do
Begin
LE1:=LE;
LE:=LE*2;
For J:=1 TO LE1 do
Begin
THETA:= c*(J-1)/LE;
UR:=COS(tHETA);
UI:=SIN(THETA);
I:=J;
Repeat
IP:=I+LE1;
TR:=XR[IP]*UR-XI[IP]*UI;
TI:=XR[IP]*UI+XI[IP]*UR;
XR[IP]:=XR[I]-TR;           XI[IP]:=XI[I]-TI;
XR[I]:=XR[I]+TR;            XI[I]:=XI[I]+TI;
I:=I+LE;
Until (I>=N)
End;
End;
If ISI=-1 then
Begin
For I:= 1 TO N do
Begin
XR[I]:=4*XR[I]/N;             XI[I]:=4*XI[I]/N;
End;
End;
End;


Procedure RFFT (VAR XR,XI:Curve;  N:integer;  ISI:Integer);
Var
M,NV2,LE,LE1,IP,I,J,K,L: Integer;
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


{stage 2}

LE:=1;
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


End;

const numsam=nfft;
var bb,zz,k,i:word;
  samplebuffer,freal,fimag:curve;
  dc:real;
{vmode($13);}

j:integer;
Begin
 vmode($13);
 for i:=1 to 255 do szinbeallit(i,00,i div 20,i div 4);
 assign(f,'hc.wav');
 reset(f,1);
 for zz:=1 to 320 do
 Begin
 seek(f,zz*5);
 for i:=1 to nfft do
 Begin
  seek(f,zz*100+i*(11000 div 512));
 blockread(f,tab[i],1);
 end;
 for i:=1 to nfft do
 Begin
  samplebuffer[i]:=ROUND(150*SIN(2*PI*5*ZZ*(I-1)/NFFT));
 end;

For I := 1 to NUMSAM do
Begin
FREAL[I]:=SAMPLEBUFFER[I];
FIMAG[I]:=0;
End;

RFFT(FREAL,FIMAG,NUMSAM,1);
DC:=FREAL[1]/2;

For I:= 1 to NUMSAM dO
FREAL[I]:=(FREAL[I]*FREAL[I]+fIMAG[I]*FIMAG[I]);

 for bb:=1 to NFFT DIV 2 do
 Begin
   szin:=(round((freal[bb])));
  pont(zz,199-bb);
end;
 szin:=255;
 k:=0;
 for i:=1 to numsam do
  k:=k+tab[i];
  k:=k div numsam;
{ pont(zz,k+150);}
 szin:=150;
{ pont(zz,tab[1]);}

end;

close(f);

readkey;
vmode($03);
End.
