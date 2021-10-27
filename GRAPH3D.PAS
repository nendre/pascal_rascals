unit graph3d;
interface
type  TPix3d = record
              x,y,z:real;
              end;

      TPix2d = record
             x,y:real;
              end;

var  Pix3d : TPix3d;
     Pix2d : TPix2d;
     fsg   : real;
     dx,dy,dz : real;
     Dist : real;
     Cor : real;
     si,co:array[0..360*2] of real;

Procedure Rotx(angle:integer);
Procedure Roty(angle:integer);
Procedure Rotz(angle:integer);
Procedure ScaleX;
Procedure ScaleY;
Procedure ScaleZ;
Procedure SimXoY;
Procedure SimXoZ;
Procedure SimYoZ;
Procedure TransX;
Procedure TransY;
Procedure TransZ;
Procedure Project;

implementation


{
------------------------------------------------------------------------------
                             R o t a c i o k
------------------------------------------------------------------------------
}
{ Rotate X axis }

Procedure Rotx(angle:integer);
var yt:real;
begin
 yt:=pix3d.y;
 pix3d.y := yt * co[angle] + pix3d.z * si[angle];
 pix3d.z := pix3d.z * co[angle] - yt * si[angle];
end;

{ Rotate Y axis }

Procedure Roty(angle:integer);
var zt:real;
begin
 zt:=pix3d.z;
 pix3d.z := zt * co[angle] + pix3d.x * si[angle];
 pix3d.x := pix3d.x * co[angle] - zt * si[angle];
end;

{ Rotate Z axis }

Procedure Rotz(angle:integer);
var xt:real;
begin
 xt:=pix3d.x;
 pix3d.x := xt * co[angle] + pix3d.y * si[angle];
 pix3d.y := pix3d.y * co[angle] - xt * si[angle];
end;



{
------------------------------------------------------------------------------
                              Scale Factor
------------------------------------------------------------------------------
}

Procedure ScaleX;
begin
 pix3d.x := pix3d.x * fsg;
end;

Procedure ScaleY;
begin
 pix3d.y := pix3d.y * fsg;
end;

Procedure ScaleZ;
begin
 pix3d.z := pix3d.z * fsg;
end;

{
------------------------------------------------------------------------------
                               S i m e t r i a k
------------------------------------------------------------------------------
}

{ XoY - simetry }

Procedure SimXoY;
begin
 pix3d.z := - pix3d.z;
end;

{ XoZ - simetry }

Procedure SimXoZ;
begin
 pix3d.y := - pix3d.y;
end;

{ YoZ - simetry }

Procedure SimYoZ;
begin
 pix3d.x := -pix3d.x;
end;

{
------------------------------------------------------------------------------
                            T r a n s z l a c i o k
------------------------------------------------------------------------------
}

Procedure TransX;
begin
 pix3d.x := pix3d.x + dx;
end;

Procedure TransY;
begin
 pix3d.y := pix3d.y + dy;
end;

Procedure TransZ;
begin
 pix3d.z := pix3d.z + dz;
end;


{
------------------------------------------------------------------------------
                            P R O I E C T I O N
------------------------------------------------------------------------------
}

Procedure Project;
var u:real;
Begin
 if (dist - pix3d.z)>0.000001 then
 begin
  u := 1 + ((Cor * pix3d.z) / (Dist - pix3d.z));
  pix2d.x := u * pix3d.x;
  pix2d.y := u * pix3d.y;
 end
 else
 begin
  pix2d.x:=30000;
  pix2d.y:=30000;
 end;

End;

Begin
End.