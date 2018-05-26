function varargout = EggGUI(varargin)
% EGGGUI MATLAB code for EggGUI.fig
%      EGGGUI, by itself, creates a new EGGGUI or raises the existing
%      singleton*.
%
%      H = EGGGUI returns the handle to a new EGGGUI or the handle to
%      the existing singleton*.
%
%      EGGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EGGGUI.M with the given input arguments.
%
%      EGGGUI('Property','Value',...) creates a new EGGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EggGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EggGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EggGUI

% Last Modified by GUIDE v2.5 28-Aug-2012 17:11:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EggGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @EggGUI_OutputFcn, ...
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


% --- Executes just before EggGUI is made visible.
function EggGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EggGUI (see VARARGIN)

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(handles.figure1,'javaframe');
jIcon=javax.swing.ImageIcon('smallEggstractor.png');
jframe.setFigureIcon(jIcon);




%default treshold
handles.output.treshold=0.4;
set(handles.tresholdCarrier,'Value',0.4);

% Update handles structure
guidata(hObject, handles);
%set(handles.editLocation,'String',cd);
set(handles.editLocation,'String',cd)
fs=dir(strcat(cd,'/','*.jpg'));
set(handles.tresholdTable,'Data',[zeros(1,length(fs));0.5*ones(1,length(fs))])
%set(handles.editLocation,'String','C:\Users\Owner\Matlab\Zurich gap\readerOfEggs\neweggs\testFolder')
set(handles.editTarget,'String',strcat(cd,'\eggData.csv'))
set(handles.imageOutput,'String',strcat(cd,'\eggsOut'))
set(handles.checkSize,'Value',1);
set(handles.checkShape,'Value',1);
set(handles.checkPigmen,'Value',0);
set(handles.check,'Value',1);
set(handles.areaBridge,'Value',1);
set(handles.checkAreaR,'Value',1);




% UIWAIT makes EggGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = EggGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.treshold=get(handles.tresholdTable,'Data');
handles.output.checkArea=get(handles.check,'Value');
handles.output.checkAreaBridge=get(handles.areaBridge,'Value');
handles.output.checkSize=get(handles.checkSize,'Value');
handles.output.checkShape=get(handles.checkShape,'Value');
handles.output.checkPigmen=get(handles.checkPigmen,'Value');
handles.output.checkIndiv.true=get(handles.checkIndiv,'Value');
handles.output.checkAreaR=get(handles.checkAreaR,'Value');
handles.output.checkIndiv.imageOutput=get(handles.imageOutput,'String');

if get(handles.whiteBack,'Value')==1
handles.output.backgroundColor='white';
end
if get(handles.blackBack,'Value')==1
    handles.output.backgroundColor='black';
end
if get(handles.redBack,'Value')==1
    handles.output.backgroundColor='red';
end
if get(handles.greenBack,'Value')==1
    handles.output.backgroundColor='green';
end
if get(handles.blueBack,'Value')==1
    handles.output.backgroundColor='blue';
end



    
    
    
if get(handles.radioHeight,'Value')==1
    handles.output.checkIndiv.scaleBy='height';
end
 if get (handles.radioWidth,'Value')==1
       handles.output.checkIndiv.scaleBy='width';
 end
 if get(handles.noScale,'Value')==1
        handles.output.checkIndiv.scaleBy='no';
 end

handles.output.checkIndiv.outputScale=get(handles.editOutputScale,'String');
handles.output.inputLocation=get(handles.editLocation,'String');
handles.output.outputLocation=get(handles.editTarget,'String');
handles.output.scaleSize=get(handles.getScale,'String');
handles.output.nameFormat=get(handles.editFormat,'String');
handles.output.rows=get(handles.rows,'String');
handles.output.collumns=get(handles.collumns,'String');


% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);



% --- Executes on button press in check.
function check_Callback(hObject, eventdata, handles)
% hObject    handle to check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check


% --- Executes on button press in checkShape.
function checkShape_Callback(hObject, eventdata, handles)
% hObject    handle to checkShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkShape


% --- Executes on button press in checkPigmen.
function checkPigmen_Callback(hObject, eventdata, handles)
% hObject    handle to checkPigmen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkPigmen



function editLocation_Callback(hObject, eventdata, handles)
fs=dir(strcat(get(handles.editLocation,'String'),'/','*.jpg'));
set(handles.tresholdTable,'Data',[zeros(1,length(fs));0.5*ones(1,length(fs))])
% hObject    handle to editLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLocation as text
%        str2double(get(hObject,'String')) returns contents of editLocation as a double


% --- Executes during object creation, after setting all properties.
function editLocation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in locationPushBotton.
function locationPushBotton_Callback(hObject, eventdata, handles)
newDirectory=uigetdir;
if newDirectory~=0
set(handles.editLocation,'String',newDirectory)
end
fs=dir(strcat(newDirectory,'/','*.jpg'));
set(handles.tresholdTable,'Data',[zeros(1,length(fs));0.5*ones(1,length(fs))])
% hObject    handle to locationPushBotton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function check_CreateFcn(hObject, eventdata, handles)
% hObject    handle to check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function editTarget_Callback(hObject, eventdata, handles)
% hObject    handle to editTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTarget as text
%        str2double(get(hObject,'String')) returns contents of editTarget as a double


% --- Executes during object creation, after setting all properties.
function editTarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in targetPushBotton.
function targetPushBotton_Callback(hObject, eventdata, handles)
[fileName fileAddress]=uiputfile('*.csv');
set(handles.editTarget,'String',strcat(fileAddress,fileName))
% hObject    handle to targetPushBotton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in doer.
function doer_Callback(hObject, eventdata, handles)
uiresume(handles.figure1)
% hObject    handle to doer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on doer and none of its controls.
function doer_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to doer (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function editFormat_Callback(hObject, eventdata, handles)
% hObject    handle to editFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFormat as text
%        str2double(get(hObject,'String')) returns contents of editFormat as a double


% --- Executes during object creation, after setting all properties.
function editFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editProxy_Callback(hObject, eventdata, handles)
% hObject    handle to editProxy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editProxy as text
%        str2double(get(hObject,'String')) returns contents of editProxy as a double


% --- Executes during object creation, after setting all properties.
function editProxy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editProxy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function getScale_Callback(hObject, eventdata, handles)
% hObject    handle to getScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of getScale as text
%        str2double(get(hObject,'String')) returns contents of getScale as a double


% --- Executes during object creation, after setting all properties.
function getScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to getScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOutputScale_Callback(hObject, eventdata, handles)
% hObject    handle to editOutputScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOutputScale as text
%        str2double(get(hObject,'String')) returns contents of editOutputScale as a double


% --- Executes during object creation, after setting all properties.
function editOutputScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOutputScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkIndiv.
function checkIndiv_Callback(hObject, eventdata, handles)
% hObject    handle to checkIndiv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkIndiv


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkSize.
function checkSize_Callback(hObject, eventdata, handles)
% hObject    handle to checkSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkSize


% --- Executes on button press in areaBridge.
function areaBridge_Callback(hObject, eventdata, handles)
% hObject    handle to areaBridge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of areaBridge


% --- Executes on button press in checkUseDef.
function checkUseDef_Callback(hObject, eventdata, handles)
% hObject    handle to checkUseDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkUseDef



function collumns_Callback(hObject, eventdata, handles)
% hObject    handle to collumns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of collumns as text
%        str2double(get(hObject,'String')) returns contents of collumns as a double


% --- Executes during object creation, after setting all properties.
function collumns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to collumns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rows_Callback(hObject, eventdata, handles)
% hObject    handle to rows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rows as text
%        str2double(get(hObject,'String')) returns contents of rows as a double


% --- Executes during object creation, after setting all properties.
function rows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imageOutput_Callback(hObject, eventdata, handles)
% hObject    handle to imageOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imageOutput as text
%        str2double(get(hObject,'String')) returns contents of imageOutput as a double


% --- Executes during object creation, after setting all properties.
function imageOutput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
newDirectory=uigetdir;
if newDirectory~=0
set(handles.imageOutput,'String',newDirectory)
end
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uipanel23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over whiteBack.
function whiteBack_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to whiteBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tresholdButton.
function tresholdButton_Callback(hObject, eventdata, handles)

if get(handles.whiteBack,'Value')==1
handles.output.backgroundColor='white';
end
if get(handles.blackBack,'Value')==1
    handles.output.backgroundColor='black';
end
if get(handles.redBack,'Value')==1
    handles.output.backgroundColor='red';
end
if get(handles.greenBack,'Value')==1
    handles.output.backgroundColor='green';
end
if get(handles.blueBack,'Value')==1
    handles.output.backgroundColor='blue';
end
tresh=treshold(handles.output.backgroundColor,get(handles.editLocation,'String'),get(handles.tresholdTable,'Data'));
set(handles.tresholdTable,'Data',tresh.treshold);


% hObject    handle to tresholdButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function tresholdCarrier_Callback(hObject, eventdata, handles)
% hObject    handle to tresholdCarrier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function tresholdCarrier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tresholdCarrier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in tresholdLog.
function tresholdLog_Callback(hObject, eventdata, handles)
% hObject    handle to tresholdLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file path]=uigetfile('*.csv');
if file~=0
data=csvread(strcat(path,file));
set(handles.tresholdTable,'Data',data)
end


% --- Executes on button press in checkAreaR.
function checkAreaR_Callback(hObject, eventdata, handles)
% hObject    handle to checkAreaR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkAreaR
