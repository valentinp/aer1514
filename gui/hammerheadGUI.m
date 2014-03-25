function varargout = hammerheadGUI(varargin)
% HAMMERHEADGUI MATLAB code for hammerheadGUI.fig
%      HAMMERHEADGUI, by itself, creates a new HAMMERHEADGUI or raises the existing
%      singleton*.
%
%      H = HAMMERHEADGUI returns the handle to a new HAMMERHEADGUI or the handle to
%      the existing singleton*.
%
%      HAMMERHEADGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HAMMERHEADGUI.M with the given input arguments.
%
%      HAMMERHEADGUI('Property','Value',...) creates a new HAMMERHEADGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hammerheadGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hammerheadGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hammerheadGUI

% Last Modified by GUIDE v2.5 24-Mar-2014 14:45:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hammerheadGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @hammerheadGUI_OutputFcn, ...
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


% --- Executes just before hammerheadGUI is made visible.
function hammerheadGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hammerheadGUI (see VARARGIN)
global height; global width; global isTrackingCalibrated;
global enableTeleopMode;

% Initialize kinect images in gui
handles.kinectRGB_image = imshow(zeros(height,width,3,'uint8'), 'Parent', handles.kinectRGB);
handles.kinectDepth_image = imagesc(zeros(height,width,'uint16'), 'Parent', handles.kinectDepth);
% handles.kinectOverlays_image = imshow(zeros(height,width,3,'uint8'),'Parent', handles.kinectOverlays);
handles.overSample_image = imshow(zeros(10,10,3,'uint8'), 'Parent', handles.overSample);

set(handles.kinectDepth, 'XTick',[],'YTick',[]); % Apparently imagesc creates these again

% Initialize teleop radio button
set(handles.radio_teleop,'Value',enableTeleopMode);
set(handles.radio_auto,'Value',~enableTeleopMode);
if enableTeleopMode
    set_param('robulink/teleop','Value','true');
else
    set_param('robulink/teleop','Value','false');
end

% Set up samples list
handles.samplesList = [];

% Choose default command line output for hammerheadGUI
handles.output = hObject;

%Set tracking variable
isTrackingCalibrated = false;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes hammerheadGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hammerheadGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_addSample.
function btn_addSample_Callback(hObject, eventdata, handles)
% hObject    handle to btn_addSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global context; global depth;
addSample(context, depth, handles);


% --- Executes on button press in btn_clearSamples.
function btn_clearSamples_Callback(hObject, eventdata, handles)
% hObject    handle to btn_clearSamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.samplesList, 'Data', []);
set(handles.samplesTable, 'Data', handles.samplesList);



function edit_leftWheelGain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_leftWheelGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_leftWheelGain as text
%        str2double(get(hObject,'String')) returns contents of edit_leftWheelGain as a double
oldkl = get_param('robulink/kl','Value');
newkl = get(hObject,'String');
if sum(~isstrprop(newkl,'digit')) == 0 % i.e. if actually a number
    set_param('robulink/kl','Value',newkl);
else
    set(hObject,'String',num2str(oldkl));
end


% --- Executes during object creation, after setting all properties.
function edit_leftWheelGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_leftWheelGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',get_param('robulink/kl','Value'));


function edit_rightWheelGain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rightWheelGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rightWheelGain as text
%        str2double(get(hObject,'String')) returns contents of edit_rightWheelGain as a double
oldkr = get_param('robulink/kr','Value');
newkr = get(hObject,'String');
if sum(~isstrprop(newkr,'digit')) == 0 % i.e. if actually a number
    set_param('robulink/kr','Value',newkr);
else
    set(hObject,'String',num2str(oldkr));
end


% --- Executes during object creation, after setting all properties.
function edit_rightWheelGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rightWheelGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',get_param('robulink/kr','Value'));

% --- Executes on button press in btn_overlayPath.
function btn_overlayPath_Callback(hObject, eventdata, handles)
% hObject    handle to btn_overlayPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global terrain; global context;
global waypoints_g;

patches = findall(allchild(handles.kinectRGB),'Type','patch');

if isempty(patches)
    overlayPath(handles.kinectRGB, waypoints_g, terrain, context);
else
    delete(patches);
end


% --- Executes on button press in btn_terrainAssessment.
function btn_terrainAssessment_Callback(hObject, eventdata, handles)
% hObject    handle to btn_terrainAssessment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global terrain; global context; global rgb; global depth;
global T_rg; global isTrackingCalibrated; global trackingStruct;

terrain = terrainAssessment(context,rgb,depth,1);

if isTrackingCalibrated
    T_rg = localizeRover(context, rgb, depth,trackingStruct, terrain.T_gk);
end

if ~isnan(T_rg)
    terrain = markTerrainAroundRoverSafe(terrain,T_rg);
else
    disp('Warning: Rover has not been localized. Can''t mark terrain around rover as safe.');
end
btn_overlayTerrain_Callback(hObject, eventdata, handles);

% --- Executes on button press in btn_overlayTerrain.
function btn_overlayTerrain_Callback(hObject, eventdata, handles)
% hObject    handle to btn_overlayTerrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global terrain; global context;
patches = findall(allchild(handles.kinectRGB),'Type','patch');

if isempty(patches)
    overlayTerrainGrid(handles.kinectRGB, terrain, context);
else
    delete(patches);
end

function edit_minFrontClearance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minFrontClearance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minFrontClearance as text
%        str2double(get(hObject,'String')) returns contents of edit_minFrontClearance as a double
oldminFrontClearance = get_param('robulink/minFrontClearance','Value');
newminFrontClearance = get(hObject,'String');
if sum(~isstrprop(newminFrontClearance,'digit')) == 0 % i.e. if actually a number
    set_param('robulink/minFrontClearance','Value',newminFrontClearance);
else
    set(hObject,'String',num2str(oldminFrontClearance));
end


% --- Executes during object creation, after setting all properties.
function edit_minFrontClearance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minFrontClearance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',get_param('robulink/minFrontClearance','Value'));


function edit_safetyOmega_Callback(hObject, eventdata, handles)
% hObject    handle to edit_safetyOmega (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_safetyOmega as text
%        str2double(get(hObject,'String')) returns contents of edit_safetyOmega as a double
oldsafetyOmega = get_param('robulink/safetyOmega','Value');
newsafetyOmega = get(hObject,'String');
if sum(~isstrprop(newsafetyOmega,'digit')) == 0 % i.e. if actually a number
    set_param('robulink/safetyOmega','Value',newsafetyOmega);
else
    set(hObject,'String',num2str(oldsafetyOmega));
end

% --- Executes during object creation, after setting all properties.
function edit_safetyOmega_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_safetyOmega (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',get_param('robulink/safetyOmega','Value'));

% --- Executes on button press in btn_setGoal.
function btn_setGoal_Callback(hObject, eventdata, handles)
% hObject    handle to btn_setGoal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global context; global depth;
global terrain; global T_rg;
global waypoints_g; global pathLength;

if ~isnan(T_rg)
    % Can't see the cursor if patches are in the display
    patches = findall(allchild(handles.kinectRGB),'Type','patch');
    delete(patches);
    
    [x,y] = ginput(1);
    realWorldPoints = mxNiConvertProjectiveToRealWorld(context, depth) / 1000;
    goal_k = realWorldPoints(round(y),round(x),:);
    goal_g = homo2cart(terrain.T_gk * cart2homo(goal_k(:)));
    roverpos_g = homo2cart(T_rg \ [0;0;0;1]);
    [waypoints_g, pathLength] = getPathSegments(handles.kinectOverlays,roverpos_g(1), roverpos_g(2), goal_g(1), goal_g(2), terrain);
    btn_overlayPath_Callback(hObject, eventdata, handles)
else
    disp('Warning: Rover has not been localized. Can''t set nav goal.');
end

% --- Executes on button press in btn_trainBallDetector.
function btn_trainBallDetector_Callback(hObject, eventdata, handles)
% hObject    handle to btn_trainBallDetector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global trackingStruct;
global context;
global isTrackingCalibrated;
trackingStruct = calibrateTracking(context);
isTrackingCalibrated = true;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global context; global option;
global isContextDeleted;

if isContextDeleted
    [context,option] = createKinectContext();
    isContextDeleted = false;
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global context; global isContextDeleted;

if ~isContextDeleted
    mxNiDeleteContext(context);
    isContextDeleted = true;
end


% --- Executes on button press in btn_followPath.
function btn_followPath_Callback(hObject, eventdata, handles)
% hObject    handle to btn_followPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global atGoal;
atGoal = false;


% --- Executes when selected object is changed in btnGroup_teleop.
function btnGroup_teleop_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in btnGroup_teleop 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global enableTeleopMode;
selection = get(eventdata.NewValue, 'String');

switch(selection)
    case 'Manual'
        enableTeleopMode = true;
        set_param('robulink/teleop','Value','true');
    case 'Automatic'
        enableTeleopMode = false;
        set_param('robulink/teleop','Value','false');
end

% --- Executes on button press in btn_selectFrame.
function btn_selectFrame_Callback(hObject, eventdata, handles)
% hObject    handle to btn_selectFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_exportMap.
function btn_exportMap_Callback(hObject, eventdata, handles)
% hObject    handle to btn_exportMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_EmergStop.
function btn_EmergStop_Callback(hObject, eventdata, handles)
% hObject    handle to btn_EmergStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global atGoal;
atGoal = true;
brake();
disp('Warning: E-Stopped');
