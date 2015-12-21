/* 
此代码能够在中国地图上气泡的方式表示各省的人口数据 
使用前请注意修改 file_dir 的路径，即当前文件的路径，该路径应包含Dataset、Province2两个数据表，生成的图片也在该目录下。
可以修改 goptions 里面的像素大小和图片的大小。
*/

%let file_dir = D:\Temp\GitHub\人口地图_气泡图;
%let name=world_cities;
filename odsout '.';
libname ss "&file_dir";
data Database(rename = (City = NAME));
set ss.Database;
label City = ' ' Y2014 = ' ' Y2013 = ' ' Y2012 = ' ';
run;

data Province;
set ss.Province2;
run;

proc sort data = Database;by NAME;run;
proc sort data = Province;by NAME;run;
data Database1(drop = ID rename = (MAP_ID = ID));
merge Database(in = ina) Province(in = inb);
by NAME;
if ina and inb;
run;


/* 下面加入 anno 的各项参数 */
data Database2; set Database1;
xsys='2'; ysys='2'; hsys='3'; when='a';
length function style $8 color $20;
function='pie'; rotate=360; style='psolid';
run;

data Database2;
/*set Database2;*/
set Database2(drop = color);
run;

data Database2; 
set Database2;
size=sqrt(Y2014/3.14)*.1;
if ID>40 then color='a1464F4aa';
else color='a1E90FFda';
output;
style='pempty'; color='white'; output;
run;


/* 以下开始作图 */
goptions xpixels=1200 ypixels=1200 XMAX=32cm YMAX=24cm cback=gray77 border;
ODS LISTING CLOSE;
ODS HTML path="&file_dir." body="&name..html" style=htmlblue;
title1 ls=1.5 h=3 c=white "2014年中国各省人口";
footnote1 c = white2 h = 1 "(气泡大小表示人口数量)";
footnote2 j = r "数据来自中国统计局";
pattern1 v=msolid c=black;

proc gmap data = Database2
			map = maps.china
			anno = Database2
		density=high all;
id ID;
/*block Y2014 / relzero  levels=6;			* 柱条图，levels表示分多少组;*/
/*block Y2014 / discrete relzero;			* 有颜色的柱条图;*/
choro Y2014 /  levels = 1 coutline = gray15 nolegend des = '';			* 颜色图;
/*prism Y2014 / cdefault=yellow relzero coutline = grey44;			* 凸块图;*/
/*surface Y2014 / stat=mean constant=7 nlines=100 rotate=70 tilt=15;			* 尖角图;*/
run;
quit;
ODS HTML CLOSE;
ODS LISTING;