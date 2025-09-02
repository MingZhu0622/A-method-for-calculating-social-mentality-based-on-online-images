clear all
close all
clc
%% ��������
em_path_list = dir('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2015��\4�������\B_ȥ��������ͼ��');% �б����ļ����е��ļ���Ϣ
for sample_num1 =3:length(em_path_list)%���ζ��������м���
    emname= strcat('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2015��\4�������\B_ȥ��������ͼ��\',em_path_list(sample_num1).name);
    [a,b,emdata] = xlsread(emname);%�沿����
    if ~isempty(a)
        %% �ҳ��ж��������ͼƬλ��
        weibo_inm=cell2mat(emdata(2:end,2));
        diff_vec1 = diff(weibo_inm);
        diff_vec2 = [0;(weibo_inm(1:end-1)-weibo_inm(2:end))];
        idx=union(find(diff_vec1==0),find(diff_vec2==0));
        multi_face=[a(idx,:)];% �ж��������ͼƬ��Ϣ
        %% ȥ��ÿ��ͼ����������
        data_no_big=[];%�ռ�����
        kk=[0;find(diff(multi_face(:,2))~=0);size(multi_face,1)];
        for n1=1:length(kk)-1
            one_im=multi_face(kk(n1)+1:kk(n1+1),:);
            face_size=one_im(:,6).*one_im(:,7);
            [max1,max2]=max(face_size);
            one_im(max2,:)=[]; %ȥ��������
            data_no_big=[data_no_big;one_im];
        end
        %% ��ȥ���ڵ������ݽ��жԱȣ�ȡ����
        emname= strcat('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2015��\4�������\D_ȥ�������ڵ�\',em_path_list(sample_num1).name);
        [kouzhao,kouzhao1,kouzhao2] = xlsread(emname);%ȥ�������ڵ��������
        idx_kouzhao={};idx_data_no_big={};
        for n2=1:size(kouzhao,1)
            idx_kouzhao{n2,1}=strcat(num2str(kouzhao(n2,1)),'-',num2str(kouzhao(n2,2)),'-',num2str(kouzhao(n2,3)));
        end
        for n3=1:size(data_no_big,1)
            idx_data_no_big{n3,1}=strcat(num2str(data_no_big(n3,1)),'-',num2str(data_no_big(n3,2)),'-',num2str(data_no_big(n3,3)));
        end
        %% �ҳ�ȥ�����������еķǲɷ���
        idx_end1=[];
        for n4=1:size(kouzhao,1)
        idx_end1(n4)=sum(contains(idx_data_no_big, idx_kouzhao{n4}));
        end
        idx_end=find(idx_end1==1);
        %% ���ݴ洢
        data_end=kouzhao2(idx_end+1,:);%ȥ���п����ڵ�������
        savepath=strcat('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2015��\4�������\E_ȥ���ɷ�\',em_path_list(sample_num1).name);
        xlswrite(savepath,[emdata(1,:);data_end]);%����excel��
        disp(strcat('����',num2str(sample_num1-2)));
    else
        savepath=strcat('C:\��ʿ\���˹���\ȫ���Ҹ��в���\����\2015��\4�������\E_ȥ���ɷ�\',em_path_list(sample_num1).name);
        xlswrite(savepath,emdata(1,:));%����excel��
        disp(strcat('����',num2str(sample_num1-2)));
    end
end