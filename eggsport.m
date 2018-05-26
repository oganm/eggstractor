function [eggs,scale]=eggsport(varargin)
%EGGSPORT Exports egg pictures from an image
%   {scale, egg1, egg2...}
%   =eggsport(image,scaleSize)
%   =eggsport(image,scaleSize,backgroundColor)
%   =eggsport(image,scaleSize,gridRow,gridCol)
%   =eggsport(image,scaleSize,gridRow,gridCol,backroungColor)
%   =eggsport(image,scaleSize,gridRow,gridCol,backroungColor,treshold)
%   default grid is 3, 4
%   default backgroundColor is white, it can also be red, blue, green or
%   black
%   color choice is made based on the one tht contrasts the most with the
%   egg

%placing of inputs. 'for' is just there to make it collapsable
for t=1
switch nargin
    case 2  %setting the variables based on the inputs.
        im=varargin{1};
        scaleSize=varargin{2};
        backgroundColor='white';
        gridRow=3;
        gridCol=4;
        treshold=0.5;
    case 3
        im=varargin{1};
        scaleSize=varargin{2};
        backgroundColor=varargin{3};
        gridRow=3;
        gridCol=4;
        treshold=0.5;
        
    case 4
        im=varargin{1};
        scaleSize=varargin{2};
        gridRow=varargin{3};
        gridCol=varargin{4};
        backgroundColor='white';
        treshold=0.5;
    case 5
        im=varargin{1};
        scaleSize=varargin{2};
        backgroundColor=varargin{5};
        gridRow=varargin{3};
        gridCol=varargin{4};
        treshold=0.5;
    case 6
        im=varargin{1};
        scaleSize=varargin{2};
        backgroundColor=varargin{5};
        gridRow=varargin{3};
        gridCol=varargin{4};   
        treshold=varargin{6};
end
end 

%taking image based on background color if background is red blue or green,
%only those channels will be taken into consideration
%UNTESTED FOR ANY OTHER BUT WHITE
switch backgroundColor
    case {'Green','GREEN','green'}
        im=im(:,:,2);
    case {'RED','red','Red'}
        im=im(:,:,1);
    case {'BLUE','blue','Blue'}
        im=im(:,:,3);
    case {'WHITE','White','white'}
        im=rgb2gray(im);
    case {'BLACK','Black','black'}
        im=imcomplement(im);
        
    otherwise
        error('what kind of color is that? only red blue green black and white is allowed')
end


imBW=im2bw(im,treshold);
%imtool(imBW)
imWB=imcomplement(imBW);
imWB=bwmorph(imWB,'close',Inf);
imWB=bwmorph(imWB,'diag',Inf);

%following lines will remove border objects caused by uneven background.
%few pixels are removed from the edges because border objects are seperated
%by few lines of 0s.
[r,c]=size(imWB);
imWB=imWB(3:r-3,3:c-3);
im=im(3:r-3,3:c-3); %the same is done to im to prevent errors in pigmentation
imWB=imclearborder(imWB);
imWB=imfill(imWB,'holes');
%cleaning of remaining artifacts including the timestamp.
treshold=floor(2.5019e-004*r*c);
imWB=bwareaopen(imWB,treshold); %removal size treashold depends on the overall size of the image optimized by trial and error (aka. not optimized but seems to work for now)
%imtool(imWB)
[L,number]=bwlabel(imWB);
eggs=cell(1,number-1); %preallocate output


%determining scale of image
obj=L==1;
%scaleProps=regionprops(obj,'Orientation','Image','Area');
scale=regionprops(obj,'Area','Centroid');
% obj=L==number;
% scale2=regionprops(obj,'Centroid');
% distance=sqrt((scale.Centroid(1)-scale2.Centroid(1))^2+(scale.Centroid(1)-scale.Centroid(2))^2);

scale=sqrt(scale.Area/scaleSize);

%number=number-1;
%scale=distance/scaleSize;


%rotation of scale object
%imtool(scaleProps.Image)

% if scaleProps.Orientation>=0
%     scale=imrotate(scaleProps.Image,-90-scaleProps.Orientation);
% end
% if scaleProps.Orientation<0
%     scale=imrotate(scaleProps.Image,90-scaleProps.Orientation);
% end
% 
% scale=regionprops(scale,'Image');



%imtool(scale.Image)
%scale=length(scale.Image)/scaleSize; %scale output pixel/cm

%exporting individual eggs
eggs=cell(1,number-1);
for t=2:number
    obj=L==t;
    objProps=regionprops(obj,'Orientation','Image','Centroid','BoundingBox','Area');
    
    %taking grayscale image for pigmentation
    box=objProps.BoundingBox;
    gray=im(ceil(box(2)):floor(box(2)+box(4)),ceil(box(1)):floor(box(1)+box(3)));
    
%     %removing small objects as blank spaces
%     if objProps.Area<r*c*0.0020
%     obj=NaN;
%     end

    
    %rotation rotation rotation. islogical seperates NaNs
    if (islogical(obj)) && objProps.Orientation>=0
        obj=imrotate(objProps.Image,90-objProps.Orientation);
        gray=imrotate(gray,90-objProps.Orientation);
    end
    if (islogical(obj))&& objProps.Orientation<0
        obj=imrotate(objProps.Image,-90-objProps.Orientation);
        gray=imrotate(gray,-90-objProps.Orientation);
    end
    
    %saving to temporary cell to be sorted
    eggs{t-1}.Obj=obj;
    eggs{t-1}.Gray=gray;
    eggs{t-1}.Centroid=objProps.Centroid;
    eggs{t-1}.Area=objProps.Area;
     
end

%if blank marker is not placed
%NOT TESTED
if length(eggs)<gridCol*gridRow
    for t=length(eggs)+1:gridCol*gridRow
        eggs{t}.Obj=NaN;
        eggs{t}.Centroid(1)=c;
        eggs{t}.Centroid(2)=r;
        eggs{t}.Area=1;
    end
end

%SORTING OF OBJECTS
xs=zeros(1,length(eggs));
ys=zeros(1,length(eggs));
sortedEggs=cell(1,length(eggs));
for t=1:length(eggs)
    xs(t)=eggs{t}.Centroid(1);
    ys(t)=eggs{t}.Centroid(2);
end
[sortedY,index]=sort(ys);
%sort by Y coordinate
sortedX=xs(index);
for t=1:length(eggs)
    sortedByY{t}=eggs{index(t)};
end
%sort completely
for t=1:gridRow
    [temp,index]=sort(sortedX((t-1)*gridCol+1:t*gridCol));
    for n=1:gridCol
        sortedEggs{(t-1)*gridCol+n}=sortedByY{(t-1)*gridCol+index(n)};
    end  
end

%place eggs to output
areas=zeros(1,length(sortedEggs));
for t=1:length(sortedEggs)
    areas(t)=eggs{t}.Area;
    eggs{t}=sortedEggs{t};
    
end

%remove eggs based on their proportion
largestA=max(areas);
for t=1:length(sortedEggs)
    if eggs{t}.Area/largestA<0.30
        eggs{t}.Obj=NaN;
    end
end


end %end of eggsport
