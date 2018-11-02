function Seed(mode)
img=imread('hw8.tif');
imshow(img);
img=double(img);

%xΪ����߾��룬yΪ���ϱ߾���
[xDis,yDis]=ginput(3);
sign1=SeedGrow([int64(yDis(1)) int64(xDis(1))],img,7,mode);
sign2=SeedGrow([int64(yDis(2)) int64(xDis(2))],img.*(1-sign1),90,mode);
sign3=SeedGrow([int64(yDis(3)) int64(xDis(3))],img.*(1-sign1),90,mode);

se=strel('square',3);
sign1=imdilate(sign1,se);sign2=imdilate(sign2,se);sign3=imdilate(sign3,se);
subplot(221);imshow(uint8(img));title('ԭͼ');
subplot(222);imshow(uint8(img.*sign1));title('����');
subplot(223);imshow(uint8(img.*sign2));title('���ĳ�1');
subplot(224);imshow(uint8(img.*sign3));title('���ĳ�2');

imwrite(uint8(img.*sign1),'����.jpg');
imwrite(uint8(img.*sign2),'���ĳ�1.jpg');
imwrite(uint8(img.*sign3),'���ĳ�2.jpg');
end

%��һ�����������ֵ,������������������
function newsign=SeedGrow(corrd,img,T,mode)
sign=zeros(size(img));
sign(corrd(1),corrd(2))=1;
pointNum=1;                            %��ͨ���е�ĸ���
areaValue=img(corrd(1),corrd(2));      %��ͨ��ĻҶ�ƽ��ֵ
flag=1;
while(flag==1)
    se=strel('square',3);
    newsign=imdilate(sign,se);
    neiberArea=find((newsign-sign)==1);             %��������������
   
    %������ͨ���������ľ���
    for i=1:size(neiberArea,1)
       distance(i)=abs(areaValue-img(neiberArea(i))); 
    end

    %��distance���ҵ���������ĵ�
    %���µĵ���뵽��ͨ����
    newPoints=find(distance<T);
    if(size(newPoints,2)==0)
        flag=0;
    else
        total=0;
        for i=1:size(newPoints,2)
            sign(neiberArea(newPoints(i)))=1;
            total=total+img(neiberArea(newPoints(i)));
        end
        areaValue=(areaValue*pointNum+total)/(pointNum+size(newPoints,2)); 
        pointNum=pointNum+size(newPoints,2);
        clear distance;
        if(mode==1)
            imshow(sign);
        end
    end
end
newsign=sign;
end