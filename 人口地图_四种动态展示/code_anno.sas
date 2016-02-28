libname ss 'C:\Users\Bones\Desktop\地图动态展示';
%macro anno11(N);
proc sql;
create table _null_ as
	select unique ID
	from dear11;
	select x into: avg_x from dear11 where n = &N.;
	select y into: avg_y from dear11 where n = &N.;
	select ID into: myID from dear11 where n = &N.;
quit;run;

data anno11;
	length function $8 color $20;
	/* 画两个三角形的阴影 */
	ID = &myID.;
	sign = 1;
	when = 'a'; style='solid'; color="A77777787";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=63; y=98; output;
	x=63; y=38; output;
	x=98; y=38; output;

	/* 画正方形的阴影 */
	style='solid'; color="A77777757";
	xsys='3'; ysys='3';
	function='poly'; 
	x=63; y=38; output;
	function='polycont';
	x=98; y=38; output;
	x=98; y=98; output;
	x=63; y=98; output;

	/* 画虚线 */
	style='solid'; color="A77777707";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=98; y=98; output;
	x=63; y=98; output;

	/* 画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=63; y=38; output;
	x=98; y=38; output;
	x=98; y=98; output;
	x=63; y=98; output;

	/* 继续画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=63; y=98; output;
	x=63; y=38; output;
	x=98; y=38; output;
run;

data anno_all;
set anno_all anno11;
run;
%mend anno11;

%macro anno12(N);
proc sql;
create table _null_ as
	select unique ID
	from dear12;
	select x into: avg_x from dear12 where n = &N.;
	select y into: avg_y from dear12 where n = &N.;
	select ID into: myID from dear12 where n = &N.;
quit;run;

data anno12;
	length function $8 color $20;
	/* 画三角形的阴影 */
	ID = &myID.;
	sign = 1; 
	when = 'a'; style='solid'; color="A77777787";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=63; y=38; output;
	x=63; y=98; output;

	/* 画正方形的阴影 */
	style='solid'; color="A77777757";
	xsys='3'; ysys='3';
	function='poly'; 
	x=63; y=38; output;
	function='polycont';
	x=98; y=38; output;
	x=98; y=98; output;
	x=63; y=98; output;

	/* 画虚线 */
	ID = &myID.;
	style='solid'; color="A77777707";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=98; y=38; output;
	x=98; y=98; output;

	/* 画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=63; y=38; output;
	x=63; y=98; output;

	/* 继续画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=63; y=98; output;
	x=98; y=98; output;
	x=98; y=38; output;
	x=63; y=38; output;
run;

data anno_all;
set anno_all anno12;
run;
%mend anno12;

%macro anno2(N);
proc sql;
create table _null_ as
	select unique ID
	from dear2;
	select x into: avg_x from dear2 where n = &N.;
	select y into: avg_y from dear2 where n = &N.;
	select ID into: myID from dear2 where n = &N.;
quit;run;

data anno2;
	length function $8 color $20;
	/* 画三角形的阴影 */
	ID = &myID.;
	sign = 2;
	when = 'a'; style='solid'; color="A77777787";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=63; y=2; output;
	x=63; y=62; output;

	/* 画正方形的阴影 */
	style='solid'; color="A77777757";
	xsys='3'; ysys='3';
	function='poly'; 
	x=63; y=2; output;
	function='polycont';
	x=98; y=2; output;
	x=98; y=62; output;
	x=63; y=62; output;

	/* 画虚线 */
	ID = &myID.;
	style='solid'; color="A77777707";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=98; y=2; output;
	x=98; y=62; output;

	/* 画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=63; y=2; output;
	x=63; y=62; output;

	/* 继续画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=63; y=62; output;
	x=98; y=62; output;
	x=98; y=2; output;
	x=63; y=2; output;
run;

data anno_all;
set anno_all anno2;
run;
%mend anno2;

%macro anno31(N);
proc sql;
create table _null_ as
	select unique ID
	from dear31;
	select x into: avg_x from dear31 where n = &N.;
	select y into: avg_y from dear31 where n = &N.;
	select ID into: myID from dear31 where n = &N.;
quit;run;

data anno31;
	length function $8 color $20;
	/* 画两个三角形的阴影 */
	ID = &myID.;
	sign = 3;
	when = 'a'; style='solid'; color="A77777787";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=37; y=2; output;
	x=37; y=62; output;
	x=2; y=62; output;

	/* 画正方形的阴影 */
	style='solid'; color="A77777757";
	xsys='3'; ysys='3';
	function='poly'; 
	x=2; y=2; output;
	function='polycont';
	x=37; y=2; output;
	x=37; y=62; output;
	x=2; y=62; output;

	/* 画虚线 */
	style='solid'; color="A77777707";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=2; y=2; output;
	x=2; y=62; output;

	/* 画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=37; y=62; output;
	x=2; y=62; output;
	x=2; y=2; output;
	x=37; y=2; output;

	/* 继续画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=37; y=2; output;
	x=37; y=62; output;
	x=2; y=62; output;
run;

data anno_all;
set anno_all anno31;
run;
%mend anno31;

%macro anno32(N);
proc sql;
create table _null_ as
	select unique ID
	from dear32;
	select x into: avg_x from dear32 where n = &N.;
	select y into: avg_y from dear32 where n = &N.;
	select ID into: myID from dear32 where n = &N.;
quit;run;

data anno32;
	length function $8 color $20;
	/* 画三角形的阴影 */
	ID = &myID.;
	sign = 3;
	when = 'a'; style='solid'; color="A77777787";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=37; y=2; output;
	x=37; y=62; output;

	/* 画正方形的阴影 */
	style='solid'; color="A77777757";
	xsys='3'; ysys='3';
	function='poly'; 
	x=37; y=2; output;
	function='polycont';
	x=37; y=62; output;
	x=2; y=62; output;
	x=2; y=2; output;

	/* 画虚线 */
	ID = &myID.;
	style='solid'; color="A77777707";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=2; y=2; output;
	x=2; y=62; output;

	/* 画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=37; y=2; output;
	x=37; y=62; output;

	/* 继续画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=37; y=62; output;
	x=2; y=62; output;
	x=2; y=2; output;
	x=37; y=2; output;
run;

data anno_all;
set anno_all anno32;
run;
%mend anno32;


%macro anno4(N);
proc sql;
create table _null_ as
	select unique ID
	from dear4;
	select x into: avg_x from dear4 where n = &N.;
	select y into: avg_y from dear4 where n = &N.;
	select ID into: myID from dear4 where n = &N.;
quit;run;

data anno4;
	length function $8 color $20;
	/* 画三角形的阴影 */
	ID = &myID.;
	sign = 4;
	when = 'a'; style='solid'; color="A77777787";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=37; y=38; output;
	x=37; y=98; output;

	/* 画正方形的阴影 */
	style='solid'; color="A77777757";
	xsys='3'; ysys='3';
	function='poly'; 
	x=37; y=38; output;
	function='polycont';
	x=37; y=98; output;
	x=2; y=98; output;
	x=2; y=38; output;

	/* 画虚线 */
	ID = &myID.;
	style='solid'; color="A77777707";
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=2; y=38; output;
	x=2; y=98; output;

	/* 画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=37; y=38; output;
	x=37; y=98; output;

	/* 继续画直线 */
	style='empty'; color='black';
	function='poly'; 
	xsys='2'; ysys='2'; x=&avg_x; y=&avg_y; output;
	function='polycont';
	xsys='3'; ysys='3';
	x=37; y=98; output;
	x=2; y=98; output;
	x=2; y=38; output;
	x=37; y=38; output;
run;

data anno_all;
set anno_all anno4;
run;
%mend anno4;


%macro add_n(dear);
data &dear.;
set &dear.;
n = _n_;
run;
%mend add_n;

%macro get_anno(anno=, t=);
%do i=1 %to &t;
	%&anno.(&i);
%end;
%mend get_anno;





proc sort data = ss.dear2 out = dear;by ID;run;
data dear(keep = x y ID);
set dear;
by ID;
if first.ID;
run;
data anno_all;
set ss.anno;
run;


data dear11 dear12 dear2 dear31 dear32 dear4 dear;
set dear;
if ID in (11 16 18 29 31) then output dear11;
else if ID in (6 13 15) then output dear12;
else if ID in (14 26 32) then output dear2;
else if ID in (8 20) then output dear31;
else if ID in (1 2 3 4 7 9 12 23 24 25 30 33 34 35) then output dear32;
else if ID in (5 10 19 21 22 28) then output dear4;
else output dear;
run;
%add_n(dear11);
%add_n(dear12);
%add_n(dear2);
%add_n(dear31);
%add_n(dear32);
%add_n(dear4);

%get_anno(anno=anno11, t=5);
%get_anno(anno=anno12, t=3);
%get_anno(anno=anno2, t=3);
%get_anno(anno=anno31, t=2);
%get_anno(anno=anno32, t=14);
%get_anno(anno=anno4, t=6);

data ss.anno_all;
set anno_all;
run;

