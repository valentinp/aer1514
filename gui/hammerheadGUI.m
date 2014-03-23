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

% Last Modified by GUIDE v2.5 22-Mar-2014 20:18:49

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
global context; global depth;
addSample(context, depth);


% --- Executes on button press in btn_clearSamples.
function btn_clearSamples_Callback(hObject, eventdata, handles)
% hObject    handle to btn_clearSamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samplesList; global samplesTable;
samplesList = [];
set(samplesTable, 'Data', samplesList);



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


% --- Executes on button press in btn_selectGoal.
function btn_selectGoal_Callback(hObject, eventdata, handles)
% hObject    handle to btn_selectGoal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_terrainAssessment.
function btn_terrainAssessment_Callback(hObject, eventdata, handles)
% hObject    handle to btn_terrainAssessment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global terrain;
terrain = terrainAssessment(context,rgb,depth,1);

terrainAssessment_T_rg = localizeRover(context,rgb,depth, terrain.T_gk);
terrain = markTerrainAroundRoverSafe(terrain,terrainAssessment_T_rg);

% --- Executes on button press in btn_overlayTerrain.
function btn_overlayTerrain_Callback(hObject, eventdata, handles)
% hObject    handle to btn_overlayTerrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
global terrain;
[x,y] = ginput(1);
goal_k = mxNiConvertProjectiveToRealWorld(context, depth) / 1000;
goal_g = homo2cart(terrain.T_gk * cart2homo(goal_k(:)));
goalX_g = goal_g(1); goalY_g = goal_g(2);

% --- Executes on button press in btn_trainBallDetector.
function btn_trainBallDetector_Callback(hObject, eventdata, handles)
% hObject    handle to btn_trainBallDetector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
