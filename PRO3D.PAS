{ +++++++++++++++++++++++++++++++++++ }
{   PROGRAM 3D                        }
{ (c) 1987-1997 All rights reserved ! }
{ +++++++++++++++++++++++++++++++++++ }

Program Project3d;

Uses Crt,Dos,Vga,Xms ;

Const
  Svga_800x600 = $5E      ;
  Text_Mode    = $03      ;

Var  VidOk : Boolean;

Procedure ClearVideo ;
var x,y:integer;
Begin
if VidOk then
 Begin
  Szin:=0;
  for x:=0 to Maxx do
  for y:=0 to Maxy do
  Pont(x,y);
 End;
End;

Procedure GraphInit(Mode:byte) ;
Begin
 Vmode(mode);
 VidOk:=true;
 ClearVideo ;
End;

Procedure GraphEnd ;
Begin
 Vmode(Text_Mode);
 VidOk:=false;
 ClrScr;
End;

Procedure Error(errnr:byte);
Begin
 If VidOk then GraphEnd ;
 Case Errnr do
 1:Writeln('You must have minimum 386 SX,4M RAM and Trident SVGA 512K !');
 End;

End;

Function Test:Boolean;
Begin
 Test:=True;
 If Test8086 <> 2 then Test:=false ;

End;

BEGIN
 VidOk:=false;
 If not(test) then error(1);

END.

