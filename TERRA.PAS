{Unit Mass3D;
Interface}
Type Pix3d = record
              x,y,z:real ;
             end;
     Pix2D = record
             u,v :real ;
             end;
     Face = record
             a,b,c: integer ;
            end;

Procedure GenerateBody(n:byte);
Procedure BodytoVertex ;
Procedure VertextoFaces;
Procedure Vertexnormals ;
Procedure FaceNormals ;
Procedure Render ;
Procedure DrawPoints ;
Procedure DrawLines  ;
Procedure DrawSolid  ;
Procedure Rotate(x,y,z:integer);
Procedure Translate(x,y,z:integer);
Procedure Project(type:byte);


Var
    Vertex : array[1..20000] of ^pix3d ;


Begin
 getmem(vertex[1],sizeof(vertex[1]^));
end.
