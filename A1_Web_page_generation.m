clear all
close all
clc
%% 网页链接的基本内容
%微博格式
web_1='https://s.weibo.com/weibo?q=';
web_2='&typeall=1&haspic=1&timescope=custom%3A';
web_3='-0%3A';
web_4='-0&Refer=g';
%% 设定关键词 （关键）
[a,b,city]=xlsread('C:\博士\个人工作\全国幸福感测量\数据\2024年\333个地级行政区和4个直辖市.xlsx',1);
keywords={'街头' '出行' '生活' '市民' '路人'};
%% 对每个关键词和时间生成网址
for city_num=1:length(city)
web={};
%关键词的url解码
for keywords_num=1:length(keywords)
    web_keywords=matlab.net.URI(strcat(city{city_num,2},keywords{keywords_num}));
    web_keywords_url=web_keywords.EncodedPath;
%% 设定采集的起止日期（关键）
A = datetime(2015,01,01);
B = datetime(2016,01,01);
%每7天为间隔生成日期
date=A:7:B;
date=[date B];
%对每一周生成网页链接
for n=1:length(date)-1
    %时间的url解码
    formatIn = 'yyyy-mm-dd'; %日期格式
    web_time1 = datestr(date(n),formatIn);
    web_time2 = datestr(date(n+1),formatIn);
    %批量生成网页并采集
    web{(keywords_num-1)*(length(date)-1)+n,1}=strcat(web_1,web_keywords_url{1,1},web_2,web_time1,web_3,web_time2,web_4);
end
end
savepath=strcat('C:\博士\个人工作\全国幸福感测量\数据\2015年\1批量生成的微博网页\',num2str(city{city_num,1},'%03d'),city{city_num,2},'.xlsx');
xlswrite(savepath,web);%存入excel中
end