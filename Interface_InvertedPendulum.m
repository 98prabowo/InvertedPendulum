function varargout = Interface_InvertedPendulum(varargin)
% INTERFACE_INVERTEDPENDULUM MATLAB code for Interface_InvertedPendulum.fig
%      INTERFACE_INVERTEDPENDULUM, by itself, creates a new INTERFACE_INVERTEDPENDULUM or raises the existing
%      singleton*.
%
%      H = INTERFACE_INVERTEDPENDULUM returns the handle to a new INTERFACE_INVERTEDPENDULUM or the handle to
%      the existing singleton*.
%
%      INTERFACE_INVERTEDPENDULUM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_INVERTEDPENDULUM.M with the given input arguments.
%
%      INTERFACE_INVERTEDPENDULUM('Property','Value',...) creates a new INTERFACE_INVERTEDPENDULUM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interface_InvertedPendulum_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interface_InvertedPendulum_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interface_InvertedPendulum

% Last Modified by GUIDE v2.5 24-Oct-2020 20:14:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interface_InvertedPendulum_OpeningFcn, ...
                   'gui_OutputFcn',  @Interface_InvertedPendulum_OutputFcn, ...
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


% --- Executes just before Interface_InvertedPendulum is made visible.
function Interface_InvertedPendulum_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interface_InvertedPendulum (see VARARGIN)

% Choose default command line output for Interface_InvertedPendulum
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interface_InvertedPendulum wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Interface_InvertedPendulum_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in push_start.
function push_start_Callback(hObject, eventdata, handles)
% hObject    handle to push_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_param('InvertedPendulumR2020a','SimulationCommand','start');

vrWorld = vrworld('pendulum_vr.wrl');
open(vrWorld);
myCanvas = vr.canvas(vrWorld, 'Parent', handles.uipanel, 'Units',...
'normalized', 'Position', [0 0 1 1],'Viewpoint','Front view');

handles.timer = timer('Name','MyTimer',               ...
                       'Period',0.1,                    ... 
                       'StartDelay',0,                 ... 
                       'TasksToExecute',inf,           ... 
                       'ExecutionMode','fixedSpacing', ...
                       'TimerFcn',{@timerCallback,hObject}); 
 guidata(hObject,handles);
 start(handles.timer);
 
 function [] = timerCallback(~,~,guiHandle)
 if ~isempty(guiHandle)
      % get the handles
      handles = guidata(guiHandle);
      if ~isempty(handles)
          % if new data, then update the axes
          rto = get_param('InvertedPendulumR2020a/plot_time','RuntimeObject');
          x_time = rto.OutputPort(1).Data;
          
          rto_angle = get_param('InvertedPendulumR2020a/plot_Angle','RuntimeObject');
          y_angle = rto_angle.OutputPort(1).Data;
%fprintf('%d\n',y_angle);

          rto_pos = get_param('InvertedPendulumR2020a/plot_Pos','RuntimeObject');
          y_pos = rto_pos.OutputPort(1).Data;

set(handles.plotTX,'xLim',[x_time-500 x_time+500]);
plot(handles.plotTX,[x_time x_time],[y_angle y_angle], 'bo', 'LineWidth', 1, 'MarkerSize', 1);
hold on;
plot(handles.plotTX,[x_time x_time],[y_pos y_pos], 'ro', 'LineWidth', 1, 'MarkerSize', 1);
hold on;

hChildren=get(handles.plotTX,'Children');
xData1 = get(hChildren(:),'XData');
yData1 = get(hChildren(:),'YData');
ns = size(xData1,1);
ax=[0;0;0;0];ay=[0;0;0;0];

if ns > 2
   ax=cell2mat(xData1(1:4));
   ay=cell2mat(yData1(1:4));
end

%line angle
plot(handles.plotTX,[ax(1) ax(3)] ,[ay(2) ay(4)], 'b-', 'LineWidth', 1);
hold on;

%line position
plot(handles.plotTX,[ax(1) ax(3)] ,[ay(1) ay(3)], 'r-', 'LineWidth', 1);
hold on;
     end
 end
 
% --- Executes on button press in push_stop.
function push_stop_Callback(hObject, eventdata, handles)
% hObject    handle to push_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.plotTX);
cla reset; % Do a complete and total reset of the axes.

set_param('InvertedPendulumR2020a','SimulationCommand','stop');



% axes(handles.plotTX);
% cla reset;

function setpoint_Callback(hObject, eventdata, handles)
% hObject    handle to setpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setpoint as text
%        str2double(get(hObject,'String')) returns contents of setpoint as a double


% --- Executes during object creation, after setting all properties.
function setpoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default SP gain to be 0.1
NN=evalin('base','SP');
NN=num2str(NN);
set(hObject,'String',NN);
set_param('InvertedPendulumR2020a','SimulationCommand','update');

function noise_Callback(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise as text
%        str2double(get(hObject,'String')) returns contents of noise as a double

% --- Executes during object creation, after setting all properties.
function noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default Noise gain to be 0.1
NN=evalin('base','Nvar');
NN=num2str(NN);
set(hObject,'String',NN);
set_param('InvertedPendulumR2020a','SimulationCommand','update');


function KP1_Callback(hObject, eventdata, handles)
% hObject    handle to KP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KP1 as text
%        str2double(get(hObject,'String')) returns contents of KP1 as a double


% --- Executes during object creation, after setting all properties.
function KP1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default
NN=evalin('base','KP1');
NN=num2str(NN);
set(hObject,'String',NN);
set_param('InvertedPendulumR2020a','SimulationCommand','update');

function KI1_Callback(hObject, eventdata, handles)
% hObject    handle to KI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KI1 as text
%        str2double(get(hObject,'String')) returns contents of KI1 as a double

% --- Executes during object creation, after setting all properties.
function KI1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default
NN=evalin('base','KI1');
NN=num2str(NN);
set(hObject,'String',NN);
set_param('InvertedPendulumR2020a','SimulationCommand','update');


function KD1_Callback(hObject, eventdata, handles)
% hObject    handle to KD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KD1 as text
%        str2double(get(hObject,'String')) returns contents of KD1 as a double


% --- Executes during object creation, after setting all properties.
function KD1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default
NN=evalin('base','KD1');
NN=num2str(NN);
set(hObject,'String',NN);
set_param('InvertedPendulumR2020a','SimulationCommand','update');


function KP2_Callback(hObject, eventdata, handles)
% hObject    handle to KP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KP2 as text
%        str2double(get(hObject,'String')) returns contents of KP2 as a double


% --- Executes during object creation, after setting all properties.
function KP2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default
NN=evalin('base','KP2');
NN=num2str(NN);
set(hObject,'String',NN);
set_param('InvertedPendulumR2020a','SimulationCommand','update');


function KI2_Callback(hObject, eventdata, handles)
% hObject    handle to KI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KI2 as text
%        str2double(get(hObject,'String')) returns contents of KI2 as a double


% --- Executes during object creation, after setting all properties.
function KI2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default
NN=evalin('base','KI2');
NN=num2str(NN);
set(hObject,'String',NN);
set_param('InvertedPendulumR2020a','SimulationCommand','update');


function KD2_Callback(hObject, eventdata, handles)
% hObject    handle to KD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KD2 as text
%        str2double(get(hObject,'String')) returns contents of KD2 as a double


% --- Executes during object creation, after setting all properties.
function KD2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default
NN=evalin('base','KD2');
NN=num2str(NN);
set(hObject,'String',NN);
set_param('InvertedPendulumR2020a','SimulationCommand','update');

function mc_Callback(hObject, eventdata, handles)
% hObject    handle to mc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mc as text
%        str2double(get(hObject,'String')) returns contents of mc as a double


% --- Executes during object creation, after setting all properties.
function mc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default
NN=evalin('base','Mcart');
NN=num2str(NN);
set(hObject,'String',NN);
set_param('InvertedPendulumR2020a','SimulationCommand','update');

function mp_Callback(hObject, eventdata, handles)
% hObject    handle to mp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mp as text
%        str2double(get(hObject,'String')) returns contents of mp as a double


% --- Executes during object creation, after setting all properties.
function mp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default
NN=evalin('base','Mpend');
NN=num2str(NN);
set(hObject,'String',NN);
set_param('InvertedPendulumR2020a','SimulationCommand','update');

function l_Callback(hObject, eventdata, handles)
% hObject    handle to l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of l as text
%        str2double(get(hObject,'String')) returns contents of l as a double


% --- Executes during object creation, after setting all properties.
function l_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default
NN=evalin('base','LCM');
NN=num2str(NN);
set(hObject,'String',NN);
set_param('InvertedPendulumR2020a','SimulationCommand','update');

% --- Executes on button press in push_apply.
function push_apply_Callback(hObject, eventdata, handles)
% hObject    handle to push_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the user entered value for gain and convert it to a string
val_SP = str2num(get(handles.setpoint,'String'));
val_Nvar = str2num(get(handles.noise,'String'));
val_KP1 = str2num(get(handles.KP1,'String'));
val_KI1 = str2num(get(handles.KI1,'String'));
val_KD1 = str2num(get(handles.KD1,'String'));
val_KP2 = str2num(get(handles.KP2,'String'));
val_KI2 = str2num(get(handles.KI2,'String'));
val_KD2 = str2num(get(handles.KD2,'String'));
val_mc = str2num(get(handles.mc,'String'));
val_mp = str2num(get(handles.mp,'String'));
val_l = str2num(get(handles.l,'String'));

%update both the model and the current string in the gain window.
if(val_SP)
    assignin('base','SP',val_SP);
    assignin('base','Nvar',val_Nvar);
    assignin('base','KP1',val_KP1);
    assignin('base','KI1',val_KI1);
    assignin('base','KD1',val_KD1);
    assignin('base','KP2',val_KP2);
    assignin('base','KI2',val_KI2);
    assignin('base','KD2',val_KD2);
    assignin('base','Mcart',val_mc);
    assignin('base','Mpend',val_mp);
    assignin('base','LCM',val_l);
    set_param('InvertedPendulumR2020a','SimulationCommand','update');
else
    val_SP = evalin('base','SP');
    val_Nvar = evalin('base','Nvar');
    val_KP1 = evalin('base','KP1');
    val_KI1 = evalin('base','KI1');
    val_KD1 = evalin('base','KD1');
    val_KP2 = evalin('base','KP2');
    val_KI2 = evalin('base','KI2');
    val_KD2 = evalin('base','KD2');
    val_mc = evalin('base','Mcart');
    val_mp = evalin('base','Mpend');
    val_l = evalin('base','LCM');
    set(handles.setpoint,'String',num2str(val_SP));
    set(handles.noise,'String',num2str(val_Nvar));
    set(handles.KP1,'String',num2str(val_KP1));
    set(handles.KI1,'String',num2str(val_KI1));
    set(handles.KD1,'String',num2str(val_KD1));
    set(handles.KP2,'String',num2str(val_KP2));
    set(handles.KI2,'String',num2str(val_KI2));
    set(handles.KD2,'String',num2str(val_KD2));
    set(handles.mc,'String',num2str(val_mc));
    set(handles.mp,'String',num2str(val_mp));
    set(handles.l,'String',num2str(val_l));
end

% rto = get_param('InvertedPendulumR2020a/plot_Angle','RuntimeObject');
% x_angle = rto.OutputPort(1).Data;
% assignin('base','x_angle',x_angle);

% x=0:10;
% y=;
% axes(handles.plotTX);
% plot(x,y);
% xlabel('x');
% ylabel('y');
% guidata(hObject, handles);
