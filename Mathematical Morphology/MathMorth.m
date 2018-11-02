clear;
clc;
oldimg=imread('figure.jpg');

%ȥ��˹����
imgdguass=wiener2(oldimg,[10 10]);
%ȥ��������
[height width]=size(oldimg);
Hsize=min(height,width);
Hfre=100;
HGrad=fspecial('Gaussian',[Hsize Hsize],Hfre);
gradnoise=imfilter(imgdguass,HGrad);
%ȥ����������
imgdgrad=imgdguass-0.5*gradnoise;
%��ֵ�ָ�
midgray=59;
thresimg=double(imgdgrad);
thresimg(thresimg<midgray)=0;
thresimg(thresimg>0)=1;
thresimg=1-thresimg;
%��ʴ��ֵ�ָ�ͼ
[height width]=size(oldimg);
signimg=thresimg;
se=strel('disk',4);
signimg(:,1:width/2)=imerode(thresimg(:,1:width/2),se);
%���͹�����ģ
se=strel('disk',4);
signimg(1:height/2,1:width/2)=imdilate(signimg(1:height/2,1:width/2),se);
se=strel('disk',1);
signimg=imdilate(signimg,se);
%������ͼ��
newimg=uint8(signimg.*double(imgdguass)+(1-signimg)*1.5*sum(sum(gradnoise))/(Hsize*Hsize));

figure
subplot(221);imshow(oldimg);title('ԭͼ');
subplot(222);imshow(imgdguass);title('ȥ��˹����');
subplot(223);imshow(gradnoise);title('��������');
subplot(224);imshow(imgdgrad);title('ȥ��������');

figure
subplot(221);imshow(thresimg);title('��ֵ�ָ�');
subplot(222);imshow(signimg);title('��ʴ+����');
subplot(223);imshow(oldimg);title('ԭͼ');
subplot(224);imshow(newimg);title('��ͼ');
imwrite(newimg,'new.jpg');

%��ȡ��ͨ������
se=strel('square',3);
area=signimg*0;
point=find(signimg==1&area==0);
num=0;
while(~isempty(point))
    [pointx pointy]=ind2sub(size(signimg),min(point));
    area(pointx,pointy)=1;
    newarea=double(imdilate(area,se)&signimg);
    while(~isequal(area,newarea))
        area=newarea;
        newarea=imdilate(area,se)&signimg;
    end
    point=find(signimg==1&area==0);
    num=num+1;
    %figure;imshow(area);
end
num
