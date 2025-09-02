clear all
clear all
close all
clc
%% 设置导入数据的文件路径
path_list = dir('C:\博士\个人工作\全国幸福感测量\数据\2024年\2各城市微博内容');% 微博爬取数据的文件夹
%% 读取城市名称
% [a,b,city]=xlsread('G:\20230624北武院\全国幸福感测量\数据\其他GDP靠前的城市133个.xlsx');
%% 遍历文件夹中的所有样本
for sample_num1 =150:337%依次对网页数据进行整理
    link_all={};%用于收集结果
    %% 导入样本数据
    crawl_name= strcat('C:\博士\个人工作\全国幸福感测量\数据\2024年\2各城市微博内容\',path_list(sample_num1+2).name);
    [data,str] = xlsread(crawl_name);%
    for num2=2:size(str,1)
        %判断该时间段是否采集到内容
        time=str{num2,3}; %获取发布时间
        if contains(time,'2024')==1 %
            link_1=str(num2,[7:15 20]);%提取图片链接
            %判断是否爬取到图片
            if isempty(link_1{1,1})==0%如果识别到图片链接则执行以下代码
                for num3=1:size(link_1,2)-1%读取每个图片的代码位置
                    if isempty(link_1{1,num3})==0%如果识别到图片链接则执行以下代码
                        %按规则对图像命名 命名规则：来源平台_关键词_微博行数_图片序号
                        imname=strcat('微博_',str(num2,1),'_',num2str(num2),'_',num2str(num3));
                        imlink=link_1{1,num3};
                        %替换图片链接 用于下载原图
                        location=strfind(imlink,'/');%找到出行“/”的位置
                        imlink(location(3)+1:location(4)-1)=[];%把预览的链接去掉，即第三个和第四个“/”之间的东西
                        location=strfind(imlink,'/');%重新找到出行“/”的位置
                        raw_imlink=strcat(imlink(1:location(3)),'mw690',imlink(location(4):end));%原图的链接
                        link_collect=[imname raw_imlink];
                        link_all(end+1,:)=link_collect;%收集结果
                    end
                end
            end
            if isempty(link_1{1,1})==1 && isempty(link_1{1,10})==0
                imname=strcat('微博_',str(num2,1),'_',num2str(num2),'_',num2str(10));
                imlink=link_1{1,10};
                %替换图片链接 用于下载原图
                location=strfind(imlink,'/');%找到出行“/”的位置
                imlink(location(3)+1:location(4)-1)=[];%把预览的链接去掉，即第三个和第四个“/”之间的东西
                location=strfind(imlink,'/');%重新找到出行“/”的位置
                raw_imlink=strcat(imlink(1:location(3)),'mw690',imlink(location(4):end));%原图的链接
                link_collect=[imname raw_imlink];
                link_all(end+1,:)=link_collect;%收集结果
            end
        end
    end
    save_path=strcat('C:\博士\个人工作\全国幸福感测量\数据\2024年\3各城市图片链接\',path_list(sample_num1+2).name);
    xlswrite(save_path,link_all,1,'A1');%存入excel中
    disp(sample_num1)
end