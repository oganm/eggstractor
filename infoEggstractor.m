function infoEggstractor
%main function

%log file is created
logID=fopen('log.txt','w');
fprintf(logID,'\n%s\n',strcat('#####',date,'######'));

output=EggGUI; %take input from gui
%GUI output
%.treshold                  2D list r2=treshold values
%.checkArea                 1,0
%.checkUseDef               1,0
%.checkAreaBridge           1,0
%.checkSize                 1,0
%.checkPigmen               1,0
%.checkIndiv.true           1,0
%.checkIndiv.imageOutput    string
%.checkIndiv.scaleBy        'height' 'width' 'no'
%.checkIndiv.outputScale    str2double(string)
%.inputLocation             string
%.outputLocation            string
%.scaleSize                 str2double(string)
%.nanProxy                  string
%.nameFormat                string
%.rows                      str2double(string)
%.collumns                  str2double(string)
%.backgroundColor           string 'white' 'black' 'red' 'blue' 'green'

fprintf(logID,'%s\n',strcat('target location:',output.inputLocation));

%loading bar is created
bar=waitbar(0,'Initializing');
set(bar,'Name','Eggstractor');
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(bar,'javaframe');
jIcon=javax.swing.ImageIcon('smallEggstractor.png');
jframe.setFigureIcon(jIcon);




output.inputLocation=strcat(output.inputLocation,'/'); %adds '/' to the end of the inputLocation for convenience 
fs=dir(strcat(output.inputLocation,'*.jpg'));   %take only jpg files
fprintf(logID,'%s\n',strcat(num2str(length(fs)),' files detected'));

rows=str2double(output.rows);  %rows of egg matrix
collumns=str2double(output.collumns); %collumns of egg matrix

%splits name format into its components
nameFormat=regexp(output.nameFormat,'_','split');
nameCount=length(nameFormat);


%total number of eggs to be processed are calculated
eggTotal=rows*collumns*length(fs); 


%progress bar total number pigment=5 imwrite=2 eggstract=3
progress=0;
progressTotal=length(fs)*5+eggTotal*(1==output.checkArea || output.checkAreaBridge==1 || output.checkSize==1)+eggTotal*output.checkShape+eggTotal*10*output.checkPigmen+eggTotal*output.checkIndiv.true*2+3;

%collumn number of numeric output matrix
col=1+output.checkArea+output.checkAreaR+output.checkAreaBridge+output.checkSize*2+output.checkShape*5+output.checkPigmen*5;

%prepares output matrixes
outputM=zeros(eggTotal,col);
outputName=cell(eggTotal,nameCount);


%files are read one by one
for x=1:length(fs)
    im=imread(strcat(output.inputLocation,fs(x).name));
    %disp(strcat(output.inputLocation,fs(x).name))
    progress=progress+5;
    waitbar(progress/progressTotal,bar,'Eggstracting')
    %eggstract from image
    
    log=strcat('eggstracting',{' '},fs(x).name,' with treshold',{' '},num2str(output.treshold(2,x)));
    fprintf(logID,'%s\n',log{1});

    [eggs,scale]=eggsport(im,str2double(output.scaleSize),rows,collumns,output.backgroundColor,output.treshold(2,x));
    
    fprintf(logID,'%s\n%s\n',strcat('Eggstraction complete. Scale:',num2str(scale),' pixels/cm'),...
        strcat('scale size:',num2str(scale*str2double(output.scaleSize)),' pixels'));
    
    eggCount=0;
    for y=1:length(eggs)
        if islogical(eggs{y}.Obj)
            eggCount=eggCount+1;
        end
    end
    
    fprintf(logID,'%s\n',strcat(num2str(eggCount),' eggs are found in the image'));

    
    if output.checkArea==1 || output.checkAreaBridge==1 || output.checkSize==1 || output.checkAreaR==1
        sizeMat=zeros(length(eggs),5);
        for y=1:length(eggs)
            progress=progress+1;
            waitbar(progress/progressTotal,bar,'Calculating size&area') 
            %unless the object is detected as an empty egg slot it is
            %analysed
            if islogical(eggs{y}.Obj)
                [h,w,v,vBridge,area]=eggSize(eggs{y},scale);
                sizeMat(y,:)=[h,w,v,vBridge,area];
            else
                sizeMat(y,:) = NaN;
            end
        end
        fprintf(logID,'%s\n','size volume calculation complete');

    end
    
    
    %splits filenames into its components. erases the file extension
    nameCell=cell(length(eggs),nameCount);
    for y=1:length(eggs)
        name=fs(x).name(1:length(fs(x).name)-4);
        name=regexp(name,'_','split');
        nameCell(y,:)=name;
    end
    
    fprintf(logID,'%s\n','Filename is processed');
    
    %eggstract white images
    if output.checkIndiv.true==1
        for y=1:length(eggs)
            progress=progress+2;
            waitbar(progress/progressTotal,bar,'Saving individual images')
            
            if islogical(eggs{y}.Obj)
                blackIm=regionprops(eggs{y}.Obj,'Image');
                [r c]=size(blackIm.Image);
                
                
                %if the user chose to use a scale, the images are resized
                if strcmpi(output.checkIndiv.scaleBy,'height')
                    proportion=str2double(output.checkIndiv.outputScale)/r;
                    blackIm.Image=imresize(blackIm.Image,proportion);
                end
                
                if strcmpi(output.checkIndiv.scaleBy,'width')
                    proportion=str2double(output.checkIndiv.outputScale)/c;
                    blackIm.Image=imresize(blackIm.Image,proportion);
                end
                
                imwrite(blackIm.Image,strcat(output.checkIndiv.imageOutput,'\', fs(x).name(1:length(fs(x).name)-4),'_',num2str(y),'.TIFF'),'TIFF');
                
            end
        end
        fprintf(logID,'%s\n','Individual images are saved');

    end
    % eggstraction complete
    
    
    %shape analysis
    if output.checkShape==1
        shapeMat=zeros(length(eggs),5);
        for y=1:length(eggs)
            progress=progress+1;
            waitbar(progress/progressTotal,bar,'Analysing shape')
            
            if islogical(eggs{y}.Obj)
                [A,c0,c1,c2,c3]=eggShape(eggs{y},scale);
                shapeMat(y,:)=[A,c0,c1,c2,c3];
            else
                shapeMat(y,:)=NaN;
            end
        end
        fprintf(logID,'%s\n','Shape calculation is completed');
    end
    
    %pigmentation analysis
    if output.checkPigmen==1
        pigMat=zeros(length(eggs),5);
        for y=1:length(eggs)
            progress=progress+10;
            waitbar(progress/progressTotal,bar,'Analysing pigmentation')
            if islogical(eggs{y}.Obj)
                [SizeMean,IntensityMean,DispersionMean,DispersionDeviation,ClutchNo]=eggPigmentMeasurer(eggs{y});
                pigMat(y,:)=[SizeMean,IntensityMean,DispersionMean,DispersionDeviation,ClutchNo];
            else
                pigMat(y,:)=NaN;
            end
        end
        fprintf(logID,'%s\n','Pigmentation analysis is completed.');
    end
    
    
    outputName(x*rows*collumns-rows*collumns+1:x*rows*collumns,:)=nameCell;
    
    t=1;
    
    outputM(x*rows*collumns-rows*collumns+1:x*rows*collumns,t)=(1:rows*collumns)';
    t=t+1;
    
    if output.checkSize==1
        outputM(x*rows*collumns-rows*collumns+1:x*rows*collumns,t:t+1)=sizeMat(:,1:2);
        t=t+2;
    end
    
    if output.checkArea==1
        outputM(x*rows*collumns-rows*collumns+1:x*rows*collumns,t)=sizeMat(:,3);
        t=t+1;
    end
    
    if output.checkAreaBridge==1
        outputM(x*rows*collumns-rows*collumns+1:x*rows*collumns,t)=sizeMat(:,4);
        t=t+1;
    end
    
    if output.checkAreaR==1
        outputM(x*rows*collumns-rows*collumns+1:x*rows*collumns,t)=sizeMat(:,5);
        t=t+1;
    end
    
    if output.checkShape==1
        outputM(x*rows*collumns-rows*collumns+1:x*rows*collumns,t:t+4)=shapeMat;
        t=t+5;
    end
    
    
    if output.checkPigmen==1
        outputM(x*rows*collumns-rows*collumns+1:x*rows*collumns,t:t+4)=pigMat;
        t=t+5;
    end
end

    waitbar(progress/progressTotal,bar,'Preparing Output')
    
titleRow='';

for t=1:nameCount
    titleRow=strcat(titleRow,nameFormat(t),',');
end
    
titleRow=strcat(titleRow,'EggNo');



if output.checkSize==1
    titleRow=strcat(titleRow,',Height,Width');
    
end

if output.checkArea==1
    titleRow=strcat(titleRow,',Volume');
end

if output.checkAreaBridge==1
    titleRow=strcat(titleRow,',Volume(bridge)');
end

if output.checkAreaR==1
    titleRow=strcat(titleRow,',Area');
end

if output.checkShape==1
    titleRow=strcat(titleRow,',A,c0,c1,c2,c3');
end

if output.checkPigmen==1
    titleRow=strcat(titleRow,',P_sizeMean,P_intensityMean,P_dispersionMean,P_dispersionDeviation,P_clutch no');
end



fileID=fopen(output.outputLocation,'w');
fprintf(fileID,'%s\n',titleRow{1});
[r c]=size(outputM);
for t=1:r
    
    
    for m=1:nameCount-1  
    fprintf(fileID,'%s',strcat(outputName{t,m},','));
    end
    
    fprintf(fileID,'%s',outputName{t,nameCount});

    
    for m=1:c
        fprintf(fileID,'%s',strcat(',',num2str(outputM(t,m))));
    end
    fprintf(fileID,'%s\n','');
    
    
end

fprintf(logID,'%s\n','#######Done#######');
fclose(fileID);
fclose(logID);
waitbar(1,bar,'info Eggstraction completed')
delete(bar);
end%end of function

