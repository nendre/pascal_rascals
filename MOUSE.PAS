Unit Mouse;
Interface
 Procedure ResetMouse  ;
 Procedure EnableMouse ;
 Procedure DisableMouse ;
 Function GetMouseX:integer;
 Function Getmousey:integer;
 Function GetButtonLeft:boolean;
 Function GetButtonRight:boolean;
 Procedure SetMouse(x,y:word);

implementation

Procedure ResetMouse;
assembler;
asm
 mov ax,00
 int 33H
End;

Procedure EnableMouse;
assembler;
asm
 mov ax,01H
 int 33H
End;



Procedure DisableMouse;
assembler;
asm
 mov ax,02H
 int 33H
End;

Function GetmouseX:integer;
Var x:word ;
Begin
 asm
  mov ax,03H
  int 33H
  mov x,cx
 end;
 GetMouseX:=X;
End;

Function GetmouseY:integer;
Var y:word ;
Begin
 asm
  mov ax,03H
  int 33H
  mov y,dx
 end;
 GetMouseY:=y;
End;

Function GetButtonLeft:boolean;
Var leftbutton:Word;
Begin
 GetButtonLeft:=false;
 asm
  mov ax,03H
  int 33H
  mov LeftButton,bx
 end;
 if leftButton=1 then GetButtonLeft:=true;
End;

Function GetButtonRight:boolean;
Var rightbutton:Word;
Begin
 GetButtonRight:=false;
 asm
  mov ax,03H
  int 33H
  mov RightButton,bx
 end;
 if RightButton=2 then GetButtonRight:=true;
End;

Procedure SetMouse(x,y:word);
assembler;
Asm
 mov cx,x
 mov dx,x
 mov ax,05H
 int 33H
End;

Begin
End.