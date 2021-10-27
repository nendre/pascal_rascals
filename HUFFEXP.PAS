{$M $6048,0,0}
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{ Huffman decode rutines for wolf3d & more                                }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Program HuffDec ;

Uses Crt ;



Type
  HuffNode   =   Record
                    bit0 , bit1 : Word      ;
                 End                        ;
Var
  HuffTable   :   Array[0..255] of HuffNode ;
  Source_File :   File                      ;
  Dest_File   :   File                      ;
  File_cnt    :   Integer                   ;
  Source_Name :   String [12]               ;
  Dest_Name   :   String [12]               ;
  SourceSize  :   longint                   ;

Procedure Error (nr : byte );
Begin
 Case nr of
  1: Begin
      Writeln('File not found !');
      Halt(1)                    ;
     End ;
  2: Begin
      Writeln('File reading error !');
      Halt(2)                        ;
     End;
  3: Begin
      Writeln('Use : HUFFDEC [<path>] <filename> ');
      Halt(3);
     End;
  4: Begin
      Writeln('File <expanded.huf> cannot be created !');
      Halt(4);
     End;
  5: Begin
      Writeln('File cannot be closed ! ');
      Halt(5);
     End;
 End;
 Writeln('Unknow error !');
 Halt(1) ;
End;


{+++++++++++++++++++++++++++++++++++++++++}
{ Expanding huffman data                  }
{+++++++++++++++++++++++++++++++++++++++++}

Procedure Expand ;
Var
  HuffStart : Byte    ;
  HuffPtr   : Byte    ;
  HuffData  : Word    ;
  SourceData: Byte    ;
  BitSet    : Byte    ;
  SourcePtr : Word    ;
  DestPtr   : Word    ;
  i , j , k : Word    ;
  SourceBuff: Array [1..10000] of Byte ;
  DestBuff  : Array [1..10000] of Byte ;

Procedure ResetBitSet ;
Begin
 BitSet := 1 ;
 SourceData:=SourceBuff[SourcePtr] ;
 Inc(SourcePtr) ;
End ;

Begin
 HuffStart := 254       ;
 Huffptr   := HuffStart ;
 SourcePtr :=  1        ;
 DestPtr   :=  1        ;
 BitSet    :=  1        ;
 Blockread(Source_File,SourceBuff,1,File_cnt);
 SourceData:=SourceBuff[SourcePtr];
 Repeat
 Blockread(Source_File,SourceBuff,10000,File_cnt);
 Repeat
  If ( SourceData and BitSet ) <> 0 then
     Begin
      HuffData := HuffTable[HuffPtr].bit1 ;
      BitSet := BitSet shl 1 ;
      If BitSet = 0 then ResetBitSet ;
     End
     else
     Begin
      HuffData := HuffTable[HuffPtr].bit0 ;
      BitSet := BitSet shl 1 ;
      If BitSet = 0 then ResetBitSet ;
     End ;
  If HuffData>255 then
   HuffPtr := HuffData - 256
                  else
  Begin
   DestBuff[destptr] := HuffData ;
   HuffPtr := HuffStart          ;
   Inc (destptr) ;
   if DestPtr > 10000 then
   Begin
    Blockwrite(Dest_file,Destbuff,10000);
    Write('.');
    DestPtr := 1 ;
   End;
  End;
 Until ( SourcePtr > File_cnt)  and (BitSet=128);
 SourcePtr:=1;
 until File_Cnt<10000;
 Blockwrite(Dest_file,Destbuff,destptr-1);
End;





BEGIN
 ClrScr ;
 If ParamCount = 0 then Error ( 3 ) ;
 Source_name := ParamStr ( 1 )       ;
 If ParamCount > 1 then Dest_name := ParamStr ( 2 )
                   else Dest_name := 'expanded.huf' ;
 Assign(Source_File , Source_name );
 {$I-}
 Reset(Source_File , 1 );
 If ioresult<>0 then Error ( 1 ) ;
 Assign(Dest_File , Dest_name )  ;
 rewrite(Dest_File , 1 );
 If ioresult<>0 then Error ( 4 ) ;
 {$I+}
 Blockread(Source_file,Hufftable,1024,File_Cnt);
 If File_Cnt<>1024 then Error ( 1 );
 Writeln( 'SourceFileName:' , Source_name : 12 )          ;
 Writeln( 'SourceFileSize:' , FileSize(Source_File) : 10) ;
 Writeln( 'DEstFileName  :' , Dest_Name : 12 )            ;
 Write('Expanding:');
 Expand ;
 Writeln('Done ! ');
 Writeln( 'DestFileSize:' , FileSize(Dest_File) :10 );
 {$I-}
 Close(Source_file);
 Close(Dest_file  );
 {$I+}
 if ioresult<>0 then Error ( 5 ) ;
END.

