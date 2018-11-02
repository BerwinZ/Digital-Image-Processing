%{
��������Ϊȥ�����÷�ʽΪ[newimg1 newimg2 neimg3]=img_dfog(oldimg)
������ʹ��������ȥ���㷨���ֱ�Ϊ��
ֱ��ͼ���⻯����ͨ��ԭ��ȥ��Retinexԭ��ȥ��

��42 �Ų��� 2014011455
%}

%-------------------------
%������
%--------------------------
function [newimg1 newimg2 newimg3]=img_dfog(oldimg)
%ʹ��ֱ��ͼ���⻯ȥ��
newimg1=UseHistogram(oldimg);
%ʹ�ð�ͨ��ȥ��
newimg2=UseDarkCha(oldimg);
%ʹ�ö�߶�����Ĥ��ǿ�㷨
newimg3=UseRetinex(oldimg);
end


%%
%-------------------------
%��������
%--------------------------
%1ֱ��ͼ���⻯������
function newimg=UseHistogram(oldimg)

newimg13=SquareHistogram(oldimg,1,3);
newimg15=SquareHistogram(oldimg,1,5);
[height width m]=size(oldimg);
corrd1=int64(linspace(1,height,5+1));
corrd2=int64(linspace(1,width,5+1));
newimg1=newimg15;
%������ȥ����
pixelnum=int64((corrd1(2)-corrd1(1))*1/3);
temp=linspace(0,1,pixelnum);
tempZeng=meshgrid(temp,1:width,1:3);
tempZeng=permute(tempZeng,[2 1 3]);
temp=linspace(1,0,pixelnum);
tempJian=meshgrid(temp,1:width,1:3);
tempJian=permute(tempJian,[2 1 3]);
for i=1:5-1
    newimg1(corrd1(i+1)-pixelnum+1:corrd1(i+1),:,:)=uint8(double(newimg13(corrd1(i+1)-pixelnum+1:corrd1(i+1),:,:)).*tempZeng+double(newimg15(corrd1(i+1)-pixelnum+1:corrd1(i+1),:,:)).*tempJian);
    newimg1(corrd1(i+1)+1:corrd1(i+1)+pixelnum,:,:)=uint8(double(newimg15(corrd1(i+1)+1:corrd1(i+1)+pixelnum,:,:)).*tempZeng+double(newimg13(corrd1(i+1)+1:corrd1(i+1)+pixelnum,:,:)).*tempJian);
end

newimg31=SquareHistogram(oldimg,3,1);
newimg51=SquareHistogram(oldimg,5,1);
%������ȥ����
[height width m]=size(oldimg);
corrd1=int64(linspace(1,height,5+1));
corrd2=int64(linspace(1,width,5+1));
newimg2=newimg51;
pixelnum=int64((corrd2(2)-corrd2(1))/3);
temp=linspace(0,1,pixelnum);
tempZeng=meshgrid(temp,1:height,1:3);
temp=linspace(1,0,pixelnum);
tempJian=meshgrid(temp,1:height,1:3);
for i=1:5-1
    newimg2(:,corrd2(i+1)-pixelnum+1:corrd2(i+1),:)=uint8(double(newimg31(:,corrd2(i+1)-pixelnum+1:corrd2(i+1),:)).*tempZeng+double(newimg51(:,corrd2(i+1)-pixelnum+1:corrd2(i+1),:)).*tempJian);
    newimg2(:,corrd2(i+1)+1:corrd2(i+1)+pixelnum,:)=uint8(double(newimg51(:,corrd2(i+1)+1:corrd2(i+1)+pixelnum,:)).*tempZeng+double(newimg31(:,corrd2(i+1)+1:corrd2(i+1)+pixelnum,:)).*tempJian);
end

newimg=uint8(double(newimg1)*0.33+double(newimg2)*0.33+double(SquareHistogram(oldimg,1,1)*0.34));
newimg=SquareHistogram(newimg,1,1);
end

%1.1�ֿ�ֱ��ͼ���⻯
function newimg=SquareHistogram(oldimg,xnum,ynum)
%xnumΪ����ָ������ynumΪ����ָ����
[height width m]=size(oldimg);
corrd1=int64(linspace(1,height,ynum+1));
corrd2=int64(linspace(1,width,xnum+1));
for i=1:ynum
    for j=1:xnum
        newimg(corrd1(i):corrd1(i+1),corrd2(j):corrd2(j+1),1)=Histogram(oldimg(corrd1(i):corrd1(i+1),corrd2(j):corrd2(j+1),1));
        newimg(corrd1(i):corrd1(i+1),corrd2(j):corrd2(j+1),2)=Histogram(oldimg(corrd1(i):corrd1(i+1),corrd2(j):corrd2(j+1),2));  
        newimg(corrd1(i):corrd1(i+1),corrd2(j):corrd2(j+1),3)=Histogram(oldimg(corrd1(i):corrd1(i+1),corrd2(j):corrd2(j+1),3));
    end
end

end

%1.2ֱ��ͼ���⻯
function newimg=Histogram(oldimg)
%��������ľ�Ϊ�Ҷ�ͼ
%���⻯����
MaxNum=double(max(max(oldimg))); 
[height width]=size(oldimg);
TotalNum=height*width;
hist=imhist(oldimg);
list(1)=hist(1);
for i=1:MaxNum
   list(i+1)=hist(i+1)+list(i); 
end
list=uint8(list*MaxNum/TotalNum);
newimg=list(oldimg+1);
%newimg=adapthisteq(oldimg);
end

%2��ͨ��������
function newimg=UseDarkCha(oldimg)
%��ͨ��darkimg(x)
%���λ��RGBͨ����Сֵ
[height width m]=size(oldimg);
minRGB=double(min(oldimg(:,:,1),min(oldimg(:,:,2),oldimg(:,:,3))));
%����15*15����Сֵ�˲�
darkimg=minfilt2(minRGB,[15,15]);
darkimg(height,width)=0;

%��A,tx��ֵ
threshold=uint8(max(max(darkimg))-(max(max(darkimg))-min(min(darkimg)))*0.001);
corrd=find(darkimg>=threshold);
oldimgR=double(oldimg(:,:,1));oldimgG=double(oldimg(:,:,2));oldimgB=double(oldimg(:,:,3));
A(1)=max(oldimgR(corrd));A(2)=max(oldimgG(corrd));A(3)=max(oldimgB(corrd));
temp1=oldimgR/A(1);temp2=oldimgG/A(2);temp3=oldimgB/A(3);
temp=double(min(temp1(:,:),min(temp2(:,:),temp3(:,:))));
temp=minfilt2(temp,[15,15]);
tx=1-0.95*temp;
tx(:,:)=max(0.1,tx(:,:));

%����A,txȥ��
%{
newimg_dfog(:,:,1)=(double(oldimg(:,:,1))-A(1))./tx+A(1);
newimg_dfog(:,:,2)=(double(oldimg(:,:,2))-A(2))./tx+A(2);
newimg_dfog(:,:,3)=(double(oldimg(:,:,3))-A(3))./tx+A(3);
%}

%��txʹ�õ����˲�,��ȥ��
tx=guidedfilter(double(rgb2gray(oldimg))/255,tx,15*4,eps);
newimg_dfog2(:,:,1)=(double(oldimg(:,:,1))-A(1))./tx+A(1);
newimg_dfog2(:,:,2)=(double(oldimg(:,:,2))-A(2))./tx+A(2);
newimg_dfog2(:,:,3)=(double(oldimg(:,:,3))-A(3))./tx+A(3);

%����ɫ��
newimg=uint8(newimg_dfog2);
newimg=UseHistogram(newimg);
end

%3Retinex������
function newimg=UseRetinex(oldimg)
newimg1=Retinex(oldimg,128);
newimg2=Retinex(oldimg,256);
newimg3=Retinex(oldimg,512);
newimg=uint8((newimg1+newimg2+newimg3)/3*255);
end

%3.1����cigmaֵ������ͨ������̬ͬ�˲�
function newimg=Retinex(oldimg,sigma)
[height,width,~]=size(oldimg);
 % �γɸ�˹�˲����� 
[X Y]=meshgrid(1:width,1:height);
F=exp(-((X-width/2).^2+(Y-height/2).^2)/(2*sigma*sigma));
F=F./(sum(F(:))); 
%�Ը�˹�˲��������ж�ά����Ҷ�任 
Ffft=fft2(double(F));

newR=Homofilter(oldimg(:,:,1),Ffft);
newG=Homofilter(oldimg(:,:,2),Ffft);
newB=Homofilter(oldimg(:,:,3),Ffft);

%�γ���ͼ��
newimg(:,:,1)=newR; 
newimg(:,:,2)=newG; 
newimg(:,:,3)=newB;
end

%3.2̬ͬ�˲�
function newimg=Homofilter(oldimg,F)
Fs=fftshift(fft2(double(oldimg)));  
newFs=Fs.*F; 
DR=real(ifft2(ifftshift(newFs)));
newR=exp(log(double(oldimg)+1)-log(double(DR)+1));  
% ����ǿ���ͼ����жԱȶ�������ǿ 
newR=(newR-min(min(newR)))/(max(max(newR))-min(min(newR))); 
newimg=adapthisteq(newR); 
end