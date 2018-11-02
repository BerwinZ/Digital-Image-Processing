clear
clc
img=imread('HW3.jpg');
subplot(2,2,1)
imshow(img)
title('ԭͼ')


%��ά����Ҷ�任
%{
��ʵ��fftshift�Ĺ���
[height width]=size(img);
[X Y]=meshgrid(1:width,1:height);
X=int64(X);
Y=int64(Y);
tempimg=int64(img).*(-1).^(X+Y);
Fs=fft2(double(tempimg));
%}
Fs=fftshift(fft2(double(img)));

%SΪƵ��ͼ
S=255*mat2gray(abs(Fs));
subplot(2,2,2)
imshow(S)
title('Ƶ��ͼ')

%Ƶ���˲���
%1�Ĳ��ֱ�����0�Ĳ��ֱ���ȥ
[height width]=size(S);
lvbo(1:height,1:width)=1;
for i=1:height/2
    for j=1:width/2
        tempX=j-width/2;
        tempY=height/2-i;
        
        %�ڶ�����ƽ��Ƶ�����᷽���˲�,ԭͼ�������
        k1=10;
        k2=6;
        if(tempY>double(height/2/(width/k1)*-1)*tempX||tempY<double(height/2/k2/(width/2)*-1)*tempX)
            lvbo(i,j)=0;
        end
    end
end
%��������Գ�
lvbo(:,width/2+1:end)=lvbo(:,width/2:-1:1);
%���ں���Գ�
lvbo(height/2+1:end,:)=lvbo(height/2:-1:1,:);

%Ƶ��ͼ�����˲���
S=S.*lvbo;
subplot(2,2,4)
imshow(S)
title('�˲���Ƶ��ͼ')
%����Ҷ�任�����˲���
Fs=Fs.*lvbo;

%��ά����Ҷ���任
ff=real(ifft2(ifftshift(Fs)));
newimg=uint8(ff);
subplot(2,2,3)
imshow(newimg)
title('�˲���ͼ��')
imwrite(newimg,'newimg.bmp');