clear all
clear all
close all
clc
%% ���õ������ݵ��ļ�·��
path_list = dir('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2024��\2������΢������');% ΢����ȡ���ݵ��ļ���
%% ��ȡ��������
% [a,b,city]=xlsread('G:\20230624����Ժ\ȫ���Ҹ��в���\����\����GDP��ǰ�ĳ���133��.xlsx');
%% �����ļ����е���������
for sample_num1 =150:337%���ζ���ҳ���ݽ�������
    link_all={};%�����ռ����
    %% ������������
    crawl_name= strcat('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2024��\2������΢������\',path_list(sample_num1+2).name);
    [data,str] = xlsread(crawl_name);%
    for num2=2:size(str,1)
        %�жϸ�ʱ����Ƿ�ɼ�������
        time=str{num2,3}; %��ȡ����ʱ��
        if contains(time,'2024')==1 %
            link_1=str(num2,[7:15 20]);%��ȡͼƬ����
            %�ж��Ƿ���ȡ��ͼƬ
            if isempty(link_1{1,1})==0%���ʶ��ͼƬ������ִ�����´���
                for num3=1:size(link_1,2)-1%��ȡÿ��ͼƬ�Ĵ���λ��
                    if isempty(link_1{1,num3})==0%���ʶ��ͼƬ������ִ�����´���
                        %�������ͼ������ ����������Դƽ̨_�ؼ���_΢������_ͼƬ���
                        imname=strcat('΢��_',str(num2,1),'_',num2str(num2),'_',num2str(num3));
                        imlink=link_1{1,num3};
                        %�滻ͼƬ���� ��������ԭͼ
                        location=strfind(imlink,'/');%�ҵ����С�/����λ��
                        imlink(location(3)+1:location(4)-1)=[];%��Ԥ��������ȥ�������������͵��ĸ���/��֮��Ķ���
                        location=strfind(imlink,'/');%�����ҵ����С�/����λ��
                        raw_imlink=strcat(imlink(1:location(3)),'mw690',imlink(location(4):end));%ԭͼ������
                        link_collect=[imname raw_imlink];
                        link_all(end+1,:)=link_collect;%�ռ����
                    end
                end
            end
            if isempty(link_1{1,1})==1 && isempty(link_1{1,10})==0
                imname=strcat('΢��_',str(num2,1),'_',num2str(num2),'_',num2str(10));
                imlink=link_1{1,10};
                %�滻ͼƬ���� ��������ԭͼ
                location=strfind(imlink,'/');%�ҵ����С�/����λ��
                imlink(location(3)+1:location(4)-1)=[];%��Ԥ��������ȥ�������������͵��ĸ���/��֮��Ķ���
                location=strfind(imlink,'/');%�����ҵ����С�/����λ��
                raw_imlink=strcat(imlink(1:location(3)),'mw690',imlink(location(4):end));%ԭͼ������
                link_collect=[imname raw_imlink];
                link_all(end+1,:)=link_collect;%�ռ����
            end
        end
    end
    save_path=strcat('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2024��\3������ͼƬ����\',path_list(sample_num1+2).name);
    xlswrite(save_path,link_all,1,'A1');%����excel��
    disp(sample_num1)
end