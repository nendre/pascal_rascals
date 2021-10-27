Uses Crt,Vga,FGraph ;

Const
      Maxrot           = 10 ;
      MaxLines         = 25 ;
      RotStep          = 360 div MaxRot ;
      MaxPoints        = MaxRot * MaxLines ;
      MaxFaces         = 2*MaxRot * (MaxLines-1);
      AddXRot          = 6;
      AddYRot          = 14;
      AddZRot          = 8;

type ComprType  = record
                  r,y : integer;
                  end;
     TComprBody = array[1..Maxlines]  of ComprType;
     TExpBody   = array[1..MaxPoints] of TPix3d;
     TProjBody  = array[1..MaxPoints] of TPix2d;
     TFace      = record
                  a,b,c:integer;
                  end;
     TFaces     = array[1..MaxFaces] of TFace;
     tsort      = array[1..MaxFaces] of TPix2d;
     Scr        = array[1..64000] of byte;




Procedure Generate_Body    ;
Procedure Load_Body        ;
Procedure Save_Body        ;
Procedure Rotate_Body      ;
Procedure Translate_Body   ;
Procedure Rotate_Source    ;
Procedure Put_Source       ;
Procedure Perspectiv       ;
Procedure CreateVNormals   ;
Procedure CreateFNormals   ;
Procedure Show_Points      ;
Procedure Show_WireFrame   ;
Procedure Show_Solid       ;
Procedure Show_Perfect     ;
Procedure Plane_Type       ;
Procedure Create_Body      ;
Procedure Main_Menu        ;





BEGIN

END.