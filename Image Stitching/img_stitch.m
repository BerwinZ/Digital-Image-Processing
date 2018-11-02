%{
ͼ��ƴ�ӳ���
1.����ֱ��Run��������img_stitch;
2.����ֻ��ƴ������ͼ����Ĭ�����м�ͼ��Ϊ��׼
3.�����Ҫ��ƴ����������ͼ���Ч������Ҫ����������imread������������Ӧ���ļ�����
  ����Ҫ��cpselect��ʹ�ò���Ԥ�õ�����д���

��42 �Ų��� 2014011455
%}

%----------------------------------------------------------------------
%������
%----------------------------------------------------------------------
function [imgWithBlack imgWithoutBlack]=img_stitch()
%����ͼ��
clear
clc
img1=imread('1.jpg');
img2=imread('2.jpg');
img3=imread('3.jpg');

%��img1��img2��ȡ5�Կ��Ƶ�
Point1preset=[2867.75000000000,382.500000000000;2413.88030326237,1346.48131413693;3092.75000000000,1360.75000000000;2102.50000000000,842.500000000000;3197.25000000000,832.750000000000];
Point2preset=[817.156224868839,362.033029525524;297,1240.25000000000;949.250000000000,1270.62500000000;34.7500000000000,742.250000000000;1075.08538826773,799.565094195129];
[points1,points2]=cpselect(img1,img2,Point1preset,Point2preset,'wait',true);
%[points1,points2]=cpselect(img1,img2,'wait',true);
%���ݿ��Ƶ��img1���б任
[newimg1 left up1 bottom1]=myTransform1(points1,points2,img1);

%��img2,img3��ȡ5�Կ��Ƶ�
Point3preset=[1003.75000000000,1003.25000000000;680.625000000000,1450.62500000000;685.625000000000,672.187500000000;1188.75000000000,1212.75000000000;991.149561521082,1524.86349710872];
Point2preset=[2858.75000000000,738.250000000000;2459.87325777301,1269.99303109205;2419.50000000000,362.250000000000;3095.18750000000,982.375000000000;2887.32694443381,1356.49494504653];
[points2,points3]=cpselect(img2,img3,Point2preset,Point3preset,'wait',true);
%[points2,points3]=cpselect(img2,img3,'wait',true);
%���ݿ��Ƶ��img3���б任
[newimg3 right up2 bottom2]=myTransform3(points3,points2,img3);

%������ͼƴ������
newimg=combine3img(newimg1,img2,newimg3);
imgWithBlack=newimg;
figure
imshow(newimg)
imwrite(newimg,'imgWithBlack.bmp');

%�ü�ͼƬ
newimg_crop=crop(newimg,left,right,max(up1,up2),min(bottom1,bottom2));
imgWithoutBlack=newimg_crop;
figure
imshow(newimg_crop)
imwrite(newimg_crop,'imgWithoutBlack.bmp');
end


%%
%----------------------------------------------------------------------
%��������
%----------------------------------------------------------------------
%��img1(��ͼ)������任
function [img_new left up bottom]=myTransform1(points1,points2,img1)
[height width m]=size(img1);
points2(:,1)=points2(:,1)+width;

%��img1��img2�ķ���任�ľ���
Tni=point2matrix(points2,points1);
%�����任������һЩ�߽�
[X Y]=meshgrid(1:width,1:height);
tempX=X*Tni(1,1)+Y*Tni(1,2)+Tni(1,3);
tempY=X*Tni(2,1)+Y*Tni(2,2)+Tni(2,3);
%�ҵ�img1�Ҳ࿿��ĵ�,Ӧ����(1,width)��(height,width)��ӳ��֮һ
min_x=int64(min(tempX(1,width),tempX(height,width)));
min_x=int64(min(min_x,width+width/7));
%�ҵ�img1�����ĵ㣬Ӧ����(1,1)��(height,1)��ӳ��֮һ
left=int64(max(tempX(1,1),tempX(height,1)));
%�ҵ�img1������ĵ㣬Ӧ����(1,1)��(1,width)��ӳ��֮һ
up=int64(max(tempY(1,1),tempY(1,width)));
up=int64(max(up,1));
%�ҵ�img1������ĵ㣬Ӧ����(height,1)��(height,width)��ӳ��֮һ
bottom=int64(min(tempY(height,1),tempY(height,width)));

%��img2��img1�ķ���任�ľ���
T=point2matrix(points1,points2);
%��img2��img1ӳ��������б�
[X_img2 Y_img2]=meshgrid(1:min_x,1:height);
new2old_X=double(X_img2)*T(1,1)+double(Y_img2)*T(1,2)+T(1,3);
new2old_Y=double(X_img2)*T(2,1)+double(Y_img2)*T(2,2)+T(2,3);
[X_img2 Y_img2]=meshgrid(1:width,1:height);
%ʹ�ò�ֵ�����������
img_new(:,:,1)=interp2(X_img2,Y_img2,double(img1(:,:,1)),new2old_X,new2old_Y);
img_new(:,:,2)=interp2(X_img2,Y_img2,double(img1(:,:,2)),new2old_X,new2old_Y);
img_new(:,:,3)=interp2(X_img2,Y_img2,double(img1(:,:,3)),new2old_X,new2old_Y);
img_new=uint8(img_new);
end

%��img3(��ͼ)������任
function [img_new right up bottom]=myTransform3(points3,points2,img3)
[height width m]=size(img3);
points2(:,1)=points2(:,1)+width;
%��img3��img2�ķ���任�ľ���
Tni=point2matrix(points2,points3);

%�����任������һЩ�߽�
[X Y]=meshgrid(1:width,1:height);
tempX=X*Tni(1,1)+Y*Tni(1,2)+Tni(1,3);
tempY=X*Tni(2,1)+Y*Tni(2,2)+Tni(2,3);
%�ҵ�img3�Ҳ࿿��ĵ�,Ӧ����(1,1)��(height,1)��ӳ��֮һ
max_x=int64(max(tempX(1,1),tempX(height,1)));
max_x=int64(max(max_x,width+width*6/7));
%�ҵ�img3�Ҳ�ĵ㣬Ӧ����(1,width)��(height,width)��ӳ��֮һ
right=int64(min(tempX(1,width),tempX(height,width)));
%�ҵ�img3������ĵ㣬Ӧ����(1,1)��(1,width)��ӳ��֮һ
up=int64(max(tempY(1,1),tempY(1,width)));
up=int64(max(up,1));
%�ҵ�img1������ĵ㣬Ӧ����(height,1)��(height,width)��ӳ��֮һ
bottom=int64(min(tempY(height,1),tempY(height,width)));

%��img2��img1�ķ���任�ľ���
T=point2matrix(points3,points2);
%��img2��img1ӳ��������б�
[X_img3 Y_img3]=meshgrid(max_x:3*width,1:height);
new2old_X=double(X_img3)*T(1,1)+double(Y_img3)*T(1,2)+T(1,3);
new2old_Y=double(X_img3)*T(2,1)+double(Y_img3)*T(2,2)+T(2,3);
[X_img3 Y_img3]=meshgrid(1:width,1:height);
%ʹ�ò�ֵ�����������
img_new(:,:,1)=interp2(X_img3,Y_img3,double(img3(:,:,1)),new2old_X,new2old_Y);
img_new(:,:,2)=interp2(X_img3,Y_img3,double(img3(:,:,2)),new2old_X,new2old_Y);
img_new(:,:,3)=interp2(X_img3,Y_img3,double(img3(:,:,3)),new2old_X,new2old_Y);
img_new=uint8(img_new);
end

%���ݿ��Ƶ������任����
function T=point2matrix(point1,point2)
%��point2��point1��ӳ��
%point1Ϊԭͼ�㣬point2Ϊ��ͼ��
length=size(point1,1);
point1=point1';
point1(3,1:length)=1;
point2=point2';
point2(3,1:length)=1;
T=point1/point2;     %point1*point2^-1
end

%ƴ���Ѿ�����任֮���ͼ��
function newimg=combine3img(img1,img2,img3)
%img1ռ1��width+1000��img3ռ2*width-1000:3*width
[height1 width1 m]=size(img1);
[height2 width2 m]=size(img2);
[height3 width3 m]=size(img3);


newimg(:,1:width2,:)=img1(:,1:width2,:);
newimg(:,2*width2+1:3*width2,:)=img3(:,end-width2+1:end,:);

pixelNum1=width1-width2;
temp=linspace(0,1,pixelNum1);
tempZeng=meshgrid(temp,1:height2,1:3);
temp=linspace(1,0,pixelNum1);
tempJian=meshgrid(temp,1:height2,1:3);
newimg(:,width2+1:width2+pixelNum1,:)=uint8(double(img2(:,1:pixelNum1,:)).*tempZeng+double(img1(:,width2+1:width2+pixelNum1,:)).*tempJian);

pixelNum3=width3-width2;
temp=linspace(0,1,pixelNum3);
tempZeng=meshgrid(temp,1:height2,1:3);
temp=linspace(1,0,pixelNum3);
tempJian=meshgrid(temp,1:height2,1:3);
newimg(:,2*width2-pixelNum3+1:2*width2,:)=uint8(double(img3(:,1:pixelNum3,:)).*tempZeng+double(img2(:,width2-pixelNum3+1:width2,:)).*tempJian);

newimg(:,width2+pixelNum1+1:2*width2-pixelNum3,:)=img2(:,pixelNum1+1:width2-pixelNum3,:);

end

%�ü��ڱ�
function newimg=crop(img,left,right,up,bottom)
[height width m]=size(img);
img(:,right:end,:)=[];
img(:,1:left,:)=[];
img(bottom:end,:,:)=[];
img(1:up,:,:)=[];
newimg=img;
end