clear all
close all
clc
%% 设置导入数据的文件路径
em_path_list = dir('C:\博士\个人工作\全国幸福感测量\数据\2015年\4测量结果\E_去除采访');% 列表情文件夹中的文件信息
%% 导入混淆矩阵和权重数据
load('confusion_matrix.mat')
%先混淆
w_max2=(100*hxjz(4,4)+100)/2;
w_min2=(100-100*hxjz(2,2))/2;
%% 遍历文件夹中的所有样本进行计算
for sample_num1 =3:339%依次对样本进行计算
    %% 导入样本数据
    emname= strcat('C:\博士\个人工作\全国幸福感测量\数据\2015年\4测量结果\E_去除采访\',em_path_list(sample_num1).name);
    [emdata,sex,~] = xlsread(emname);%情绪数据
    if ~isempty(emdata) %如果emdata非空，则测量积极和消极情绪
        %% 导入情绪数据
        em_all = emdata(:,8:14);%某一帧中所有的情绪（生气1、厌恶2、害怕3、开心4、伤心5、惊讶6、正常7）
        %% 二、先混淆矩阵，后计算情绪
        pos=[0 0 0.42 1 0.25 0.82 0.51];
        neg=[1 1 0.58 0 0.75 0.18 0.49];
        em_pos=[];em_neg=[];
        em_all_hxjz = (hxjz*em_all')';
        [em_i,em_c]=max(em_all_hxjz');
        em_pos=em_i.*pos(em_c);
        em_neg=em_i.*neg(em_c);
        wellbing2=(em_pos+100-em_neg)/2;
        wellbing2=(wellbing2-w_min2)/(w_max2-w_min2)*100;
        %% 计算平均幸福度
        result{sample_num1-2,1}=wellbing2;
        face_num(sample_num1-2,1)=size(wellbing2,2);
        well_bing(sample_num1-2,:)=mean(wellbing2);
    end
end