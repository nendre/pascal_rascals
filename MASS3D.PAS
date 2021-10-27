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

Procedure Init;
Procedure Done;
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
Procedure Project(tip:byte);


