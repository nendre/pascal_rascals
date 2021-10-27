{$G+}
{$F-}
{$R-}
USES Crt,Dos,Cdaudio,Sbdsp,Sound,Bmp,Graph,Svgm,Vga;         { Units          }

Const Curs : array[0..15,0..7] of word=                  { Mouse Cursor   }
 (
 (    0,  0,  0,255,  0,  0,  0,  0),
 (    0,  0,  0,255,  0,  0,  0,  0),
 (    0,  0,  0,255,  0,  0,  0,  0),
 (    0,  0,255,255,255,  0,  0,  0),
 (    0,  0,255,255,255,  0,  0,  0),
 (    0,255,255,255,255,255,  0,  0),
 (    0,  0,  0,255,  0,  0,  0,  0),
 (    0,  0,255,255,255,  0,  0,  0),
 (    0,255,  0,255,  0,255,  0,  0),
 (  255,  0,  0,255,  0,  0,255,  0),
 (  255,  0,  0,255,  0,  0,255,  0),
 (  255,  0,255,  0,255,  0,255,  0),
 (    0,255,  0,  0,  0,255,  0,  0),
 (    0,  0,255,255,255,  0,  0,  0),
 (    0,  0,  0,  0,  0,  0,  0,  0),
 (    0,  0,  0,  0,  0,  0,  0,  0)) ;

 Black        =  64 +  0 ;
 Blue         =  64 +  1 ;
 Green        =  64 +  2 ;
 Cyan         =  64 +  3 ;
 Red          =  64 +  4 ;
 Magenta      =  64 +  5 ;
 Brown        =  64 +  6 ;
 LightGray    =  64 +  7 ;
 DarkGray     =  64 +  8 ;
 LightBlue    =  64 +  9 ;
 LightGreen   =  64 + 10 ;
 LightCyan    =  64 + 11 ;
 LightRed     =  64 + 12 ;
 LightMagenta =  64 + 13 ;
 Yellow       =  64 + 14 ;
 White        =  64 + 15 ;

Var
     Buttons : Array[1..70] of Record                      { Normal Button  }
                              X,Y    : Integer     ;       { Position       }
                              U,V    : Integer     ;       { End Pos        }
                              Head   : String[8]   ;       { Button Name    }
                              Bcolor : Byte        ;       { Button Color   }
                              Pr     : Boolean     ;       { Button Stat    }
                              end;
     VolButtons : Array[1..40] of Record                 { Volume Buttons }
                               X,Y           : Integer          ;
                               u,v           : Integer          ;
                               Bal           : Integer          ;
                               Vol           : Byte             ;
                               Mute          : Boolean          ;
                               Head          : String[8]        ;
                               bx,by,bu,bv   : Integer          ;
                               vx,vy,vu,vv   : Integer          ;
                              end;
    Temp               : Array[1..3,1..400] of longint  ;
    Palette,OldPalette : palettetype                    ;
    Size               : integer                        ;  { Cursor size   }
    Mask1,Mask         : Array[0..15,0..7] of byte      ;  { Mask of mouse }
    Mxo,Myo            : Integer                        ;  { Old coords.   }
    Pmask,Pscr,Pold    : Pointer                        ;  { Cursors       }
    NrButtons          : Byte                           ;  { Total buttons }
    NrVolButtons       : Byte                           ;  { Tot.Vol butt. }
    Akt                : Byte                           ;  { Akt.pres.butt.}
    I,J,K              : Integer                        ;  { Counters      }
    Ch                 : Char                           ;  { Input char    }
    Cdtrack            : Integer                        ;
    Cdinfo             : DiscRec                        ;
    Nrtracks           : Byte                           ;
    Cdvar              : Tmsf                           ;
    Trk                : Byte                           ;
    Trt                : Byte                           ;  { Filter        }
    Pal1,Pal2          : Paletta                        ;  { Palettes      }
    Zene               : Array[1..10000] of Byte        ;  { Echo buffer   }
    Old                : Procedure                      ;  { Old vector    }
    ver                : byte;
    s,m                : string;
Procedure SM;                                             { Mouse Draw }
Begin
if (mxo<>mx) or (myo<>my) then
Begin
  Putimage(mxo,myo,pscr^,normalput)     ;
  mxo:=mx;myo:=my                       ;
  Getimage(mxo,myo,mxo+7,myo+15,pscr^)  ;
  Putimage(mxo,myo,pmask^,orput)        ;
end;
End;

Procedure Smvi;                                           { Mouse Draw }
Begin Putimage(mxo,myo,pscr^,normalput); End ;

Procedure SMV;                                            { Mouse Draw }
Begin
 mxo:=mx;myo:=my                      ;
 Getimage(mxo,myo,mxo+7,myo+15,pscr^) ;
 Putimage(mxo,myo,pmask^,orput)       ;
End;

Procedure Sync;                                       { Syncron wait }
assembler;
asm
 mov dx,3daH
@l1:
 in al,dx
 test al,8
 jne @l1
@l2:
 in al,dx
 test al,8
 je @l2
end;

Procedure WaitWss;
var i:integer;
Begin
 for i:=1 to $2000 do
  if (port[$534] and 128)=0 then break;
End;


Procedure SetDFR(n:byte);
var b,c:byte;
   i:byte;
Begin
Waitwss;
 port[$534]:=$08;
 b:=port[$535];
 b:=b and 240;
 b:=b+n;
for i:=0 to 1 do
Begin
waitwss;
 port[$534]:=$48;
 c:=port[$535];
 c:=port[$535];
 port[$535]:=b;
 c:=port[$535];
 c:=port[$535];
end;
    waitwss;
    setmixerregwss(wssport,73,128+64);
    waitwss;
   setmixerregwss(wssport,9,2+1);

End;

Procedure SetDFRbit(n:boolean);
var b,c:byte;
   i:byte;
Begin
Waitwss;
 port[$534]:=$08;
 b:=port[$535];
 b:=b and 15;
 if n then b:=b+80 else b:=b+16;
for i:=0 to 1 do
Begin
waitwss;
 port[$534]:=$48;
 c:=port[$535];
 c:=port[$535];
 port[$535]:=b;
 c:=port[$535];
 c:=port[$535];
waitwss;
end;
    waitwss;
    setmixerregwss(wssport,73,128+64);
    waitwss;
   setmixerregwss(wssport,9,2+1);

End;

Procedure Error(n:byte);                                { Error Messages }
Begin
case n of
1:Begin
   writeln('Graphics initialisation error!');
   halt(1)                                  ;
  End;
end;
End;

Procedure Effect;interrupt;
var cnt:integer;
Begin
 If buttons[35].pr then
 Begin
  port[$537]:=zene[cnt];
  if cnt>5000 then cnt:=1;
  zene[cnt]:=(zene[cnt]+port[$537]+port[$537]) div 3;
  inc(cnt);
 End;
End;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{             O S C I L L O S C O P E & V-U M E T E R S                }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

Procedure ShowGra;
Var i,k       : Integer ;
    Tot1,Tot2 : Longint ;
    B         : Byte    ;
    Temp1     : Integer ;
    Ste       : Longint ;
Begin
Ste:=0;Tot1:=0;Tot2:=0 ;
waitwss;
for I:=192 to 350 do
 Begin
  Szin:=Black                                   ;        { Toroljuk a regit}
  Putpixel(i+429,temp[1,i] div 2+11,szin)       ;
  Putpixel((i-190)+20,temp[2,i] div 2+11,szin)  ;
  If buttons[33].pr then                                 { 16/8 bites vetel}
   Begin
   Temp[1,i]:=Port[$537];
   Temp[2,i]:=port[$537];
   End
   else
   Begin if Buttons[34].Pr then
    Begin
     Temp[1,i] := Port[$537] ; Temp1 := Port[$537] ;
     Temp[2,i] := Port[$537] ; Temp1 := Port[$537] ;
     if Temp[1,i] > 255 then Temp[1,i] := 255      ;
     if Temp[1,i] < 0   then Temp[1,i] := 0        ;
     if Temp[2,i] > 255 then Temp[2,i] := 255      ;
     if Temp[2,i] < 0   then Temp[2,i] := 0        ;
    End
    else
    Begin
    Temp[1,i] := Port[$537]                                     ;
    Temp[1,i] := ((Temp[1,i] + 255 * Port[$537]) div 256)+127   ;
    Temp[2,i] := Port[$537]                                     ;
    Temp[2,i] := ((Temp[2,i] + 255 * Port[$537]) div 256)+127   ;
    End;
    Temp[3,i] := Temp[1,i] - Temp[2,i]  ;
{    For J:=0 to 200 do Begin End;}
waitwss;
   End;
  Szin := White                                ;       { Kitesszuk az ujat }
  Putpixel(i+429,temp[1,i] div 2+11,szin)      ;
  Putpixel((i-190)+20,temp[2,i] div 2+11,szin) ;
  Inc(tot1,ABS(temp[2,i]-127));inc(tot2,ABS(temp[1,i]-127)) ; { TOtal}
 End;
 Ste:=(Tot2-Tot1) div 40                                ;     { Stereo bar}
 If Ste<-80 then Ste:=-80 else If Ste>80 then Ste:=80   ;
 if ste>=0 then
 Begin
 for i:=0 to (ste div 8) do szinbeallit(180-i,255,255,0);
 for i:=(ste div 8) to 10 do szinbeallit(180-i,0,20,0);
 for i:=0 to 10 do szinbeallit(180+i,0,20,0);
 end
 else
 Begin
 ste:=-ste;
 for i:=0 to (ste div 8) do szinbeallit(180+i,255,255,0);
 for i:=(ste div 8) to 10 do szinbeallit(180+i,0,20,0);
 for i:=1 to 10 do szinbeallit(180-i,0,20,0);
 end;
{ Setfillstyle(Solidfill,10);Bar(300,140,500,150)        ;}
{ if ste>0 then Begin
 setfillstyle(solidfill,red)                         ;
 bar(400,140,400+ste,150)
 end else Begin
 setfillstyle(solidfill,red)                         ;
 bar(400+ste,140,400,150)                               ;
 End                                                    ;}
{Bal Bar}
 Tot1:=Tot1 div 80 ; Tot2:=Tot2 div 80                  ;
 if Tot1>130 then Tot1:=130;If Tot1<0 then Tot1:=0    ;
 for i:=0 to (tot1 div 10) do
 if i<8 then szinbeallit(212-i,255,255,0) else szinbeallit(212-i,255,215,0);
 for i:=(tot1 div 10) to 12 do
 if i<8 then szinbeallit(212-i,0,20,0) else szinbeallit(212-i,30,0,0);
{ setfillstyle(solidfill,red);;Bar(190,140-Tot1,200,140);
 if tot1>70 then
 Begin setfillstyle(solidfill,yellow+64);;bar(190,10,200,140-tot1) end else
 Begin setfillstyle(solidfill,10);bar(190,10,200,140-tot1);end;}
{Jobb bar}
 if tot2>130 then tot2:=130;if tot2<0 then tot2:=130;
 for i:=0 to (tot2 div 10) do
 if i<8 then szinbeallit(232-i,255,255,0) else szinbeallit(232-i,255,215,0);
 for i:=(tot2 div 10) to 12 do
 if i<8 then szinbeallit(232-i,0,20,0) else szinbeallit(232-i,30,0,0);

{ setfillstyle(solidfill,red+64);bar(600,140-tot2,610,140);
 if tot1>70 then
 Begin setfillstyle(solidfill,yellow+64);bar(600,10,610,140-tot2) end else
 Begin setfillstyle(solidfill,10);bar(600,10,610,140-tot2);end;}
end;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{             D R A W  A  N E W   B U T T O N                          }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure VolButton(nr:integer);
var i,y1,y2:integer;
Begin
if (nr>0) and (nr<=Nrvolbuttons) then
Begin
with VolButtons[nr] do
Begin
 setfillstyle(solidfill,9);
 setcolor(white);
 bar(x,y,u,v);line(x,y,u,y);line(x,y,x,v);


 i:=17;

 settextstyle(2,horizdir,1);
  setusercharsize(3,4,3,4);
 setcolor(darkgray);

 if vol> 14 then
 setcolor(yellow);
 outtextxy(x+18,y+20,'9');
 if vol> 10 then
 setcolor(yellow);
 outtextxy(x+18,y+20+i,'6');
 if vol> 6 then
 setcolor(yellow);
 outtextxy(x+18,y+20+i*2,'3');
 if vol> 0 then
 setcolor(yellow);
 outtextxy(x+18,y+20+i*3,'0');
 setcolor(10);
 for i:=0 to 9 do
 Begin
{ if (vol*10 div 16)<(9-i) then setcolor(10) else setcolor(yellow);}
 setcolor(10);
 line(x+4,y+20+i*7,x+9,y+20+i*7);
 line(u-4,y+20+i*7,u-9,y+20+i*7);
 End;


 setcolor(black);
 line(u,v,u,y);line(u,v,x,v);
 settextstyle(0,0,1);
 if mute then setcolor(cyan) else setcolor(red);outtextxy(x+4,v+2,head);
 setcolor(black);
 line(x+16,y+20,u-16,y+20);line(x+16,y+20,x+16,v-10);
 setcolor(white);
 line(u-16,v-10,u-16,y+20);line(u-16,v-10,x+16,v-10);
 setfillstyle(solidfill,10);
 y1:=(v-10)-(vol*(v-y-30) div 16-2);y2:=y1-7;bar(x+8,y2,u-8,y1);
 vx:=x+4;vu:=u-4;vy:=y2;vv:=y1;
 setcolor(white);
 line(x+7,y2,u-7,y2);line(x+7,y2,x+7,y1);
 setcolor(black);
 line(u-7,y1,u-7,y2);
 line(u-7,y1,x+7,y1);line(x+2,y+2,u-2,y+2);line(x+2,y+2,x+2,y+8);
 setcolor(white);
 line(u-2,y+8,u-2,y+2);line(u-2,y+8,x+2,y+8);
 y1:=x+4+bal*((u-4)-(x+4)) div 16-2;y2:=y1+5;
  setfillstyle(solidfill,12);
 bar(y1,y+3,y2,y+7);bx:=y1;by:=y+3;bu:=y2;bv:=y+7;
 setcolor(lightgray);
 end;
end;
end;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{             S E T  T H E  V O L U M E                                }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure setvol(nr:byte);
var temp:byte;
    l,r:byte;
Begin
with volbuttons[nr] do
 case nr of
 1: Begin
    if mute then temp:=128 else temp:=0;
    l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregctrl(ctrlport,7,(15-(vol-l)) or temp);  {Master}
    setmixerregctrl(ctrlport,8,(15-(vol-r)) or temp);  {Master}
    end;
 5: Begin
    l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
     if mute then temp:=128 else temp:=0;
     setmixerregwss(wssport,06,(15-(vol-l))*4 or temp); {Voice}
     setmixerregwss(wssport,07,(15-(vol-r))*4 or temp); {Voice}
    end;
 6: Begin
    l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
     if mute then temp:=128 else temp:=0;
     setmixerregwss(wssport,4,(15-(vol-l))*2 or temp); {Synt}
     setmixerregwss(wssport,5,(15-(vol-r))*2 or temp); {Synt}
    End;
 2: Begin
     if mute then temp:=128 else temp:=0;
    l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
     setmixerregwss(wssport,18,(15-(vol-l))*2 or temp); { Line volume            }
     setmixerregwss(wssport,19,(15-(vol-r))*2 or temp); { Line volume            }
    end;
 4: Begin
     if mute then temp:=128 else temp:=0;
    l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
     setmixerregwss(wssport,2,(15-(vol-l))*2 or temp); { CD volume              }
     setmixerregwss(wssport,3,(15-(vol-r))*2 or temp); { CD volume              }
    end;
 3: Begin
    if mute then temp:=128 else temp:=0;
    setmixerregctrl(ctrlport,9,(15-vol)*2 or temp); { Mic volume             }
    End;
 8: Begin
    l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
     setmixerregctrl(ctrlport,22,((vol-l) div 2) + (((vol-r) div 2) shl 4)); {Treble}
    end;
 7: Begin
    l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregctrl(ctrlport,21,((vol-l) div 2) + (((vol-r) div 2) shl 4)); {Bass}
    End;
 9: Begin
    l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregctrl(ctrlport,20,((vol-l) div 2) + (((vol-r) div 2) shl 4)); {3D}
    End;
10: Begin
    l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    temp:=getmixerregwss(wssport,0);
    setmixerregwss(wssport,0,(temp and 240) or (vol-l)); {Input}
    temp:=getmixerregwss(wssport,1);
    setmixerregwss(wssport,1,(temp and 240) or (vol-r)); {Input}
    end;
11: Begin
     if mute then temp:=128 else temp:=0;
     setmixerregwss(wssport,26,(15-vol) or temp); {Speak}
    End;

12:setvolume(vol*16);
13: Begin
   l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregwss(sbport,$22,((vol-l) + ((vol-r) shl 4)));
    end;
15: Begin
   l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregwss(sbport,$2e,((vol-l) + ((vol-r) shl 4)));
    end;
14: Begin
   l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregwss(sbport,$04,((vol-l) + ((vol-r) shl 4)));
    end;
18: Begin
   l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregwss(sbport,$0a,((vol-l) + ((vol-r) shl 4)));
    end;
17: Begin
   l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregwss(sbport,$26,((vol-l) + ((vol-r) shl 4)));
    end;
16: Begin
   l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregwss(sbport,$28,((vol-l) + ((vol-r) shl 4)));
    end;
 end;
End;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{           S E T  U P  A  N E W   V O L U M E  B U T T O N            }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure NewVolButton(xx,yy,ref:integer;s:string);
Begin
 inc(nrvolbuttons);
 With Volbuttons[nrvolbuttons] do
 Begin x:=xx*43-30;y:=yy*93+ref;u:=x+40;v:=y+93;bal:=8;vol:=7;head:=s;End;
End;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{             D R A W  A  B U T T O N                                  }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure Button(nr:integer;press:boolean);
Begin
if (nr>0) and (nr<=Nrbuttons) then
Begin
With buttons[nr] do
 Begin
 if not(press) then
 Begin
  setcolor(black);
  line(x,y,u,y);line(x,y,x,v);
  setcolor(white);
  line(u,v,u,y);line(u,v,x,v);
  end
  else
  Begin
   setcolor(white);
  line(x,y,u,y);line(x,y,x,v);
  setcolor(black);
   line(u,v,u,y);line(u,v,x,v);
 end;
  if pr then setcolor(red) else setcolor(brown);outtextxy(x+2,y+7,head);
 End;
end;
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                S E T   UP  A  N E W   B U T T O N                    }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure NewButton(xx,yy,rx,ry:integer;s:string;st:boolean);
Begin
 inc(Nrbuttons);
 with buttons[nrbuttons] do
 Begin
  x:=xx*53+10+rx;y:=yy*23+10+ry;u:=x+50;v:=y+20;head:=s;
{  Button(nrbuttons,true);}
 End;
End;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{   S -  B    S T U F F                                                }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure ResetSb;
var temp:byte;
Begin
{Master SB}
temp:=getmixerregwss(sbport,$22);
temp:=(temp and 15);
volbuttons[15].vol:=temp;
{Wav Sb}
temp:=getmixerregwss(sbport,$04);
temp:=(temp and 15);
volbuttons[16].vol:=temp;
{Line sb}
temp:=getmixerregwss(sbport,$2e);
temp:=(temp and 15);
volbuttons[17].vol:=temp;
{Cd Sb}
temp:=getmixerregwss(sbport,$28);
temp:=(temp and 15);
volbuttons[18].vol:=temp;
{Fm Sb}
temp:=getmixerregwss(sbport,$26);
temp:=(temp and 15);
volbuttons[19].vol:=temp;
{Mic Sb}
temp:=getmixerregwss(sbport,$0A);
temp:=(temp and 15);
volbuttons[20].vol:=temp;
{Set all}
for temp:=15 to 20 do
Begin sync;volbutton(temp);setvol(temp);end;
End;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{            I F   B U T T O N   I S  P R E S S E D                    }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure LockButton;
var temp:byte;
Begin

Case akt of
{Input Devices}
  1:Begin
     temp:=getmixerregwss(wssport,0);{cd}
     setmixerregwss(wssport,0,(temp and 63) or 64);
     temp:=getmixerregwss(wssport,1);
     setmixerregwss(wssport,1,(temp and 63) or 64);
     buttons[1].pr:=true;buttons[3].pr:=false;
     buttons[2].pr:=false;buttons[9].pr:=false;
    End;
  2:Begin
     temp:=getmixerregwss(wssport,0);{line}
     setmixerregwss(wssport,0,(temp and 63));
     temp:=getmixerregwss(wssport,1);
     setmixerregwss(wssport,1,(temp and 63));
     buttons[2].pr:=true;buttons[3].pr:=false;
     buttons[1].pr:=false;buttons[9].pr:=false;
    End;
  3:Begin
     temp:=getmixerregwss(wssport,0);{mic}
     setmixerregwss(wssport,0,(temp and 63) or 128);
     temp:=getmixerregwss(wssport,1);
     setmixerregwss(wssport,1,(temp and 63) or 128);
     buttons[3].pr:=true;buttons[2].pr:=false;
     buttons[1].pr:=false;buttons[9].pr:=false;
    End;
{Speker Diameter}
  5:Begin
     setmixerregctrl(ctrlport,2,16);{Pc1}
     buttons[5].pr:=true;buttons[7].pr:=false;
     buttons[6].pr:=false;buttons[8].pr:=false;
    end;
  6:Begin
    setmixerregctrl(ctrlport,2,32);{Pc2}
     buttons[6].pr:=true;buttons[7].pr:=false;
     buttons[5].pr:=false;buttons[8].pr:=false;
    End;
  7:Begin
      setmixerregctrl(ctrlport,2,16+32);{Hifi}
     buttons[7].pr:=true;buttons[5].pr:=false;
     buttons[6].pr:=false;buttons[8].pr:=false;
    End;
  8:Begin
      setmixerregctrl(ctrlport,2,0); {Desk}
     buttons[8].pr:=true;buttons[7].pr:=false;
     buttons[6].pr:=false;buttons[5].pr:=false;
    End;
 9:Begin
     temp:=getmixerregwss(wssport,0);{all}
     setmixerregwss(wssport,0,(temp and 63) or 192);
     temp:=getmixerregwss(wssport,1);
     setmixerregwss(wssport,1,(temp and 63) or 192);
    buttons[9].pr:=true;buttons[3].pr:=false;
     buttons[2].pr:=false;buttons[1].pr:=false;
    End;
 {Swithes}
 10:Begin {Gain}
     If buttons[10].pr then Begin
                                   Buttons[10].pr:=false;
                                   temp:=getmixerregwss(wssport,0) and 223;
                                   setmixerregwss(wssport,0,temp);{Off}
                                  end
                                  else
                                  Begin
                                  buttons[10].pr:=true;
                                   temp:=getmixerregwss(wssport,0) and 223;
                                   setmixerregwss(wssport,0,temp or 32);{ON}
                                  end;
   End;
 11:Begin {lbe}
     If buttons[11].pr then Begin
   Buttons[11].pr:=false;setmixerregwss(wssport,13,0);{Off}
   volbuttons[10].mute:=true;sync;volbutton(10);
  end
  else
  Begin
  buttons[11].pr:=true;setmixerregwss(wssport,13,1); {ON}
  volbuttons[10].mute:=false;sync;volbutton(10);
  end;
  end;
 12:Begin {Aci}
     If buttons[12].pr then Begin
                                   Buttons[12].pr:=false;
                                   temp:=getmixerregwss(wssport,9);
                                   setmixerregwss(wssport,9,temp and 251);{OFF}
                                  end
                                  else
                                  Begin
                                  buttons[12].pr:=true;
                                   temp:=getmixerregwss(wssport,9);
                                   setmixerregwss(wssport,9,temp or 4);{ON}
                                  end;
    end;
 13:Begin {3D}
     If buttons[13].pr then Begin
 Buttons[13].pr:=false;
 setmixerregctrl(ctrlport,19,1);{Off}
 volbuttons[7].mute:=true;
 volbuttons[8].mute:=true;
 volbuttons[9].mute:=true;
 sync;
 volbutton(7);
 sync;
                                   volbutton(8);
                                   sync;
                                   volbutton(9);
                                  end
                                  else
                                  Begin
                                  buttons[13].pr:=true;
                                  setmixerregctrl(ctrlport,19,0);{ON}
                                   volbuttons[7].mute:=false;
                                   volbuttons[8].mute:=false;
                                   volbuttons[9].mute:=false;
                                   sync;
                                   volbutton(7);
                                   sync;
                                   volbutton(8);
                                   sync;
                                   volbutton(9);
                                  end;
    end;
 14:if dooropen then Insertdoor else EjectDoor;
 15:if cdtrack<>(0) then Begin buttons[15].pr:=true;PlayTrack(cdtrack);end;
 16:PauseAudio;
 17:if drvbusy then
               Begin
                pauseaudio;
                buttons[17].pr:=true;
                buttons[15].pr:=false;
               End
                 else
               Begin
               resumeaudio;
               buttons[17].pr:=false;
               buttons[15].pr:=true;
              end;
 18:Playnexttrk;
 19:playprevtrk;
 20:if locked then Begin
                    buttons[20].pr:=false;
                    unlockdoor
                    end
                    else
                    Begin
                    buttons[20].pr:=true;
                    lockdoor;
                   end;
 21: if (cdtrack<nrtracks) then inc(cdtrack);
 22: if (cdtrack>1) then dec(cdtrack);
 23:Begin
      buttons[23].pr:=true;
      buttons[24].pr:=false;
      buttons[25].pr:=false;
      buttons[26].pr:=false;
      temp:=getmixerregwss(sbport,$0c);
      temp:=(temp and 248) or (1);
      setmixerregwss(sbport,$0c,temp);
    end;
 24:Begin
      buttons[24].pr:=true;
      buttons[23].pr:=false;
      buttons[25].pr:=false;
      buttons[26].pr:=false;
      temp:=getmixerregwss(sbport,$0c);
      temp:=(temp and 248) or (1+2+4);
      setmixerregwss(sbport,$0c,temp);
    end;
 25:Begin
      buttons[25].pr:=true;
      buttons[24].pr:=false;
      buttons[23].pr:=false;
      buttons[26].pr:=false;
      temp:=getmixerregwss(sbport,$0c);
      temp:=(temp and 248) or (1+4);
      setmixerregwss(sbport,$0c,temp);
    end;
 26:Begin
      buttons[26].pr:=true;
      buttons[24].pr:=false;
      buttons[25].pr:=false;
      buttons[23].pr:=false;
      temp:=getmixerregwss(sbport,$0c);
      temp:=(temp and 248) or (1+2);
      setmixerregwss(sbport,$0c,temp);
    end;
 27: Begin setmixerregwss(sbport,0,0);resetsb;end;
 28:Begin
   if buttons[28].pr=false then
      Begin
      buttons[28].pr:=true;
      temp:=getmixerregwss(sbport,$0c);
      temp:=(temp and 247);
      setmixerregwss(sbport,$0c,temp);
      end
      else
      Begin
      buttons[28].pr:=false;
      temp:=getmixerregwss(sbport,$0c);
      temp:=(temp and 247) or 8;
      setmixerregwss(sbport,$0c,temp);
      end
    end;
 29:Begin
   if buttons[29].pr=false then
      Begin
      buttons[29].pr:=true;
      temp:=getmixerregwss(sbport,$0c);
      temp:=(temp and 223);
      setmixerregwss(sbport,$0e,temp);
      end
      else
      Begin
      buttons[29].pr:=false;
      temp:=getmixerregwss(sbport,$0c);
      temp:=(temp and 223) or 32;
      setmixerregwss(sbport,$0e,temp);
      end
    end;
 30:Begin
   if buttons[30].pr=false then
      Begin
      buttons[30].pr:=true;
      temp:=getmixerregwss(sbport,$0c);
      temp:=(temp and 223);
      setmixerregwss(sbport,$0c,temp);
      end
      else
      Begin
      buttons[30].pr:=false;
      temp:=getmixerregwss(sbport,$0c);
      temp:=(temp and 223) or 32;
      setmixerregwss(sbport,$0c,temp);
      end
    end;
 31:Begin
   if buttons[31].pr=false then
      Begin
      buttons[31].pr:=true;
      temp:=getmixerregwss(sbport,$0e);
      temp:=(temp and 253);
      setmixerregwss(sbport,$0e,temp);
      end
      else
      Begin
      buttons[31].pr:=false;
      temp:=getmixerregwss(sbport,$0e);
      temp:=(temp and 253) or 2;
      setmixerregwss(sbport,$0e,temp);
      end
    end;
  32:resetsb;
  33:Begin if buttons[33].pr=true then buttons[33].pr:=false else
        buttons[33].pr:=true;setdfrbit(buttons[33].pr);
    End;
{  34:Begin if buttons[34].pr=true then buttons[34].pr:=false else
        buttons[34].pr:=true;setani;
     end;
  35:Begin
       buttons[35].pr:=not(buttons[35].pr);
       setani;
    End;
  37:Begin
       trt:=trt xor 1;
       buttons[37].pr:=not(buttons[37].pr);
       setani;
     End;
  38:Begin
       trt:=trt xor 2;
       buttons[38].pr:=not(buttons[38].pr);

       setani;
     End;
  39:Begin
       trt:=trt xor 4;
       buttons[39].pr:=not(buttons[39].pr);

       setani;
     End;
  40:Begin
       trt:=trt xor 8;
       buttons[40].pr:=not(buttons[40].pr);
       setani;
       End;}

 47:setdfr(1);
 48:setdfr(15);
 49:setdfr(0);
 50:setdfr(3);
 51:setdfr(14);
 52:setdfr(5);
 53:setdfr(2);
 54:setdfr(7);
 55:setdfr(4);
 56:setdfr(6);
 57:setdfr(13);
 58:setdfr(9);
 59:setdfr(11);
 60:setdfr(12);
 end;

 {setcolors}
{ hide;}
 for temp:=1 to nrbuttons do
 Begin
 if buttons[temp].pr then buttons[temp].bcolor:=red
                     else buttons[temp].bcolor:=brown;
{ sync;}
 button(temp,true);
 end;
{  show;}
end;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{  I F  B U T T O N S ID      A F F E C T E D                          }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure LockMouse ;
Var i:integer;
Begin
{Getmouse;}
 for i:=1 to Nrbuttons do
  with buttons[i] do
  Begin
   if ((x<=mx)and(u>=mx)and(y<=my)and(v>=my)and(lb)) then
   Begin
     smvi;sync;Button(i,false);       {Draw Pressed button}
     Repeat showgra;Until not(lb);    {Wait for button relase}
     if ((x<=mx)and(u>=mx)and(y<=my)and(v>=my)) then akt:=i;
     sync;Button(i,true);LockButton;   {Draw Final Button}
     smv;
   End;
   end;
End;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                 I F V O L U M E   A F F E C T E D                    }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure LockVolume;
var mo:integer;
Begin
 for i:=1 to NrVolButtons do
 With volbuttons[i] do
 Begin
  if ((mx>=vx) and (mx<=vu) and (my>=vy) and (my<=vv) and (lb)) then
  Begin
  mo:=my;
   Repeat
    if ((my<>mo) and (my>=(y+20)) and (my<=(v-10))
                 and (mx>=(x)) and (mx<=(u))) then
   Begin
    vol:=1+(15-(16*(my-(y+20)) div (v-y-30)));
    if vol<1 then vol:=1;
    if vol>16 then vol:=16;
    vol:=vol-1;smvi;sync;volbutton(i);setvol(i);smv;
   end;
   mo:=my;
   showgra;
{   Effects;}
   Until not(lb);
  end;
 end;
End;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                  L O C K  T H E  B A L A N C E                       }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure LockBalance;
var mo:integer;
Begin
 {Getmouse;}
 for i:=1 to NrVolButtons do
 With volbuttons[i] do
 Begin
  if ((mx>=bx) and (mx<=bu) and (my>=by) and (my<=bv) and (lb)) then
  Begin
  mo:=mx;
   Repeat
   {getmouse;}
    if ((mx<>mo) and (my>=(y+3)) and (my<=(y+10))
                 and (mx>=(x+3)) and (mx<=(u-3))) then
   Begin
    bal:=(16*(mx-x) div (u-x-8));
    if bal<1 then bal:=1;
    if bal>16 then bal:=16;
    bal:=bal-1;
    smvi;sync;volbutton(i);setvol(i);smv;
   end;
   mo:=mx;
   showgra;
   Until not(lb);
  end;
 end;
End;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                 L O C K   M U T E D  V O L S                         }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure LockMute;
var mo:integer;
Begin
 {Getmouse;}
 for i:=1 to NrVolButtons do
 With volbuttons[i] do
 Begin
   if ((lb) and (my>=(v+2)) and (mx>=(x+2)) and (my<=(v+10))
   and (mx<=(x+40))) then
  Begin
   Repeat
   {getmouse;}
   showgra;
   Until not(lb);
    if ((i<>7) and (i<>8) and (i<>9) and (i<>10)) then
    mute:=not(mute);
{    hide;}
    smvi;sync;volbutton(i);setvol(i);smv;
{    show;}
  end;
 end;
End;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{  I N I T  T H E  V A R I A B L E S                                   }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

Procedure InitVars;
var temp:byte;
Begin

{BUTTONS}
 for temp:=1 to nrbuttons do buttons[temp].pr:=false;
 temp:=getmixerregwss(wssport,0);
 if (temp and 32)=32 then buttons[10].pr:=true;{gain}
 if ((temp and 128)=128) and ((temp and 64)=64){inp}
                         then buttons[9].pr:=true else
 if ((temp and 128)<>128) and ((temp and 64)=64)
                         then buttons[1].pr:=true else
 if ((temp and 128)=128) and ((temp and 64)<>64)
                         then buttons[3].pr:=true else
                              buttons[2].pr:=true;
 temp:=getmixerregctrl(ctrlport,2);{dia}
 if ((temp and 16)=16) and ((temp and 32)=32)
                       then buttons[7].pr:=true else
 if ((temp and 16)<>16) and ((temp and 32)=32) then
                         buttons[6].pr:=true else
 if ((temp and 16)=16) and ((temp and 32)<>32) then
                         buttons[5].pr:=true else
                            buttons[7].pr:=true;
 temp:=getmixerregwss(wssport,9);{aci}
 if (temp and 4)=4 then buttons[12].pr:=true;
 temp:=getmixerregwss(wssport,13);{lbe}
 if (temp and 1)=1 then buttons[11].pr:=true;
 temp:=getmixerregctrl(ctrlport,19);{3d}
 if (temp and 1)=0 then buttons[13].pr:=true;
 temp:=getmixerregwss(wssport,8);{out/in filter}
 if (temp and 1)=1 then buttons[37].pr:=true else buttons[37].pr:=false;
 if (temp and 2)=2 then buttons[38].pr:=true else buttons[38].pr:=false;
 if (temp and 4)=4 then buttons[39].pr:=true else buttons[39].pr:=false;
 if (temp and 8)=8 then buttons[40].pr:=true else buttons[40].pr:=false;
 trt:=temp;
 lockbutton;
 {Volume controls}

 for temp:=1 to nrvolbuttons do volbuttons[temp].mute:=false;
{master}
temp:=getmixerregctrl(ctrlport,7);
if (temp and 128)=128 then volbuttons[1].mute:=true;
temp:=temp and 15;
volbuttons[1].vol:=15-temp;

{Line}
temp:=getmixerregwss(wssport,18);
if (temp and 128)=128 then volbuttons[2].mute:=true;
temp:=temp and 31;volbuttons[2].vol:=(31-temp) div 2;
{Cd}
temp:=getmixerregwss(wssport,2);
if (temp and 128)=128 then volbuttons[4].mute:=true;
temp:=temp and 31;
volbuttons[4].vol:=(31-temp) div 2;
{Wav}
temp:=getmixerregwss(wssport,6);
if (temp and 128)=128 then volbuttons[5].mute:=true;
temp:=temp and 63;
volbuttons[5].vol:=(63-temp) div 4;
{Fm}
temp:=getmixerregwss(wssport,4);
if (temp and 128)=128 then volbuttons[6].mute:=true;
temp:=temp and 31;
volbuttons[6].vol:=(31-temp) div 2;
{bass}
temp:=getmixerregctrl(ctrlport,21);
if not(buttons[13].pr) then volbuttons[7].mute:=true;
temp:=temp and 7;
volbuttons[7].vol:=temp * 2;
{treble}
temp:=getmixerregctrl(ctrlport,22);
if not(buttons[13].pr) then volbuttons[8].mute:=true;
temp:=temp and 7;
volbuttons[8].vol:=(temp * 2);
{3D}
temp:=getmixerregctrl(ctrlport,20);
if not(buttons[13].pr) then volbuttons[9].mute:=true;
temp:=temp and 7;
volbuttons[9].vol:=(temp * 2);
{Input}
temp:=getmixerregwss(wssport,0);
if not (buttons[11].pr) then volbuttons[10].mute:=true;
temp:=temp and 15;
volbuttons[10].vol:=temp;
{Speak}
if (temp and 128)=128 then volbuttons[11].mute:=true;
temp:=getmixerregwss(wssport,26);
temp:=temp and 15;
volbuttons[11].vol:=15-temp;
{Mic}
temp:=getmixerregctrl(ctrlport,9);
if (temp and 128)=128 then volbuttons[3].mute:=true;
temp:=temp and 31;
volbuttons[3].vol:=(31-temp) div 2;

volbuttons[12].vol:=(AudVolume div 16);volbuttons[12].mute:=false;
volbuttons[13].vol:=0;volbuttons[13].mute:=false;
volbuttons[14].vol:=0;volbuttons[14].mute:=false;
{Master SB}
temp:=getmixerregwss(sbport,$22);
temp:=(temp and 15);
volbuttons[15].vol:=temp;
{Wav Sb}
temp:=getmixerregwss(sbport,$04);
temp:=(temp and 15);
volbuttons[16].vol:=temp;
{Line sb}
temp:=getmixerregwss(sbport,$2e);
temp:=(temp and 15);
volbuttons[17].vol:=temp;
{Cd Sb}
temp:=getmixerregwss(sbport,$28);
temp:=(temp and 15);
volbuttons[18].vol:=temp;
{Fm Sb}
temp:=getmixerregwss(sbport,$26);
temp:=(temp and 15);
volbuttons[19].vol:=temp;
{Mic Sb}
temp:=getmixerregwss(sbport,$0A);
temp:=(temp and 15);
volbuttons[20].vol:=temp;
{Set all}
for temp:=1 to nrvolbuttons do
Begin
sync;
volbutton(temp);
setvol(temp);
end;

End;



Procedure RefreshCd;
var text,ttext:string;
Begin
{if not(drvbusy) then}
 if (cdtrack=0) then
  if nodisc then
   Begin
   setfillstyle(solidfill,10);
   bar(14,449,160,457);
   str(nrtracks,text);
   outtextxy(15,450,'Total:'+text);

   end
  else
   Begin
   getdiscinfo(cdinfo);
   nrtracks:=cdinfo.length.trk;
   curtrkpos(cdvar);
   cdtrack:=cdvar.trk;
   if cdtrack=0 then setcolor(10) else setcolor(blue);
      setfillstyle(solidfill,10);
   bar(14,449,160,457);
   str(nrtracks,text);
   outtextxy(15,450,'Total:'+text);

   end
 else
 if nodisc then
  Begin
   cdtrack:=0;
  end
  else
  Begin
  gettrkloc(cdinfo,trk);
  end;
   sync;
   setfillstyle(solidfill,10);
 bar(14+70,440,168,457);
 nrtracks:=cdinfo.length.trk;
 if not(nodisc) then cdtrack:=cdvar.trk;
 if cdtrack=0 then setcolor(10) else setcolor(blue);
 curtrkpos(cdvar);
{ outtextxy(15,450,'Total:'+text);}
 str(cdvar.trk,text);
 outtextxy(90,450,'Pos:'+text);
 gettrkrem(cdvar);
 if (cdtrack=0) or not(drvbusy) then Begin cdvar.min:=0;cdvar.sec:=0;cdvar.frm:=0;end;
 str(cdvar.min,text);
 ttext:=text+':';
 str(cdvar.sec,text);
 ttext:=ttext+text+':';
 str(cdvar.frm,text);
 ttext:=ttext+text;
  sync;
     setfillstyle(solidfill,10);
   bar(14,449-10,168,457-10);
  outtextxy(15,440,'Time left:'+ttext);
End;

Procedure CdInit;
var text:string;
Begin
 insertdoor;
 cdtrack:=0;
   getdiscinfo(cdinfo);
   nrtracks:=cdinfo.length.trk;
   cdtrack:=cdvar.trk;
   if cdtrack=0 then setcolor(cyan) else setcolor(blue);
      setfillstyle(solidfill,10);
   bar(14,449,160,457);
   str(nrtracks,text);
   outtextxy(15,450,'Total:'+text);

 Refreshcd;
End;

{+++++++++++++++++ G R A P H I C S   I N I T   +++++++++++++++++++++++++++++}

Procedure InitGraphics;
Var i:integer;
Begin
{ setfillstyle(solidfill,lightgray+64);
 bar(0,0,getmaxx,getmaxy);}
 palleolvas(pal2);
 for i:=0 to 255 do szinbeallit(i,0,0,0);
 for i:=0 to 15 do  {MOUSE}
 for j:=0 to 7 do
 Begin putpixel(j,i,curs[i,j]);end;
 size:=imagesize(0,0,7,15);
 getmem(pmask,size);
 getmem(pscr,size);
 getmem(pold,size);
 getimage(0,0,7,15,pmask^);
 cleardevice;
 bmpbetolt('mixer4.bmp');
 setbkcolor(10);
 for i:=0 to 63 do
 pal[i+64]:=pal1[i];
 setcolor(black);
 line(5,5,getmaxx-5,5);line(5,5,5,getmaxy-5);
 setcolor(white);
 line(getmaxx-5,getmaxy-5,getmaxx-5,5);
 line(getmaxx-5,getmaxy-5,5,getmaxy-5);
 setcolor(black);
 line(10,160,getmaxx-10,160);
 line(10,160,10,180);
 setcolor(white);
 line(10,180,getmaxx-10,180);
 line(getmaxx-10,180,getmaxx-10,160);
 line(10+5,160+2,getmaxx-15,160+2);
 line(10+5,160+2,10+5,180-2);
 line(10+5,300+2,getmaxx-15,300+2);
 line(10+5,300+2,10+5,305-2);
 line(10+5,310+2,getmaxx-15,310+2);
 line(10+5,310+2,10+5,315-2);
 setcolor(black);
 line(10+5,180-2,getmaxx-15,180-2);
 line(getmaxx-15,180-2,getmaxx-15,160+2);
 line(getmaxx-15,305-2,getmaxx-15,300+2);
 line(getmaxx-15,305-2,10+5,305-2);
 line(getmaxx-15,315-2,getmaxx-15,310+2);
 line(getmaxx-15,315-2,10+5,315-2);
{ line(8,316,170,316);line(8,316,8,460);
 setcolor(white);
 line(8,460,170,460);line(170,316,170,460);}
 {Logos}
 settextstyle(2,horizdir,1);setusercharsize(2,1,1,1);
 setcolor(white);outtextxy(320,163,'Studio Mixer');
 setcolor(Magenta);
 for i:=1 to 2 do outtextxy(320+i,164,'Studio Mixer');
 setcolor(blue);settextstyle(0,horizdir,0);
 outtextxy(10,147,'      L  E  F  T');
 outtextxy(600,147,'      R  I  G  H  T');
{ outtextxy(15,320,'  CD CONTROL BOX');}
 outtextxy(25,290,'|_ OPLSA3 Mixer _|');
 outtextxy(200,290,'|________ WSS Mixer.Ver:'+s+'.'+m+'_________|');
 outtextxy(540,290,'|___Sound Blaster Pro Mixer__|');
 {Left}
 setfillstyle(solidfill,black+64);
 bar(20,10,180,140);
 setcolor(brown);
 line(19,9,181,9);line(19,9,19,140);
 setcolor(white);
 line(19,141,181,141);line(181,141,181,9);

{right}
  setfillstyle(solidfill,black+64);
 bar(620,10,780,140);
 setcolor(brown);
 line(619,9,781,9);line(619,9,619,140);
 setcolor(white);
 line(619,141,781,141);line(781,141,781,9);
 {jOBB SPECTBAR}
 {setcolor(brown);
 line(599,9,611,9);Line(599,141,599,9);
 setcolor(white);
 line(611,9,611,141);Line(599,141,611,141);}
  setcolor(blue);
 for i:=0 to 10 do
 Begin
  if (i/5)<>(i div 5) then line(594,10+i*13,598,10+i*13) else
  line(588,10+i*13,600,10+i*13);
  settextstyle(2,horizdir,1);
  setusercharsize(3,4,3,4);
 End;
  setcolor(white);
  outtextxy(613,7,'0');
  outtextxy(613,35,'5');
  outtextxy(611,72,'10');
  outtextxy(611,115,'15');
  outtextxy(611,142,'20 dB');


  for i:=0 to 12 do
  Begin
{  setcolor(white);
  line(600,10+i*10,610,10+i*10);
  line(600,10+i*10,600,20+i*10);
  setcolor(black);
  line(600,20+i*10,610,20+i*10);
  line(610,10+i*10,610,20+i*10);}
  setfillstyle(solidfill,220+i);
  bar(601,11+i*10,609,19+i*10);
  end;
{BAL SPEKTBAR}
{ setcolor(brown);
 line(189,9,201,9);Line(189,9,189,141);
 setcolor(white);
 line(201,9,201,141);Line(189,141,201,141);}
 setcolor(blue);
 for i:=0 to 10 do
 Begin
  if (i/5)<>(i div 5) then line(202,10+i*13,208,10+i*13) else
  line(190,10+i*13,212,10+i*13);
  settextstyle(2,horizdir,1);
  setusercharsize(3,4,3,4);
 End;
  setcolor(white);
  outtextxy(185,7,'0');
  outtextxy(185,35,'5');
  outtextxy(183,72,'10');
  outtextxy(183,115,'15');
  outtextxy(183,142,'20 dB');

 settextstyle(0,0,0);
   for i:=0 to 12 do
  Begin
{  setcolor(white);
  line(190,8+i*10,200,8+i*10);
  line(190,8+i*10,190,18+i*10);
  setcolor(black);
  line(190,18+i*10,290,18+i*10);
  line(200,8+i*10,200,18+i*10);}
  setfillstyle(solidfill,200+i);
  bar(191,11+i*10,199,19+i*10);

  end;

 {sTEREO ANI}
{setfillstyle(solidfill,black+64);}
{ bar(300,140,500,150);
 setcolor(brown);
 line(299,139,501,139);Line(299,139,299,151);
 setcolor(white);
 line(501,139,501,151);Line(299,151,501,151);}
 for i:=0 to 19 do
 Begin
 setfillstyle(solidfill,170+i);
 bar(301+i*10,141,301+8+i*10,149);
 end;
 setcolor(blue);
 for i:=0 to 10 do
 if (i/5)<>(i div 5) then line(300+i*20,138,300+i*20,132) else
                          line(300+i*20,150,300+i*20,128);
 outtextxy(397,152,'0');
 outtextxy(397-100,152,'L');
 outtextxy(397+100,152,'R');
 for i:=1 to nrbuttons do
 button(i,true);
 for i:=1 to nrvolbuttons do
 volbutton(i);
End;

Procedure Init ;
var gd,gm:integer;
Begin
{Initialise Video}
 waitwss;
 ver:=getmixerregwss(wssport,$0c);
 str((ver div 100):2,s);
 str((ver-(ver div 100)*100):2,m);
 gd:=installuserdriver('svga256',nil);
 gm:=3;initgraph(gd,gm,'c:\bp\bgi');
 if grok<>graphresult then error(1);
 vmode($5e);
{Save palette}
palleolvas(pal1);
{Init Screen}

 InitGraphics;
{CD init}
 Cdtrack:=0;
 pauseaudio;
 CdInit;

{sbinit}
{ resetdsp(2,5,1,5);resetsb;setmixerregwss(wssport,73,128);
 setmixerregwss(wssport,92,16+64);setmixerregwss(wssport,9,2);}
 FOR I:=1 to 400 do begin temp[1,i]:=127;temp[2,i]:=127;end;
{Buttons init}
 NrButtons:=0;
{1} NewButton(4,1,-7,-20,'  CD',false);
{2} NewButton(5,1,-7,-20,' LINE',false);
{3} NewButton(6,1,-7,-20,' MIC',false);
{4} NewButton(10,6,-7,-20,' EXIT',false);
{5} NewButton(4,2,-7,-20,' Pc1',false);
{6} NewButton(5,2,-7,-20,' Pc2',false);
{7} NewButton(6,2,-7,-20,' HiFi',false);
{8} NewButton(7,2,-7,-20,' Desk',false);
{9} NewButton(7,1,-7,-20,' ALL',false);
{10} NewButton(4,3,-7,-20,' Gain',false);
{11} NewButton(5,3,-7,-20,' LBE',false);
{12} NewButton(6,3,-7,-20,' ACI',false);
{13} NewButton(7,3,-7,-20,' 3D',false);
{14} NewButton(0,14,0,0,'Eject',false);
{15} NewButton(1,14,0,0,'   >',false);
{16} NewButton(2,14,0,0,'  þþ',false);
{17} NewButton(3,14,0,0,'  ||',false);
{18} NewButton(4,14,0,0,'  >>',false);
{19} NewButton(5,14,0,0,'  <<',false);
{20} NewButton(6,14,0,0,' L/U',false);
{21} NewButton(7,14,0,0,' Next',false);
{22} NewButton(8,14,0,0,' Prev',false);
{23} NewButton(9,1,-7,-20,' Mic',false);
{24} NewButton(9,2,-7,-20,' Line',false);
{25} NewButton(9,3,-7,-20,' Cd',false);
{26} NewButton(9,4,-7,-20,' N/A',false);
{27} NewButton(9,5,-7,-20,'Reset',false);
{28} NewButton(8,1,-7,-20,'Filter',false);
{29} NewButton(8,2,-7,-20,' Out',false);
{30} NewButton(8,3,-7,-20,' In',false);
{31} NewButton(8,4,-7,-20,' M/S',false);
{32} NewButton(8,5,-7,-20,'SBRes',false);
{33} Newbutton(4,5,-7,-20,'8/16',false);
{34} Newbutton(5,5,-7,-20,'Ultra',false);
{35} Newbutton(6,5,-7,-20,'Echo',false);
{36} Newbutton(7,5,-7,-20,' T2',false);
{37} Newbutton(4,4,-7,-20,'Set1',false);
{38} Newbutton(5,4,-7,-20,'Set2',false);
{39} Newbutton(6,4,-7,-20,'Set3',false);
{40} Newbutton(7,4,-7,-20,'Set4',false);
{41} Newbutton(10,1,-7,-20,' T2',false);
{42} Newbutton(10,2,-7,-20,' Play',false);
{43} Newbutton(10,3,-7,-20,' Stop',false);
{44} Newbutton(10,4,-7,-20,'  S3',false);
{45} Newbutton(10,5,-7,-20,'  S4',false);
{46} Newbutton(4,6,-7,-20,'  SM',false);
{47} NewButton(0,15,0,0,'5513',false);
{48} NewButton(1,15,0,0,'6615',false);
{49} NewButton(2,15,0,0,'8000',false);
{50} NewButton(3,15,0,0,'9600',false);
{51} NewButton(4,15,0,0,'11025',false);
{52} NewButton(5,15,0,0,'16000',false);
{53} NewButton(6,15,0,0,'18900',false);
{54} NewButton(7,15,0,0,'22050',false);
{55} NewButton(8,15,0,0,'27429',false);
{56} NewButton(9,15,0,0,'32000',false);
{57} NewButton(10,15,0,0,'33075',false);
{58} NewButton(11,15,0,0,'37800',false);
{59} NewButton(12,15,0,0,'44100',false);
{60} NewButton(13,15,0,0,'48000',false);
{VolButtons Init}
 Akt:=0;
 for i:=1 to nrbuttons do Buttons[i].Pr:=False;
{1}  Newvolbutton( 1 ,2,0, 'Mast ' )   ;
{2}  Newvolbutton( 8 ,2,0, 'Line ' )   ;
{3}  Newvolbutton( 9 ,2,0, ' Mic ' )   ;
{4}  Newvolbutton(10 ,2,0, ' CD  ' )   ;
{5}  Newvolbutton( 5 ,2,0, 'Wave ' )   ;
{6}  Newvolbutton( 6 ,2,0, 'Synt ' )   ;
{7}  Newvolbutton( 2 ,2,0, 'Bass ' )   ;
{8}  Newvolbutton( 3 ,2,0, 'Treb ' )   ;
{9}  Newvolbutton( 4 ,2,0, ' 3D  ' )   ;
{10} Newvolbutton( 7 ,2,0, 'Input' )   ;
{11} Newvolbutton(11 ,2,0, 'Speak' )   ;
{12} Newvolbutton(12 ,2,0, 'CDvol' )   ;
{13} Newvolbutton(13 ,2,0, 'Mast ' )   ;
{14} Newvolbutton(14 ,2,0, 'Wav  ' )   ;
{15} Newvolbutton(15 ,2,0, 'Line ' )   ;
{16} Newvolbutton(16 ,2,0, ' Cd  ' )   ;
{17} Newvolbutton(17 ,2,0, ' Fm  ' )   ;
{18} Newvolbutton(18 ,2,0, 'Mic  ' )   ;
{Volume & Buttons dates init}
 InitVars;
{Restore palette}
Palbeallit(pal);
Szinbeallit(255,255,255,255);
for i:=0 to 4 do
Begin
 szinbeallit(200+i,40,00,0);
 szinbeallit(220+i,40,00,0);
end;
for i:=5 to 12 do
Begin
 szinbeallit(200+i,00,20,0);
 szinbeallit(220+i,00,20,0);
end;
for i:=0 to 19 do
szinbeallit(170+i,0,20,0);
 {Lets goo!}
 resetmouse;
 rb:=false;lb:=false;
{ Getintvec(8,@old);
 setintvec(8,@Effect);}
{ asm
 pushf
 cli
 end;
 port[$43]:=$36;
 port[$40]:=10;
 port[$40]:=0;
 asm
 popf
 sti;
 end;}
End;

{Program end sequence}

Procedure Done;
Begin
 {asm
 pushf
 cli
 end;
 port[$43]:=$36;
 port[$40]:=0;
 port[$40]:=0;
 asm
 popf
 sti;
 end;
}
{ setintvec(8,@old);}
 Mouseend;
 Freemem(pmask,size);
 Freemem(pscr,size);
 Freemem(pold,size);
 Closegraph;
End;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{++++++++++               M A I N  --  P R O G R A M           ++++++++++++}
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Begin
 Init;
 getimage(0,0,7,15,pold^);
 Repeat
  Sm            ;
  LockMouse     ;
  LockVolume    ;
  LockBalance   ;
  LockMute      ;
  {RefreshCd}   ;
  ShowGra       ;

  if Keypressed then
  Begin Ch:=readkey;
  if Keypressed then Ch:=readkey;
  End;
 until (Akt=4) or (ch=#27);
 Done;

End.
