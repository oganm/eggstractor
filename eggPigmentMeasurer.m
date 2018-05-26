function [SizeMean,IntensityMean,DispersionCenter,DispersionDeviation,ClutchNo]=eggPigmentMeasurer(egg)
[BWPigments,BackgroundBW,maxRow,numOfPixelsInEgg,HeightEgg]=pigmentFinder(egg.Obj,egg.Gray); %Gray-scale eggs and B&W egg silloutes are
%sent to the pigmentFinder(function-Line 56)
[L,number]=bwlabel(BWPigments); %Pigment image that is taken from pigmentFinder is labelled
sizeSpots=zeros(1,number); %An array is created by setting the length to the number of pigment spots (To hold th sizes)
intensitySpots=zeros(1,number); %An array is created by setting the length to the number of pigment spots (To hold the intensities)
distanceSpots=zeros(1,number); %An array is created by setting the length to the number of pigment spots (To hold the distances from bottom)
[row,~]=find(BackgroundBW); %X coordinates of the pixels in the background are found
SizeBackGround=size(row,1); %Total number of the pixels in the background are found by finding the size of the X-coordinate vector
SumOfBG=sum(sum(egg.Gray.*uint8(BackgroundBW))); %Sum of background of the egg is found by multiplying the binary background image with 
%Gray Scale egg image.
meanBG=SumOfBG/SizeBackGround; %Sum of the background is divided to total number of pixels in the background to find the mean of the 
%background of the egg (non pigmented egg area's mean)
for i=1:number %For loop is set to run `number of pigment spots` times
    pigmentSpot=L==i; %Pigment spots are taken 1by1 in every turn of the for loop.
    [r,c]=find(pigmentSpot); %Pixel locations of the spot is taken
    pixelsOfSpot=size(r,1);  %Number of pixels in the spot is calculated
    sizeSpots(i)=pixelsOfSpot; %Size of the spot is calculated and filled into the array 'sizeSpots' to hold all the spots' size values as for loop
    %moves through all the spots 1by1
    pixelValuesSpot=zeros(1,pixelsOfSpot); %An array is created by the size of the pigment spot.
    for j=1:pixelsOfSpot
        pixelValuesSpot(j)=egg.Gray(r(j),c(j)); %Then the array (pixelValuesSpot) is filled with the values of each pixel in the pigment spot
    end
    intensitySpots(i)=mean(pixelValuesSpot); %Mean of the array (pixelValuesSpot) is taken as spots intensity and placed in another array to hold 
    %all the spots' intensity values as for loop moves through all the spots 1by1
    Stats=regionprops(pigmentSpot,'Centroid'); %Center point of the pigment spot is found
    CenterOfSpot=Stats.Centroid;               %and taken into CenterOfSpot
    distanceSpots(i)=maxRow-CenterOfSpot(2); %Then the vertical distance of the spot from the bottom point of the egg is calculated
end
sizeSpotsScaled=sizeSpots./numOfPixelsInEgg; %Spots' sizes are scaled by dividing the sizes to the size of the egg.
sortedSize=sort(sizeSpotsScaled); %Scaled size values are sorted
if number>8 %Checks to find if there are more than 8 pigment spots in the egg or not.
    SizeMean=mean(sortedSize(number-7:number)); %If there are more than 8 largest 8 pigments size mean is taken 
    %as the mean of the egg pigmentation size
else
    SizeMean=mean(sizeSpotsScaled); %If there aren't more than 8 pigment spots  all the pigments are used to get the mean.
end
sizeSpotsNormal=sizeSpotsScaled/mean(sizeSpotsScaled); %Spot sizes are normalized by dividing all of them to the mean of all of them.
intensitySpotsScaled=(meanBG-intensitySpots).*sizeSpotsNormal; %Spot intensities are calculated by substracting their previously measured darkness 
%values from the mean of the background of the egg and by multiplying this result with their sizes to make larger pigments more weighted
intensitySpotsNormal=intensitySpots/mean(intensitySpots); % Intensity values are normalized by dividing all of the to the mean of all of them
sortedIntensity=sort(intensitySpotsScaled); %Intensity values are sorted
if number>8 %Checks to find if there are more than 8 pigment spots in the egg or not. 
    IntensityMean=mean(sortedIntensity(number-7:number)); %If there are more than 8 largest 8 pigments size mean is taken 
    %as the mean of the egg pigmentation size
else
    IntensityMean=mean(intensitySpotsScaled); %If there aren't more than 8 pigment spots  all the pigments are used to get the mean.                       
end
dispersionCoefficient=distanceSpots.*sizeSpotsNormal.*intensitySpotsNormal; %Spots' distaces from the bottom of the egg are multiplyed individually
%with their sizes and intensities. This is done to calculate the dispersion later in the program and to give more weight to the larger and more
%intense spots
effectCoefficent=sizeSpotsNormal.*intensitySpotsNormal; %Individual sizes of the spots are multiplied with individual intensities
DispersionCenter=(sum(dispersionCoefficient)/sum(effectCoefficent))/(HeightEgg*8+1); %Center of dispersion is calculated by using a formula that is
%used to calculate the center of mass. Volume is changed with size and density with intensity. Resulting number is divided to the Height of the
%egg times 8 (result a number between 0-8) and 1 is added to make it between 1 and 9 
%(this will b eused to calculate the Dispersion Deviation -the real dispersion- )
DispersionShrinked=zeros(1,5); %A matrix is created to hold the intensity*size values of the spots, which are located in 1 of the 9 area of the egg.
Zones=[1,2,3,4,5]; %5 zones are set
AreaSlices=zeros(1,5); %5 Slices are set
Stats1=regionprops(egg.Obj,'Image'); %Bounding box of the BWImage is taken
[SizeX,~]=size(Stats1.Image); %Height of the egg is found
for i=1:5
    AreaSlices(i)=sum(sum((Stats1.Image(ceil(SizeX-SizeX/5*(i)+1):ceil(SizeX-SizeX/5*(i-1)),:)))); %Each slice (1/5th of the egg) is filled with the
    %intensity*size values of the pigments that are in the slice.
end
for i=1:number %For loop is set to run `number of pigment spots` times
    for j=1:5 %For loop is set to run 5 times to check all of the 9 zones of the egg
        if distanceSpots(i)>(j-1)*HeightEgg/5 && distanceSpots(i)<=j*HeightEgg/5 %Checks the distances of the pigments spots and
            DispersionShrinked(j)=DispersionShrinked(j)+effectCoefficent(i);    %adds them into the proper zone of the egg
            %after this loop is finished we will have a vector that has 9
            %values in it. 1st number in this vector will be the total
            %size*intensity values of the spots that are located closest (0<x<HeightEgg*1/5) to
            %the bottom and 9th will be the total for the spots that are
            %farthest (HeightEgg*4/5<x<HeightEgg*5/5) from the bottom.
        end
    end
end
DispersionSliceNormalized=DispersionShrinked./AreaSlices; %5Zones are divided to the area of the egg that is in that zone to normalize it
DispersionSliceMean=sum(DispersionSliceNormalized.*[1,2,3,4,5])/sum(DispersionSliceNormalized); %Mean of the vector is taken to calculate dispersion
DispersionDeviation=(sum((Zones-DispersionSliceMean).^2.*DispersionSliceNormalized)/sum(DispersionSliceNormalized));
%Standard deviation is calculated by using the values in the vector
%'DispersionShrinked' as sample size and the Zone numbers as the mean
%distance of this sample size's from the bottom of the egg. This give a
%result that includes Size and Intensity to the dispersion too.
if DispersionDeviation>2 %The deviation result is linearized according to the number of clutch
    DispersionDeviation=4-DispersionDeviation;
    ClutchNo=2;
elseif DispersionDeviation<2
    ClutchNo=1;
else
    ClutchNo=0;
end
if number<3 %If there are less than 3 pigment spots (highly likely an error) everything is equalized to zero.
    SizeMean=0;
    IntensityMean=0;
    DispersionCenter=0;
    DispersionDeviation=0;
    ClutchNo=0;
end
end
function [BWPigments,BackgroundBW,maxRow,numOfPixelsInEgg,HeightEgg]=pigmentFinder(Obj,Gray)
egg.Obj=Obj;  %Egg structure's Obj variable is equalized to Obj(BW egg silloute)
egg.Gray=Gray;%Egg structure's Gray variable is equalized to Gray(gray-scale egg image)
[SizeX,SizeY]=size(egg.Obj); %Sizes of the image is taken
[r,c]=find(egg.Obj); %White pixels' (egg silloute) locations are found
numOfPixelsInEgg=size(r,1); %Total number of pixels are found
MeanOfEgg=eggMean(egg.Obj,egg.Gray,numOfPixelsInEgg); %Gray-scale eggs, B&W egg silloutes and Number of Pixels in the egg are sent to the 
%eggMean(function-Line 116)
PastingSurface=uint8(zeros(SizeX,SizeY)+MeanOfEgg); %A gray-scale surface that has an equal size with the egg image is created and filled 
%with egg's mean
PastingSurfaceBW=im2bw(uint8(zeros(SizeX,SizeY))); %A binary surface that has an equal size with the egg image is created.
for i=1:numOfPixelsInEgg %For loop is set to run `number of pixels in egg` times
    PastingSurface(r(i),c(i))=egg.Gray(r(i),c(i)); %For every turn, a pixel is copied from Gray egg image to previously created pasting 
    %surface to get a uniform background 
end
for j=1:numOfPixelsInEgg%For loop is set to run `number of pixels in egg` times
    window=[r(j)-20,r(j)+20,c(j)-20,c(j)+20]; %A 41*41 pixel window is created
    if window(1)<=0      %Created 41*41pixel window is checked to prevent it from 'trespassing' the boundaries of the image
        window(1)=1;     %Checks to see if window is reaching to the left border of the image and if it does, cuts it from left.
    end                  %
    if window(2)>SizeX   %Checks to see if window is reaching to the right border of the image and if it does, cuts it from right.
        window(2)=SizeX; %
    end                  %
    if window(3)<=0      %Checks to see if window is reaching to the upper border of the image and if it does, cuts it from up.
        window(3)=1;     %
    end                  %
    if window(4)>SizeY   %Checks to see if window is reaching to the bottom border of the image and if it does, cuts it from bottom.
        window(4)=SizeY; %
    end
    meanBox=mean(mean((PastingSurface((window(1):window(2)),(window(3):window(4)))))); %Box's mean is calculated
    if PastingSurface(r(j),c(j))>(meanBox-8) %The pixel in the middle is compared against the mean of the box and if it is brighter than the
        PastingSurfaceBW(r(j),c(j))=0; %mean of the box by 8, corresponding pixel in the BW Surface is set to 0
    else
        PastingSurfaceBW(r(j),c(j))=1; %if it is darker the pixel is set to 0
    end 
    %After scanning all the egg, dark areas(pigments) were set as white.
end
boundariesCell=bwboundaries(egg.Obj); %Boundary pixels of the BW egg are found
boundariesMatrix=boundariesCell{1}; %The resulting cell array is turned into a matrix.
for j=1:size(boundariesMatrix,1)%For loop is set to run `number of pixels in bordary` times
    windowB=[r(j)-5,r(j)+5,c(j)-5,c(j)+5];%A 11*11 pixel window is created
    if windowB(1)<=0     %Created 11*11pixel window is checked to prevent it from 'trespassing' the boundaries of the image
        windowB(1)=1;    %Checks to see if window is reaching to the left border of the image and if it does, cuts it from left.
    end
    if windowB(2)>SizeX
        windowB(2)=SizeX;%Checks to see if window is reaching to the right border of the image and if it does, cuts it from right.
    end
    if windowB(3)<=0     %Checks to see if window is reaching to the upper border of the image and if it does, cuts it from up.
        windowB(3)=1;
    end
    if windowB(4)>SizeY  %Checks to see if window is reaching to the bottom border of the image and if it does, cuts it from bottom.
        windowB(4)=SizeY;
    end
        PastingSurface((windowB(1):windowB(2)),(windowB(3):windowB(4)))=0; %The window is travelled along the border and the area is
        %set to 0(black) to erase the pigments at the border since they are
        %likely to be caused by fotographing and cutting processes
end
PastingSurfaceBW=bwmorph(PastingSurfaceBW,'close','bridge'); %NEwly found pigment areas are morphologically closed and possible little gaps 
%within pigment spots are filled via bridge method
PastingSurfaceBW=imfill(PastingSurfaceBW,'holes'); %Holes within pigment spots that might be caused by window operation are filled                                  
maxRow=max(r); %Highest point of the egg is taken
minRow=min(r); %Lowest point of the egg is taken
HeightEgg=maxRow-minRow; %Height of the egg is calculated
BWPigments=bwareaopen(PastingSurfaceBW,36); %Possible noise is erased by area open. !!!!!!!!
BackgroundBW=egg.Obj-PastingSurfaceBW; %B&W background of the egg is taken by substracting pigment image from egg silloute image. This gave
%an image that has black spots in the white egg silloute (non pigmented egg areas are white)
end
function [MeanOfEgg]=eggMean(eggObj,eggGray,numOfPixelsInEgg)
SumOfEgg=sum(sum(eggGray.*uint8(eggObj))); %Total intensity of the egg is taken by multiplying binary image with the gray-scale image
MeanOfEgg=SumOfEgg/numOfPixelsInEgg; %Total intensity is divided by total number to get the mean of the egg
end