import numpy as np 
from PIL import Image 

working_dir = 'c:/intelFPGA_lite/18.1/work_with_gx_kit/ov7670_2_hdmi/rtl/ov7670_2_hdmi/image_work/compression/work_with_pic/'
w_pic = working_dir + 'working_pic.jpg'
wtxt = working_dir + 'pic.txt'

img = Image.open(w_pic)
img = img.resize((640,480))
arr = np.asarray(img, dtype='uint8')
arr = arr.ravel()
print(arr.dtype)
np.savetxt( wtxt, arr)



# Прошакалить в питоне



# Сохранить грязного шакала в двух вариациях цветной
