function varargout = treshold(varargin)
% TRESHOLD MATLAB code for treshold.fig
%      TRESHOLD, by itself, creates a new TRESHOLD or raises the existing
%      singleton*.
%
%      H = TRESHOLD returns the handle to a new TRESHOLD or the handle to
%      the existing singleton*.
%
%      TRESHOLD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRESHOLD.M with the given input arguments.
%
%      TRESHOLD('Property','Value',...) creates a new TRESHOLD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before treshold_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to treshold_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help treshold

% Last Modified by GUIDE v2.5 24-Aug-2012 11:37:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @treshold_OpeningFcn, ...
    'gui_OutputFcn',  @treshold_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before treshold is made visible.
function treshold_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to treshold (see VARARGIN)

% Choose default command line output for treshold
set(handles.checker,'Value',1)
data=varargin{3};
set(handles.tresholdTable,'Data',data);


warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(handles.figure1,'javaframe');
jIcon=javax.swing.ImageIcon('smallEggstractor.png');
jframe.setFigureIcon(jIcon);

if data(1,1)==1
    set(handles.indivTreshold,'Value',1)
    set(handles.individualSlider,'Value',data(2,1))
end


adress=varargin{2};
fs=dir(strcat(adress,'/','*.jpg'));
set(handles.tresholdSlider,'Value',0.5)
for t=1:length(fs)
    if data(1,t)==0
        set(handles.tresholdSlider,'Value',data(2,t))
        break
    end
end

backgroundColor=varargin{1};
set(handles.fileCarrier,'Max',length(fs));
set(handles.fileCarrier,'Min',1);
set(handles.fileCarrier,'Value',1)


while get(handles.checker,'Value')==1
    im=imread(strcat(adress,'/',fs(get(handles.fileCarrier,'Value')).name));
    
    data=get(handles.tresholdTable,'Data');
    if data(1,get(handles.fileCarrier,'Value'))==1
        set(handles.indivTreshold,'Value',1)
        set(handles.individualSlider,'Value',data(2,get(handles.fileCarrier,'Value')))
    else
        set(handles.indivTreshold,'Value',0)
    end
    
    
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
    end
    set(handles.average,'String',num2str(mean(mean(im))));
    
    set(handles.name,'String',fs(get(handles.fileCarrier,'Value')).name)
    
    
    
    handles.output = hObject;
    % Update handles structure
    guidata(hObject, handles);
    
    if get(handles.indivTreshold,'Value')==1
        set(handles.individualSlider,'Vis','on')
        set(handles.tresholdSlider,'Vis','off')
        treshold=get(handles.individualSlider,'Value');
    else
        set(handles.individualSlider,'Vis','off')
        set(handles.tresholdSlider,'Vis','on')
        treshold=get(handles.tresholdSlider,'Value');
    end
    imbw=im2bw(im,treshold);
    imbw=imcomplement(imbw);
    imbw=bwmorph(imbw,'close',Inf);
    imbw=bwmorph(imbw,'diag',Inf);
    [r,c]=size(imbw);
    imbw=imbw(3:r-3,3:c-3);
    imbw=imclearborder(imbw);
    imbw=imfill(imbw,'holes');
    minSize=floor(2.5019e-004*r*c);
    imbw=bwareaopen(imbw,minSize);


    
    set(handles.treshold,'String',num2str(treshold))
    hAres=gca;
    imshow(imbw,'Parent',hAres)
    
    
    % UIWAIT makes treshold wait for user response (see UIRESUME)
    uiwait(handles.figure1);
end




% --- Outputs from this function are returned to the command line.
function varargout = treshold_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
data=get(handles.tresholdTable,'Data');
[r c]=size(data);

for t=1:c
    if data(1,t)~=1
        data(2,t)=get(handles.tresholdSlider,'Value');
    end
end

handles.output.treshold=data;
a=clock;
csvwrite(strcat('tresholdLog_',date,'_',num2str(a(4)),'.',num2str(a(5)),'.',num2str(round(a(6))),'.csv'),data);

varargout{1} = handles.output;

delete(handles.figure1);



% --- Executes on slider movement.
function tresholdSlider_Callback(hObject, eventdata, handles)

uiresume(handles.figure1)
% hObject    handle to tresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function tresholdSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
if get(handles.indivTreshold,'Value')==1
    a=get(handles.tresholdTable,'Data');
    a(1,get(handles.fileCarrier,'Value'))=1;
    a(2,get(handles.fileCarrier,'Value'))=get(handles.individualSlider,'Value');
    set(handles.tresholdTable,'Data',a)
end
set(handles.checker,'Value',0);

uiresume(handles.figure1)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checker.
function checker_Callback(hObject, eventdata, handles)
% hObject    handle to checker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checker



function treshold_Callback(hObject, eventdata, handles)
if get(handles.indivTreshold,'Value')==1
    set(handles.individualSlider,'Value',str2double(get(handles.treshold,'String')));
    a=get(handles.tresholdTable,'Data');
    a(1,get(handles.fileCarrier,'Value'))=1;
    a(2,get(handles.fileCarrier,'Value'))=get(handles.individualSlider,'Value');
    set(handles.tresholdTable,'Data',a)
else
    set(handles.tresholdSlider,'Value',str2double(get(handles.treshold,'String')));
end
uiresume(handles.figure1)
% hObject    handle to treshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of treshold as text
%        str2double(get(hObject,'String')) returns contents of treshold as a double


% --- Executes during object creation, after setting all properties.
function treshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to treshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in forward.
function forward_Callback(hObject, eventdata, handles)
if get(handles.indivTreshold,'Value')==1
    a=get(handles.tresholdTable,'Data');
    a(1,get(handles.fileCarrier,'Value'))=1;
    a(2,get(handles.fileCarrier,'Value'))=get(handles.individualSlider,'Value');
    set(handles.tresholdTable,'Data',a)
end
if get(handles.fileCarrier,'Value')~=get(handles.fileCarrier,'Max')
    set(handles.fileCarrier,'Value',get(handles.fileCarrier,'Value')+1)
    uiresume(handles.figure1)
end
% hObject    handle to forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
if get(handles.indivTreshold,'Value')==1
    a=get(handles.tresholdTable,'Data');
    a(1,get(handles.fileCarrier,'Value'))=1;
    a(2,get(handles.fileCarrier,'Value'))=get(handles.individualSlider,'Value');
    set(handles.tresholdTable,'Data',a)
end
if get(handles.fileCarrier,'Value')~=get(handles.fileCarrier,'Min')
    set(handles.fileCarrier,'Value',get(handles.fileCarrier,'Value')-1)
    uiresume(handles.figure1)
end
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function fileCarrier_Callback(hObject, eventdata, handles)
% hObject    handle to fileCarrier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
1;

% --- Executes during object creation, after setting all properties.
function fileCarrier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileCarrier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function average_CreateFcn(hObject, eventdata, handles)
% hObject    handle to average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on button press in indivTreshold.
function indivTreshold_Callback(hObject, eventdata, handles)

data=get(handles.tresholdTable,'Data');
a=get(handles.fileCarrier,'Value');
data(1,a)=get(handles.indivTreshold,'Value');
set(handles.tresholdTable,'Data',data);

% hObject    handle to indivTreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of indivTreshold
uiresume(handles.figure1)



% --- Executes on slider movement.
function individualSlider_Callback(hObject, eventdata, handles)
data=get(handles.tresholdTable,'Data');
a=get(handles.fileCarrier,'Value');
data(2,a)=get(handles.individualSlider,'Value');
set(handles.tresholdTable,'Data',data);


% hObject    handle to individualSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
uiresume(handles.figure1)



% --- Executes during object creation, after setting all properties.
function individualSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to individualSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
