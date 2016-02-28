%let file_dir = C:\Users\Bones\Desktop\地图动态展示;
libname ss "&file_dir";

/* 从ss逻辑库中导入数据到work逻辑库 */
data dataset;
set ss.database1;
run;

/* 把源数据分成两部分，dataset1用来画全国地图，dataset2用来画各省的地图，因为它们用的map数据集是不同的，要分开处理 */
data dataset1(drop = ID1) dataset2(drop = ID1);
set dataset;
if ID1 ne '' then output dataset1; 
else output dataset2;
if  NAME in ("北京市","天津市","上海市","重庆市") then output dataset2;
run;

/* 设置各个省份的宏变量，用“myID”和maps逻辑库的ID组成变量名，对应的值是它的省编号。如myID1对于的是安徽省，省编号为'CN-34' */
data _null_;
set dataset1;
call symput(cats('myID',MAP_ID), trim(ID2));
call symput(cats('myNAME',MAP_ID), trim(NAME));
run;

/* 在全国地图上的各个省份加上标签，用于点击跳转 */
data dataset12(drop = ID rename = (MAP_ID = ID));
length my_html $300;
set dataset1;
my_html = cats("title='", NAME, "0d"x, "人口（单位：万）：", NUM, "0d"x, "自然增长率（‰）：", RATE, "'href='", "file:///", "&file_dir./Temp/", MAP_ID, ".htm'");
run;
data dataset22;
length my_html $300;
set dataset2;
my_html = cats('title="', NAME, '0d'x, '人口（单位：万）：', NUM, '0d'x, "自然增长率（‰）：", RATE, '"');
run;

/* 画全国地图 */
%macro drow_map_country();
ODS LISTING CLOSE;
ODS HTML path = "&file_dir.\Temp" body = "main.htm" 
 (title="&year Corruption Perceptions Index") style=htmlblue;
goptions reset = all border;
title1 ls = 1.5 height = 2 "中国2012年人口分布";
proc gmap data = dataset12 map = maps.china all;
id id;
choro NUM / cdefault = "AFFFF0050" stat = first html = my_html;
run;
quit;
ODS HTML CLOSE;
ODS LISTING;
%mend drow_map_country;

/* 画省MAP_ID为ID的省人口分布地图 */
%macro drow_map_provinces(ID);
goption reset = all border;
%let myNAMEs = %sysfunc(cats(myNAME, &ID.));
%let myIDs = %sysfunc(cats(myID, &ID.));
title1 ls = 1.5 height = 2 "&&&myNAMEs..2012年人口分布";
ODS LISTING CLOSE;
ODS HTML path = "&file_dir.\Temp" body = "&ID..htm" 
 (title="Corruption Perceptions Index") style=htmlblue;
proc gmap data = dataset22(where = (ID2 = "&&&myIDs..")) map = mapsgfk.china(where = (ID1 = "&&&myIDs..")) all;
note move=(120,5) color=gray55 link="file:///&file_dir./Temp/main.htm" box=2 "全国地图";
id id;
choro NUM / cdefault = "AFFFF0050" stat = first html = my_html;
run;
quit;
ODS HTML CLOSE;
ODS LISTING;
%mend drow_map_provinces;

/* 此宏函数用来画国家地图和33个省份的地图 */
%macro drow_all_maps();
%drow_map_country();
%do i=1 %to 33;
	%if &i. ne 17 and &i. ne 27 %then %drow_map_provinces(&i.);
%end;
%mend drow_all_maps;

/* 开始作图 */
%drow_all_maps();