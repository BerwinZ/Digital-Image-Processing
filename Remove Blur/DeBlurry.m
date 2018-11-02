clear
clc
img=imread('image.jpg');
subplot(2,2,1)
imshow(img)
title('ԭͼ')

%��ͼ���ֱ��ͼ
grayimg=rgb2gray(img);
[height width]=size(grayimg);     %����ͼ��ߴ����
for k=0:255
    GP(k+1)=length(find(grayimg==k))/(height*width);  %����ÿ���Ҷȳ��ֵĸ��ʣ��������GP����Ӧλ��
end
subplot(2,2,2)
bar(0:255,GP,'g')   %����GP��ͼ��
xlim([0 255])
title('ԭͼ��ֱ��ͼ')
xlabel('�Ҷ�ֵ')
ylabel('���ָ���')

%��ͼ����Ҷ�任
Fs(:,:,1:3)=fftshift(fft2(double(img(:,:,1:3))));

%���˹�˲�
%{
��ȷ����
k=0.0025 a=0.1
k=0.001  a=0.1,0.05
k=0.002 a=0.05
%}
k=0.0025;
a=0.07;
[height width m]=size(img);
for i=1:height     
    for j=1:width                 
        HG(i,j)=exp(-k*((i-double(height/2)+0.5)^2+(j-double(width/2)+0.5)^2)^(5/6));  
        if(HG(i,j)<=a)
            HG(i,j)=10^10;
        end
    end
end

%��Butterworth�˲� 
%{
D0=22 a=0.1
%}
D0=15;
a=0.1;
[height width m]=size(img);
for i=1:height     
    for j=1:width                 
        D=sqrt((i-double(height/2)+0.5)^2+(j-double(width/2)+0.5)^2);       
        HB(i,j)=1/(1+(sqrt(2)-1)*(D/D0)^2);
        if(HB(i,j)<=a)
            HB(i,j)=10^10;
        end
    end
end

%ԭͼ��ģ��
newFsG(:,:,1)=Fs(:,:,1)./HG;
newFsG(:,:,2)=Fs(:,:,2)./HG;
newFsG(:,:,3)=Fs(:,:,3)./HG;

newFsB(:,:,1)=Fs(:,:,1)./HB;
newFsB(:,:,2)=Fs(:,:,2)./HB;
newFsB(:,:,3)=Fs(:,:,3)./HB;

%������Ҷ�任
ffG(:,:,1:3)=real(ifft2(ifftshift(newFsG(:,:,1:3))));
ffB(:,:,1:3)=real(ifft2(ifftshift(newFsB(:,:,1:3))));

%��ʾͼƬ
newimgG=uint8(ffG);
subplot(2,2,3)
imshow(newimgG)
title('��Gaussian�˲�')
imwrite(newimgG,'Gaussian.jpg');

newimgB=uint8(ffB);
subplot(2,2,4)
imshow(newimgB)
title('��Butterworth�˲�')
imwrite(newimgB,'Butterworth.jpg');