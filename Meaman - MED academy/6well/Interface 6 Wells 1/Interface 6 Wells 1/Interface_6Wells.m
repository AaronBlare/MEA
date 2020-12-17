function varargout = Interface_6Wells(varargin)
%INTERFACE_6WELLS M-file for Interface_6Wells.fig
%      INTERFACE_6WELLS, by itself, creates a new INTERFACE_6WELLS or raises the existing
%      singleton*.
%
%      H = INTERFACE_6WELLS returns the handle to a new INTERFACE_6WELLS or the handle to
%      the existing singleton*.
%
%      INTERFACE_6WELLS('Property','Value',...) creates a new INTERFACE_6WELLS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Interface_6Wells_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      INTERFACE_6WELLS('CALLBACK') and INTERFACE_6WELLS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in INTERFACE_6WELLS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interface_6Wells

% Last Modified by GUIDE v2.5 26-May-2010 12:44:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interface_6Wells_OpeningFcn, ...
                   'gui_OutputFcn',  @Interface_6Wells_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Interface_6Wells is made visible.
function Interface_6Wells_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Interface_6Wells
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interface_6Wells wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Interface_6Wells_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in togglebutton_A1.
function togglebutton_A1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_A1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_A1


% --- Executes on button press in togglebutton_A2.
function togglebutton_A2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_A2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_A2


% --- Executes on button press in togglebutton_A3.
function togglebutton_A3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_A3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_A3


% --- Executes on button press in togglebutton_A4.
function togglebutton_A4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_A4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_A4


% --- Executes on button press in togglebutton_A5.
function togglebutton_A5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_A5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_A5


% --- Executes on button press in togglebutton_A6.
function togglebutton_A6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_A6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_A6


% --- Executes on button press in togglebutton_A7.
function togglebutton_A7_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_A7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_A7


% --- Executes on button press in togglebutton_A8.
function togglebutton_A8_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_A8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_A8


% --- Executes on button press in togglebutton_A9.
function togglebutton_A9_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_A9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_A9


% --- Executes on button press in togglebutton_B1.
function togglebutton_B1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_B1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_B1


% --- Executes on button press in togglebutton_B2.
function togglebutton_B2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_B2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_B2


% --- Executes on button press in togglebutton_B3.
function togglebutton_B3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_B3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_B3


% --- Executes on button press in togglebutton_B4.
function togglebutton_B4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_B4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_B4


% --- Executes on button press in togglebutton_B5.
function togglebutton_B5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_B5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_B5


% --- Executes on button press in togglebutton_B6.
function togglebutton_B6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_B6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_B6


% --- Executes on button press in togglebutton_B7.
function togglebutton_B7_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_B7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_B7


% --- Executes on button press in togglebutton_B8.
function togglebutton_B8_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_B8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_B8


% --- Executes on button press in togglebutton_B9.
function togglebutton_B9_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_B9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_B9


% --- Executes on button press in togglebutton_C1.
function togglebutton_C1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_C1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_C1


% --- Executes on button press in togglebutton_C2.
function togglebutton_C2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_C2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_C2


% --- Executes on button press in togglebutton_C3.
function togglebutton_C3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_C3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_C3


% --- Executes on button press in togglebutton_C4.
function togglebutton_C4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_C4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_C4


% --- Executes on button press in togglebutton_C5.
function togglebutton_C5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_C5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_C5


% --- Executes on button press in togglebutton_C6.
function togglebutton_C6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_C6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_C6


% --- Executes on button press in togglebutton_C7.
function togglebutton_C7_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_C7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton_C8.
function togglebutton_C8_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_C8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_C8


% --- Executes on button press in togglebutton_C9.
function togglebutton_C9_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_C9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_C9


% --- Executes on button press in togglebutton_D1.
function togglebutton_D1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_D1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_D1


% --- Executes on button press in togglebutton_D2.
function togglebutton_D2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_D2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_D2


% --- Executes on button press in togglebutton_D3.
function togglebutton_D3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_D3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_D3


% --- Executes on button press in togglebutton_D4.
function togglebutton_D4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_D4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_D4


% --- Executes on button press in togglebutton_D5.
function togglebutton_D5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_D5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_D5


% --- Executes on button press in togglebutton_D6.
function togglebutton_D6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_D6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_D6


% --- Executes on button press in togglebutton_D7.
function togglebutton_D7_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_D7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_D7


% --- Executes on button press in togglebutton_D8.
function togglebutton_D8_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_D8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_D8


% --- Executes on button press in togglebutton_D9.
function togglebutton_D9_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_D9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_D9


% --- Executes on button press in togglebutton_E1.
function togglebutton_E1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_E1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_E1


% --- Executes on button press in togglebutton_E2.
function togglebutton_E2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_E2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_E2


% --- Executes on button press in togglebutton_E3.
function togglebutton_E3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_E3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_E3


% --- Executes on button press in togglebutton_E4.
function togglebutton_E4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_E4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_E4


% --- Executes on button press in togglebutton_E5.
function togglebutton_E5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_E5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_E5


% --- Executes on button press in togglebutton_E6.
function togglebutton_E6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_E6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_E6


% --- Executes on button press in togglebutton_E7.
function togglebutton_E7_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_E7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_E7


% --- Executes on button press in togglebutton_E8.
function togglebutton_E8_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_E8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_E8


% --- Executes on button press in togglebutton_E9.
function togglebutton_E9_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_E9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton_F1.
function togglebutton_F1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_F1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_F1


% --- Executes on button press in togglebutton_F2.
function togglebutton_F2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_F2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_F2


% --- Executes on button press in togglebutton_F3.
function togglebutton_F3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_F3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_F3


% --- Executes on button press in togglebutton_F4.
function togglebutton_F4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_F4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_F4


% --- Executes on button press in togglebutton_F5.
function togglebutton_F5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_F5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_F5


% --- Executes on button press in togglebutton_F6.
function togglebutton_F6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_F6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_F6


% --- Executes on button press in togglebutton_F7.
function togglebutton_F7_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_F7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_F7


% --- Executes on button press in togglebutton_F8.
function togglebutton_F8_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_F8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_F8


% --- Executes on button press in togglebutton_F9.
function togglebutton_F9_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_F9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_F9


% --- Executes on button press in pushbutton_input.
function pushbutton_input_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning off;
handles.exp_folder = uigetdir(pwd,'Select the experiment folder');
if strcmp(num2str(handles.exp_folder),'0')
    errordlg('Selection failed: end of session','Error')
    return
end

cd(handles.exp_folder);
%[folder]=searchfolderMF(pwd,'PeakDetectionMAT');
%a=strfind(folder{1,1},'_Peak');
[folder]=searchfolderMF(pwd,'Mat_');
a=strfind(folder{1,1},'_Mat');
b=strfind(folder{1,1},'\');
handles.exp_num=folder{1,1}(b(end,end)+1:a(1,1)-1);  % Trovo il numero dell'esperimento
handles.result_folder = strcat(handles.exp_num,'_6WellsAnalysis');

cd (handles.exp_folder)
mkdir (handles.result_folder);      % Viene creata la cartella dei risultati relativi 
cd ..                               % all'esperimento selezionato dall'utente
handles.end_folder = strcat(handles.exp_folder,'\',handles.exp_num,'_6WellsAnalysis');
cd (handles.end_folder);
handles.sub_A=strcat(handles.exp_num,'a');
handles.sub_B=strcat(handles.exp_num,'b');
handles.sub_C=strcat(handles.exp_num,'c');
handles.sub_D=strcat(handles.exp_num,'d');
handles.sub_E=strcat(handles.exp_num,'e');
handles.sub_F=strcat(handles.exp_num,'f');
mkdir (handles.sub_A);
mkdir (handles.sub_B);
mkdir (handles.sub_C);
mkdir (handles.sub_D);
mkdir (handles.sub_E);
mkdir (handles.sub_F);

handles.subfolder_A=strcat(handles.end_folder,'\',handles.exp_num,'a');
handles.subfolder_B=strcat(handles.end_folder,'\',handles.exp_num,'b');
handles.subfolder_C=strcat(handles.end_folder,'\',handles.exp_num,'c');
handles.subfolder_D=strcat(handles.end_folder,'\',handles.exp_num,'d');
handles.subfolder_E=strcat(handles.end_folder,'\',handles.exp_num,'e');
handles.subfolder_F=strcat(handles.end_folder,'\',handles.exp_num,'f');

% cd (handles.subfolder_A);
% handles.peak_A=strcat(handles.exp_num,'A_PeakDetectionMAT');
% mkdir (handles.peak_A);
% cd ..
% cd (handles.subfolder_B);
% handles.peak_B=strcat(handles.exp_num,'B_PeakDetectionMAT');
% mkdir (handles.peak_B);
% cd ..
% cd (handles.subfolder_C);
% handles.peak_C=strcat(handles.exp_num,'C_PeakDetectionMAT');
% mkdir (handles.peak_C);
% cd ..
% cd (handles.subfolder_D);
% handles.peak_D=strcat(handles.exp_num,'D_PeakDetectionMAT');
% mkdir (handles.peak_D);
% cd ..
% cd (handles.subfolder_E);
% handles.peak_E=strcat(handles.exp_num,'E_PeakDetectionMAT');
% mkdir (handles.peak_E);
% cd ..
% cd (handles.subfolder_F);
% handles.peak_F=strcat(handles.exp_num,'F_PeakDetectionMAT');
% mkdir (handles.peak_F);
% 
% handles.peakfolder_A=strcat(handles.subfolder_A,'\',handles.exp_num,'A_PeakDetectionMAT');
% handles.peakfolder_B=strcat(handles.subfolder_B,'\',handles.exp_num,'B_PeakDetectionMAT');
% handles.peakfolder_C=strcat(handles.subfolder_C,'\',handles.exp_num,'C_PeakDetectionMAT');
% handles.peakfolder_D=strcat(handles.subfolder_D,'\',handles.exp_num,'D_PeakDetectionMAT');
% handles.peakfolder_E=strcat(handles.subfolder_E,'\',handles.exp_num,'E_PeakDetectionMAT');
% handles.peakfolder_F=strcat(handles.subfolder_F,'\',handles.exp_num,'F_PeakDetectionMAT');

cd (handles.subfolder_A);
handles.peak_A=strcat(handles.exp_num,'a_Mat_files');
mkdir (handles.peak_A);
cd ..
cd (handles.subfolder_B);
handles.peak_B=strcat(handles.exp_num,'b_Mat_files');
mkdir (handles.peak_B);
cd ..
cd (handles.subfolder_C);
handles.peak_C=strcat(handles.exp_num,'c_Mat_files');
mkdir (handles.peak_C);
cd ..
cd (handles.subfolder_D);
handles.peak_D=strcat(handles.exp_num,'d_Mat_files');
mkdir (handles.peak_D);
cd ..
cd (handles.subfolder_E);
handles.peak_E=strcat(handles.exp_num,'e_Mat_files');
mkdir (handles.peak_E);
cd ..
cd (handles.subfolder_F);
handles.peak_F=strcat(handles.exp_num,'f_Mat_files');
mkdir (handles.peak_F);

handles.peakfolder_A=strcat(handles.subfolder_A,'\',handles.exp_num,'a_Mat_files');
handles.peakfolder_B=strcat(handles.subfolder_B,'\',handles.exp_num,'b_Mat_files');
handles.peakfolder_C=strcat(handles.subfolder_C,'\',handles.exp_num,'c_Mat_files');
handles.peakfolder_D=strcat(handles.subfolder_D,'\',handles.exp_num,'d_Mat_files');
handles.peakfolder_E=strcat(handles.subfolder_E,'\',handles.exp_num,'e_Mat_files');
handles.peakfolder_F=strcat(handles.subfolder_F,'\',handles.exp_num,'f_Mat_files');

cd ..
cd ..
cd (folder{1,1});
% [ptrain]=searchfolderMF(pwd,'ptrain');
% s=size(ptrain,2);
[ptrain]=searchfolderMF(pwd,'_');
s=size(ptrain,2);
for i=1:s
    sl=strfind(ptrain{1,i},'\');
    name=ptrain{1,i}(sl(1,end)+1:end);
    cd ..
    cd (handles.peakfolder_A);
    peak_subfolder=(name);
    mkdir(peak_subfolder);
    handles.folder_A=strcat(handles.peakfolder_A,'\',name);
    cd (handles.peakfolder_B);
    peak_subfolder=(name);
    mkdir(peak_subfolder);
    handles.folder_B=strcat(handles.peakfolder_B,'\',name);
    cd (handles.peakfolder_C);
    peak_subfolder=(name);
    mkdir(peak_subfolder);
    handles.folder_C=strcat(handles.peakfolder_C,'\',name);
    cd (handles.peakfolder_D);
    peak_subfolder=(name);
    mkdir(peak_subfolder);
    handles.folder_D=strcat(handles.peakfolder_D,'\',name);
    cd (handles.peakfolder_E);
    peak_subfolder=(name);
    mkdir(peak_subfolder);
    handles.folder_E=strcat(handles.peakfolder_E,'\',name);
    cd (handles.peakfolder_F);
    peak_subfolder=(name);
    mkdir(peak_subfolder);
    handles.folder_F=strcat(handles.peakfolder_F,'\',name);
    
    cd ..
    cd ..
    cd ..
    cd (folder{1,1});
    cd (ptrain{1,i});
    [A1]=searchfolderMF(pwd,'_43');
    [A2]=searchfolderMF(pwd,'_42');
    [A3]=searchfolderMF(pwd,'_51');
    [A4]=searchfolderMF(pwd,'_44');
    [A5]=searchfolderMF(pwd,'_52');
    [A6]=searchfolderMF(pwd,'_53');
    [A7]=searchfolderMF(pwd,'_31');
    [A8]=searchfolderMF(pwd,'_41');
    [A9]=searchfolderMF(pwd,'_54');
    [A10]=searchfolderMF(pwd,'_32');
    copyfile(A1{1,1},handles.folder_A);
    copyfile(A2{1,1},handles.folder_A);
    copyfile(A3{1,1},handles.folder_A);
    copyfile(A4{1,1},handles.folder_A);
    copyfile(A5{1,1},handles.folder_A);
    copyfile(A6{1,1},handles.folder_A);
    copyfile(A7{1,1},handles.folder_A);
    copyfile(A8{1,1},handles.folder_A);
    copyfile(A9{1,1},handles.folder_A);
    copyfile(A10{1,1},handles.folder_A);

    
    [B1]=searchfolderMF(pwd,'_63');
    [B2]=searchfolderMF(pwd,'_82');
    [B3]=searchfolderMF(pwd,'_83');
    [B4]=searchfolderMF(pwd,'_71');
    [B5]=searchfolderMF(pwd,'_73');
    [B6]=searchfolderMF(pwd,'_64');
    [B7]=searchfolderMF(pwd,'_62');
    [B8]=searchfolderMF(pwd,'_72');
    [B9]=searchfolderMF(pwd,'_74');
    [B10]=searchfolderMF(pwd,'_61');
    copyfile(B1{1,1},handles.folder_B);
    copyfile(B2{1,1},handles.folder_B);
    copyfile(B3{1,1},handles.folder_B);
    copyfile(B4{1,1},handles.folder_B);
    copyfile(B5{1,1},handles.folder_B);
    copyfile(B6{1,1},handles.folder_B);
    copyfile(B7{1,1},handles.folder_B);
    copyfile(B8{1,1},handles.folder_B);
    copyfile(B9{1,1},handles.folder_B);
    copyfile(B10{1,1},handles.folder_B);

    
    [C1]=searchfolderMF(pwd,'_65');
    [C2]=searchfolderMF(pwd,'_76');
    [C3]=searchfolderMF(pwd,'_77');
    [C4]=searchfolderMF(pwd,'_75');
    [C5]=searchfolderMF(pwd,'_87');
    [C6]=searchfolderMF(pwd,'_66');
    [C7]=searchfolderMF(pwd,'_85');
    [C8]=searchfolderMF(pwd,'_86');
    [C9]=searchfolderMF(pwd,'_78');
    [C10]=searchfolderMF(pwd,'_84');
    copyfile(C1{1,1},handles.folder_C);
    copyfile(C2{1,1},handles.folder_C);
    copyfile(C3{1,1},handles.folder_C);
    copyfile(C4{1,1},handles.folder_C);
    copyfile(C5{1,1},handles.folder_C);
    copyfile(C6{1,1},handles.folder_C);
    copyfile(C7{1,1},handles.folder_C);
    copyfile(C8{1,1},handles.folder_C);
    copyfile(C9{1,1},handles.folder_C);
    copyfile(C10{1,1},handles.folder_C);

    [D1]=searchfolderMF(pwd,'_56');
    [D2]=searchfolderMF(pwd,'_57');
    [D3]=searchfolderMF(pwd,'_48');
    [D4]=searchfolderMF(pwd,'_55');
    [D5]=searchfolderMF(pwd,'_47');
    [D6]=searchfolderMF(pwd,'_46');
    [D7]=searchfolderMF(pwd,'_68');
    [D8]=searchfolderMF(pwd,'_58');
    [D9]=searchfolderMF(pwd,'_45');
    [D10]=searchfolderMF(pwd,'_67');
    copyfile(D1{1,1},handles.folder_D);
    copyfile(D2{1,1},handles.folder_D);
    copyfile(D3{1,1},handles.folder_D);
    copyfile(D4{1,1},handles.folder_D);
    copyfile(D5{1,1},handles.folder_D);
    copyfile(D6{1,1},handles.folder_D);
    copyfile(D7{1,1},handles.folder_D);
    copyfile(D8{1,1},handles.folder_D);
    copyfile(D9{1,1},handles.folder_D);
    copyfile(D10{1,1},handles.folder_D);
    
    [E1]=searchfolderMF(pwd,'_36');
    [E2]=searchfolderMF(pwd,'_17');
    [E3]=searchfolderMF(pwd,'_16');
    [E4]=searchfolderMF(pwd,'_28');
    [E5]=searchfolderMF(pwd,'_26');
    [E6]=searchfolderMF(pwd,'_35');
    [E7]=searchfolderMF(pwd,'_37');
    [E8]=searchfolderMF(pwd,'_27');
    [E9]=searchfolderMF(pwd,'_25');
    [E10]=searchfolderMF(pwd,'_38');    
    copyfile(E1{1,1},handles.folder_E);
    copyfile(E2{1,1},handles.folder_E);
    copyfile(E3{1,1},handles.folder_E);
    copyfile(E4{1,1},handles.folder_E);
    copyfile(E5{1,1},handles.folder_E);
    copyfile(E6{1,1},handles.folder_E);
    copyfile(E7{1,1},handles.folder_E);
    copyfile(E8{1,1},handles.folder_E);
    copyfile(E9{1,1},handles.folder_E);
    copyfile(E10{1,1},handles.folder_E);
    
    [F1]=searchfolderMF(pwd,'_34');
    [F2]=searchfolderMF(pwd,'_23');
    [F3]=searchfolderMF(pwd,'_22');
    [F4]=searchfolderMF(pwd,'_24');
    [F5]=searchfolderMF(pwd,'_12');
    [F6]=searchfolderMF(pwd,'_33');
    [F7]=searchfolderMF(pwd,'_14');
    [F8]=searchfolderMF(pwd,'_13');
    [F9]=searchfolderMF(pwd,'_21');
    [F10]=searchfolderMF(pwd,'_15');
    copyfile(F1{1,1},handles.folder_F);
    copyfile(F2{1,1},handles.folder_F);
    copyfile(F3{1,1},handles.folder_F);
    copyfile(F4{1,1},handles.folder_F);
    copyfile(F5{1,1},handles.folder_F);
    copyfile(F6{1,1},handles.folder_F);
    copyfile(F7{1,1},handles.folder_F);
    copyfile(F8{1,1},handles.folder_F);
    copyfile(F9{1,1},handles.folder_F);
    copyfile(F10{1,1},handles.folder_F);

end
set(handles.edit1,'String',handles.exp_folder);
set_on(handles);

guidata(hObject, handles);  


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_rasterplot.
function pushbutton_rasterplot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_rasterplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%val_A1=get(handles.togglebutton_A1, 'Value') %% E' 1 se il bottone è selezionato

val_A=get(handles.radiobutton_A, 'Value');
val_B=get(handles.radiobutton_B, 'Value');
val_C=get(handles.radiobutton_C, 'Value');
val_D=get(handles.radiobutton_D, 'Value');
val_E=get(handles.radiobutton_E, 'Value');
val_F=get(handles.radiobutton_F, 'Value');

val=[val_A val_B val_C val_D val_E val_F];
valindex= find(val);
som=sum(val);

cd(handles.exp_folder);
[well_folder]=searchfolderMF(pwd,'Wells');
start_folder=well_folder{1,1};

raster_6wells(start_folder,som,valindex,handles.end_folder,handles.subfolder_A);
msgbox ('Elaboration performed sussefully!','End Of Session', 'warn');

set(handles.radiobutton_A, 'Value',0);
set(handles.radiobutton_B, 'Value',0);
set(handles.radiobutton_C, 'Value',0);
set(handles.radiobutton_D, 'Value',0);
set(handles.radiobutton_E, 'Value',0);
set(handles.radiobutton_F, 'Value',0);


% --- Executes on button press in pushbutton_quit.
function pushbutton_quit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button = questdlg('Ready to quit?', ...
    'Exit Dialog','Yes','No','No');
switch button
    case 'Yes',
        close;
        
    case 'No',
        quit cancel;
end


% --- Executes on button press in radiobutton_A.
function radiobutton_A_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_A
value_A=get(handles.radiobutton_A, 'Value');

if value_A==1
    set(handles.togglebutton_A1, 'Value',1);
    set(handles.togglebutton_A2, 'Value',1);
    set(handles.togglebutton_A3, 'Value',1);
    set(handles.togglebutton_A4, 'Value',1);
    set(handles.togglebutton_A5, 'Value',1);
    set(handles.togglebutton_A6, 'Value',1);
    set(handles.togglebutton_A7, 'Value',1);
    set(handles.togglebutton_A8, 'Value',1);
    set(handles.togglebutton_A9, 'Value',1);

else
    set(handles.togglebutton_A1, 'Value',0);
    set(handles.togglebutton_A2, 'Value',0);
    set(handles.togglebutton_A3, 'Value',0);
    set(handles.togglebutton_A4, 'Value',0);
    set(handles.togglebutton_A5, 'Value',0);
    set(handles.togglebutton_A6, 'Value',0);
    set(handles.togglebutton_A7, 'Value',0);
    set(handles.togglebutton_A8, 'Value',0);
    set(handles.togglebutton_A9, 'Value',0);
end


% --- Executes on button press in radiobutton_B.
function radiobutton_B_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_B

value_B=get(handles.radiobutton_B, 'Value');

if value_B==1
    set(handles.togglebutton_B1, 'Value',1);
    set(handles.togglebutton_B2, 'Value',1);
    set(handles.togglebutton_B3, 'Value',1);
    set(handles.togglebutton_B4, 'Value',1);
    set(handles.togglebutton_B5, 'Value',1);
    set(handles.togglebutton_B6, 'Value',1);
    set(handles.togglebutton_B7, 'Value',1);
    set(handles.togglebutton_B8, 'Value',1);
    set(handles.togglebutton_B9, 'Value',1);

else
    set(handles.togglebutton_B1, 'Value',0);
    set(handles.togglebutton_B2, 'Value',0);
    set(handles.togglebutton_B3, 'Value',0);
    set(handles.togglebutton_B4, 'Value',0);
    set(handles.togglebutton_B5, 'Value',0);
    set(handles.togglebutton_B6, 'Value',0);
    set(handles.togglebutton_B7, 'Value',0);
    set(handles.togglebutton_B8, 'Value',0);
    set(handles.togglebutton_B9, 'Value',0);
end



% --- Executes on button press in radiobutton_C.
function radiobutton_C_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_C
value_C=get(handles.radiobutton_C, 'Value');

if value_C==1
    set(handles.togglebutton_C1, 'Value',1);
    set(handles.togglebutton_C2, 'Value',1);
    set(handles.togglebutton_C3, 'Value',1);
    set(handles.togglebutton_C4, 'Value',1);
    set(handles.togglebutton_C5, 'Value',1);
    set(handles.togglebutton_C6, 'Value',1);
    set(handles.togglebutton_C7, 'Value',1);
    set(handles.togglebutton_C8, 'Value',1);
    set(handles.togglebutton_C9, 'Value',1);

else
    set(handles.togglebutton_C1, 'Value',0);
    set(handles.togglebutton_C2, 'Value',0);
    set(handles.togglebutton_C3, 'Value',0);
    set(handles.togglebutton_C4, 'Value',0);
    set(handles.togglebutton_C5, 'Value',0);
    set(handles.togglebutton_C6, 'Value',0);
    set(handles.togglebutton_C7, 'Value',0);
    set(handles.togglebutton_C8, 'Value',0);
    set(handles.togglebutton_C9, 'Value',0);
end


% --- Executes on button press in radiobutton_D.
function radiobutton_D_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_D

value_D=get(handles.radiobutton_D, 'Value');

if value_D==1
    set(handles.togglebutton_D1, 'Value',1);
    set(handles.togglebutton_D2, 'Value',1);
    set(handles.togglebutton_D3, 'Value',1);
    set(handles.togglebutton_D4, 'Value',1);
    set(handles.togglebutton_D5, 'Value',1);
    set(handles.togglebutton_D6, 'Value',1);
    set(handles.togglebutton_D7, 'Value',1);
    set(handles.togglebutton_D8, 'Value',1);
    set(handles.togglebutton_D9, 'Value',1);

else
    set(handles.togglebutton_D1, 'Value',0);
    set(handles.togglebutton_D2, 'Value',0);
    set(handles.togglebutton_D3, 'Value',0);
    set(handles.togglebutton_D4, 'Value',0);
    set(handles.togglebutton_D5, 'Value',0);
    set(handles.togglebutton_D6, 'Value',0);
    set(handles.togglebutton_D7, 'Value',0);
    set(handles.togglebutton_D8, 'Value',0);
    set(handles.togglebutton_D9, 'Value',0);
end

% --- Executes on button press in radiobutton_E.
function radiobutton_E_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_E
value_E=get(handles.radiobutton_E, 'Value');

if value_E==1
    set(handles.togglebutton_E1, 'Value',1);
    set(handles.togglebutton_E2, 'Value',1);
    set(handles.togglebutton_E3, 'Value',1);
    set(handles.togglebutton_E4, 'Value',1);
    set(handles.togglebutton_E5, 'Value',1);
    set(handles.togglebutton_E6, 'Value',1);
    set(handles.togglebutton_E7, 'Value',1);
    set(handles.togglebutton_E8, 'Value',1);
    set(handles.togglebutton_E9, 'Value',1);

else
    set(handles.togglebutton_E1, 'Value',0);
    set(handles.togglebutton_E2, 'Value',0);
    set(handles.togglebutton_E3, 'Value',0);
    set(handles.togglebutton_E4, 'Value',0);
    set(handles.togglebutton_E5, 'Value',0);
    set(handles.togglebutton_E6, 'Value',0);
    set(handles.togglebutton_E7, 'Value',0);
    set(handles.togglebutton_E8, 'Value',0);
    set(handles.togglebutton_E9, 'Value',0);
end


% --- Executes on button press in radiobutton_F.
function radiobutton_F_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_F
value_F=get(handles.radiobutton_F, 'Value');

if value_F==1
    set(handles.togglebutton_F1, 'Value',1);
    set(handles.togglebutton_F2, 'Value',1);
    set(handles.togglebutton_F3, 'Value',1);
    set(handles.togglebutton_F4, 'Value',1);
    set(handles.togglebutton_F5, 'Value',1);
    set(handles.togglebutton_F6, 'Value',1);
    set(handles.togglebutton_F7, 'Value',1);
    set(handles.togglebutton_F8, 'Value',1);
    set(handles.togglebutton_F9, 'Value',1);

else
    set(handles.togglebutton_F1, 'Value',0);
    set(handles.togglebutton_F2, 'Value',0);
    set(handles.togglebutton_F3, 'Value',0);
    set(handles.togglebutton_F4, 'Value',0);
    set(handles.togglebutton_F5, 'Value',0);
    set(handles.togglebutton_F6, 'Value',0);
    set(handles.togglebutton_F7, 'Value',0);
    set(handles.togglebutton_F8, 'Value',0);
    set(handles.togglebutton_F9, 'Value',0);
end

