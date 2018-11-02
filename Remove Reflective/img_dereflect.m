%{
��������Ϊȥ���⣬���÷�ʽΪnewimg=img_dereflect(filename)

��42 �Ų��� 2014011455
%}

%-------------------------
%������
%--------------------------
function newimg=img_dereflect(filename)
%����ͼ��
oldimg=imread(filename);
grayimg=rgb2gray(oldimg);
%ȡ��ģ ����Ϊ0������Ϊ1
mask=getmask(grayimg,1,100);

%̬ͬ�˲�ȡ����ͼ
Fs=fftshift(fft2(log(double(grayimg))));
H=GuassianL(Fs,10);
newFs=Fs.*H;
lightimg=real(ifft2(ifftshift(newFs)));

%ԭͼ��ȥ����ͼ
lightimg=extend(log(double(0.7*grayimg)),lightimg);
imgdlight=log(double(grayimg))-double(lightimg);
imgdlight=exp(imgdlight);
imgextend=uint8(extend(grayimg,imgdlight));

%Ϊ�����������ʵ�ֵ
newgray=adjustcolor(grayimg,imgextend,mask);

%�ɻҶ�ͼ��������RGBͼ
newimg=getRGB(oldimg,newgray);

%RGBͼȡ��ģ
newimg(:,:,1)=newimg(:,:,1).*(1-uint8(mask(:,:)));
newimg(:,:,2)=newimg(:,:,2).*(1-uint8(mask(:,:)));
newimg(:,:,3)=newimg(:,:,3).*(1-uint8(mask(:,:)));
end

%%
%-------------------------
%��������
%--------------------------
%1��˹��ͨ�˲���
function H=GuassianL(img,D0)
[height width]=size(img);
[X Y]=meshgrid(1:width,1:height);
D=(Y-double(height)/2).^2+(X-double(width)/2).^2;
H=exp(-1*D/(2*D0^2));
end

%2ȡ��������ģ
function ym=getmask(img,low,high)
%����Ϊ1�� ����Ϊ0��
%��ģ����ȡ��ģ
Fs=fftshift(fft2(img));
H=GuassianL(Fs,40);
newFs=Fs.*H;
newimg=real(ifft2(ifftshift(newFs)));
%�γ���ģ
square=divide(newimg,low,high);
square=fillblack(square);
ym=square;
end

%2.1��ֵ�ָ�
function H=divide(img,a,b)
%����Ϊ1�� ����Ϊ0��
[height width]=size(img);
k1=uint8(ceil(a-double(img)));
k2=uint8(ceil(double(img)-b));
H=k1|k2;
end

%2.2���ģ�м�İ�ɫ����
function ymnew=fillblack(ymold)
%ȥ���Ľ�,���ĽǱ��
ymnew=ymold;
[height width]=size(ymold);
ymnew(1:height,1:int64(width/10))=1;
ymnew(1:height,int64(9*width/10):width)=1;

allblack=find(ymnew==0);
[x y]=ind2sub(size(ymold),allblack);
minx=min(x);
maxx=max(x);
miny=min(y);
maxy=max(y);
middley=(maxy+miny)/2;

for i=minx+1:maxx
    for j=miny+1:middley
        if(ymnew(i,j)==1)
            if(ymnew(i-1,j)==0&&ymnew(i,j-1)==0)
                ymnew(i,j)=0;
            end
        end
    end
end

for i=minx+1:maxx
    for j=maxy-1:-1:middley
        if(ymnew(i,j)==1)
            if(ymnew(i-1,j)==0&&ymnew(i,j+1)==0)
                ymnew(i,j)=0;
            end
        end
    end
end
end

%3������ɫ
function newimg=adjustcolor(oldgray,newgray,mask)
%��������RGB��Ϊ255
[height width]=size(oldgray);

oldgraymask=oldgray.*(uint8(244)*uint8(mask)+uint8(1));
%ȡ������ɫ
clr=0;
num=0;
for k=10:100
    temp=length(find(oldgraymask==k));  %����ÿ���Ҷȳ��ֵĸ���
    num=num+temp;
    clr=clr+k*temp;
end
clr=double(clr)/num;
noisy=rand(height,width);

%ȡ��������
contour=getcontour(oldgray);
%ȡ����������
imgsquare=newgray.*(uint8(244)*uint8(mask)+uint8(1));
highlight=gethighlight(imgsquare);
%��������ֱ仯
vary=30;
colorchange=uint8(ceil(abs(double(oldgray)-double(newgray))-vary));
%��ǿ�ҷ������⣬�����ಿ���ԻҶ�ͼ��ֵ
%ǿ������Ϊclr+noisy
k1=(1-mask)&(colorchange)&(1-contour)&(highlight);
newimg=double(k1).*(clr+(double(noisy)-0.5)*10)+double(~k1).*double(oldgray);
end

%3.1ȡ���⼯�в���
function highlight=gethighlight(grayimg)
%1Ϊ����ǿ������
%ģ������ʹ��ɢ�Ĺ��������˵������¼��еķ�����
Fs=fftshift(fft2(grayimg));
H=GuassianL(Fs,10);
newFs=Fs.*H;
imgsquare=uint8(real(ifft2(ifftshift(newFs))));
highlight=divide(imgsquare,30,225);     %60
end

%3.2ȡ��������
function contour=getcontour(grayimg)
%1������Ϊ����
%��ͨ�˲�
Fs=fftshift(fft2(grayimg));
H=1-GuassianL(Fs,80);
newFs=Fs.*H;
lunkuo=real(ifft2(ifftshift(newFs)));
lunkuo=uint8(extend(grayimg,lunkuo));

%��ԭ����ȿ���Щ���ֱ仯С���仯С�ļ�Ϊ����
vary=40;
[height width]=size(grayimg);
H=uint8(ceil(vary-abs(double(lunkuo)-double(grayimg))));
contour=H&1;
end

%4�仯ȡֵ��Χ
function newimg=extend(standard,oldimg)
maxold=double(max(max(oldimg)));
minold=double(min(min(oldimg)));
maxstd=double(max(max(standard)));
minstd=double(min(min(standard)));
newimg=(double(oldimg)-minold)*(maxstd-minstd)/(maxold-minold)+minstd;
end

%5��ȡ���յ�RGBͼ
function newimg=getRGB(oldimg,newgray)
grayimg=rgb2gray(oldimg);

%�Ҷ�ͼֱ��ת��RGB
newimg1=gray2rgb(newgray,oldimg);

%ͨ��hsvͨ��ת��
hsvimg=rgb2hsv(oldimg);
newhsv=extend(hsvimg(:,:,3),newgray);
hsvimg(:,:,3)=newhsv;
newimg2=hsv2rgb(hsvimg);

%����ȡƽ��
newimg3=uint8((double(newimg1)+double(newimg2))/2);
newimg=newimg3;
end

%5.1�Ҷ�ͼתRGB
function newrgb=gray2rgb(newgray,oldrgb)
oldgray=rgb2gray(oldrgb);
[height width]=size(newgray);
k=double(newgray)./double(oldgray);
newrgb(:,:,1)=uint8(double(oldrgb(:,:,1)).*k);
newrgb(:,:,2)=uint8(double(oldrgb(:,:,2)).*k);
newrgb(:,:,3)=uint8(double(oldrgb(:,:,3)).*k);
end