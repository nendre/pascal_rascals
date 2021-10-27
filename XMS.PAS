{$B-,D-,F-,L+,R-,S-,V-}

unit XMS;

interface

var XMSError:byte;

function XMSInstalled:boolean;
procedure XMSInfo(var Version,InternalVersion:word;var HMAAvail:boolean);
procedure AllocHMA(bytes:word);
procedure FreeHMA;

procedure EnableAddrA20;
procedure DisableAddrA20;
procedure EnableDataA20;
procedure DisableDataA20;
function A20Status:boolean;

procedure AllocExtMem(Kbytes:word;var Handle:word);
procedure FreeExtMem(Handle:word);
procedure FreeExtMemInfo(var MaxFreeBlock,TotalFreeMem:word);
procedure ReAllocExtMem(KBytes,handle:word);

procedure MoveExtMem(DestOffs:longint;
                      DestHandle:word;
                      SourceOffs:longint;
                      SourceHandle:word;
                      bytes:longint);

procedure ReadExtMem(bytes:longint;
                     SourceHandle:word;
                     SourceOffs:longint;
                     var Dest);

procedure WriteExtMem(var Src;
                      bytes:longint;
                      DestHandle:word;
                      DestOffs:longint);

procedure GetHandleInfo(handle:word;
                        var locked:boolean;
                        var Hlength,
                        FreeHandles:word);

function GetProtectedMemory(handle:word):pointer;
procedure RelaseProtectedMemory(handle:word);
procedure AllocSupMem(PagesRequested:word;
                        var PagesAllocated:word;
                        var baseAddress:pointer);

procedure FreeSupMem(BaseAddress:pointer);


implementation
uses Dos;

var XMSAddr:pointer;
    _AX,_BX,_DX,_SI:word;
    var buff:record
    TransferBytes:longint;
    source:word;
    SourceOffset:longint;
    destination:word;
    DestOffset:longint
    end;

function XMSInstalled:boolean;

var regs:registers;
begin
 with regs do
 begin
  ax:=$4300;
  intr($2F,regs);
  if AL<>$80 then XMSINstalled:=false
  else
  begin
  AX:=$4310;
  intr($2F,regs);
  XMSAddr:=ptr(ES,BX);
  XMSInstalled:=true
  end
 end
end;

procedure CallXMS;
begin
  asm
  mov ax,[_ax]
  mov bx,[_bx]
  mov dx,[_dx]
  mov si,[_si]
  call[XMSAddr]
  mov [_ax],ax
  mov [_bx],bx
  mov [_dx],dx
  end
end;

procedure XMSInfo(var Version,InternalVersion:word;
                  var HMAavail:boolean);

begin
  _ax:=0;
  callXMS;
  Version:=_ax;
  InternalVersion:=_bx;
  HMAavail:=_DX=1
end;

procedure FreeExtMemInfo(var MaxFreeBlock,
                         TotalFreeMem:word);
begin
  _ax:=$0800;
  CallXMS;
  XMSError:=lo(_bx);
  if XMSError=0 then
  begin
   MaxFreeBlock:=_AX;
   TotalFreeMem:=_DX;
  end
end;

procedure AllocHMA(bytes:word);
begin
 _ax:=$0100;
 _dx:=bytes;
 CallXMS;
 if _ax=1 then XMSError:=0 else XMSError:=lo(_bx)
end;

procedure FreeHMA;
begin
  _AX:=$0200;
  CallXMS;
  if _ax=1 then XMSError:=0 else XMSError:=lo(_bx)
end;

procedure EnableAddrA20;
begin
  _AX:=$0300;
  CallXMS;
  if _AX=1 then XMSError:=0 else XMSError:=lo(_bx)
end;

procedure DisableAddrA20;
begin
  _AX:=$0400;
  CallXMS;
  if _AX=1 then XMSError:=0 else XMSError:=lo(_bx)
end;

procedure EnableDataA20;
begin
  _AX:=$0500;
  CallXMS;
  if _AX=1 then XMSError:=0 else XMSError:=lo(_bx)
end;

procedure DisableDataA20;
begin
  _AX:=$0600;
  CallXMS;
  if _AX=1 then XMSError:=0 else XMSError:=lo(_bx)
end;

function A20status:boolean;
begin
 _ax:=$0700;
 CallXMS;
 A20Status:=_ax=1
end;

procedure AllocExtMem(kbytes:word;var Handle:word);
begin
 _AX:=$0900;
 _DX:=kbytes;
 CallXMS;
 if _ax=1 then
 begin
  XMSError:=0;
  handle:=_dx;
 end
 else XMSError:=lo(_bx)
end;

procedure FreeExtMem(Handle:word);
begin
 _ax:=$0a00;
 _dx:=handle;
 CallXMS;
 if _ax=1 then XMSError:=0 else XMSError:=lo(_bx);
end;

procedure MoveExtMem(DestOffs:longint;
                     DestHandle:word;
                     SourceOffs:longint;
                     SourceHandle:word;
                     bytes:longint);
begin
 move(bytes,Buff,sizeof(buff));
 _ax:=$0b00;
 _si:=ofs(buff);
 CallXMS;
 if _ax=1 then XMSError:=0 else XMSError:=lo(_bx)
end;

procedure ReadExtMem(bytes:longint;
                     SourceHandle:word;
                     SourceOffs:longint;
                     var Dest);
begin
   with buff do
   begin
    Transferbytes:=bytes;
    source:=SourceHandle;
    SourceOffset:=SourceOffs;
    destination:=0;
    DestOffset:=longint(@dest)
   end;
   _ax:=$0b00;
   _si:=ofs(buff);
   CallXMS;
   if _ax=1 then XMSError:=0 else XMSError:=lo(_bx)
end;

procedure WriteExtMem(var Src;
                    bytes:longint;
                    DestHandle:word;
                    DestOffs:longint);
begin
 with buff do
  begin
   Transferbytes:=bytes;
   source:=0;
   SourceOffset:=longint(@Src);
   Destination:=DestHandle;
   DestOffset:=DestOffs
end;
_ax:=$0b00;
_si:=ofs(buff);
CallXMS;
if _ax=1 then XMSError:=0 else XMSError:=lo(_bx)
end;

function GetProtectedMemory(handle:word):pointer;

type SegOfs=record
     Ofs,Seg:word
     end;
var linPtr:pointer;

begin
 _ax:=$0c00;
 _dx:=handle;
 CallXMS;
 if _ax=1 then
 begin
 SegOfs(LinPtr).seg:=_dx;
 SegOfs(LinPtr).ofs:=_bx;
 XMSError:=0;
 end
 else
 begin
 LinPtr:=nil;
 XMSError:=lo(_bx)
 end;
 GetProtectedMemory:=linPtr
end;

procedure RelaseProtectedMemory(handle:word);
begin
 _ax:=$0d00;
 _dx:=handle;
 CallXMS;
 if _ax=1 then XMSError:=0 else XMSError:=lo(_bx)
end;

procedure GetHandleInfo(handle:word;
                       var locked:boolean;
                       var Hlength,FreeHandles:word);
begin
_ax:=$0e00;
_dx:=handle;
CallXms;
if _ax=1 then
begin
 locked:=lo(_bx) =1;
 FreeHandles:=lo(_bx);
 HLength:=_dx;
 XMSError:=0
end
else XMSError:=lo(_bx)
end;

procedure ReAllocExtMem(kbytes,handle:word);
begin
 _ax:=$0f00;
 _bx:=kbytes;
 _dx:=handle;
 CallXMS;
 if _ax=1 then XMSerror:=0 else XMSError:=lo(_bx)
end;

procedure AllocSupMem(PagesRequested:word;
                   var PagesAllocated:word;
                   var BaseAddress:pointer);
begin
 _ax:=$1000;
 _dx:=PagesRequested;
 CallXMS;
 if _ax=1 then
 begin
  PagesAllocated:=_dx;
  BaseAddress:=ptr(_bx,0);
  XMSError:=0
  end
  else
  XMSError:=lo(_bx)
end;


procedure FreeSupMem(BaseAddress:pointer);
begin
 _ax:=$1100;
 _dx:=seg(BaseAddress^);
 CallXMS;
 if _ax=1 then XMSError:=0 else XMSError:=lo(_bx)
end;
end.