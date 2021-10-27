{$G+}
USES Crt,Graph,cdaudio,sbdsp,mygra,mymouse,sound;
Var
     Buttons : array[1..50] of record
                                 x,y:integer ;  {Position}
                                 u,v:integer ;  {End Pos}
                                head:string[8]; {Button Name}
                                bcolor:byte;
                                pr:boolean;
                              end;
     VolButtons : array[1..40] of record
                               x,y:integer ;
                               u,v:integer ;
                               bal:integer ;
                               vol:byte ;
                               mute:boolean;
                               head:string[8];
                               bx,by,bu,bv:integer;
                               vx,vy,vu,vv:integer;
                              end;
     Palette,OldPalette:palettetype;
    Temp : array[1..3,1..400] of longint;
    zene:array[1..10000] of byte;
    zi:integer;
     NrButtons:byte;
     NrVolButtons:byte;
     akt:byte;
     i,j,k:integer;
     ch:char;
     cdtrack:integer;
     cdinfo:discRec;
     nrtracks:byte;
     cdvar:tmsf;
     trk:byte;
     ste:integer;
     trt:byte;

Procedure Eff;interrupt;

Begin

End;


Procedure Error(n:byte);
Begin
case n of
1:Begin
   writeln('Graphics initialisation error!');
   halt(1);
  End;
end;
End;


Procedure Effect;
var i,j,k:integer;
Begin
{if buttons[34].pr then}
Begin
 for i:=1 to 100 do
 Begin
 zi:=zi+1;
 if zi>(volbuttons[13].vol*600) then zi:=1;
 port[$537]:=(zene[zi]);
 zene[zi]:=(port[$537]+zene[zi]) div 2;
 for k:=1 to volbuttons[14].vol*20 do begin end;
 End;
end;
End;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{             O S C I L L O S C O P E & V-U M E T E R S                }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

Procedure ShowGra;
Var i,k:integer;
    tot1,tot2:longint;
    b:byte;
    temp1:integer;
    ste:longint;
    s:string;
Begin

ste:=0;
tot1:=0;tot2:=0;
 for i:=192 to 350 do
 Begin
  putpixel(i+269,temp[1,i] div 2+11,black);
  putpixel((i-190)+20,temp[2,i] div 2+11,black);
  putpixel(i+270,370+temp[3,i] div 4,lightgray);
if buttons[33].pr then
Begin temp[1,i]:=port[$537];temp[2,i]:=port[$537];End else
Begin if buttons[34].pr then
 Begin
  temp[1,i]:=port[$537];temp1:=port[$537];temp[2,i]:=port[$537];temp1:=port[$537];
  if temp[1,i]>255 then temp[1,i]:=255;if temp[1,i]<0 then temp[1,i]:=0;
  if temp[2,i]>255 then temp[2,i]:=255;if temp[2,i]<0 then temp[2,i]:=0;
 End
   else
 Begin
  temp[1,i]:=port[$537];temp[1,i]:=((temp[1,i]+255*port[$537]) div 256)+127;
  temp[2,i]:=port[$537];temp[2,i]:=((temp[2,i]+255*port[$537]) div 256)+127;
 end;
 temp[3,i]:=temp[1,i]-temp[2,i];
 for j:=0 to 50 do begin end;
end;
  putpixel(i+269,temp[1,i] div 2+11,white);
  putpixel((i-190)+20,temp[2,i] div 2+11,white);
  putpixel(i+270,370+temp[3,i] div 4,blue);
  inc(tot1,ABS(temp[2,i]-127));inc(tot2,ABS(temp[1,i]-127));
 End;
 ste:=(tot1-tot2) div 40;if ste<-80 then ste:=-80 else if ste>80 then ste:=80;
 fillbox(220,140,420,150,lightgray);
 if ste>0 then fillbox(320,140,320+ste,150,red) else fillbox(320+ste,140,320,150,red) ;
 tot1:=tot1 div 80;tot2:=tot2 div 80;
 if tot1>130 then tot1:=130;if tot1<0 then tot1:=130;
 fillbox(190,140-tot1,200,140,red);
 if tot1>70 then fillbox(190,10,200,140-tot1,yellow) else
  fillbox(190,10,200,140-tot1,lightgray);
 if tot2>130 then tot2:=130;if tot2<0 then tot2:=130;
 fillbox(440,140-tot2,450,140,red);
 if tot1>70 then fillbox(440,10,450,140-tot2,yellow) else
  fillbox(440,10,450,140-tot2,lightgray);
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
 fillbox(x,y,u,v,lightgray);line(x,y,u,y,white);line(x,y,x,v,white);
 line(u,v,u,y,black);line(u,v,x,v,black);
 if mute then setcolor(cyan) else setcolor(red);outtextxy(x+4,v+2,head);
 line(x+16,y+20,u-16,y+20,black);line(x+16,y+20,x+16,v-10,black);
 line(u-16,v-10,u-16,y+20,white);line(u-16,v-10,x+16,v-10,white);
 y1:=(v-10)-(vol*(v-y-30) div 16-2);y2:=y1-7;fillbox(x+4,y2,u-4,y1,lightgray);
 vx:=x+4;vu:=u-4;vy:=y2;vv:=y1;
 line(x+7,y2,u-7,y2,white);line(x+7,y2,x+7,y1,white);line(u-7,y1,u-7,y2,black);
 line(u-7,y1,x+7,y1,black);line(x+2,y+2,u-2,y+2,black);line(x+2,y+2,x+2,y+8,black);
 line(u-2,y+8,u-2,y+2,white);line(u-2,y+8,x+2,y+8,white);
 y1:=x+4+bal*((u-4)-(x+4)) div 16-2;y2:=y1+5;
 fillbox(y1,y+3,y2,y+7,brown);bx:=y1;by:=y+3;bu:=y2;bv:=y+7;
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
{13: setmixerregwss(wssport,13,(((15-vol)*2)) shr 3 );}
{14: setmixerregwss(wssport,72,(15-vol));}
15: Begin
   l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregwss(sbport,$22,((vol-l) + ((vol-r) shl 4)));
    end;
17: Begin
   l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregwss(sbport,$2e,((vol-l) + ((vol-r) shl 4)));
    end;
16: Begin
   l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregwss(sbport,$04,((vol-l) + ((vol-r) shl 4)));
    end;
20: Begin
   l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregwss(sbport,$0a,((vol-l) + ((vol-r) shl 4)));
    end;
19: Begin
   l:=0;r:=0;
    if bal<8 then l:=(7-bal)*vol div 7 else
    if bal>7 then r:=(bal-8)*vol div 7;
    setmixerregwss(sbport,$26,((vol-l) + ((vol-r) shl 4)));
    end;
18: Begin
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
  line(x,y,u,y,black);line(x,y,x,v,black);
  line(u,v,u,y,black);line(u,v,x,v,black);
  end
  else
  Begin
  line(x,y,u,y,white);line(x,y,x,v,white);
   line(u,v,u,y,black);line(u,v,x,v,black);
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
  x:=xx*53+10+rx;y:=yy*23+10+ry;u:=x+50;v:=y+20;head:=s;sync;
  Button(nrbuttons,true);
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

Procedure SetAni;
var b:byte;
Begin

    if buttons[33].pr then trt:=((trt and 15) or 16) else
                           trt:=((trt and 15) or 80);

    setmixerregwss(wssport,72,trt);
    b:=getmixerregwss(wssport,72);
    b:=getmixerregwss(wssport,72);
    delay(10);
    setmixerregwss(wssport,73,128+64);
    delay(10);
    delay(10);
   setmixerregwss(wssport,9,2+1);
End;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{            I F   B U T T O N   I S  P R E S S E D                    }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure LockButton;
var temp:byte;
Begin

Case akt of
{Input Devices}
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
  1:Begin
     temp:=getmixerregwss(wssport,0);{cd}
     setmixerregwss(wssport,0,(temp and 63) or 64);
     temp:=getmixerregwss(wssport,1);
     setmixerregwss(wssport,1,(temp and 63) or 64);
     buttons[1].pr:=true;buttons[3].pr:=false;
     buttons[2].pr:=false;buttons[9].pr:=false;
    End;
 9:Begin
     temp:=getmixerregwss(wssport,0);{all}
     setmixerregwss(wssport,0,(temp and 63) or 192);
     temp:=getmixerregwss(wssport,1);
     setmixerregwss(wssport,1,(temp and 63) or 192);
    buttons[9].pr:=true;buttons[3].pr:=false;
     buttons[2].pr:=false;buttons[1].pr:=false;
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
 {Swithes}
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
 27: Begin setmixerregwss(sbport,0,0);resetsb;end;
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
        buttons[33].pr:=true;setani;
    End;
  34:Begin if buttons[34].pr=true then buttons[34].pr:=false else
        buttons[34].pr:=true;setani;
     end;
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
       End;

 end;
{ setani;}

 {setcolors}
 disablemouse;
 for temp:=1 to nrbuttons do
 Begin
 if buttons[temp].pr then buttons[temp].bcolor:=red
                     else buttons[temp].bcolor:=brown;
{ sync;}
 button(temp,true);
 end;
  enablemouse;
end;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{  I F  B U T T O N S ID      A F F E C T E D                          }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure LockMouse ;
Var i:integer;
Begin
 Getmouse;
 for i:=1 to Nrbuttons do
  with buttons[i] do
  Begin
   if ((x<=mx)and(u>=mx)and(y<=my)and(v>=my)and(lb)) then
   Begin
    {Draw Pressed button}
     DisableMouse;sync;Button(i,false);EnableMouse;
    {Wait for button relase}
     Repeat
      showgra;
     Until NotPressed;
    {Lock Cursor pos}
     Getmouse;
     if ((x<=mx)and(u>=mx)and(y<=my)and(v>=my)) then akt:=i;
   {Draw Final Button}
     DisableMouse;sync;Button(i,true);EnableMouse;LockButton;
   End;
   end;
End;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                 I F V O L U M E   A F F E C T E D                    }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure LockVolume;
var mo:integer;
Begin
 Getmouse;
 for i:=1 to NrVolButtons do
 With volbuttons[i] do
 Begin
  if ((mx>=vx) and (mx<=vu) and (my>=vy) and (my<=vv) and (lb)) then
  Begin
  mo:=my;
   Repeat
   getmouse;
    if ((my<>mo) and (my>=(y+20)) and (my<=(v-10))
                 and (mx>=(x)) and (mx<=(u))) then
   Begin
    vol:=1+(15-(16*(my-(y+20)) div (v-y-30)));
    if vol<1 then vol:=1;
    if vol>16 then vol:=16;
    vol:=vol-1;disablemouse;sync;volbutton(i);enablemouse;setvol(i);
   end;
   mo:=my;
   showgra;
{   Effects;}
   Until NotPressed;
  end;
 end;

End;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                  L O C K  T H E  B A L A N C E                       }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure LockBalance;
var mo:integer;
Begin
 Getmouse;
 for i:=1 to NrVolButtons do
 With volbuttons[i] do
 Begin
  if ((mx>=bx) and (mx<=bu) and (my>=by) and (my<=bv) and (lb)) then
  Begin
  mo:=mx;
   Repeat
{   sound(50);delay(100);nosound;}
   getmouse;
    if ((mx<>mo) and (my>=(y+3)) and (my<=(y+10))
                 and (mx>=(x+3)) and (mx<=(u-3))) then
   Begin
{   sound(50);delay(100);nosound;}
    bal:=(16*(mx-x) div (u-x-8));
    if bal<1 then bal:=1;
    if bal>16 then bal:=16;
    bal:=bal-1;
    disablemouse;
    sync;
    volbutton(i);
    enablemouse;
    setvol(i);
   end;
   mo:=mx;
   showgra;
{   Effects;}
   Until NotPressed;
  end;
 end;

End;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                 L O C K   M U T E D  V O L S                         }
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Procedure LockMute;
var mo:integer;
Begin
 Getmouse;
 for i:=1 to NrVolButtons do
 With volbuttons[i] do
 Begin
   if ((lb) and (my>=(v+2)) and (mx>=(x+2)) and (my<=(v+10))
   and (mx<=(x+40))) then
  Begin
   Repeat
   getmouse;
   showgra;
   Until NotPressed;
    if ((i<>7) and (i<>8) and (i<>9) and (i<>10)) then
    mute:=not(mute);
    disablemouse;
    sync;
    volbutton(i);
    setvol(i);
    enablemouse;
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
   fillbox(14,449,160,457,lightgray);
   str(nrtracks,text);
   outtextxy(15,450,'Total:'+text);

   end
  else
   Begin
   getdiscinfo(cdinfo);
   nrtracks:=cdinfo.length.trk;
   curtrkpos(cdvar);
   cdtrack:=cdvar.trk;
   if cdtrack=0 then setcolor(cyan) else setcolor(blue);
   fillbox(14,449,160,457,lightgray);
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
 fillbox(14+70,449,160,457,lightgray);
 nrtracks:=cdinfo.length.trk;
 if not(nodisc) then cdtrack:=cdvar.trk;
 if cdtrack=0 then setcolor(cyan) else setcolor(blue);
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
   fillbox(14,449-10,168,457-10,lightgray);
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
   fillbox(14,449,160,457,lightgray);
   str(nrtracks,text);
   outtextxy(15,450,'Total:'+text);

 Refreshcd;
End;

{+++++++++++++++++ G R A P H I C S   I N I T   +++++++++++++++++++++++++++++}

Procedure InitGraphics;
Var i:integer;
Begin
 fillbox(0,0,getmaxx,getmaxy,lightgray);
 setbkcolor(black);
 line(5,5,getmaxx-5,5,black);line(5,5,5,getmaxy-5,black);
 line(getmaxx-5,getmaxy-5,getmaxx-5,5,white);
 line(getmaxx-5,getmaxy-5,5,getmaxy-5,white);
 line(10,160,getmaxx-10,160,black);
 line(10,160,10,180,black);
 line(10,180,getmaxx-10,180,white);
 line(getmaxx-10,180,getmaxx-10,160,white);
 line(10+5,160+2,getmaxx-15,160+2,white);
 line(10+5,160+2,10+5,180-2,white);
 line(10+5,300+2,getmaxx-15,300+2,white);
 line(10+5,300+2,10+5,305-2,white);
 line(10+5,310+2,getmaxx-15,310+2,white);
 line(10+5,310+2,10+5,315-2,white);
 line(10+5,180-2,getmaxx-15,180-2,black);
 line(getmaxx-15,180-2,getmaxx-15,160+2,black);
 line(getmaxx-15,305-2,getmaxx-15,300+2,black);
 line(getmaxx-15,305-2,10+5,305-2,black);
 line(getmaxx-15,315-2,getmaxx-15,310+2,black);
 line(getmaxx-15,315-2,10+5,315-2,black);
 line(8,316,170,316,black);line(8,316,8,460,black);
 line(8,460,170,460,white);line(170,316,170,460,white);
 {Logos}
 settextstyle(2,horizdir,1);setusercharsize(2,1,1,1);
 setcolor(white);outtextxy(190,163,'The Force Of The Voice');
 setcolor(Magenta);
 for i:=1 to 2 do outtextxy(190+i,164,'The Force Of The Voice');
 setcolor(blue);settextstyle(0,horizdir,0);
 outtextxy(10,147,'      L  E  F  T');
 outtextxy(440,147,'      R  I  G  H  T');
 outtextxy(15,320,'  CD CONTROL BOX');
 outtextxy(50,290,'  < < < < Windows Sound System  &  Yamaha  Mixer Panel > > > >');
 outtextxy(220,420,'Sound Blaster Pro Mixer');
 {Left}
 fillbox(20,10,180,140,black);
 line(19,9,181,9,brown);line(19,9,19,140,brown);
 line(19,141,181,141,white);line(181,141,181,9,white);
{right}
 fillbox(460,10,620,140,black);
 line(459,9,620,9,brown);line(459,9,459,140,brown);
 line(459,141,621,141,white);line(621,141,621,9,white);
 {jOBB SPECTBAR}
 line(439,9,451,9,brown);Line(439,141,439,9,brown);
 line(451,9,451,141,white);Line(439,141,451,141,white);
 for i:=9 to 141 do
 Begin
  if (i/5)=(i div 5) then line(434,i,438,i,brown) ;
  if (i/10)=(i div 10) then line(428,i,438,i,brown);
 End;
{BAL SPEKTBAR}
 line(189,9,201,9,brown);Line(189,9,189,141,brown);
 line(201,9,201,141,white);Line(189,141,201,141,white);
 for i:=9 to 141 do
 Begin
  if (i/5)=(i div 5) then line(202,i,208,i,brown);
  if (i/10)=(i div 10) then line(202,i,212,i,brown);
 End;
 {sTEREO ANI}
 fillbox(220,140,420,150,black);
 line(219,139,421,139,brown);Line(219,139,219,151,brown);
 line(421,139,421,151,white);Line(219,151,421,151,white);
 for i:=1 to nrbuttons do
 button(i,true);
 for i:=1 to nrvolbuttons do
 volbutton(i);
End;

Procedure Init ;
var gd,gm:integer;
    b:byte;
Begin
{Initialise Video}
 gd:=VGA;gm:=VGAhi;initgraph(gd,gm,'c:\bp\bgi');
 if grok<>graphresult then error(1);
{Save palette}
 Getpalette(oldpalette);for i:=0 to 15 do setpalette(i,0);
{Init Screen}
 InitGraphics;
{CD init}
 Cdtrack:=0;
 pauseaudio;
 CdInit;
{Mouse Init}
 ResetMouse;rb:=false;lb:=false;
{sbinit}
{ resetdsp(2,5,1,5)};setmixerregwss(wssport,73,128);
 setmixerregwss(wssport,92,16+64);setmixerregwss(wssport,9,2);
 port[$534]:=$10;
 b:=port[$535] or $40;
 port[$535]:=b;
 port[$534]:=8;
 readkey;
 FOR I:=1 to 400 do
 begin temp[1,i]:=127;temp[2,i]:=127;end;
{Buttons init}
 NrButtons:=0;
{1} NewButton(4,1,-7,-20,'  CD',false);
{2} NewButton(5,1,-7,-20,' LINE',false);
{3} NewButton(6,1,-7,-20,' MIC',false);
{4} NewButton(10,19,10,5,' EXIT',false);
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
{17} NewButton(0,15,0,0,'  ||',false);
{18} NewButton(1,15,0,0,'  >>',false);
{19} NewButton(2,15,0,0,'  <<',false);
{20} NewButton(0,16,0,0,' L/U',false);
{21} NewButton(1,16,0,0,' Next',false);
{22} NewButton(2,16,0,0,' Prev',false);
{23} NewButton(3,18,10,5,' Mic',false);
{24} NewButton(4,18,10,5,' Line',false);
{25} NewButton(5,18,10,5,' Cd',false);
{26} NewButton(6,18,10,5,' N/A',false);
{27} NewButton(7,18,10,5,'Reset',false);
{28} NewButton(3,19,10,5,'Filter',false);
{29} NewButton(4,19,10,5,' Out',false);
{30} NewButton(5,19,10,5,' In',false);
{31} NewButton(6,19,10,5,' M/S',false);
{32} NewButton(7,19,10,5,'SBRes',false);
{33} Newbutton(4,5,-7,-20,'8/16',false);
{34} Newbutton(5,5,-7,-20,'Ultra',false);
{35} Newbutton(6,5,-7,-20,' T1',false);
{36} Newbutton(7,5,-7,-20,' T2',false);
{37} Newbutton(4,4,-7,-20,'Set1',false);
{38} Newbutton(5,4,-7,-20,'Set2',false);
{39} Newbutton(6,4,-7,-20,'Set3',false);
{40} Newbutton(7,4,-7,-20,'Set4',false);
{VolButtons Init}
 akt:=0;
 for i:=1 to nrbuttons do
 buttons[i].pr:=false;
{1} Newvolbutton(1,2,0,'Mast');
{2} Newvolbutton(2,2,0,'Line');
{3} Newvolbutton(3,2,0,' Mic');
{4} Newvolbutton(4,2,0,' CD');
{5} Newvolbutton(5,2,0,'Wave');
{6} Newvolbutton(6,2,0,'Synt');
{7} Newvolbutton(8,2,0,'Bass');
{8} Newvolbutton(9,2,0,'Treb');
{9} Newvolbutton(10,2,0,' 3D');
{10} Newvolbutton(7,2,0,'Input');
{11} Newvolbutton(11,2,0,'Speak');
{12} Newvolbutton(12,2,0,'CDvol');
{13} Newvolbutton(13,2,0,'SENS');
{14} Newvolbutton(14,2,0,'B>T');
{15} Newvolbutton(5,2,130,'Mast');
{16} Newvolbutton(6,2,130,'Wav');
{17} Newvolbutton(7,2,130,'Line');
{18} Newvolbutton(8,2,130,' Cd');
{19} Newvolbutton(9,2,130,' Fm');
{20} Newvolbutton(10,2,130,'Mic');
{Volume & Buttons dates init}
 InitVars;
{Restore palette}
 for i:=0 to 15 do setpalette(i,oldpalette.colors[i]);
 {Lets goo!}
 EnableMouse;
 zi:=1;
End;

{Program end sequence}

Procedure Done;
Begin
 Closegraph;
 DisableMouse;
End;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{++++++++++               M A I N  --  P R O G R A M           ++++++++++++}
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Begin
 Init;
 Repeat
  LockMouse;LockVolume;LockBalance;
  LockMute;RefreshCd;ShowGra;
  if keypressed then Begin ch:=readkey;if keypressed then ch:=readkey;End;
 until (akt=4) or (ch=#27);
 Done;
End.
