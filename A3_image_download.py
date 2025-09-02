import os
import pandas as pd
import requests
import urllib3
import re
urllib3.disable_warnings()
#读取各城市的excel文件名
path = '/root/autodl-tmp/link'  # 存城市图片数据的文件夹 autodl-tmp/图片链接
files = sorted(os.listdir(path))  # 得到文件夹下的所有文件名称
for sample_num in range(len(files)): #
    num1 = 0
    if sample_num == 0: #如果程序从某个地方断开，则运行相应的文件号
        num1 = 0
    # 导入图片链接文件
    datapath=path+'/'+files[sample_num]  # 获取文件下图片链接文件的目录
    df = pd.read_excel(datapath)
    im_name = df.iloc[:,0]
    im_link = df.iloc[:,1]
    #创建保存图片的文件夹
    image_folder = (r'/root/autodl-tmp/save'+'/'+files[sample_num][0:3])
    if not os.path.exists(image_folder):
        os.mkdir(image_folder)
    #下载图片
    headers = {
        'authority': 'weibo.com',
        'x-requested-with': 'XMLHttpRequest',
        'sec-ch-ua-mobile': '?0',
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'content-type': 'application/x-www-form-urlencoded',
        'accept': '*/*',
        'sec-fetch-site': 'same-origin',
        'sec-fetch-mode': 'cors',
        'sec-fetch-dest': 'empty',
        'referer': 'https://weibo.com/1192329374/KnnG78Yf3?filter=hot&root_comment_id=0&type=comment',
        'accept-language': 'zh-CN,zh;q=0.9,en-CN;q=0.8,en;q=0.7,es-MX;q=0.6,es;q=0.5',
        'cookie': 'XSRF-TOKEN=g_8SfsR-pywYjEgvbGgGPiw8;ALF=1720532635;SUB=_2A25LYcHLDeRhGeBK6FQV8y3KzziIHXVoH1sDrDV8PUJbkNANLUXxkW1NR91YDCTnasMxZa4VNzVpZoYvPUfl87QU;SUBP=0033WrSXqPxfM725Ws9jqgMF55529P9D9WhdKy-zBeks2q7xeupPO-rc5JpX5KzhUgL.FoqXe0qXe0ecShB2dJLoIpL8TPWEIgfLi--Ri-88i-i8i--Ri-88i-2p;WBPSESS=qqQJLLhNFSL8TL3Thwts9OgDAzz3ENTfPnaxUSH6cV0fOlqawH3ndwrYDVPlrHAGQ1pWi377rpQZaoqQ2n-ec9P3vqhHk7rWpfM9yJg7UZO2tm8yQ4_ms4eUjj9aSZ7f90mbwpHelBsFqfZGkP0xRQ==',
    }


    for im_num in range(num1, len(im_link)):
        image_url = im_link[im_num]
        imdown = requests.get(url=image_url, headers=headers, verify=False).content #下载图片
        list_index = [i.start() for i in re.finditer("_", im_name[im_num])]  # 寻找‘_’出现的位置
        picsave = open(image_folder+'/'+im_name[im_num][list_index[1]+1:]+'.jpg','wb')
        # 保存图片到之前设置的路径，并用微博行数+图片序号命名
        picsave.write(imdown)
        picsave.close()
        count = im_num + 1  # 设置计数器方便查看
        print(f'{sample_num}第{count}张图片下载完成！')
