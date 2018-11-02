%1����ͼ��
clear
clc
img=imread('hw2.jpg');
[m,n]=size(img);     %����ͼ��ߴ����
GP=zeros(1,256);     %Ԥ������ŻҶȳ��ָ��ʵ�����
figure(1)
subplot(2,3,1)
imshow(img)
title('ԭͼ��')

%2��ͼ���ֱ��ͼ
for k=0:255
    GP(k+1)=length(find(img==k))/(m*n);  %����ÿ���Ҷȳ��ֵĸ��ʣ��������GP����Ӧλ��
end
figure(1)
subplot(2,3,2)
bar(0:255,GP,'g')   %����GP��ͼ��
xlim([0 255])
title('ԭͼ��ֱ��ͼ')
xlabel('�Ҷ�ֵ')
ylabel('���ָ���')

%3���⻯����
MaxNum=255;          %=find(GP==max(GP));   %�ҵ����ĻҶ�ֵ
TotalNum=m*n;
for i=0:255
    list(i+1)=uint8(length(find(img<=i))*MaxNum/TotalNum);
end
for i=1:m
    for j=1:n
        img_JH(i,j)=list(img(i,j)+1);
    end
end
figure(1)
subplot(2,3,4)
imshow(img_JH)
title('���⻯ͼ��')

%4���Ȼ�֮�������
for k=0:255
    JH(k+1)=length(find(img_JH==k))/(m*n); %����ÿ���Ҷȳ��ֵĸ��ʣ��������GP����Ӧλ��
end
figure(1)
subplot(2,3,5)
bar(0:255,JH,'g')   %���Ƶ�ͼ��
xlim([0 255])
title('���⻯ֱ��ͼ')
xlabel('�Ҷ�ֵ')
ylabel('���ָ���')

%5�ۻ��ֲ�����
for k=0:255
    temp=0;
    for i=0:k
        temp=temp+JH(i+1);
    end
    LJ(k+1)=temp;
end
figure(1)
subplot(2,3,6)
bar(0:255,LJ,'g')
xlim([0 255])
ylim([0 1])
title('�ۻ��ֲ�����')

%6������ǿ
white(1:m,1:n)=255;
a=1.5;
img_light=uint8(uint8((1-a)*white)+a*img_JH);
figure(2)
subplot(1,2,1)
imshow(img_light)
title('������ǿͼ��')
xlabel('a=1.5')

%7��תͼ��
for i=1:m
    for j=1:n
        img_FZ(i,j)=255-img_JH(i,j);
    end
end
figure(2)
subplot(1,2,2)
imshow(img_FZ)
title('��תͼ')