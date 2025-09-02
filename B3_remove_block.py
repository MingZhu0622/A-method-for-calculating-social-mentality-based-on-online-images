import os
import pandas as pd
import cv2
import numpy as np
# 导入图片和数据所在文件夹
em_path = '/root/autodl-tmp/face' #去除模糊图像后的数据所在文件夹
im_path = '/root/autodl-tmp/save' #图片所在文件
em_path_list = sorted(os.listdir(em_path))
im_path_list = sorted(os.listdir(im_path))
for num1 in range(1, len(em_path_list)):
    allmask = [] #定义一个空list，用于收集信息
    emname = em_path + '/' + em_path_list[num1]
    emdata = pd.read_excel(emname)
    # 提取图片的名称、面部区域的x、y、宽、高数据
    imname1 = emdata.iloc[:, 0]
    imname2 = emdata.iloc[:, 1]
    imx = emdata.iloc[:, 3]
    imy = emdata.iloc[:, 4]
    imw = emdata.iloc[:, 5]
    imh = emdata.iloc[:, 6]
    # 依次处理每个样本
    for num2 in range(0, len(imx)): #len(imx)
        # 提取图片链接
        image = im_path + '/' + em_path_list[num1][0:3] + '/' + str(imname1[num2]) + '_' + str(imname2[num2]) + '.jpg'# 图片链接
        img = cv2.imread(image)  # 读取图片
        if img.shape[2] == 3: #如果是彩色图像则进行下一步操作
            img = img[imy[num2]:imy[num2]+imh[num2], imx[num2]:imx[num2]+imw[num2]]  # 裁剪出人脸图片
            imsize = img.shape
            if imsize[0] != 0 and imsize[1] != 0: #如果图像大小不为0
                # 截取下半部人脸 识别是否被口罩遮挡
                img = img[round(imsize[0]/2):imsize[0], 0: imsize[1]]
                # 转换颜色空间至HSV和YCbCr
                img_HSV = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
                HSV_mask = cv2.inRange(img_HSV, (0, 15, 0), (17, 170, 255))
                HSV_mask = cv2.morphologyEx(HSV_mask, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
                img_YCrCb = cv2.cvtColor(img, cv2.COLOR_BGR2YCrCb)
                YCrCb_mask = cv2.inRange(img_YCrCb, (0, 135, 85), (255, 180, 135))
                YCrCb_mask = cv2.morphologyEx(YCrCb_mask, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
                # 根据HSV和YCbCr检测肤色
                global_mask = cv2.bitwise_and(YCrCb_mask, HSV_mask)
                global_mask = cv2.medianBlur(global_mask, 3)
                global_mask = cv2.morphologyEx(global_mask, cv2.MORPH_OPEN, np.ones((4, 4), np.uint8))
                global_result = cv2.bitwise_not(global_mask)
                # 判断肤色像素占比 小于25%则认为存在遮挡
                g = (global_result == 0).sum()
                skin_ratio = g/(img.shape[0]*img.shape[1])
                if skin_ratio >= 0.25:
                    allmask.append(num2) # 采集未被遮挡的人脸行数
                # 每处理500张图片输出一次
                if num2 % 500 == 0:
                    print(num1, '第', num2, '张图片处理完成')
    # 每完成一个城市，保存一次结果
    data_noblock = emdata.iloc[allmask, :]
    save_path = '/root/autodl-tmp/noblock/' + em_path_list[num1]
    data_noblock.to_excel(save_path, index=False)
    print(num1, '处理完成')
    # show results
    #cv2.imwrite("/root/autodl-tmp/3_global_result.jpg", gray_result)

