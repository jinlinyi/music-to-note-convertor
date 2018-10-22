% Author: TEAM FORWARD
% Instructor: Professor Yanfeng Shen
% Course: VG100 Intro to Engineering
% UNIVERSITY OF MICHIGAN - SHANGHAI JIAO TONG UNIVERSITY JOINT INSTITUTE
% Date: AUG 10 2016

function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 06-Aug-2016 21:45:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Fs=str2num(get(handles.text3,'String'));
durationSecs=str2num(get(handles.edit2,'String'));
fig(1)=handles.axes1;
fig(2)=handles.axes2;
fig(3)=handles.axes3;
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);
myAudioRecording(Fs,fig,durationSecs);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

OUTPUTDATA = getappdata(0,'OUTPUTDATA');
recorder = OUTPUTDATA.recorder;
stop(recorder);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

OUTPUTDATA=getappdata(0,'OUTPUTDATA');
x=OUTPUTDATA.x;
Fs=str2num(get(handles.text3,'String'));

axes(handles.axes2);
hold on;
x=x/max(x);
noiseSeg = x(1:0.2*Fs);
noiseLimit = 2*(mean(noiseSeg)+4*std(noiseSeg));

[~,locs_Rwave] = findpeaks(x,'MinPeakHeight',0.8,...
    'MinPeakDistance',0.1*Fs);
locs_Rwave(length(locs_Rwave)+1) = length(x);
plot(locs_Rwave/Fs,x(locs_Rwave),'rv','MarkerFaceColor','r');

outputMIDI = [];
outputT = [];
for i = 1:length(locs_Rwave)-1
    outputT(i) = (locs_Rwave(i+1)-locs_Rwave(i))/Fs;
end

[beat,p]=timeunit(outputT)


x0=0;y0=0;k=0;
for i = 1:length(locs_Rwave)-1
    xs = x(locs_Rwave(i):locs_Rwave(i+1));
    len = length(xs);
    
    ts=1/Fs;
    tmax=(len-1)*ts;
    t=0:ts:tmax;
    f=-Fs/2:Fs/(len-1):Fs/2;
    f=f(ceil(length(f)/2+0.5):end);
    z=abs(fftshift(fft(xs)));
    z=z(ceil(length(z)/2+0.5):end);
    
    axes(handles.axes3);
    plot(f,abs(z));
    hold on;
    [~,fmax] = findpeaks(z,'MinPeakHeight',270,'MinPeakDistance',15);
    plot(f(fmax),abs(z(fmax)),'rv','MarkerFaceColor','r');
    xlim([0 2500]);
    halfF = f(round(fmax(1)/2));
    if round(fmax(1)/2)-20>0
        testseg = z(round(fmax(1)/2)-20:round(fmax(1)/2)-10);
    else
        testseg = z(1:5)
        print('error');
    end
    
    plot(halfF,0,'rv','MarkerFaceColor','g');
    [C2,I2]=max(testseg);
    outputMIDI(i) = f2MIDIn(f(fmax(1)));
    plot(f(fmax(1)),0,'rv','MarkerFaceColor','b');
    
    ylim([0 1500]);
    hold off;
    axes(handles.axes1);
    hold on;
    [x0,y0,k]=DrawMain(x0,y0,k,outputMIDI(i),p(i));
    
    pause;
end

axes(handles.axes1);
axis([-10 70 -75 5]);

OUTPUTDATA.y0=y0;
OUTPUTDATA.p=p;
OUTPUTDATA.beat=beat;
OUTPUTDATA.x=x;
OUTPUTDATA.outputT=outputT;
OUTPUTDATA.outputMIDI=outputMIDI;
OUTPUTDATA.locs_Rwave=locs_Rwave;
setappdata(0,'OUTPUTDATA',OUTPUTDATA);

fd=fopen('current.txt','wt');
for abc=1:1:length(locs_Rwave)-1
    fprintf(fd,'%d %d\n',16/p(abc),outputMIDI(abc));
end
fclose(fd);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% myPlay();
OUTPUTDATA=getappdata(0,'OUTPUTDATA');
outputMIDI=OUTPUTDATA.outputMIDI;
p=OUTPUTDATA.p;

flag=0;i=1;
while i<=size(p,2)
if p(i)==16/3 || p(i)==16/6 || p(i)==16/12
p(i+1:size(p,2)+1)=p(i:size(p,2));
p(i)=p(i)*1.5;
p(i+1)=p(i)*2;
outputMIDI(i+1:size(outputMIDI,2)+1)=outputMIDI(i:size(outputMIDI,2));
outputMIDI(i+1)=51;
end
i=i+1;
end
myPlay(outputMIDI,16./p,8);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

correction(handles.axes1);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String','30');

% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String','44100');


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
axis on;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

OUTPUTDATA=getappdata(0,'OUTPUTDATA');
y=OUTPUTDATA.y0;

if y<=-70
    axes(handles.axes1);
    dh=(-70-y)*(1-hObject.Value);
    axis([-10 70 -75-dh 5-dh]);
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
