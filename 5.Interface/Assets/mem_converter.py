import cv2
import numpy as np
file_name="WIN95"
res=1
def to_bin(data,res):
    message=""
    for i in range(res):
        message+=str(int(data/128))
        data-=int(data/128)*128
        data=data*2
    return message
b = open(file_name+"_b.mem","w")
g = open(file_name+"_g.mem","w")
r = open(file_name+"_r.mem","w")
image=cv2.imread(file_name+".bmp")

for i in range(image.shape[0]):
    for j in range(image.shape[1]):
        b.write(to_bin(image[i][j][0],res)+"\n")
        g.write(to_bin(image[i][j][1],res)+"\n")
        r.write(to_bin(image[i][j][2],res)+"\n")
b.close()
g.close()
r.close()
img=np.zeros((image.shape[0],image.shape[1],3),dtype=np.uint8)
b = open(file_name+"_b.mem","r")
g = open(file_name+"_g.mem","r")
r = open(file_name+"_r.mem","r")
def to_num(data,res):
    return int(data,2)*2**(8-res) #+2**(8-res)-1
for i in range(img.shape[0]):
    for j in range(img.shape[1]):
        img[i][j][0]=to_num(b.readline(),res)
        img[i][j][1]=to_num(g.readline(),res)
        img[i][j][2]=to_num(r.readline(),res)
cv2.imshow("",img)
cv2.waitKey(0)
