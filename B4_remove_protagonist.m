clear all
close all
clc
%% 导入数据
em_path_list = dir('C:\博士\个人工作\全国幸福感测量\数据\2015年\4测量结果\B_去除无人脸图像');% 列表情文件夹中的文件信息
for sample_num1 =3:length(em_path_list)%依次对样本进行计算
    emname= strcat('C:\博士\个人工作\全国幸福感测量\数据\2015年\4测量结果\B_去除无人脸图像\',em_path_list(sample_num1).name);
    [a,b,emdata] = xlsread(emname);%面部数据
    if ~isempty(a)
        %% 找出有多个人脸的图片位置
        weibo_inm=cell2mat(emdata(2:end,2));
        diff_vec1 = diff(weibo_inm);
        diff_vec2 = [0;(weibo_inm(1:end-1)-weibo_inm(2:end))];
        idx=union(find(diff_vec1==0),find(diff_vec2==0));
        multi_face=[a(idx,:)];% 有多个人脸的图片信息
        %% 去除每张图中最大的人脸
        data_no_big=[];%收集数据
        kk=[0;find(diff(multi_face(:,2))~=0);size(multi_face,1)];
        for n1=1:length(kk)-1
            one_im=multi_face(kk(n1)+1:kk(n1+1),:);
            face_size=one_im(:,6).*one_im(:,7);
            [max1,max2]=max(face_size);
            one_im(max2,:)=[]; %去除最大的脸
            data_no_big=[data_no_big;one_im];
        end
        %% 与去除遮挡的数据进行对比，取交集
        emname= strcat('C:\博士\个人工作\全国幸福感测量\数据\2015年\4测量结果\D_去除口罩遮挡\',em_path_list(sample_num1).name);
        [kouzhao,kouzhao1,kouzhao2] = xlsread(emname);%去除口罩遮挡后的数据
        idx_kouzhao={};idx_data_no_big={};
        for n2=1:size(kouzhao,1)
            idx_kouzhao{n2,1}=strcat(num2str(kouzhao(n2,1)),'-',num2str(kouzhao(n2,2)),'-',num2str(kouzhao(n2,3)));
        end
        for n3=1:size(data_no_big,1)
            idx_data_no_big{n3,1}=strcat(num2str(data_no_big(n3,1)),'-',num2str(data_no_big(n3,2)),'-',num2str(data_no_big(n3,3)));
        end
        %% 找出去除口罩数据中的非采访者
        idx_end1=[];
        for n4=1:size(kouzhao,1)
        idx_end1(n4)=sum(contains(idx_data_no_big, idx_kouzhao{n4}));
        end
        idx_end=find(idx_end1==1);
        %% 数据存储
        data_end=kouzhao2(idx_end+1,:);%去掉有口罩遮挡的数据
        savepath=strcat('C:\博士\个人工作\全国幸福感测量\数据\2015年\4测量结果\E_去除采访\',em_path_list(sample_num1).name);
        xlswrite(savepath,[emdata(1,:);data_end]);%存入excel中
        disp(strcat('城市',num2str(sample_num1-2)));
    else
        savepath=strcat('C:\博士\个人工作\全国幸福感测量\数据\2015年\4测量结果\E_去除采访\',em_path_list(sample_num1).name);
        xlswrite(savepath,emdata(1,:));%存入excel中
        disp(strcat('城市',num2str(sample_num1-2)));
    end
end