clear all
close all
clc
%% ��ҳ���ӵĻ�������
%΢����ʽ
web_1='https://s.weibo.com/weibo?q=';
web_2='&typeall=1&haspic=1&timescope=custom%3A';
web_3='-0%3A';
web_4='-0&Refer=g';
%% �趨�ؼ��� ���ؼ���
[a,b,city]=xlsread('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2024��\333���ؼ���������4��ֱϽ��.xlsx',1);
keywords={'��ͷ' '����' '����' '����' '·��'};
%% ��ÿ���ؼ��ʺ�ʱ��������ַ
for city_num=1:length(city)
web={};
%�ؼ��ʵ�url����
for keywords_num=1:length(keywords)
    web_keywords=matlab.net.URI(strcat(city{city_num,2},keywords{keywords_num}));
    web_keywords_url=web_keywords.EncodedPath;
%% �趨�ɼ�����ֹ���ڣ��ؼ���
A = datetime(2015,01,01);
B = datetime(2016,01,01);
%ÿ7��Ϊ�����������
date=A:7:B;
date=[date B];
%��ÿһ��������ҳ����
for n=1:length(date)-1
    %ʱ���url����
    formatIn = 'yyyy-mm-dd'; %���ڸ�ʽ
    web_time1 = datestr(date(n),formatIn);
    web_time2 = datestr(date(n+1),formatIn);
    %����������ҳ���ɼ�
    web{(keywords_num-1)*(length(date)-1)+n,1}=strcat(web_1,web_keywords_url{1,1},web_2,web_time1,web_3,web_time2,web_4);
end
end
savepath=strcat('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2015��\1�������ɵ�΢����ҳ\',num2str(city{city_num,1},'%03d'),city{city_num,2},'.xlsx');
xlswrite(savepath,web);%����excel��
end