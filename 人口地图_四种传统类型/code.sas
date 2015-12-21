/*
此文档用来将中国各省数据在地图上展示
注意需要修改 file_dir 的路径，即当前文件所在目录，该目录下应包含dataset、Map_city、Maps_city三个数据表。
可以修改 goptions 里面的像素大小和图片的大小。
*/

%let file_dir = D:\Temp\GitHub\人口地图_四种传统类型;
libname ss "&file_dir";

proc sort data = ss.database out = a1;by City;run;
proc sort data = ss.Map_city out = a2;by NAME;run;

data a3;
merge a1(rename = (City = NAME) in = ina) a2(in = inb);
by NAME;
if ina and inb and MAP_ID ne .;
run;

/* 将Num、Rate字段从字符型转成数值型*/
data a3(drop = Num Rate ID rename = (is = Num rs = Rate MAP_ID = ID));
set a3;
is = Num + 0;
rs = Rate + 0;
run;

/* 去掉省、市、自治区后缀 */
data aa1;
set a3;
where NAME like '%省';
NAME = kcompress(NAME,'省');
run;
data aa2;
set a3;
where NAME like '%市';
NAME = kcompress(NAME,'市');
run;
data aa3;
set a3;
where NAME like '%自治区';
NAME = kcompress(NAME,'自治区');
run;
data aa;
set aa1 aa2 aa3;
run;

/* 以上aa是response data，下面为labelout准备数据表a5 */
proc sort data = aa;by ID;run;
proc sort data = ss.Maps_city(rename = (MAP_ID = ID)) out = b1;by ID;run;

data a4;
merge aa(in = ina) b1(in = inb);
by ID;
if ina and inb;
run;

proc sort data = a4;by ID;run;
proc sort data = Maps.China out = b2(keep = ID X Y);by ID;run;

data a5;
merge a4(in = ina) b2(in = inb);
by ID;
if ina and inb;
run;


/***************************** 以上为数据准备，以下开始作图 *******************************/


/* 求labelout,在地图上显示标签的时候需要用到 */
proc sort data = a5;by ID1NAME;run;
%annomac;
%maplabel (a5, a5, labelout, NAME, ID1NAME,
          font=<ttf> NSimSun, color=black, size=2, hsys=3);


/* 以下开始作图 */
ods listing style=statistical;
filename file "&file_dir/IMG_output.png";
goptions reset = all device=png gsfname=file xpixels=1200 ypixels=1200 XMAX=32cm YMAX=24cm transparency border;
title1 height = 2 ls = 2 "2014年中国各省人数";
/*footnote1 j = r "单位：万人";*/
footnote2 j = r "数据来自中国统计局";
legend1 label = ("人口范畴：");

proc gmap data = aa 
			map = maps.china
		density=low all;
id ID;
/*block Num / relzero legend = legend1 levels=6;			* 柱条图，levels表示分多少组;*/
block Num / discrete legend = legend1 relzero;			* 有颜色的柱条图;
/*choro Num / annotate=labelout stat=first legend = legend1 levels = 12;			* 颜色图;*/
/*prism Num / cdefault=yellow relzero legend = legend1 coutline = grey44;			* 凸块图;*/
/*surface Num / stat=mean constant=6 nlines=100 rotate=70 tilt=25;			* 尖角图;*/
run;
quit;

