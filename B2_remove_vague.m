clear all
close all
clc
%% ���õ������ݵ��ļ�·��
em_path_list = dir('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2015��\4�������\B_ȥ��������ͼ��');% ԭʼ������
%% �����ļ����е���������
for sample_num1 =152:length(em_path_list)%���ζ��������м���
    %% ������������
    emname= strcat('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2015��\4�������\B_ȥ��������ͼ��\',em_path_list(sample_num1).name);
    [a,b,emdata] = xlsread(emname);%��������
    data=emdata(2:end,:);%�ӵڶ��п�ʼ��ȡ
    %% ����ͼ��Ĵ�С��Px������
    px=cell2mat(data(:,6)).*cell2mat(data(:,7)); %�沿�����w��h
    index=find(px>1240);%����1240px��ͼ����Ϊ�ǿ�����ʶ������
    savepath=strcat('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2015��\4�������\C_ȥ��ģ��ͼ��\',em_path_list(sample_num1).name);
    xlswrite(savepath,[emdata(1,:);data(index,:)]);%����excel��
    disp(sample_num1)
end