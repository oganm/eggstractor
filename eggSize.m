function [h,w,v,vBridge,surface] = eggSize(egg,scale)
%egg goes in size goes out. not rocket science
eggProps=regionprops(egg.Obj,'Image');
[r,c]=size(eggProps.Image);
h=r/scale;  %gives answer in cm
w=c/scale;
v=h*w^2*0.51;

[a b]= size(eggProps.Image);
vBridge=0;
for x=1:a
    vBridge=pi*(sum(eggProps.Image(x,:))/scale/2)^(2)/scale+vBridge;
     
end


surface=0;
for x=1:a;
    surface=2*pi*(sum(eggProps.Image(x,:))/scale/2)/scale+surface;
    
end

