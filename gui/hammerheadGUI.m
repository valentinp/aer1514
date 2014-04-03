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

% Last Modified by GUIDE v2.5 03-Apr-2014 08:20:07

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
global enableTeleopMode; global calibStruct; global sampleList_k;
global maxDepth;

% Initialize kinect images in gui
handles.kinectRGB_image = imshow(zeros(height,width,3,'uint8'), 'Parent', handles.kinectRGB);
handles.kinectDepth_image = imagesc(zeros(height,width,'uint16'), 'Parent', handles.kinectDepth);
% handles.kinectOverlays_image = imshow(zeros(height,width,3,'uint8'),'Parent', handles.kinectOverlays);
handles.overSample_image = imshow(zeros(100,100,3,'uint8'), 'Parent', handles.overSample);

set(handles.kinectDepth, 'XTick',[],'YTick',[]); % Apparently imagesc creates these again
set(handles.kinectDepth, 'CLim', [0,maxDepth]);

% Initialize teleop radio button
set(handles.radio_teleop,'Value',enableTeleopMode);
set(handles.radio_auto,'Value',~enableTeleopMode);

if str2num(get_param('robulink/armPower','Value')) > 0
    set(handles.checkbox_armSwing,'Value', 1);
else
    set(handles.checkbox_armSwing,'Value', 0);
end


if enableTeleopMode
    set_param('robulink/teleop','Value','true');
else
    set_param('robulink/teleop','Value','false');
end

% Set up samples list
sampleList_k = [];

% Choose default command line output for hammerheadGUI
handles.output = hObject;

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
global context; global option; 
global depth;
global sampleList_k;

newSamples = fetchSamples(context, depth);
sampleList_k = [sampleList_k newSamples];
set(handles.table_samples, 'Data', sampleList_k);
drawnow;


% --- Executes on button press in btn_clearAllSamples.
function btn_clearAllSamples_Callback(hObject, eventdata, handles)
% hObject    handle to btn_clearAllSamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sampleList_k;
sampleList_k = [];
set(handles.table_samples, 'Data', sampleList_k);
drawnow;


function edit_leftWheelGain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_leftWheelGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_leftWheelGain as text
%        str2double(get(hObject,'String')) returns contents of edit_leftWheelGain as a double
oldkl = get_param('robulink/kl','Value');
newkl = get(hObject,'String');
if sum(~(isstrprop(newkl,'digit') | newkl == '.')) == 0 % i.e. if actually a number
    set_param('robulink/kl','Value',newkl);
else
    set(hObject,'String',num2str(oldkl));
end
drawnow;

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
drawnow;

function edit_rightWheelGain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rightWheelGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rightWheelGain as text
%        str2double(get(hObject,'String')) returns contents of edit_rightWheelGain as a double
oldkr = get_param('robulink/kr','Value');
newkr = get(hObject,'String');
if sum(~(isstrprop(newkr,'digit') | newkr == '.')) == 0 % i.e. if actually a number
    set_param('robulink/kr','Value',newkr);
else
    set(hObject,'String',num2str(oldkr));
end
drawnow;

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
drawnow;

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
drawnow;

% --- Executes on button press in btn_terrainAssessment_automatic.
function btn_terrainAssessment_automatic_Callback(hObject, eventdata, handles)
% hObject    handle to btn_terrainAssessment_automatic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global terrain; global context; global option

% Don't use the backfilled depths for terrain assessment
mxNiUpdateContext(context, option);
[~,depth] = getKinectData(context, option);

terrain = terrainAssessment(context,depth,1);

imagesc(terrain.safeCells, 'Parent', handles.kinectOverlays);
set(handles.kinectOverlays, 'XTick',[],'YTick',[],'XDir','Normal','YDir','Normal');

patches = findall(allchild(handles.kinectRGB),'Type','patch');
delete(patches);
btn_overlayTerrain_Callback(hObject, eventdata, handles);
drawnow;

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
drawnow;

function edit_minFrontClearance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minFrontClearance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minFrontClearance as text
%        str2double(get(hObject,'String')) returns contents of edit_minFrontClearance as a double
oldminFrontClearance = get_param('robulink/minFrontClearance','Value');
newminFrontClearance = get(hObject,'String');
if sum(~(isstrprop(newminFrontClearance,'digit') | newminFrontClearance == '.')) == 0 % i.e. if actually a number
    set_param('robulink/minFrontClearance','Value',newminFrontClearance);
else
    set(hObject,'String',num2str(oldminFrontClearance));
end
drawnow;

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
if sum(~(isstrprop(newsafetyOmega,'digit') | newsafetyOmega == '.')) == 0 % i.e. if actually a number
    set_param('robulink/safetyOmega','Value',newsafetyOmega);
else
    set(hObject,'String',num2str(oldsafetyOmega));
end
drawnow;

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
drawnow;

% --- Executes on button press in btn_trainBallDetector.
function btn_trainBallDetector_Callback(hObject, eventdata, handles)
% hObject    handle to btn_trainBallDetector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global calibStruct;
global context;
global isTrackingCalibrated;
global rgbObjectMask;

rgbObjectMask = false(size(rgbObjectMask));
calibStruct = calibrateTracking(context);
isTrackingCalibrated = true;
drawnow;

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global context; global option;
global isContextDeleted;
global maxDepth;

if isContextDeleted
    [context,option] = createKinectContext();
    mxNiSetProperty(context,'MaxDepthValue',maxDepth);
%     mxNiSetProperty(context,'WhiteBalancedEnabled',0);
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
drawnow;

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
drawnow;

% --- Executes on button press in btn_selectFrame.
function btn_selectFrame_Callback(hObject, eventdata, handles)
% hObject    handle to btn_selectFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global framePoints_k; global context;
global rgb; global depth;
framePoints_k = selectFrame(context, rgb, depth);
drawnow;


% --- Executes on button press in btn_exportMap.
function btn_exportMap_Callback(hObject, eventdata, handles)
% hObject    handle to btn_exportMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global context; 
global sampleList_k;
global framePoints_k;

exportMap(sampleList_k, framePoints_k);

% if ~isnan(T_mk) 
%     exportMap(sampleList_k);
% else
%     T_mk = selectFrame(context);
%     exportMap(sampleList_k);
% end
drawnow;


% --- Executes on button press in btn_EmergStop.
function btn_EmergStop_Callback(hObject, eventdata, handles)
% hObject    handle to btn_EmergStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global atGoal;
atGoal = true;
brake();
disp('Warning: E-Stopped');
drawnow;


function edit_v_Callback(hObject, eventdata, handles)
% hObject    handle to edit_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_v as text
%        str2double(get(hObject,'String')) returns contents of edit_v as a double
global v;

newv = get(hObject,'String');
if sum(~(isstrprop(newv,'digit') | newv == '.')) == 0 % i.e. if actually a number
    v = str2double(newv);
end

set(hObject,'String',num2str(v));
drawnow;

% --- Executes during object creation, after setting all properties.
function edit_v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global v;

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', num2str(v));


function edit_k1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_k1 as text
%        str2double(get(hObject,'String')) returns contents of edit_k1 as a double
global k1;

newk1 = get(hObject,'String');
if sum(~(isstrprop(newk1,'digit') | newk1 == '.')) == 0 % i.e. if actually a number
    k1 = str2double(newk1);
end

set(hObject,'String',num2str(k1));
drawnow;

% --- Executes during object creation, after setting all properties.
function edit_k1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global k1;

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',num2str(k1));


function edit_k2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_k2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_k2 as text
%        str2double(get(hObject,'String')) returns contents of edit_k2 as a double
global k2;

newk2 = get(hObject,'String');
if sum(~(isstrprop(newk2,'digit') | newk2 == '.')) == 0 % i.e. if actually a number
    k2 = str2double(newk2);
end

set(hObject,'String',num2str(k2));
drawnow;

% --- Executes during object creation, after setting all properties.
function edit_k2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_k2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global k2;

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',num2str(k2));


% --- Executes on button press in btn_terrainAssessment_manual.
function btn_terrainAssessment_manual_Callback(hObject, eventdata, handles)
% hObject    handle to btn_terrainAssessment_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global terrain; global context; global option;

% Don't use the backfilled depths for terrain assessment
mxNiUpdateContext(context, option);
[~,depth] = getKinectData(context, option);

terrain = terrainAssessment(context,depth,0);

patches = findall(allchild(handles.kinectRGB),'Type','patch');
delete(patches);
btn_overlayTerrain_Callback(hObject, eventdata, handles);

drawnow;


% --- Executes on button press in btn_markRoverRegionSafe.
function btn_markRoverRegionSafe_Callback(hObject, eventdata, handles)
% hObject    handle to btn_markRoverRegionSafe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global terrain; global T_rg;

if ~isnan(T_rg)
    terrain = markTerrainAroundRoverSafe(terrain,T_rg);
else
    disp('Warning: Rover has not been localized. Can''t mark terrain around rover as safe.');
end

patches = findall(allchild(handles.kinectRGB),'Type','patch');
delete(patches);
btn_overlayTerrain_Callback(hObject, eventdata, handles);

drawnow;



function edit_lightDetectorThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lightDetectorThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lightDetectorThreshold as text
%        str2double(get(hObject,'String')) returns contents of edit_lightDetectorThreshold as a double

oldthresh = get_param('robulink/sampleThresh','Value');
newthresh = get(hObject,'String');
if sum(~(isstrprop(newthresh,'digit') | newthresh == '.')) == 0 % i.e. if actually a number
    set_param('robulink/sampleThresh','Value',newthresh);
else
    set(hObject,'String',num2str(oldthresh));
end
drawnow;


% --- Executes during object creation, after setting all properties.
function edit_lightDetectorThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lightDetectorThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',get_param('robulink/sampleThresh','Value'));



function edit_v_teleop_Callback(hObject, eventdata, handles)
% hObject    handle to edit_v_teleop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_v_teleop as text
%        str2double(get(hObject,'String')) returns contents of edit_v_teleop as a double
global v_teleop;

newv = get(hObject,'String');
if sum(~(isstrprop(newv,'digit') | newv == '.')) == 0 % i.e. if actually a number
    v_teleop = str2double(newv);
end

set(hObject,'String',num2str(v_teleop));
drawnow;

% --- Executes during object creation, after setting all properties.
function edit_v_teleop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_v_teleop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global v_teleop;

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', num2str(v_teleop));

function edit_omega_teleop_Callback(hObject, eventdata, handles)
% hObject    handle to edit_omega_teleop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_omega_teleop as text
%        str2double(get(hObject,'String')) returns contents of edit_omega_teleop as a double
global omega_teleop;

newomega = get(hObject,'String');
if sum(~(isstrprop(newomega,'digit') | newomega == '.')) == 0 % i.e. if actually a number
    omega_teleop = str2double(newomega);
end

set(hObject,'String',num2str(omega_teleop));
drawnow;

% --- Executes during object creation, after setting all properties.
function edit_omega_teleop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_omega_teleop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global omega_teleop;

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', num2str(omega_teleop));



function edit_armPower_Callback(hObject, eventdata, handles)
% hObject    handle to edit_armPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_armPower as text
%        str2double(get(hObject,'String')) returns contents of edit_armPower as a double
oldpower = get_param('robulink/armPower','Value');
newpower = get(hObject,'String');
if sum(~(isstrprop(newpower,'digit') | newpower == '.')) == 0 % i.e. if actually a number
    set_param('robulink/armPower','Value',newpower);
else
    set(hObject,'String',num2str(oldpower));
end
drawnow;

% --- Executes during object creation, after setting all properties.
function edit_armPower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_armPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',get_param('robulink/armPower','Value'));



function edit_vAbsMax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_vAbsMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_vAbsMax as text
%        str2double(get(hObject,'String')) returns contents of edit_vAbsMax as a double
global vAbsMax;

newv = get(hObject,'String');
if sum(~(isstrprop(newv,'digit') | newv == '.')) == 0 % i.e. if actually a number
    vAbsMax = str2double(newv);
end

set(hObject,'String',num2str(vAbsMax));
drawnow;

% --- Executes during object creation, after setting all properties.
function edit_vAbsMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_vAbsMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global vAbsMax;

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', num2str(vAbsMax));

function edit_omegaAbsMax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_omegaAbsMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_omegaAbsMax as text
%        str2double(get(hObject,'String')) returns contents of edit_omegaAbsMax as a double
global omegaAbsMax;

newomega = get(hObject,'String');
if sum(~(isstrprop(newomega,'digit') | newomega == '.')) == 0 % i.e. if actually a number
    omegaAbsMax = str2double(newomega);
end

set(hObject,'String',num2str(omegaAbsMax));
drawnow;

% --- Executes during object creation, after setting all properties.
function edit_omegaAbsMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_omegaAbsMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global omegaAbsMax;

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', num2str(omegaAbsMax));


% % --- Executes on button press in btn_addSampleOnGround.
% function btn_addSampleOnGround_Callback(hObject, eventdata, handles)
% % hObject    handle to btn_addSampleOnGround (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% global context; global depth; global terrain; 
% global U; global V;
% global sampleList_k;
% 
% if isfield(terrain,'m')
%     groundDepth = zeros(size(depth));
%     [groundDepth,~] = fillMissingDepthWithGroundPlane(context, groundDepth, U, V, terrain.m, terrain.n, terrain.p);
%     newSamples = fetchSamples(context, groundDepth);
%     sampleList_k = [sampleList_k newSamples];
%     set(handles.table_samples, 'Data', sampleList_k);
% else
%     disp('Can''t add sample on ground until terrain assessment has been run.');
% end
% drawnow;

% --- Executes on button press in btn_addSampleAtRover.
function btn_addSampleAtRover_Callback(hObject, eventdata, handles)
% hObject    handle to btn_addSampleAtRover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global T_rg; global terrain; global sampleList_k;

if ~isnan(T_rg)
    % T_kg * T_gr * [0;0;0;1]
    newSamples = homo2cart(terrain.T_kg * (T_rg \ [0;0;0;1]));
    sampleList_k = [sampleList_k newSamples];
    set(handles.table_samples, 'Data', sampleList_k);
else
    disp('Rover is not localized. Can''t add sample at rover.');
end
drawnow;

% --- Executes on button press in btn_clearLastSample.
function btn_clearLastSample_Callback(hObject, eventdata, handles)
% hObject    handle to btn_clearLastSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sampleList_k;

if ~isempty(sampleList_k)
    sampleList_k = sampleList_k(:,1:end-1);
    set(handles.table_samples, 'Data', sampleList_k);
else
    disp('Can''t delete last sample since sample list is already empty.');
end
drawnow;


% --- Executes on button press in btn_addObjectMask.
function btn_addObjectMask_Callback(hObject, eventdata, handles)
% hObject    handle to btn_addObjectMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global context;
global rgbObjectMask;

rgbObjectMask = addPolygonMask(context, rgbObjectMask);

% --- Executes on button press in btn_localizeManual.
function btn_localizeManual_Callback(hObject, eventdata, handles)
% hObject    handle to btn_localizeManual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global localizeManuallyThisIter;

localizeManuallyThisIter = true;


% --- Executes on button press in checkbox_armSwing.
function checkbox_armSwing_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_armSwing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_armSwing
if get(hObject,'Value') % i.e. if actually a number
    set_param('robulink/armPower','Value', '25');
else
    set_param('robulink/armPower','Value', '0');
end
drawnow;
