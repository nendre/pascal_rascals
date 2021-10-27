{$A+,B-,D+,E-,F-,G-,I+,L+,N+,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
uses crt,graph;
Const abc:string='ABCDEFGH';
			nrfig=5;
			nrplay=2*(2+2+2+2+8);
 bs=1;
 fi=2;
 lo=3;
 ki=4;
 no=5;
 fu=6;

	pieces:array[1..6] of

	 array[1..8] of string[8] =
	 {pice 1}
	(
	('00000000',
	'01100110',
	'00111100',
	'00111100',
	'00111100',
	'00111100',
	'01111110',
	'00000000')
	{pice 2...}
	,
	('00000000',
	'00011000',
	'00111100',
	'00011000',
	'00011000',
	'00111100',
	'01111110',
	'00000000')
	,
 ('00000000',
	'00001110',
	'00111110',
	'00000110',
	'00001110',
	'01111000',
	'01111110',
	'00000000')
	,
 ('00000000',
	'00011000',
	'01111110',
	'00011000',
	'00011000',
	'00011000',
	'01111110',
	'00000000')
	,
 ('00000000',
	'01000010',
	'00111100',
	'00011000',
	'00111100',
	'00011000',
	'01111110',
	'00000000')
	,
 ('00000000',
	'00111100',
	'01000010',
	'00100100',
	'00111100',
	'00011000',
	'01111110',
	'00000000')

	);


type

	 Tfig=record
					xact,yact: integer;
					xnext,ynext:integer;
					xold,yold:integer;
					power:integer;
					apower:integer;
					totpower:integer;
					warning:integer;
					mute:array[1..8,1..8] of byte;
					okmute:array[1..8,1..8] of byte;
					tip:byte;
					color:byte;
					kill:boolean;
				 end;
		tpoint=record
					 x,y:integer;
					 end;
		Fg=record
					okmute:array[1..8] of tpoint;
			 end;

Var
		tab:array[0..9,0..9] of byte;
		zone:array[0..9,0..9] of integer;
		gd,gm:integer;
		xa,ya,size:integer;
		mx,my,clik:word;
		mxt,myt:integer;
		fig:array[1..nrplay] of Tfig;
		p:array[1..5] of pointer;
		moves:array[1..5] of fg;
{initializing table}

Procedure InitTable;
Var i,j:Integer;
		b:boolean;
Begin
 xa:=13;ya:=13;size:=50;
 b:=false;
 for i:=0 to 9 do
 Begin
 for j:=0 to 9 do
 Begin
	if b then tab[i,j]:=0 else tab[i,j]:=1;b:=not(b);
	zone[i,j]:=0;
 End;
 b:=not(b);
 end;
End;

Procedure Initmygraph;
Begin
 gd:=detect;
 initgraph(gd,gm,'f:\');
 setbkcolor(darkgray);
 cleardevice;
End;

Procedure DrawTable;
var i,j:integer;
		c:string;
Begin
 setcolor(green);
 rectangle(xa-1,ya-1,xa+8*size+1,ya+8*size+1);
 for i:=1 to 8 do
 for j:=1 to 8 do
 Begin
	setfillstyle(solidfill,tab[i,j]*green);
	bar(xa+((i-1)*size),ya+((j-1)*size),xa+size+((i-1)*size),ya+size+((j-1)*size));
 End;
 for i:=1 to 8 do
 outtextxy((size div 2)+xa+((i-1)*size),ya+((8)*size+(size div 2)),abc[i]);
 for i:=1 to 8 do
 begin
 str(9-i,c);
 outtextxy((size div 2)+xa+((8)*size),ya+((i-1)*size+(size div 2)),c);
 end;
End;



Procedure Drawpiece(c,pic,x,y:integer);
var i,j,xm,ym:integer;

Begin for i:=xa+((x-1)*size) to xa+size+((x-1)*size) do
 for j:=ya+((y-1)*size) to ya+size+((y-1)*size) do
 begin
	xm:=round(7*(i-(xa+((x-1)*size)))/size)+1;
	ym:=round(7*(j-(ya+((y-1)*size)))/size)+1;
	if pieces[pic][ym][xm]='1' then putpixel(i,j,c);

 end;
End;

Procedure Removepiece(x,y:integer);
var i:integer;
begin
	setfillstyle(solidfill,tab[x,y]*green);
	bar(xa+((x-1)*size),ya+((y-1)*size),xa+size+((x-1)*size),ya+size+((y-1)*size));

 for i:=1 to 8 do
 outtextxy((size div 2)+xa+((i-1)*size),ya+((8)*size+(size div 2)),abc[i]);
end;

Procedure Rp(x,y:integer);
var i:integer;
begin
	setfillstyle(solidfill,blue);
	bar(xa+((x-1)*size),ya+((y-1)*size),xa+size+((x-1)*size),ya+size+((y-1)*size));

end;



Procedure Xmp;
var xm,ym,i,j,k:integer;
		sizze:word;
begin
 for k:=1 to 6 do
 begin
 new(p[k]);
 getmem(p[k],sqr(size+2));
 for i:=xa+((10-1)*size) to xa+size+((10-1)*size) do
 for j:=ya+((1-1)*size) to ya+size+((1-1)*size) do
 begin
	xm:=round(7*(i-(xa+((10-1)*size)))/size)+1;
	ym:=round(7*(j-(ya+((1-1)*size)))/size)+1;
	if pieces[k][ym][xm]='1' then putpixel(i,j,blue);
 end;
	getimage(xa+(10-1)*size,ya+((1-1)*size),
	xa+size+((10-1)*size),ya+size+((1-1)*size),p[k]^);
	removepiece(10,1);
 end;
end;

Procedure initpiece;
Var i:integer;
Begin
{ for i:=1 to 8 do
 drawpiece(red,fi,i,2);
 drawpiece(red,bs,1,1);
 drawpiece(red,bs,8,1);
 drawpiece(red,lo,2,1);
	drawpiece(red,lo,7,1);
 drawpiece(red,fu,6,1);
 drawpiece(red,fu,3,1);
 drawpiece(red,ki,4,1);
 drawpiece(red,no,5,1);}


{fika}
 fig[1].xact:=1;fig[1].yact:=2;fig[1].color:=red;fig[1].tip:=fi;
 fig[2].xact:=2;fig[2].yact:=2;fig[2].color:=red;fig[2].tip:=fi;
 fig[3].xact:=3;fig[3].yact:=2;fig[3].color:=red;fig[3].tip:=fi;
 fig[4].xact:=4;fig[4].yact:=2;fig[4].color:=red;fig[4].tip:=fi;
 fig[5].xact:=5;fig[5].yact:=2;fig[5].color:=red;fig[5].tip:=fi;
 fig[6].xact:=6;fig[6].yact:=2;fig[6].color:=red;fig[6].tip:=fi;
 fig[7].xact:=7;fig[7].yact:=2;fig[7].color:=red;fig[7].tip:=fi;
 fig[8].xact:=8;fig[8].yact:=2;fig[8].color:=red;fig[8].tip:=fi;

 fig[9].xact:=1;fig[9].yact:=7;fig[9].color:=white;fig[9].tip:=fi;
 fig[10].xact:=2;fig[10].yact:=7;fig[10].color:=white;fig[10].tip:=fi;
 fig[11].xact:=3;fig[11].yact:=7;fig[11].color:=white;fig[11].tip:=fi;
 fig[12].xact:=4;fig[12].yact:=7;fig[12].color:=white;fig[12].tip:=fi;
 fig[13].xact:=5;fig[13].yact:=7;fig[13].color:=white;fig[13].tip:=fi;
 fig[14].xact:=6;fig[14].yact:=7;fig[14].color:=white;fig[14].tip:=fi;
 fig[15].xact:=7;fig[15].yact:=7;fig[15].color:=white;fig[15].tip:=fi;
 fig[16].xact:=8;fig[16].yact:=7;fig[16].color:=white;fig[16].tip:=fi;
{bastya}
 fig[17].xact:=1;fig[17].yact:=1;fig[17].color:=red;fig[17].tip:=bs;
 fig[18].xact:=8;fig[18].yact:=1;fig[18].color:=red;fig[18].tip:=bs;

 fig[19].xact:=1;fig[19].yact:=8;fig[19].color:=white;fig[19].tip:=bs;
 fig[20].xact:=8;fig[20].yact:=8;fig[20].color:=white;fig[20].tip:=bs;
{lo}
 fig[21].xact:=2;fig[21].yact:=1;fig[21].color:=red;fig[21].tip:=lo;
 fig[22].xact:=7;fig[22].yact:=1;fig[22].color:=red;fig[22].tip:=lo;

 fig[23].xact:=2;fig[23].yact:=8;fig[23].color:=white;fig[23].tip:=lo;
 fig[24].xact:=7;fig[24].yact:=8;fig[24].color:=white;fig[24].tip:=lo;
{futo}
 fig[25].xact:=3;fig[25].yact:=1;fig[25].color:=red;fig[25].tip:=fu;
 fig[26].xact:=6;fig[26].yact:=1;fig[26].color:=red;fig[26].tip:=fu;

 fig[27].xact:=3;fig[27].yact:=8;fig[27].color:=white;fig[27].tip:=fu;
 fig[28].xact:=6;fig[28].yact:=8;fig[28].color:=white;fig[28].tip:=fu;

{kiraly}
 fig[29].xact:=4;fig[29].yact:=1;fig[29].color:=red;fig[29].tip:=ki;
 fig[30].xact:=4;fig[30].yact:=8;fig[30].color:=white;fig[30].tip:=ki;
{kiralyno}
 fig[31].xact:=5;fig[31].yact:=1;fig[31].color:=red;fig[31].tip:=no;
 fig[32].xact:=5;fig[32].yact:=8;fig[32].color:=white;fig[32].tip:=no;

	for i:=1 to 32 do
	fig[32].kill:=false;

 for i:=1 to 32 do
 with fig[i] do
 drawpiece(color,tip,xact,yact);


{ for i:=1 to 8 do
 drawpiece(green,fi,i,7);
 drawpiece(green,bs,1,8);
 drawpiece(green,bs,8,8);
 drawpiece(green,lo,2,8);
	drawpiece(green,lo,7,8);
 drawpiece(green,fu,6,8);
 drawpiece(green,fu,3,8);
 drawpiece(green,ki,4,8);
 drawpiece(green,no,5,8);}
End;

Procedure Initmouse;assembler;
asm
 mov ax,01H
 int 33H
End;

Procedure Mousepos;
assembler;
asm
 mov ax,03H
 int 33H
 mov clik,bx
 mov mx,cx
 mov my,dx
end;

Procedure MouseposT;
var s:string;
Begin
	mousepos;
	mxt:=mx-xa;myt:=my-ya;
	mxt:=(mxt div size)+1;
	myt:=(myt div size)+1;
	setcolor(white);
	setfillstyle(1,green);
	bar(0,0,30,10);
	str(mxt,s);
	outtextxy(1,1,s);
	str(myt,s);
	outtextxy(10,1,s);
End;

Procedure MouseOff;
Assembler;
asm
 mov ax,02H
 int 33H
end;

Procedure MouseON;
Assembler;
asm
 mov ax,01H
 int 33H
end;

Function mousepressed:boolean;
Begin
 mousepos;
	mousepressed:=(clik=1);
end;

Procedure Dragenddrop;
Var i:integer;
		mxo,myo:integer;
		ox,oy:integer;
		xg,yg:integer;
		a,b:integer;


function szabadK(k:integer):boolean;
var i,j:integer;
		sz:boolean;
Begin
 sz:=true;

 if not(mxt in [1..8]) or not(myt in [1..8]) then sz:=false;

 for i:=1 to 32 do
 if (i<>k) and (mxt=fig[i].xact) and (myt=fig[i].yact)
 and (fig[i].color=fig[k].color) then sz:=false;

 case fig[k].tip of
 fi:{fika}
	Begin
{   if (fig[k].yact=2) and (fig[k].color=red)}
	 if fig[k].color=red
	 then
	 begin
	 if ((myt-fig[k].yact)<>1) then sz:=false;
	 if (fig[k].yact=2)  and ((myt-fig[k].yact)=2) then sz:=true;
	 if mxt<>fig[k].xact then sz:=false;

	{ for i:=1 to 32 do
	 if ((mxt-fig[k].xact)=0) and ((fig[i].color)=white)
	 and (fig[i].xact<>mxt) and (fig[i].yact<>myt)
	 then sz:=false;}

	 if (abs(mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=1) then
	 for i:=1 to 32 do
	 if (fig[i].color=white) and (mxt=fig[i].xact) and (myt=fig[i].yact) then
	 begin sz:=true;fig[i].xact:=0;fig[i].yact:=0;end;

	 if (abs(mxt-fig[k].xact)=0) and ((myt-fig[k].yact) in [1..2]) then
	 for i:=1 to 32 do
	 if (fig[i].color=white) and (mxt=fig[i].xact) and (myt=fig[i].yact) then
	 begin sz:=false;end;

	 end
	 else
	 begin
	 if ((myt-fig[k].yact)<>-1) then sz:=false;
	 if (fig[k].yact=7)  and ((myt-fig[k].yact)=-2) then sz:=true;
	 if mxt<>fig[k].xact then sz:=false;

	 if (abs(mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=-1) then
	 for i:=1 to 32 do
	 if (fig[i].color=red) and (mxt=fig[i].xact) and (myt=fig[i].yact) then
	 begin sz:=true;fig[i].xact:=0;fig[i].yact:=0;end;
	 if (abs(mxt-fig[k].xact)=0) and (abs(myt-fig[k].yact) in [1..2]) then
	 for i:=1 to 32 do
	 if (fig[i].color=red) and (mxt=fig[i].xact) and (myt=fig[i].yact) then
	 begin sz:=false;end
	 end
	End;
	bs:
	begin
		if  (myt<>fig[k].yact) and (mxt<>fig[k].xact) then sz:=false;

		if mxt<fig[k].xact then begin a:=mxt;b:=fig[k].xact; end
												else begin a:=fig[k].xact;b:=mxt;end;
		for i:=a+1 to b-1 do
		for j:=1 to 32 do
		if (k<>j) and (fig[j].yact=myt) and (fig[j].xact=i) then sz:=false;

		if myt<fig[k].yact then begin a:=myt;b:=fig[k].yact; end
												else begin a:=fig[k].yact;b:=myt;end;
		for i:=a+1 to b-1 do
		for j:=1 to 32 do
		if (k<>j) and (fig[j].xact=mxt) and (fig[j].yact=i) then sz:=false;

		if sz then
		for i:=1 to 32 do
		if (mxt=fig[i].xact) and (myt=fig[i].yact) then
		begin fig[i].xact:=0;fig[i].yact:=0;end;
		end;
	no:
	begin
{vizor}
		if ( (myt<>fig[k].yact) and (mxt<>fig[k].xact) )
		and
	 (abs(mxt-fig[k].xact) <> abs(myt-fig[k].yact)) then sz:=false;

		if  not((myt<>fig[k].yact) and (mxt<>fig[k].xact)) then
		begin
		if mxt<fig[k].xact then begin a:=mxt;b:=fig[k].xact; end
												else begin a:=fig[k].xact;b:=mxt;end;
		for i:=a+1 to b-1 do
		for j:=1 to 32 do
		if (k<>j) and (fig[j].yact=myt) and (fig[j].xact=i) then sz:=false;

		if myt<fig[k].yact then begin a:=myt;b:=fig[k].yact; end
												else begin a:=fig[k].yact;b:=myt;end;
		for i:=a+1 to b-1 do
		for j:=1 to 32 do
		if (k<>j) and (fig[j].xact=mxt) and (fig[j].yact=i) then sz:=false;
	 end;
{atlo}
	 if not(abs(mxt-fig[k].xact) <> abs(myt-fig[k].yact)) then
	 begin
	 if fig[k].xact<mxt then
	 begin
	 for i:=fig[k].xact+1 to mxt-1 do
	 for j:=1 to 32 do
	 begin
	 a:=1;
	 if (fig[k].yact>myt) then a:=-1;
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+a*(i-fig[k].xact)) then sz:=false;
	 end;
	 end
	 else
	 begin
	 for i:=mxt+1 to fig[k].xact-1 do
	 for j:=1 to 32 do
	 begin
	 a:=1;
	 if (fig[k].yact>myt) then a:=-1;
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+a*(fig[k].xact-i)) then sz:=false;
	 end;
	 end;
 end;




		if sz then
		for i:=1 to 32 do
		if (mxt=fig[i].xact) and (myt=fig[i].yact) then
		begin fig[i].xact:=0;fig[i].yact:=0;end;

	end;
	lo:
	Begin
	 if not(
	 ((mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=2) or
	 ((mxt-fig[k].xact)=2) and ((myt-fig[k].yact)=1) or
	 ((mxt-fig[k].xact)=-1) and ((myt-fig[k].yact)=-2) or
	 ((mxt-fig[k].xact)=-2) and ((myt-fig[k].yact)=-1) or
	 ((mxt-fig[k].xact)=-1) and ((myt-fig[k].yact)=2) or
	 ((mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=-2) or
	 ((mxt-fig[k].xact)=-2) and ((myt-fig[k].yact)=1) or
	 ((mxt-fig[k].xact)=-2) and ((myt-fig[k].yact)=-1)) then sz:=false;
	 if fig[k].color=red then
	 for i:=1 to 32 do
	 if sz and (mxt=fig[i].xact) and (myt=fig[i].yact)
	 and (fig[i].color=white) then
	 begin fig[i].xact:=0;fig[i].yact:=0;end
	 else
	 if sz and (mxt=fig[i].xact) and (myt=fig[i].yact)
	 and (fig[i].color=red) then
	 begin fig[i].xact:=0;fig[i].yact:=0;end
	End;
	fu:
	Begin
	 if abs(mxt-fig[k].xact) <> abs(myt-fig[k].yact) then sz:=false;
	 if fig[k].xact<mxt then
	 begin
	 for i:=fig[k].xact+1 to mxt-1 do
	 for j:=1 to 32 do
	 begin
	 a:=1;
	 if (fig[k].yact>myt) then a:=-1;
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+a*(i-fig[k].xact)) then sz:=false;
	 end;
	 end
	 else
	 begin
	 for i:=mxt+1 to fig[k].xact-1 do
	 for j:=1 to 32 do
	 begin
	 a:=1;
	 if (fig[k].yact>myt) then a:=-1;
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+a*(fig[k].xact-i)) then sz:=false;
	 end;

	 end;

	{ for i:=fig[k].xact+1 to mxt-1 do
	 for j:=1 to 32 do
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+i-fig[k].xact) then sz:=false
	 else
	 for i:= mxt+1 to fig[k].xact-1 do
	 for j:=1 to 32 do
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+i-mxt) then sz:=false;
}   if sz then
		for i:=1 to 32 do
		if (mxt=fig[i].xact) and (myt=fig[i].yact) then
		begin fig[i].xact:=0;fig[i].yact:=0;end;

	End;
	ki:
	Begin
	 if not(
	 ((mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=0) or
	 ((mxt-fig[k].xact)=0) and ((myt-fig[k].yact)=1) or
	 ((mxt-fig[k].xact)=-1) and ((myt-fig[k].yact)=0) or
	 ((mxt-fig[k].xact)=0) and ((myt-fig[k].yact)=-1) or
	 ((mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=1) or
	 ((mxt-fig[k].xact)=-1) and ((myt-fig[k].yact)=-1) or
	 ((mxt-fig[k].xact)=-1) and ((myt-fig[k].yact)=1) or
	 ((mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=-1)) then sz:=false;
	 if sz then
		for i:=1 to 32 do
		if (mxt=fig[i].xact) and (myt=fig[i].yact) then
		begin fig[i].xact:=0;fig[i].yact:=0;end;

	End;
 end;{case}
 szabadk:=sz;
end;




function szabad(k:integer):boolean;
var c,d,i,j:integer;
		sz:boolean;
Begin
 sz:=true;

 if not(mxt in [1..8]) or not(myt in [1..8]) then sz:=false;

 for i:=1 to 32 do
 if (i<>k) and (mxt=fig[i].xact) and (myt=fig[i].yact)
 and (fig[i].color=fig[k].color) then sz:=false;

 case fig[k].tip of
 fi:{fika}
	Begin
{   if (fig[k].yact=2) and (fig[k].color=red)}
	 if fig[k].color=red
	 then
	 begin
	 if ((myt-fig[k].yact)<>1) then sz:=false;
	 if (fig[k].yact=2)  and ((myt-fig[k].yact)=2) then sz:=true;
	 if mxt<>fig[k].xact then sz:=false;

	{ for i:=1 to 32 do
	 if ((mxt-fig[k].xact)=0) and ((fig[i].color)=white)
	 and (fig[i].xact<>mxt) and (fig[i].yact<>myt)
	 then sz:=false;}

	 if (abs(mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=1) then
	 for i:=1 to 32 do
	 if (fig[i].color=white) and (mxt=fig[i].xact) and (myt=fig[i].yact) then
	 begin sz:=true;fig[i].xact:=0;fig[i].yact:=0;end;

	 if (abs(mxt-fig[k].xact)=0) and ((myt-fig[k].yact) in [1..2]) then
	 for i:=1 to 32 do
	 if (fig[i].color=white) and (mxt=fig[i].xact) and (myt=fig[i].yact) then
	 begin sz:=false;end;

	 end
	 else
	 begin
	 if ((myt-fig[k].yact)<>-1) then sz:=false;
	 if (fig[k].yact=7)  and ((myt-fig[k].yact)=-2) then sz:=true;
	 if mxt<>fig[k].xact then sz:=false;

	 if (abs(mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=-1) then
	 for i:=1 to 32 do
	 if (fig[i].color=red) and (mxt=fig[i].xact) and (myt=fig[i].yact) then
	 begin sz:=true;fig[i].xact:=0;fig[i].yact:=0;end;
	 if (abs(mxt-fig[k].xact)=0) and (abs(myt-fig[k].yact) in [1..2]) then
	 for i:=1 to 32 do
	 if (fig[i].color=red) and (mxt=fig[i].xact) and (myt=fig[i].yact) then
	 begin sz:=false;end
	 end
	End;
	bs:
	begin
		if  (myt<>fig[k].yact) and (mxt<>fig[k].xact) then sz:=false;

		if mxt<fig[k].xact then begin a:=mxt;b:=fig[k].xact; end
												else begin a:=fig[k].xact;b:=mxt;end;
		for i:=a+1 to b-1 do
		for j:=1 to 32 do
		if (k<>j) and (fig[j].yact=myt) and (fig[j].xact=i) then sz:=false;

		if myt<fig[k].yact then begin a:=myt;b:=fig[k].yact; end
												else begin a:=fig[k].yact;b:=myt;end;
		for i:=a+1 to b-1 do
		for j:=1 to 32 do
		if (k<>j) and (fig[j].xact=mxt) and (fig[j].yact=i) then sz:=false;

		if sz then
		for i:=1 to 32 do
		if (mxt=fig[i].xact) and (myt=fig[i].yact) then
		begin fig[i].xact:=0;fig[i].yact:=0;end;
		end;
	no:
	begin
{vizor}
		if ( (myt<>fig[k].yact) and (mxt<>fig[k].xact) )
		and
	 (abs(mxt-fig[k].xact) <> abs(myt-fig[k].yact)) then sz:=false;

		if  not((myt<>fig[k].yact) and (mxt<>fig[k].xact)) then
		begin
		if mxt<fig[k].xact then begin a:=mxt;b:=fig[k].xact; end
												else begin a:=fig[k].xact;b:=mxt;end;
		for i:=a+1 to b-1 do
		for j:=1 to 32 do
		if (k<>j) and (fig[j].yact=myt) and (fig[j].xact=i) then sz:=false;

		if myt<fig[k].yact then begin a:=myt;b:=fig[k].yact; end
												else begin a:=fig[k].yact;b:=myt;end;
		for i:=a+1 to b-1 do
		for j:=1 to 32 do
		if (k<>j) and (fig[j].xact=mxt) and (fig[j].yact=i) then sz:=false;
	 end;
{atlo}
	 if not(abs(mxt-fig[k].xact) <> abs(myt-fig[k].yact)) then
	 begin
	 if fig[k].xact<mxt then
	 begin
	 for i:=fig[k].xact+1 to mxt-1 do
	 for j:=1 to 32 do
	 begin
	 a:=1;
	 if (fig[k].yact>myt) then a:=-1;
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+a*(i-fig[k].xact)) then sz:=false;
	 end;
	 end
	 else
	 begin
	 for i:=mxt+1 to fig[k].xact-1 do
	 for j:=1 to 32 do
	 begin
	 a:=1;
	 if (fig[k].yact>myt) then a:=-1;
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+a*(fig[k].xact-i)) then sz:=false;
	 end;
	 end;
 end;




		if sz then
		for i:=1 to 32 do
		if (mxt=fig[i].xact) and (myt=fig[i].yact) then
		begin fig[i].xact:=0;fig[i].yact:=0;end;

	end;
	lo:
	Begin
	 if not(
	 ((mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=2) or
	 ((mxt-fig[k].xact)=2) and ((myt-fig[k].yact)=1) or
	 ((mxt-fig[k].xact)=-1) and ((myt-fig[k].yact)=-2) or
	 ((mxt-fig[k].xact)=-2) and ((myt-fig[k].yact)=-1) or
	 ((mxt-fig[k].xact)=-1) and ((myt-fig[k].yact)=2) or
	 ((mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=-2) or
	 ((mxt-fig[k].xact)=-2) and ((myt-fig[k].yact)=1) or
	 ((mxt-fig[k].xact)=-2) and ((myt-fig[k].yact)=-1)) then sz:=false;
	 if fig[k].color=red then
	 for i:=1 to 32 do
	 if sz and (mxt=fig[i].xact) and (myt=fig[i].yact)
	 and (fig[i].color=white) then
	 begin fig[i].xact:=0;fig[i].yact:=0;end
	 else
	 if sz and (mxt=fig[i].xact) and (myt=fig[i].yact)
	 and (fig[i].color=red) then
	 begin fig[i].xact:=0;fig[i].yact:=0;end
	End;
	fu:
	Begin
	 if abs(mxt-fig[k].xact) <> abs(myt-fig[k].yact) then sz:=false;
	 if fig[k].xact<mxt then
	 begin
	 for i:=fig[k].xact+1 to mxt-1 do
	 for j:=1 to 32 do
	 begin
	 a:=1;
	 if (fig[k].yact>myt) then a:=-1;
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+a*(i-fig[k].xact)) then sz:=false;
	 end;
	 end
	 else
	 begin
	 for i:=mxt+1 to fig[k].xact-1 do
	 for j:=1 to 32 do
	 begin
	 a:=1;
	 if (fig[k].yact>myt) then a:=-1;
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+a*(fig[k].xact-i)) then sz:=false;
	 end;

	 end;

	{ for i:=fig[k].xact+1 to mxt-1 do
	 for j:=1 to 32 do
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+i-fig[k].xact) then sz:=false
	 else
	 for i:= mxt+1 to fig[k].xact-1 do
	 for j:=1 to 32 do
	 if (fig[j].xact=i) and (fig[j].yact=fig[k].yact+i-mxt) then sz:=false;
}   if sz then
		for i:=1 to 32 do
		if (mxt=fig[i].xact) and (myt=fig[i].yact) then
		begin fig[i].xact:=0;fig[i].yact:=0;end;

	End;
	ki:
	Begin
	 if not(
	 ((mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=0) or
	 ((mxt-fig[k].xact)=0) and ((myt-fig[k].yact)=1) or
	 ((mxt-fig[k].xact)=-1) and ((myt-fig[k].yact)=0) or
	 ((mxt-fig[k].xact)=0) and ((myt-fig[k].yact)=-1) or
	 ((mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=1) or
	 ((mxt-fig[k].xact)=-1) and ((myt-fig[k].yact)=-1) or
	 ((mxt-fig[k].xact)=-1) and ((myt-fig[k].yact)=1) or
	 ((mxt-fig[k].xact)=1) and ((myt-fig[k].yact)=-1)) then sz:=false
	 else
	 begin
		for j:=1 to 32 do
		if (k<>j) and (fig[j].color<>fig[k].color) then
		Begin
		a:=fig[k].xact;b:=fig[k].yact;
		if (szabadk(j)) then
		begin
		sz:=false;
		fig[k].xact:=a;fig[k].yact:=b;
		end;
		end;
		end;

	 if sz then
		for i:=1 to 32 do
		if (mxt=fig[i].xact) and (myt=fig[i].yact) then
		begin fig[i].xact:=0;fig[i].yact:=0;end;

	End;
 end;{case}
 szabad:=sz;
end;

Begin
 mousepost;
 for i:=1 to 32 do
 if (fig[i].xact=mxt) and (fig[i].yact=myt) and (mousepressed) then
 begin
	xg:=mx;yg:=my;
	mxo:=xa+(mxt-1)*size;myo:=ya+(myt-1)*size;
	mouseoff;
	removepiece(mxt,myt);
	putimage(mxo,myo,p[fig[i].tip]^,xorput);
	mouseon;
	 repeat
		 mousepost;
		 if (xg<>mx) or (yg<>my) then
		 Begin
		 mouseoff;
		 putimage(mxo,myo,p[fig[i].tip]^,xorput);
		 mxo:=mxo-(xg-mx);myo:=myo-(yg-my);
		 putimage(mxo,myo,p[fig[i].tip]^,xorput);
		 xg:=mx;yg:=my;
		 mouseon;
		 End;

	 until not(mousepressed);
	 mousepost;


	mouseoff;
	putimage(mxo,myo,p[fig[i].tip]^,xorput);

	if szabad(i) then
	begin
	removepiece(mxt,myt);
	drawpiece(fig[i].color,fig[i].tip,mxt,myt);
	fig[i].xact:=mxt;fig[i].yact:=myt;
	end
	else
	drawpiece(fig[i].color,fig[i].tip,fig[i].xact,fig[i].yact);
	mouseon;
 end;
end;


Begin
	inittable;
	Initmygraph;
	DrawTable;
	initpiece;
	initmouse;
	xmp;
	repeat
	Dragenddrop;
	until	keypressed;
	readkey;
	closegraph;
End.

