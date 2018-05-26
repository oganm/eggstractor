function [ A,c0,c1,c2,c3 ] = eggShape( egg,scale )

im=egg.Obj;

 %rotate the egg sideways to place on cartesian surface
    im=imrotate(im,90);
    [row, A]=size(im);
    A=A/2;
    %take half of the image, turn the upper half upside down

    imHalf1=flipdim(im(floor(1:row/2),:),1);
    imHalf2=im(floor(row/2:row),:);
    boundary1=bwboundaries(imHalf1);
    boundary2=bwboundaries(imHalf2);
    %I hate cells
    boundary1=boundary1{1};
    boundary2=boundary2{1};
    
    %remove top line from the data points
    clear topLine1
    clear topLine2
z=0;
for t=1:length(boundary1)
    if boundary1(t,1)==1
        z=z+1;
        topLine1(z)=t;
    end
end
boundary1(topLine1,:)=[];
z=0;
for t=1:length(boundary2)
    if boundary2(t,1)==1
        z=z+1;
        topLine2(z)=t;
    end
end
boundary2(topLine2,:)=[];

%places the egg in its rightfull place in the middle of the coordinate
%system
correction=median(1:2*A);
x1=boundary1(:,2)-correction;
x2=boundary2(:,2)-correction;
y1=boundary1(:,1);
y2=boundary2(:,1);

%fitting operation
sA=num2str(A);
sAx=strcat('(x/',sA,')');
sFunc=strcat('sqrt(',sA,'^2-x^2)*(A+B*',sAx,'+C*',sAx,'^2+D*',sAx,'^3)');
fun=fittype(sFunc);
xCum=[x1;x2];
yCum=[y1;y2];
fitobject=fit(xCum,yCum,fun,'StartPoint',[0.7,0.12,-0.04,0]);

c0=fitobject.A;
c1=fitobject.B;
c2=fitobject.C;
c3=fitobject.D;
A=A/scale;

end

