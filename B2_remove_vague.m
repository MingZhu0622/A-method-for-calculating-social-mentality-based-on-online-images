clear all
close all
clc
%% 设置导入数据的文件路径
em_path_list = dir('C:\博士\个人工作\全国幸福感测量\数据\2015年\4测量结果\B_去除无人脸图像');% 原始的数据
%% 遍历文件夹中的所有样本
for sample_num1 =152:length(em_path_list)%依次对样本进行计算
    %% 导入情绪数据
    emname= strcat('C:\博士\个人工作\全国幸福感测量\数据\2015年\4测量结果\B_去除无人脸图像\',em_path_list(sample_num1).name);
    [a,b,emdata] = xlsread(emname);%情绪数据
    data=emdata(2:end,:);%从第二行开始提取
    %% 计算图像的大小（Px数量）
    px=cell2mat(data(:,6)).*cell2mat(data(:,7)); %面部检测框的w×h
    index=find(px>1240);%大于1240px的图像被认为是可用于识别表情的
    savepath=strcat('C:\博士\个人工作\全国幸福感测量\数据\2015年\4测量结果\C_去除模糊图像\',em_path_list(sample_num1).name);
    xlswrite(savepath,[emdata(1,:);data(index,:)]);%存入excel中
    disp(sample_num1)
end