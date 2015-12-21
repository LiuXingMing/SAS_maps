/* 
此代码能够在中国地图上气泡的方式表示各省的人口数据 
使用前请注意修改 file_dir 的路径，即当前文件的路径，该路径应包含Dataset、Province2两个数据表，生成的图片也在该目录下。
可以修改 goptions 里面的像素大小和图片的大小。
*/

%let file_dir = D:\Temp\GitHub\人口地图_气泡图;
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
else color='a76EE00ca';
output;
style='pempty'; color='gray33'; output;
run;


/* 以下开始作图 */
ods listing style=statistical;
filename file "&file_dir/IMG_output.png";
/*goptions reset = all device=png gsfname=file xpixels=1200 ypixels=1200 XMAX=32cm YMAX=24cm border transparency colors = ('#d0ffa9');*/
goptions reset = all device=png gsfname=file xpixels=1200 ypixels=1200 XMAX=32cm YMAX=24cm border transparency;
title1 "2014年中国各省人数";
footnote1 "气泡大小表示人口数量";
footnote2 j = r "数据来自中国统计局";
legend1 label = ( " " position = top) 
		value = ("西藏自治区"
				"青海省"
				"宁夏回族自治区"
				"海南省"
				"天津市"
				"北京市"
				"新疆维吾尔自治区"
				"上海市"
				"内蒙古自治区"
				"甘肃省"
				"吉林省"
				"重庆市"
				"贵州省"
				"山西省"
				"陕西省"
				"福建省"
				"黑龙江省"
				"辽宁省"
				"江西省"
				"云南省"
				"广西壮族自治区"
				"浙江省"
				"湖北省"
				"安徽省"
				"湖南省"
				"河北省"
				"江苏省"
				"四川省"
				"河南省"
				"山东省"
				"广东省"
				);

proc gmap data = Database2
			map = maps.china
			anno = Database2
		density=low all;
id ID;
/*block Y2014 / relzero  levels=6;			* 柱条图，levels表示分多少组;*/
/*block Y2014 / discrete relzero;			* 有颜色的柱条图;*/
choro Y2014 /  stat=first legend = legend1 discrete levels = 1;			* 颜色图;
/*prism Y2014 / cdefault=yellow relzero coutline = grey44;			* 凸块图;*/
/*surface Y2014 / stat=mean constant=7 nlines=100 rotate=70 tilt=15;			* 尖角图;*/
run;
quit;