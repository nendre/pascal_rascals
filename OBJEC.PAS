uses Crt,Vga ;

Type App = object
          i,j,k : integer;
          Constructor Init(mode:integer);
           Destructor Done              ;
           Procedure  Run               ;
         End ;

Constructor App.Init(mode:integer);
Begin
 Vmode($13);
End;

Destructor App.Done;
Begin
 Vmode($03);
End;

Procedure App.Run ;
Var x,y : integer ;
Begin
 repeat
 Begin
 i:=random(319);
 j:=random(199);
 Szin:=random(255);
 xpont(i,j);
 End;
 until keypressed;
End;

Var Graph : App ;

Begin
 Graph.Init($13);
 Graph.Run;
 Graph.Done;
End.

