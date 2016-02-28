%let file_dir = C:\Users\Bones\Desktop\地图动态展示;
%let name=result;
libname ss "&file_dir";
filename odsout '.';
goptions nodisplay;

/* 从ss逻辑库中导入数据到work逻辑库 */
data dataset;
set ss.database1;
run;
data anno_all;
set ss.anno_all;
run;

/* 从maps逻辑库导入数据到work逻辑库 */
data china;
set maps.china;
	x = long; y = lat;
	province = id;
run;
proc gproject data = china out = china project = cylindri
	longmin = 57
	longmax = 100
	latmin = 6
	latmax = 31
	;
	id province;
run;

/* 把源数据分成两部分，dataset1用来画全国地图，dataset2用来画各省的地图，因为它们用的map数据集是不同的，要分开处理 */
data dataset1(drop = ID1) dataset2(drop = ID1);
set dataset;
	if ID1 ne '' then output dataset1; 
	else output dataset2;
	if  NAME in ("北京市","天津市","上海市","重庆市") then output dataset2;
run;


data _null_;
set dataset1;
	call symput(cats('myID',MAP_ID), trim(ID2));
	call symput(cats('myNAME',MAP_ID), trim(NAME));
run;

/* 在全国地图上的各个省份加上标签，用于点击跳转 */
data dataset12(drop = ID rename = (MAP_ID = ID));
length my_html $300;
set dataset1;
	my_html = cats("title='", NAME, "0d"x, "人口（单位：万）：", NUM, "0d"x, "自然增长率（‰）：", RATE, "'");
run;
data dataset22;
length my_html $300;
set dataset2;
	my_html = cats('title="', NAME, '0d'x, '人口（单位：万）：', NUM, '0d'x, "自然增长率（‰）：", RATE, '"');
run;

/* 清除 work.gseg 里面的内容，防止名字重复时报错 */
/*proc greplay igout=work.gseg nofs;*/
/*   delete _all_;*/
/*run;*/


/* 画全国地图 */
%macro drow_country();
	pattern1 v = msolid c=tan;
	title1 ls = 1.5 height = 7 "中国2012年人口分布";
	goptions display;
	goptions noborder gunit=pct;
	goptions colors = ('#EEB4B4' '#00E5EE' '#00008B' '#7A67EE' '#8B7E66' '#FFF8DC' '#EE82EE' '#FDF5E6' '#9932CC' '#00FF7F' '#838B83' '#EE4000' '#EEC900' '#FFF0F5' '#EEEE00' '#CD5C5C' '#E9967A' '#458B74' '#B0E2FF' '#8B2500' '#A4D3EE' '#8B814C' '#00CD00' '#436EEE' '#EE9A00' '#00CDCD' '#BDB76B' '#FFFFF0' '#76EE00' '#D15FEE' '#00008B');
	goptions xpixels=1000 ypixels=600; 
	proc gmap data = dataset12 map = china all;
	id id;
	block NUM / discrete nolegend 
			cdefault = "AFFFF0050" 
			stat = first 
			blocksize = 2.7
			shape = s
			html = my_html;
	run;
	goptions nodisplay;
%mend drow_country;


%macro frame1();
	   1/llx = 0   lly = 0
	     ulx = 0   uly = 100
	     urx =100  ury = 100
	     lrx =100  lry = 0
	   2/llx = 63  lly = 38
	     ulx = 63  uly = 98
	     urx = 98  ury = 98
	     lrx = 98  lry = 38
%mend frame1;
%macro frame2();
	   1/llx = 0   lly = 0
	     ulx = 0   uly = 100
	     urx =100  ury = 100
	     lrx =100  lry = 0
	   2/llx = 63  lly = 2
	     ulx = 63  uly = 62
	     urx = 98  ury = 62
	     lrx = 98  lry = 2
%mend frame2;
%macro frame3();
	   1/llx = 0   lly = 0
	     ulx = 0   uly = 100
	     urx =100  ury = 100
	     lrx =100  lry = 0
	   2/llx = 2  lly = 2
	     ulx = 2  uly = 62
	     urx = 37  ury = 62
	     lrx = 37  lry = 2
%mend frame3;
%macro frame4();
	   1/llx = 0   lly = 0
	     ulx = 0   uly = 100
	     urx =100  ury = 100
	     lrx =100  lry = 0
	   2/llx = 1  lly = 39
	     ulx = 1  uly = 99
	     urx = 36  ury = 99
	     lrx = 36  lry = 39
%mend frame4;

%macro which_frame(ID=);
	proc sql;
		select avg(sign) into: ss from anno;
	quit;run;
	%let frame = %sysfunc(cats(%frame,&ss.));
%mend which_frame;



/* 画省MAP_ID为ID的省人口分布地图 */
%macro drow_provinces(ID);
	%let myNAMEs = %sysfunc(cats(myNAME, &ID.));
	%let myIDs = %sysfunc(cats(myID, &ID.));
	%let country = %sysfunc(cats(coun,&ID.));
	%let province = %sysfunc(cats(prov,&ID.));

    /* 数据准备	*/
	data anno;
		set anno_all;
		if ID = &ID.;
	run;
	data dataset12;
		set dataset12;
		if ID = &ID. then wanted = 'YES';
		else wanted = 'NO';
	run;

	/* 画国家图 */
	pattern1 c=greyee;
	pattern2 c=red;
	title1 ls = 0 h = 0"";
	goptions noborder;
	goptions xpixels=1000 ypixels=600 cback = white;
	proc gmap data = dataset12 map = china annotate=anno all;
	id id;
	choro wanted / discrete 
			nolegend
			cdefault = greyee
			coutline = gray88
			cempty = white
			name = "&country."
			html = my_html;
	run;

	/* 画省图 */
	title1 ls=2.0 h=12pct c=red f="/bold" "&&&myNAMEs..";
	goptions colors = ('#00f300' '#00e700' '#00db00' '#00cf00' '#00c300' '#00b700' '#00ab00' '#009f00' '#009300' '#008700' '#007b00' '#006f00' '#006300' '#005700' '#004b00' '#003f00' '#003300' '#002700' '#001b00' '#000f00');
	pattern1 v = msolid c = tan;
	pattern2 c = '#00ff00';
	goptions xpixels=200 ypixels=250 cback = white;
	proc gmap data = dataset22(where = (MAP_ID = &ID.)) map = mapsgfk.china(where = (ID1 = "&&&myIDs..")) all;
	id id;
	block NUM / discrete
			nolegend 
			cdefault = "AFFFF0050" 
			stat = first 
			html = my_html 
			blocksize = 1.7
			shape = c
			name = "&province.";
	run;


	/* 以上两个图合并在一起 */
	%let frame = frame0;
	%which_frame(ID = &ID.);

	goptions display;
	goptions xpixels=1000 ypixels=600; 
	proc greplay tc=tempcat nofs igout=work.gseg;
	  tdef crmap des='crmap'
	   &frame.;
	   ;
	template = crmap;
	treplay
	 1:&country.
	 2:&province.
	 des='' name="Dear";
	run;
	quit;
	goptions nodisplay;
	
%mend drow_provinces;

/* 做出31个省的HTML */
%macro drow_all_provinces();
%do i=1 %to 33;
	%if &i. ne 17 and &i. ne 27 %then %drow_provinces(&i.);
%end;
%mend drow_all_provinces;



options dev=sasprtc printerpath=gif animduration=.7 animloop=0 animoverlay=no animate=start nocenter;
ods listing close;
ods html path=odsout body="&name..htm" (title="SAS/Graph Animation (&sysver)") style=sasweb;
goptions gsfmode=append;

/* 开始作图 */
%drow_country();
%drow_all_provinces();

quit;
ods html close;
ods listing;