from deepface import DeepFace
import os
import re
import cv2
import gc
# 获取文件夹中所有子文件夹的路径
path = '/root/autodl-tmp/save'  # 存放样本的文件夹目录autodl-tmp/wellbing
files = sorted(os.listdir(path)) # 得到文件夹下的所有文件名称
for sample_num in range(len(files)):
    citypath = path+'/'+files[sample_num]
    imfiles = os.listdir(citypath)  # 得到文件夹下所有图片的名称 imfiles.index('微博_出现_1_2')
    save_path = '/root/autodl-tmp/result'  # 存放运行结果的文件夹dywZs9g2deuC
    excel_path = save_path + '/' + files[sample_num] + '.txt'  # 获取储存excel的文件目录
    collect = [] #定义一个空的list
    frame_num = 0
    for im_num in range( len(imfiles)):#
        im_path = citypath + '/' + imfiles[im_num]  # 获取文件下样本视频的目录
        # 判断图像是否具有RGB3个通道
        img_test = cv2.imread(im_path)
        if img_test is not None: #如果对象非空 则进行下一步
            if len(img_test.shape) == 3: #如果三个通道均有 则进行下一步
                del img_test #释放资源
                objs = DeepFace.analyze(im_path,
                                        detector_backend='retinaface',  # 人脸检测算法选择 retinaface效果较好
                                        actions=['emotion', 'age', 'gender'], #识别的属性包括表情、年龄、性别
                                        enforce_detection=False, silent=True)
                # 对一帧图像的结果进行采集
                ## 获取图片的基本信息
                list_index = [i.start() for i in re.finditer("_", imfiles[im_num])]#寻找‘_’出现的位置

                for i in range(0, len(objs)):
                    if objs[i]['region']['x'] != 0:  # 判断该帧是否检测到目标，若检测到则：
                        d = []  # 创建一个空list收集数据
                        d.append(imfiles[im_num][0:list_index[0]])# 微博所在行数（从第2行开始，用于溯源图片的博文）
                        d.append(imfiles[im_num][list_index[0] + 1:imfiles[im_num].find('.')])#该微博的第几张图片
                        d.append(i+1)  # 收集一张图像中的对象id
                        # 收集面部检测框的xywh
                        d.append(objs[i]['region']['x'])
                        d.append(objs[i]['region']['y'])
                        d.append(objs[i]['region']['w'])
                        d.append(objs[i]['region']['h'])
                        # 收集7种面部表情的强度 以及最大表情的强度
                        d.append(objs[i]['emotion']['angry'])  # 生气
                        d.append(objs[i]['emotion']['disgust'])  # 厌恶
                        d.append(objs[i]['emotion']['fear'])  # 害怕
                        d.append(objs[i]['emotion']['happy'])  # 开心
                        d.append(objs[i]['emotion']['sad'])  # 伤心
                        d.append(objs[i]['emotion']['surprise'])  # 惊讶
                        d.append(objs[i]['emotion']['neutral'])  # 正常
                        d.append(objs[i]['dominant_emotion'])  # 强度最高的表情
                        d.append(objs[i]['age'])  # 年龄
                        d.append(objs[i]['dominant_gender'])  # 年龄
                        collect.append(d)  # 暂时储存
                    else:
                        d = []  # 创建空list
                        #记录无人脸的图片信息
                    #   d.append(imfiles[im_num][0:list_index[0]])# 所在城市
                    #   d.append(imfiles[im_num][list_index[0]+1:list_index[1]])# 关键词
                        d.append(imfiles[im_num][0:list_index[0]])# 微博所在行数（从第2行开始，用于溯源图片的博文）
                        d.append(imfiles[im_num][list_index[0] + 1:imfiles[im_num].find('.')])#该微博的第几张图片
                        collect.append(d)  # 暂时储存

        cv2.destroyAllWindows() #释放opencv的内存
        frame_num += 1  # 一帧数据采集完成后更新帧序号
        if (frame_num) %50 == 0:
            print(sample_num, frame_num)  # 输出处理的城市和图片序号
        if (frame_num) % 200 == 0: #每500张图片保存一次结果到txt
            num_200 = frame_num
            data = open(excel_path, "a")  # 以追加的方式打开txt
            for i in collect:
                i = str(i).strip('[').strip(']').replace(',', '').replace("'", '') #调整格式
                data.write(i+'\n') #每写完一行就换行
            data.close()  # 关闭文件
            collect = []  # 将collect清零
        if frame_num == len(imfiles):# 若到最后一张图片 也保存一次 且无需继续读取新的表格
            data = open(excel_path, "a")  # 以追加的方式打开txt
            for i in collect:
                i = str(i).strip('[').strip(']').replace(',', '').replace("'", '')  # 调整格式
                data.write(i + '\n')  # 每写完一行就换行
            data.close()  # 关闭文件
            collect = []  # 将collect清零
            print(sample_num, '处理结束')  # 输出处理的城市和图片序号