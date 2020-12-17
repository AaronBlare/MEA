

function varargout = Meaman(varargin)
% meamanxz M-file for meamanxz.fig
%      meamanxz, by itself, creates a new meamanxz or raises the existing
%      singleton*.
%
%      H = meamanxz returns the handle to a new meamanxz or the handle to
%      the existing singleton*.
%
%      meamanxz('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in meamanxz.M with the given input arguments.
%
%      meamanxz('Property','Value',...) creates a new meamanxz or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before meamanxz_openingfcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to meamanxz_openingfcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help meamanxz

% Last Modified by GUIDE v2.5 02-Nov-2018 19:29:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @meamanxx_OpeningFcn, ...
                   'gui_OutputFcn',  @meamanxx_OutputFcn, ...
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


% --- Executes just before meamanxz is made visible.
function meamanxx_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to meamanxz (see VARARGIN)

% Choose default command line output for meamanxz
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes meamanxz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = meamanxx_OutputFcn(hObject, eventdata, handles) 
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
Raster ;


guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 a = get(handles.TimeBinEdit,'String');
TimeBin = str2num( a );

b = get(handles.editChannelNumAwsr,'String');
CHANNEL = str2num( b );

if (get(handles.checkbox1channel_awsr,'Value') == get(handles.checkbox1channel_awsr,'Max'))
   % Checkbox is checked-take approriate action
   MED_AWSR_1ch( TimeBin , CHANNEL )
else
   MED_AWSR( TimeBin ) ;  
end    



guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% a = get(handles.edit15,'String'); 
% a_to = get(handles.edit23,'String'); 
% x = get(handles.text19DT_bin,'String'); 
% art_c = get(handles.edit22Artc,'String'); 
% LFP_stim_num_c = get(handles.edit52_LFP_stim_num,'String'); 
% LFP_stim_num_arr = strread( LFP_stim_num_c ,  '%d '  ) ;  
%  
% % Take_all_spikes_after_stim = true ;
% 
%  if (get(handles.checkbox5msBin,'Value') == get(handles.checkbox5msBin,'Max'))
%    % Checkbox is checked-take approriate action
%    checkbox5msBin = true ;
% else
%    checkbox5msBin = false ;
%  end 
%  
% Search_Params.DT_bin = str2num( x{1} );
% Search_Params.PosStim_Interval_start = str2num( a );
% Search_Params.PosStim_Interval_end = str2num( a_to );
% Search_Params.Artefact_channel = str2num( art_c ); 
% 
%   if (get(handles.checkboxSubFolder,'Value') == get(handles.RelativeDurBox,'Max'))
%    % Checkbox is checked-take approriate action
%    files_subfolders = true ;
% else
%    files_subfolders= false ;
%   end
%  
% 
% 
% a = get(handles.SigmaEdit,'String');
% b = get(handles.edit24,'String');
% c = get(handles.edit25,'String');
% if (get(handles.checkboxArt,'Value') == get(handles.checkboxArt,'Max'))
%    ARTEFACTS_ON = 'y' ;
% else
%    ARTEFACTS_ON = 'n' ;
% end
% 
% if (get(handles.checkboLFP,'Value') == get(handles.checkboLFP,'Max'))
%    Arg_plus.Post_stim_potentials_collect   =  true ;
% else
%    Arg_plus.Post_stim_potentials_collect   =  false ;
% end
% 
% 
% sigma_from_sec = str2num( b );
% sigma_to_ms = str2num( c );
% SIGMATRES = str2num( a );
% % LFP_stim_num = str2num( LFP_stim_num_c );
% % LFP_stim_num_arr
% 
% if (get(handles.ListConvert,'Value') == get(handles.ListConvert,'Max'))
%    % Checkbox is checked-take approriate action
%    FILE_LIST_PROCESS = 'y' ;
% else
%    % Checkbox is not checked-take approriate action
%    FILE_LIST_PROCESS = 'n' ;
% end 
% 
% List_files2 = 'n' ;
%   
% if (get(handles.checkboxAutoAnalysis,'Value') == get(handles.checkboxAutoAnalysis,'Max'))
%     Auto_burst_analysis = true ;
% else
%     Auto_burst_analysis = false ;
% end
% 
% if (get(handles.checkboxPostStim,'Value') == get(handles.checkboxPostStim,'Max'))
%     AutoPostStim= true ;
% else
%     AutoPostStim = false ;
% end
% 
% if (get(handles.checkbox6well_detect,'Value') == get(handles.checkbox6well_detect,'Max'))
%     var.use_6well_mea = true ;
% else
%     var.use_6well_mea= false ;
% end




%--- Burst analysis parameters --------------------
 Find_bursts_GUI_input 
 
 
%     Search_Params = Global_flags.Search_Params ;
%     
%     Search_Params.SsuperBurst_scale_sec = SsuperBurst_scale_sec ;
%     Search_Params.Filter_small_bursts = Filter_small_bursts ;
%     Search_Params.Filter_Superbursts = Filter_Superbursts ;      
%     Search_Params.TimeBin = TimeBin ; 
%     Search_Params.AWSR_sig_tres = AWSR_sig_tres ;
%     Search_Params.save_bursts_to_files = save_bursts_to_files ;
%     Search_Params.List_files2 = List_files2 ;
%     Search_Params.Show_figures = true ;
%     Search_Params.Arg_file = Arg_file ;
%     Search_Params.use6well_raster = use6well_raster ;
% %     Search_Params.Simple_analysis = Simple_analysis;
%     Search_Params.Analyze_Connectiv = Analyze_Connectiv;

%---------------------------------------------------
Search_Params.Show_figures = false ;




 
% Arg_plus.Analyze_all_files_in_subfolders = files_subfolders ;
% Arg_plus.use_6well_mea = var.use_6well_mea ;
% Arg_plus.LFP_stim_num = LFP_stim_num_arr ; 




MED_Convert( SIGMATRES , FILE_LIST_PROCESS , ARTEFACTS_ON , sigma_from_sec ,  sigma_to_ms , ...
        Auto_burst_analysis , Search_Params , Search_Params , Arg_plus  )  

% end
% guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function SigmaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SigmaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ListConvert.
function ListConvert_Callback(hObject, eventdata, handles)
% hObject    handle to ListConvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of ListConvert
if (get(hObject,'Value') == get(hObject,'Max'))
   % Checkbox is checked-take approriate action
   FILE_LIST_PROCESS = 'y' ;
else
   % Checkbox is not checked-take approriate action
   FILE_LIST_PROCESS = 'n' ;
end
    
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(handles.checkboxBurstFile,'Value') == get(handles.checkboxBurstFile,'Max'))
    save_bursts_to_files = 'y' ;
else
    save_bursts_to_files = 'n' ;
end
    
 a = get(handles.TimeBinBurstEdit,'String');
 b = get(handles.BurstSigmaEdit,'String');
 
TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );


b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );

if (get(handles.checkbox1channel_burst,'Value') == get(handles.checkbox1channel_burst,'Max'))
   % Checkbox is checked-take approriate action
   MED_AWSR_1ch_Find_Bursts( TimeBin , CHANNEL , AWSR_sig_tres )
else
   MED_AWSR_Find_Bursts( TimeBin  , AWSR_sig_tres , save_bursts_to_files );
end



% end
guidata(hObject, handles);

function TimeBinEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TimeBinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeBinEdit as text
%        str2double(get(hObject,'String')) returns contents of TimeBinEdit as a double


% --- Executes during object creation, after setting all properties.
function TimeBinEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeBinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TimeBinBurstEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TimeBinBurstEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeBinBurstEdit as text
%        str2double(get(hObject,'String')) returns contents of TimeBinBurstEdit as a double


% --- Executes during object creation, after setting all properties.
function TimeBinBurstEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeBinBurstEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BurstSigmaEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BurstSigmaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BurstSigmaEdit as text
%        str2double(get(hObject,'String')) returns contents of BurstSigmaEdit as a double


% --- Executes during object creation, after setting all properties.
function BurstSigmaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BurstSigmaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function editChannelNumBurst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editChannelNumBurst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




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




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 a = get(handles.TimeBinEdit,'String');
TimeBin = str2num( a );

b = get(handles.editChannelNumAwsr,'String');
CHANNEL = str2num( b );

if (get(handles.checkbox1channel_awsr,'Value') == get(handles.checkbox1channel_awsr,'Max'))
   % Checkbox is checked-take approriate action
   MED_AmpRate_1ch( TimeBin , CHANNEL );
else
   MED_AmpRate( TimeBin ) ;  
end    





% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.*','Select file') ;
 a = get(handles.TimeBinEdit,'String');
TimeBin = str2num( a );


if filename ~= 0
filename
index_r = load(  char( filename )  ) ; 
params.show_figures = true ;
params.new_figure = false ;

figure
subplot( 2, 1, 1)
% awsr = AWSR_file(filename , pathname , TimeBin);
AWSR = AWSR_from_index_r( index_r , TimeBin , params);
subplot( 2, 1, 2)
% amprate = AmpRate_file(filename , pathname , TimeBin);
 AmpRate = AmpRate_from_index_r( index_r , TimeBin , params );

    


figure 
scatter( AmpRate , AWSR ) ;
xlabel( 'Amplitude rate, mV per bin')
ylabel( 'Spike rate, spikes per bin')

end




% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MED_InterChannels_Realtions



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = get(handles.TimeBinBurstEdit,'String');
 b = get(handles.BurstSigmaEdit,'String');
 
TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );

b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );

if (get(handles.RelativeDurBox,'Value') == get(handles.RelativeDurBox,'Max'))
   % Checkbox is checked-take approriate action
   d = true ;
else
   d = false ;
end

if (get(handles.checkboxClearSpace,'Value') == get(handles.checkboxClearSpace,'Max'))
   % Checkbox is checked-take approriate action
   e = true ;
else
  e = false ;
end
ADJUST_SPIKES = e ;


[filename, pathname] = uigetfile('*.*','Select file') ;
if filename ~= 0 
Init_dir = cd ;
cd( pathname ) ;        
AWSR = AWSR_file(filename,'-' , TimeBin );
 [burst_start,burst_max,burst_end] = Extract_bursts( AWSR ,TimeBin , AWSR_sig_tres) ;
burst_start = ( burst_start * 1000 ) ;
burst_max = ( burst_max * 1000 )  ;
burst_end = ( burst_end * 1000 ) ;
Cycle_P_val_process = 'n' ; 
PHASE_ON = d ;
 Def_bursts2 
%  S_matr_3
if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_AWSR_Bursts_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gcf,  figname ,'fig');
end
cd( Init_dir ) ;



end




% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;

if filename ~= 0
index_r = load( char( filename ) ) ;    
[filename2,pathname2] = uigetfile( '*.*' , 'Select file' ) ;    

if filename2 ~= 0
    

index_r2 = load( char( filename2 ) ) ;

Tmax = max( index_r( : , 1 ) ) ;
Tmax = Tmax + 0.1*Tmax ;
index_r2( : , 1 ) = index_r2( : , 1 ) + Tmax ;
index_r = [ index_r ; index_r2 ];

Raster_file = [ char(filename) 'add' ] ;
 fid = fopen(Raster_file , 'w');
fprintf(fid, '%.3f  %d  %.4f\n', index_r');
fclose(fid);

end
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 afrom = get(handles.edit_from,'String');
 ato = get(handles.edit_to,'String');
Edit_from = str2num( afrom )*1000;
Edit_to = str2num( ato )*1000;
N = 64 ;

[filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;

if filename ~= 0
index_r = load( char( filename ) ) ;   
whos index_r
       

       ss = find( index_r( : , 1 ) >= Edit_from & index_r( : , 1 ) < Edit_to ) ;
       if ~isempty( ss )
            index_r( ss , : ) = [] ;
        end 


whos index_r
Raster_file = [ char(filename) '_cut' ] ;
 fid = fopen(Raster_file , 'w');
 [a,p] = size(index_r);

 if p == 3 
fprintf(fid, '%.3f  %d  %.4f\n', index_r');
 else
fprintf(fid, '%.3f  %d\n', index_r');     
 end
fclose(fid);

end



function edit_from_Callback(hObject, eventdata, handles)
% hObject    handle to edit_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_from as text
%        str2double(get(hObject,'String')) returns contents of edit_from as a double


% --- Executes during object creation, after setting all properties.
function edit_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_to_Callback(hObject, eventdata, handles)
% hObject    handle to edit_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_to as text
%        str2double(get(hObject,'String')) returns contents of edit_to as a double


% --- Executes during object creation, after setting all properties.
function edit_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(handles.editStim,'String'); 
 
Diap_ms = str2num( a );
Stim_response( Diap_ms );


% --- Executes on button press in checkboxArt.
function checkboxArt_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxArt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxArt


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


a = get(handles.TimeBinBurstEdit,'String');
 b = get(handles.BurstSigmaEdit,'String');
 
TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );


b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );




[filename, pathname] = uigetfile('*.*','Select file') ;
if filename ~= 0 
Init_dir = cd ;
cd( pathname ) ;        
AWSR = AWSR_file(filename,'-' , TimeBin );
 [burst_start,burst_max,burst_end] = Extract_bursts( AWSR ,TimeBin , AWSR_sig_tres) ;
burst_start = ( burst_start * 1000 ) ;
burst_max = ( burst_max * 1000 )  ;
burst_end = ( burst_end * 1000 ) ;

 index_r = load( char( filename ) ) ; 
 
 
 
 
    for i=1:  length( burst_start   )  
       index_after_art = find( burst_start(i) <  index_r( : , 1 ) & burst_end(i) > index_r( : , 1 ) );
       index_r( index_after_art , : ) = [] ;
    end    
 
 
 Raster_file = [ char(filename) '_Burst_cut' ] ;
 fid = fopen(Raster_file , 'w');
fprintf(fid, '%.3f  %d  %.4f\n', index_r');
fclose(fid);
 
%  Def_bursts2 
%  S_matr_3


if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_AWSR_Bursts_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gcf,  figname ,'fig');
end
cd( Init_dir ) ;



end



function editStim_Callback(hObject, eventdata, handles)
% hObject    handle to editStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStim as text
%        str2double(get(hObject,'String')) returns contents of editStim as a double


% --- Executes during object creation, after setting all properties.
function editStim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function pushbutton4_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% a = get(handles.SigmaEdit,'String');
% b = get(handles.edit24,'String');


%  
% c = get(handles.edit25,'String');
% 
% if (get(handles.checkboxArt,'Value') == get(handles.checkboxArt,'Max'))
%    ARTEFACTS_ON = 'y' ;
% else
%    ARTEFACTS_ON = 'n' ;
% end
% 
% if (get(handles.checkboLFP,'Value') == get(handles.checkboLFP,'Max'))
%    Arg_plus.Post_stim_potentials_collect   =  true ;
% else
%    Arg_plus.Post_stim_potentials_collect  =  false ;
% end

% sigma_from_sec = str2num( b );
% sigma_to_ms = str2num( c );
% SIGMATRES = str2num( a );
% channel_to_analyze = str2num( ch );
% channel_to_analyze  = strread( ch ,  '%d '  ) ;  

 
% 
% if (get(handles.ListConvert,'Value') == get(handles.ListConvert,'Max'))
%    % Checkbox is checked-take approriate action
%    FILE_LIST_PROCESS = 'y' ;
% else
%    % Checkbox is not checked-take approriate action
%    FILE_LIST_PROCESS = 'n' ;
% end
% 
%  
% if (get(handles.checkbox6well_detect,'Value') == get(handles.checkbox6well_detect,'Max'))
%     var.use_6well_mea = true ;
% else
%     var.use_6well_mea= false ;
% end
% Arg_plus.use_6well_mea  = var.use_6well_mea ;
% 

%--- Burst analysis parameters --------------------
 Find_bursts_GUI_input 
% -------------------
ch = get(handles.edit26chan,'String');
channel_to_analyze  = readChanNum( ch    ) ;   
MED_Convert_1ch_artefact( SIGMATRES , 'n' , ARTEFACTS_ON , sigma_from_sec ,  sigma_to_ms ,channel_to_analyze , Arg_plus )  




guidata(hObject, handles);


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;

if filename ~= 0
index_r = load( char( filename ) ) ;    
   


Tmax = max( index_r( : , 1 ) ) ;
Tmax = Tmax + 0.1*Tmax ;
index_r( : , 1 ) = Tmax - index_r( : , 1 )  ;

Raster_file = [ char(filename) 'mirror' ] ;
 fid = fopen(Raster_file , 'w');
fprintf(fid, '%.3f  %d  %.4f\n', index_r');
fclose(fid);

end


% --- Executes on button press in checkboxBurstFile.
function checkboxBurstFile_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxBurstFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxBurstFile


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


a = get(handles.TimeBinBurstEdit,'String');
 b = get(handles.BurstSigmaEdit,'String');
 
TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );


b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );




[filename, pathname] = uigetfile('*.*','Select file') ;
if filename ~= 0 
Init_dir = cd ;
cd( pathname ) ;        
AWSR = AWSR_file(filename,'-' , TimeBin );
 [burst_start,burst_max,burst_end] = Extract_bursts( AWSR ,TimeBin , AWSR_sig_tres) ;
burst_start = ( burst_start * 1000 ) ;
burst_max = ( burst_max * 1000 )  ;
burst_end = ( burst_end * 1000 ) ;
Cycle_P_val_process = 'y' ; 
 Def_bursts2 
%  S_matr_3
if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;

end
cd( Init_dir ) ;




end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


a = get(handles.TimeBinBurstEdit,'String');
 b = get(handles.BurstSigmaEdit,'String');
 
TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );


b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );




[filename, pathname] = uigetfile('*.*','Select file') ;

 [filename2, pathname2] = uigetfile('*.*','Select file') ;
if filename ~= 0 
Init_dir = cd ;
cd( pathname ) ;        
AWSR = AWSR_file(filename,'-' , TimeBin );
 [burst_start,burst_max,burst_end] = Extract_bursts( AWSR ,TimeBin , AWSR_sig_tres) ;
burst_start = ( burst_start * 1000 ) ;
burst_max = ( burst_max * 1000 )  ;
burst_end = ( burst_end * 1000 ) ;
Cycle_P_val_process = 'n' ; 

   if filename2 ~= 0 
    cd( pathname2 ) ;        
    AWSR2 = AWSR_file(filename2,'-' , TimeBin );
    [burst_start2,burst_max2,burst_end2] = Extract_bursts( AWSR2 ,TimeBin , AWSR_sig_tres) ;
    burst_start2 = ( burst_start2 * 1000 ) ;
    burst_max2 = ( burst_max2 * 1000 )  ;
    burst_end2 = ( burst_end2 * 1000 ) ;
   end
    
%     nbursts ;
    Def_bursts2_load_2rasters_compare_total

%  S_matr_3
if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_AWSR_Bursts_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gcf,  figname ,'fig');
end
cd( Init_dir ) ;



end


% --- Executes when uipanel3 is resized.
function uipanel3_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Experiment_name = get(handles.edit_FILE_DB,'String');
a = get(handles.edit_sigmaDB ,'String'); 
Arg_file.Sigma_threshold =  str2num( a );
if (get(handles.checkboxDBmea,'Value') == get(handles.checkboxBurstFile,'Max'))
    Use_meaDB_raster = true ;
else
    Use_meaDB_raster = false ;
end
Arg_file.Use_meaDB_raster = Use_meaDB_raster ;
Arg_file.Experiment_name = Experiment_name ;


a = get(handles.TimeBinEdit,'String');
TimeBin = str2num( a );

b = get(handles.editChannelNumAwsr,'String');
CHANNEL = str2num( b );

if (get(handles.checkbox1channel_awsr,'Value') == get(handles.checkbox1channel_awsr,'Max'))
   % Checkbox is checked-take approriate action
   MED_AWSR_1ch( TimeBin , CHANNEL , Arg_file )
else
   MED_AWSR( TimeBin , Arg_file) ;  
end    


guidata(hObject, handles);


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 a = get(handles.TimeBinEdit,'String');
TimeBin = str2num( a );

b = get(handles.editChannelNumAwsr,'String');
CHANNEL = str2num( b );

if (get(handles.checkbox1channel_awsr,'Value') == get(handles.checkbox1channel_awsr,'Max'))
   % Checkbox is checked-take approriate action
   MED_AmpRate_1ch( TimeBin , CHANNEL );
else
   MED_AmpRate( TimeBin ) ;  
end 

% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--- Burst analysis parameters --------------------
 Find_bursts_GUI_input
%     Search_Params.SsuperBurst_scale_sec  
%     Search_Params.TimeBin  
%     Search_Params.AWSR_sig_tres 
%     Search_Params.save_bursts_to_files  
%     Search_Params.List_files2 
%     Search_Params.Arg_file 
%---------------------------------------------------
 
% %---- Get DB parameters -----------
%     Experiment_name = get(handles.edit_FILE_DB,'String');
%     Arg_file.Experiment_name = Experiment_name ;
% 
%     a = get(handles.edit_sigmaDB ,'String'); 
%     Arg_file.Sigma_threshold =  str2num( a );
% 
%     if (get(handles.checkboxDBmea,'Value') == get(handles.checkboxBurstFile,'Max'))
%         Use_meaDB_raster = true ;
%     else
%         Use_meaDB_raster = false ;
%     end
%     Arg_file.Use_meaDB_raster = Use_meaDB_raster ;
% %----------------------------------
Arg_file.FILE_LIST_PROCESS_defined = false;
Arg_file.FILE_LIST_PROCESS = Search_Params.List_files2 ;

if (get(handles.checkbox1channel_burst,'Value') == get(handles.checkbox1channel_burst,'Max'))
   % Checkbox is checked-take approriate action
   MED_AWSR_1ch_Find_Bursts( TimeBin , CHANNEL , AWSR_sig_tres )
else
   MED_AWSR_Find_Bursts_LOAD( TimeBin  , AWSR_sig_tres , save_bursts_to_files ,  Arg_file , Search_Params);
end


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = get(handles.TimeBinBurstEdit,'String');
b = get(handles.BurstSigmaEdit,'String');
 c= get(handles.BurstNumberEdit,'String');

TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );
nbursts = str2num( c );

b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );




[filename, pathname] = uigetfile('*.*','Select file') ;

%  [filename2, pathname2] = uigetfile('*.*','Select file') ;
if filename ~= 0 
Init_dir = cd ;
cd( pathname ) ;        
%  [filename3, pathname3] = uigetfile('*.*','Select file') ;
% load(filename3);
AWSR = AWSR_file(filename,'-' , TimeBin );
 [burst_start,burst_max,burst_end] = Extract_bursts( AWSR ,TimeBin , AWSR_sig_tres) ;
burst_start = ( burst_start * 1000 ) ;
burst_max = ( burst_max * 1000 )  ;
burst_end = ( burst_end * 1000 ) ;
Cycle_P_val_process = 'n' ; 

   
%     nbursts ;
    Def_bursts2_load_2rasters

%  S_matr_3
if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_AWSR_Bursts_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gcf,  figname ,'fig');
end
cd( Init_dir ) ;



end



% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MED_InterChannels_Realtions


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Experiment_name = get(handles.edit_FILE_DB,'String');
a = get(handles.edit_sigmaDB ,'String'); 
Arg_file.Sigma_threshold =  str2num( a );

if (get(handles.checkboxDBmea,'Value') == get(handles.checkboxDBmea,'Max'))
    Use_meaDB_raster = true ;
else
    Use_meaDB_raster = false ;
end

if (get(handles.checkbox6well ,'Value') == get(handles.checkbox6well ,'Max'))
    Use_6well_mea = true ;
else
    Use_6well_mea = false ;
end


Arg_file.Use_meaDB_raster = Use_meaDB_raster ;
Arg_file.Experiment_name = Experiment_name ;
Arg_file.Use_6well_mea = Use_6well_mea ;

Find_bursts_GUI_input

Raster  ;


guidata(hObject, handles);

% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;

if filename ~= 0
index_r = load( char( filename ) ) ;    
[filename2,pathname2] = uigetfile( '*.*' , 'Select file' ) ;    

if filename2 ~= 0
    

index_r2 = load( char( filename2 ) ) ;

Tmax = max( index_r( : , 1 ) ) ;
Tmax = Tmax + 0.1*Tmax ;
index_r2( : , 1 ) = index_r2( : , 1 ) + Tmax ;
index_r = [ index_r ; index_r2 ];

Raster_file = [ char(filename) 'add' ] ;
 fid = fopen(Raster_file , 'w');
fprintf(fid, '%.3f  %d  %.4f\n', index_r');
fclose(fid);

end
end





% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;

if filename ~= 0
index_r = load( char( filename ) ) ;    
   


Tmax = max( index_r( : , 1 ) ) ;
Tmax = Tmax + 0.1*Tmax ;
index_r( : , 1 ) = Tmax - index_r( : , 1 )  ;

Raster_file = [ char(filename) 'mirror' ] ;
 fid = fopen(Raster_file , 'w');
fprintf(fid, '%.3f  %d  %.4f\n', index_r');
fclose(fid);

end

% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 afrom = get(handles.edit_from,'String');
 ato = get(handles.edit_to,'String');
Edit_from = str2num( afrom )*1000;
Edit_to = str2num( ato )*1000;
N = 64 ;

[filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;

raster_cut_file_and_save( filename , pathname , N ,Edit_from , Edit_to ,true)



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_from as text
%        str2double(get(hObject,'String')) returns contents of edit_from as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_to as text
%        str2double(get(hObject,'String')) returns contents of edit_to as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double

 

% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Post_stim_response_params_GUI_input

%--- Burst analysis parameters --------------------
Find_bursts_GUI_input
%     Search_Params.SsuperBurst_scale_sec  
%     Search_Params.TimeBin  
%     Search_Params.AWSR_sig_tres 
%     Search_Params.save_bursts_to_files  
%     Search_Params.List_files2 
%     Search_Params.Arg_file 
Search_Params.Show_figures = false ;
% Search_Params.Analyse_preBursts = true ;
%---------------------------------------------------

%---- Get DB parameters -----------
    Experiment_name = get(handles.edit_FILE_DB,'String');
    Arg_file.Experiment_name = Experiment_name ;

    a = get(handles.edit_sigmaDB ,'String'); 
    Arg_file.Sigma_threshold =  str2num( a );

    if (get(handles.checkboxDBmea,'Value') == get(handles.checkboxBurstFile,'Max'))
        Use_meaDB_raster = true ;
    else
        Use_meaDB_raster = false ;
    end
    Arg_file.Use_meaDB_raster = Use_meaDB_raster ;
%----------------------------------

GLOBAL_CONSTANTS_load

% Params.leave_or_erase_artifacts = GLOBAL_const.leave_or_erase_artifacts  ; % after load artifact erase or leave only some
Params.erase_artifacts   = GLOBAL_const.erase_artifacts  ;
Params.leave_or_erase_every_artifact_period   = GLOBAL_const.leave_or_erase_every_artifact_period  ; % if 6 - then erase 1 ,6 ,12 ... artifact (or leave)

Params.TimeBin = TimeBin ;
Params.AWSR_sig_tres = AWSR_sig_tres ;
Params.Search_Params = Search_Params ;




% Search_Params.DT_bin = str2num( x{1} );
% Search_Params.PosStim_Interval_start = str2num( a );
% Search_Params.PosStim_Interval_end = str2num( a_to );
% Search_Params.Artefact_channel = str2num( art_c ); 
% Search_Params.AutoPostStim

% Stim_response( Search_Params.PosStim_Interval_start  , Search_Params.PosStim_Interval_end ...
%     , Search_Params.Take_all_spikes_after_stim,Search_Params.DT_bin , Search_Params.Artefact_channel ...
%     ,0,true, Search_Params.checkbox5msBin  ,Params  );

Stim_response( Search_Params.PosStim_Interval_start  , Search_Params.PosStim_Interval_end ...
    , Search_Params.Take_all_spikes_after_stim,Search_Params.DT_bin , Search_Params.Artefact_channel ...
    ,0,true, Search_Params.checkbox5msBin  ,Search_Params  );


%     function [ POST_STIM_RESPONSE ] = Stim_response( Post_stim_interval_start ,Post_stim_interval_end , ...
%     Take_all_spikes_after_stim , DT_bin , ...
%       Artefact_channel, filename , SHOW_FIGURES , checkbox5msBin , Params )
    
% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = get(handles.TimeBinBurstEdit,'String');
b = get(handles.BurstSigmaEdit,'String');
c= get(handles.BurstNumberEdit,'String');

TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );
nbursts = str2num( c );

b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );




[filename, pathname] = uigetfile('*.*','Select file') ;

 [filename2, pathname2] = uigetfile('*.*','Select file') ;
if filename ~= 0 
Init_dir = cd ;
cd( pathname ) ;        
%  [filename3, pathname3] = uigetfile('*.*','Select file') ;
% load(filename3);
AWSR = AWSR_file(filename,'-' , TimeBin );
 [burst_start,burst_max,burst_end] = Extract_bursts( AWSR ,TimeBin , AWSR_sig_tres) ;
burst_start = ( burst_start * 1000 ) ;
burst_max = ( burst_max * 1000 )  ;
burst_end = ( burst_end * 1000 ) ;
Cycle_P_val_process = 'n' ; 
AWSR2 = AWSR_file(filename2,'-' , TimeBin );
 [burst_start2,burst_max2,burst_end2] = Extract_bursts( AWSR2 ,TimeBin , AWSR_sig_tres) ;
burst_start2 = ( burst_start2 * 1000 ) ;
burst_max2 = ( burst_max2 * 1000 )  ;
burst_end2 = ( burst_end2 * 1000 ) ;
   
    
    Def_bursts2_load_2rasters2

%  S_matr_3
if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_AWSR_Bursts_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gcf,  figname ,'fig');
end
cd( Init_dir ) ;



end


% --- Executes on button press in pushbutton30.

% hObject    hfunction pushbutton30_Callback(hObject, eventdata, handles)andle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = get(handles.TimeBinBurstEdit,'String');
b = get(handles.BurstSigmaEdit,'String');
 c= get(handles.BurstNumberEdit,'String');

TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );
nbursts = str2num( c );

b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );

if (get(handles.RelativeDurBox,'Value') == get(handles.RelativeDurBox,'Max'))
   % Checkbox is checked-take approriate action
   d = true ;
else
   d = false ;
end


[filename, pathname] = uigetfile('*.*','Select file') ;

%  [filename2, pathname2] = uigetfile('*.*','Select file') ;
if filename ~= 0 
Init_dir = cd ;
cd( pathname ) ;        
%  [filename3, pathname3] = uigetfile('*.*','Select file') ;
% load(filename3);  
Cycle_P_val_process = 'n' ; 

 PHASE_ON  = d ;
%     nbursts ;
    Distance_in_motif_raster_1

%  S_matr_3
if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_AWSR_Bursts_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gcf,  figname ,'fig');
end
cd( Init_dir ) ;



end

 


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = get(handles.TimeBinBurstEdit,'String');
b = get(handles.BurstSigmaEdit,'String');
c= get(handles.BurstNumberEdit,'String');

TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );
nbursts = str2num( c );

b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );

if (get(handles.RelativeDurBox,'Value') == get(handles.RelativeDurBox,'Max'))
   % Checkbox is checked-take approriate action
   d = true ;
else
   d = false ;
end

if (get(handles.checkboxClearSpace,'Value') == get(handles.checkboxClearSpace,'Max'))
   % Checkbox is checked-take approriate action
   e = true ;
else
  e = false ;
end

    PHASE_ON = d ;
    ADJUST_SPIKES = e ;

LOAD_2files_Distance_in_motif_raster


% --- Executes on button press in RelativeDurBox.
function RelativeDurBox_Callback(hObject, eventdata, handles)
% hObject    handle to RelativeDurBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RelativeDurBox


% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = get(handles.TimeBinBurstEdit,'String');
b = get(handles.BurstSigmaEdit,'String');
c= get(handles.BurstNumberEdit,'String');

TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );
nbursts = str2num( c );

b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );

if (get(handles.RelativeDurBox,'Value') == get(handles.RelativeDurBox,'Max'))
   % Checkbox is checked-take approriate action
   d = true ;
else
   d = false ;
end


if (get(handles.checkboxClearSpace,'Value') == get(handles.checkboxClearSpace,'Max'))
   % Checkbox is checked-take approriate action
   e = true ;
else
  e = false ;
end


[filename, pathname] = uigetfile('*.*','Select file') ;

%  [filename2, pathname2] = uigetfile('*.*','Select file') ;
if filename ~= 0 
Init_dir = cd ;
cd( pathname ) ;        
%  [filename3, pathname3] = uigetfile('*.*','Select file') ;
% load(filename3);
   
    PHASE_ON = d ;
    ADJUST_SPIKES = e ;
    Distance_in_motif_raster_1

%  S_matr_3
if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_AWSR_Bursts_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gcf,  figname ,'fig');
end
cd( Init_dir ) ;



end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(0,'DefaultAxesFontSize',13,'DefaultTextFontSize',12);
 

% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = get(handles.TimeBinBurstEdit,'String');
 b = get(handles.BurstSigmaEdit,'String');
 
TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );


b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );

if (get(handles.checkboxList2,'Value') == get(handles.checkboxBurstFile,'Max'))
    List_files2 = 'y' ;
else
    List_files2 = 'n' ;
end

if (get(handles.RelativeDurBox,'Value') == get(handles.RelativeDurBox,'Max'))
   % Checkbox is checked-take approriate action
   d = true ;
else
   d = false ;
end
PHASE_ON = d ;

if (get(handles.checkboxClearSpace,'Value') == get(handles.checkboxClearSpace,'Max'))
   % Checkbox is checked-take approriate action
   e = true ;
else
  e = false ;
end
ADJUST_SPIKES = e ;


% [filename, pathname] = uigetfile('*.*','Select file') ;
% if filename ~= 0 
% Init_dir = cd ;
% cd( pathname ) ;        

% MED_AWSR_Find_Bursts_LOAD( TimeBin  , AWSR_sig_tres , save_bursts_to_files , List_files2);


Cycle_P_val_process = 'y' ; 
load_spikes_LOAD_listfiles(Cycle_P_val_process ,ADJUST_SPIKES,PHASE_ON,List_files2 )
%  load_spikes_mat_cycle1 
%  S_matr_3
if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;

% end
% cd( Init_dir ) ;




end


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = get(handles.TimeBinBurstEdit,'String');
 b = get(handles.BurstSigmaEdit,'String');
 
TimeBin = str2num( a );
AWSR_sig_tres = str2num( b );


b = get(handles.editChannelNumBurst,'String');
CHANNEL = str2num( b );

if (get(handles.RelativeDurBox,'Value') == get(handles.RelativeDurBox,'Max'))
   % Checkbox is checked-take approriate action
   d = true ;
else
   d = false ;
end
PHASE_ON = d ;

if (get(handles.checkboxClearSpace,'Value') == get(handles.checkboxClearSpace,'Max'))
   % Checkbox is checked-take approriate action
   e = true ;
else
  e = false ;
end
ADJUST_SPIKES = e ;


[filename, pathname] = uigetfile('*.*','Select file') ;
if filename ~= 0 
Init_dir = cd ;
cd( pathname ) ;        

Cycle_P_val_process = 'n' ; 
 load_spikes_mat_cycle1 
%  S_matr_3
if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;

end
cd( Init_dir ) ;

end


% --- Executes during object creation, after setting all properties.
function editChannelNumAwsr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editChannelNumAwsr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pushbutton20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function BurstNumberEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BurstNumberEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxList2.
function checkboxList2_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxList2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxList2


% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(handles.edit18_ps_from,'String'); 
 c = get(handles.edit19_ps_to,'String'); 
 ch = get(handles.edit21_learn_chan,'String'); 
 
 
Post_stim_num_spikes_from_t = str2num( a );
Post_stim_num_spikes_to_t =  str2num( c );
Post_stim_num_spikes_channel =  str2num( ch );
Stim_response_trails_window( Post_stim_num_spikes_from_t , Post_stim_num_spikes_to_t ,Post_stim_num_spikes_channel)  ;



function edit18_ps_from_Callback(hObject, eventdata, handles)
% hObject    handle to edit18_ps_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18_ps_from as text
%        str2double(get(hObject,'String')) returns contents of edit18_ps_from as a double


% --- Executes during object creation, after setting all properties.
function edit18_ps_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18_ps_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_ps_to_Callback(hObject, eventdata, handles)
% hObject    handle to edit19_ps_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19_ps_to as text
%        str2double(get(hObject,'String')) returns contents of edit19_ps_to as a double


% --- Executes during object creation, after setting all properties.
function edit19_ps_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19_ps_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text19DT_bin_Callback(hObject, eventdata, handles)
% hObject    handle to text19DT_bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text19DT_bin as text
%        str2double(get(hObject,'String')) returns contents of text19DT_bin as a double


% --- Executes during object creation, after setting all properties.
function text19DT_bin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text19DT_bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function edit21_learn_chan_Callback(hObject, eventdata, handles)
% hObject    handle to edit21_learn_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21_learn_chan as text
%        str2double(get(hObject,'String')) returns contents of edit21_learn_chan as a double


% --- Executes during object creation, after setting all properties.
function edit21_learn_chan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21_learn_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(handles.edit18_ps_from,'String'); 
 c = get(handles.edit19_ps_to,'String'); 
 ch = get(handles.edit21_learn_chan,'String'); 
 
 
Post_stim_num_spikes_from_t = str2num( a );
Post_stim_num_spikes_to_t =  str2num( c );
Post_stim_num_spikes_channel =  str2num( ch );
Stim_response_trails_window_from_matfile( Post_stim_num_spikes_from_t , Post_stim_num_spikes_to_t ,Post_stim_num_spikes_channel)  ;



function edit22Artc_Callback(hObject, eventdata, handles)
% hObject    handle to edit22Artc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22Artc as text
%        str2double(get(hObject,'String')) returns contents of edit22Artc as a double


% --- Executes during object creation, after setting all properties.
function edit22Artc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22Artc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Union_2bursts_matfiles
 



function edit26chan_Callback(hObject, eventdata, handles)
% hObject    handle to edit26chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26chan as text
%        str2double(get(hObject,'String')) returns contents of edit26chan as a double


% --- Executes during object creation, after setting all properties.
function edit26chan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxAutoAnalysis.
function checkboxAutoAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxAutoAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxAutoAnalysis


% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)



% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkboxSearch_Params.
function checkboxPostStim_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPostStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPostStim



function edit28_To_t_Callback(hObject, eventdata, handles)
% hObject    handle to edit28_To_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28_To_t as text
%        str2double(get(hObject,'String')) returns contents of edit28_To_t as a double


% --- Executes during object creation, after setting all properties.
function edit28_To_t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28_To_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_From_t_Callback(hObject, eventdata, handles)
% hObject    handle to edit27_From_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27_From_t as text
%        str2double(get(hObject,'String')) returns contents of edit27_From_t as a double


% --- Executes during object creation, after setting all properties.
function edit27_From_t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27_From_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 afrom = get(handles.edit27_From_t,'String');
 ato = get(handles.edit28_To_t,'String');
Edit_from = str2num( afrom );
Edit_to = str2num( ato );
N = 64 ;


 ConnectivityAnalysis_file(   N  , Edit_from  , Edit_to   )



function edit_FILE_DB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_FILE_DB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_FILE_DB as text
%        str2double(get(hObject,'String')) returns contents of edit_FILE_DB as a double


% --- Executes during object creation, after setting all properties.
function edit_FILE_DB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_FILE_DB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 


% --- Executes on button press in checkboxSubFolder.
function checkboxSubFolder_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSubFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSubFolder


% --- Executes on button press in checkbox5msBin.
function checkbox5msBin_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5msBin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5msBin


% --- Executes on button press in checkboxDBmea.
function checkboxDBmea_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxDBmea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxDBmea



function edit_sigmaDB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sigmaDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sigmaDB as text
%        str2double(get(hObject,'String')) returns contents of edit_sigmaDB as a double


% --- Executes during object creation, after setting all properties.
function edit_sigmaDB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigmaDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Experiment_name = get(handles.edit_FILE_DB,'String');
a = get(handles.edit_sigmaDB ,'String'); 
Arg_file.Sigma_threshold =  str2num( a );

if (get(handles.checkboxDBmea,'Value') == get(handles.checkboxBurstFile,'Max'))
    Use_meaDB_raster = true ;
else
    Use_meaDB_raster = false ;
end

Arg_file.Use_meaDB_raster = Use_meaDB_raster ;
Arg_file.Experiment_name = Experiment_name ;

Learn_curve_file( Arg_file )  ;


% --- Executes on button press in pushbutton44.
function pushbutton44_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(handles.edit33 ,'String'); 
split_interval = str2num( a )*1000; 
N = 64 ;

if (get(handles.checkboxInNewFoldeer,'Value') == get(handles.checkboxInNewFoldeer,'Max'))
    In_new_Dir =true ;
else
    In_new_Dir = false ;
end

if (get(handles.checkboAutoBurstsAnalysis,'Value') == get(handles.checkboAutoBurstsAnalysis,'Max'))
    Auto_Analyze_Bursts =true ;
else
    Auto_Analyze_Bursts = false ;
end
  
params.split_interval = split_interval ;




[filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;



if In_new_Dir
    curr_dir = cd ;
    new_dir = [ a 'sec_split\' ] ;
%     mkdir( [ curr_dir '\' new_dir ] ) 
    new_dir_path = [ pathname  new_dir ] ;
    mkdir( new_dir_path ) ;
    copyfile(  [ pathname filename ] , new_dir_path )
    cd( new_dir_path )  
end

file_list = raster_Split_into_intervals_and_save( filename ,pathname, N ,params)

if In_new_Dir
delete( [new_dir_path '\' filename ] )
cd( curr_dir )
end 



if Auto_Analyze_Bursts
    ANALYSIS_ARG.FILE_LIST_PROCESS = true;
    ANALYSIS_ARG.FILE_LIST_PROCESS_defined = true ;
    ANALYSIS_ARG.FILE_LIST_PROCESS_file_list = file_list ;
    
    
    %--- Burst analysis parameters --------------------
    Find_bursts_GUI_input
    %     Search_Params.SsuperBurst_scale_sec  
    %     Search_Params.TimeBin  
    %     Search_Params.AWSR_sig_tres 
    %     Search_Params.save_bursts_to_files  
    %     Search_Params.List_files2 
    %     Search_Params.Arg_file 
    %---------------------------------------------------

        %---- Get DB parameters -----------
        Experiment_name = get(handles.edit_FILE_DB,'String');
    ANALYSIS_ARG.Experiment_name = '' ;

    a = get(handles.edit_sigmaDB ,'String'); 
    Arg_file.Sigma_threshold =  str2num( a );

    if (get(handles.checkboxDBmea,'Value') == get(handles.checkboxBurstFile,'Max'))
        Use_meaDB_raster = true ;
    else
        Use_meaDB_raster = false ;
    end
    ANALYSIS_ARG.Use_meaDB_raster = Use_meaDB_raster ; 
    save_bursts_to_files = true ;
 
    MED_AWSR_Find_Bursts_LOAD( TimeBin  , AWSR_sig_tres , save_bursts_to_files , ANALYSIS_ARG , Search_Params );
 
 
    
end




% if filename ~= 0
% index_r = load( char( filename ) ) ; 
% Tmax = max( index_r( : , 1 ) ) ;
% 
% params.split_interval = split_interval ;
% params.Tmax = Tmax ;
% 
% file_number = 1 ;
% for Ti = 0 : split_interval : Tmax - split_interval ;
%  Edit_from =  Ti ;
% Edit_to = Ti + split_interval ;
% file_number
% params.add_prefix = [ '_' num2str( file_number ) '_' ] ;
% raster_cut_file_and_save( filename , pathname , N ,Edit_from , Edit_to , false , params )
% file_number=file_number+1;
% 
% end
% end






function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton45.
function pushbutton45_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function editBurst_Thres_Callback(hObject, eventdata, handles)
% hObject    handle to editBurst_Thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBurst_Thres as text
%        str2double(get(hObject,'String')) returns contents of editBurst_Thres as a double


% --- Executes during object creation, after setting all properties.
function editBurst_Thres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBurst_Thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBurst_chan_thres_Callback(hObject, eventdata, handles)
% hObject    handle to editBurst_chan_thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBurst_chan_thres as text
%        str2double(get(hObject,'String')) returns contents of editBurst_chan_thres as a double


% --- Executes during object creation, after setting all properties.
function editBurst_chan_thres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBurst_chan_thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Stim_per_channel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Stim_per_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Stim_per_channel as text
%        str2double(get(hObject,'String')) returns contents of edit_Stim_per_channel as a double


% --- Executes during object creation, after setting all properties.
function edit_Stim_per_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Stim_per_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 

% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Experiment_name = get(handles.edit_FILE_DB,'String');
a = get(handles.edit_sigmaDB ,'String'); 
Arg_file.Sigma_threshold =  str2num( a );

if (get(handles.checkboxDBmea,'Value') == get(handles.checkboxDBmea,'Max'))
    Use_meaDB_raster = true ;
else
    Use_meaDB_raster = false ;
end

if (get(handles.checkbox_Loop_curves,'Value') == get(handles.checkbox_Loop_curves,'Max'))
    Loop_curves = true ;
else
    Loop_curves = false ;
end

Arg_file.Loop_curves = Loop_curves ;
Arg_file.Use_meaDB_raster = Use_meaDB_raster ;
Arg_file.Experiment_name = Experiment_name ;


a = get(handles.editRS_thres_perc,'String'); 
Arg_file.RS_threshold_percent  = str2num( a );

b = get(handles.edit_channelForRS,'String'); 
Arg_file.Channel_num_for_Learn_curve  = str2num( b );

 Find_Learn_curve_on_RS_thres( Arg_file )

function edit_channelForRS_Callback(hObject, eventdata, handles)
% hObject    handle to edit_channelForRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_channelForRS as text
%        str2double(get(hObject,'String')) returns contents of edit_channelForRS as a double


% --- Executes during object creation, after setting all properties.
function edit_channelForRS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_channelForRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRS_thres_perc_Callback(hObject, eventdata, handles)
% hObject    handle to editRS_thres_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRS_thres_perc as text
%        str2double(get(hObject,'String')) returns contents of editRS_thres_perc as a double


% --- Executes during object creation, after setting all properties.
function editRS_thres_perc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRS_thres_perc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton48.
function pushbutton48_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Analysis_2_sets_init_parameters ;

b = get(handles.edit_Low_Resp_Thr,'String'); 
ANALYSIS_ARG.Low_Resp_Thr_percent = str2num( b );

g = get(handles.edit_High_resp_Thr,'String'); 
ANALYSIS_ARG.High_Resp_Thr_percent  = str2num( g );
 

if (get(handles.checkboxSilentChan,'Value') == get(handles.checkboxSilentChan,'Max'))
    ANALYSIS_ARG.Count_zero_values  = true ;
else 
    ANALYSIS_ARG.Count_zero_values  = false ;
end




if (get(handles.checkbox3files,'Value') == get(handles.checkbox3files,'Max'))
    ANALYSIS_ARG.Use_3_files  = true ;
else 
    ANALYSIS_ARG.Use_3_files  = false ;
end


ANALYSIS_ARG.Select_pair_of_files = true ; 
ANALYSIS_ARG.COMPARE_ONLY_TOTAL_SPIKE_RATES = true ;
ANALYSIS_ARG.SHOW_FIGURES = true ;

meaDB_Main_script ;


% --- Executes on button press in checkboxAdjust.
function checkboxAdjust_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxAdjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxAdjust


% --- Executes on button press in pushbutton49.
function pushbutton49_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




b = get(handles.edit_Low_Resp_Thr,'String'); 
ANALYSIS_ARG.Response_threshold  = str2num( b );


if (get(handles.checkboxSilentChan,'Value') == get(handles.checkboxSilentChan,'Max'))
    ANALYSIS_ARG.Count_zero_values  = true ;
else 
    ANALYSIS_ARG.Count_zero_values  = false ;
end



% ANALYSIS_ARG.Use_Small_response = Use_Small_response ;



ANALYSIS_ARG.SHOW_FIGURES = true ;

meaDB_Main_script ;


% --- Executes on button press in checkbox_Loop_curves.
function checkbox_Loop_curves_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Loop_curves (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Loop_curves



function edit_Small_PSTH_bin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Small_PSTH_bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Small_PSTH_bin as text
%        str2double(get(hObject,'String')) returns contents of edit_Small_PSTH_bin as a double


% --- Executes during object creation, after setting all properties.
function edit_Small_PSTH_bin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Small_PSTH_bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Add_prefix_to_NLearn_rasters 


% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Artefacts_Rater_Leave_last_stim_train 


% --- Executes on button press in checkbox_Small_responses.
function checkbox_Small_responses_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Small_responses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Small_responses



function edit_Low_Resp_Thr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Low_Resp_Thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Low_Resp_Thr as text
%        str2double(get(hObject,'String')) returns contents of edit_Low_Resp_Thr as a double


% --- Executes during object creation, after setting all properties.
function edit_Low_Resp_Thr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Low_Resp_Thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSupeB_scale_Callback(hObject, eventdata, handles)
% hObject    handle to editSupeB_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSupeB_scale as text
%        str2double(get(hObject,'String')) returns contents of editSupeB_scale as a double


% --- Executes during object creation, after setting all properties.
function editSupeB_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSupeB_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxSilentChan.
function checkboxSilentChan_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSilentChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSilentChan


% --- Executes on button press in checkbox6well_detect.
function checkbox6well_detect_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6well_detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6well_detect


% --- Executes on button press in checkbox_Small_responses2.
function checkbox_Small_responses2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Small_responses2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Small_responses2



function edit_Response_threshold2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Response_threshold2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Response_threshold2 as text
%        str2double(get(hObject,'String')) returns contents of edit_Response_threshold2 as a double


% --- Executes during object creation, after setting all properties.
function edit_Response_threshold2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Response_threshold2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox3files.
function checkbox3files_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3files



function edit_High_resp_Thr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_High_resp_Thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_High_resp_Thr as text
%        str2double(get(hObject,'String')) returns contents of edit_High_resp_Thr as a double


% --- Executes during object creation, after setting all properties.
function edit_High_resp_Thr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_High_resp_Thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonDelete.
function pushbuttonDelete_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

b = get(handles.editChanDel,'String'); 
Channels_to_delete  = strread( b ,  '%d '  ) ;  

if (get(handles.checkboxLeavechan,'Value') == get(handles.checkboxLeavechan,'Max'))
        var.leave_channels = true ;
    else
        var.leave_channels = false ;
    end

[filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;

Channel_delete_file_and_save( filename , pathname , Channels_to_delete , var )



function editChanDel_Callback(hObject, eventdata, handles)
% hObject    handle to editChanDel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editChanDel as text
%        str2double(get(hObject,'String')) returns contents of editChanDel as a double


% --- Executes during object creation, after setting all properties.
function editChanDel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editChanDel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chec6well_bursts.
function chec6well_bursts_Callback(hObject, eventdata, handles)
% hObject    handle to chec6well_bursts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chec6well_bursts


% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ask_BurstsFilen_Connectiv_analysis


% --- Executes on button press in checkboxSimpleBu.
function checkboxSimpleBu_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSimpleBu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSimpleBu


% --- Executes on button press in pushbutton54.
function pushbutton54_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Connectiv_compare_to_files


% --- Executes on button press in checkboxConnectiv.
function checkboxConnectiv_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxConnectiv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxConnectiv


% --- Executes on button press in pushbutton55.
function pushbutton55_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Analysis_2_sets_init_parameters ;

ANALYSIS_ARG.FILE_LIST_PROCESS  = false ;
ANALYSIS_ARG.FILE_LIST_PROCESS_defined  = false ;  
ANALYSIS_ARG.SHOW_FIGURES = true ;
ANALYSIS_ARG.Experiment_type = 'Connectivity_compare' ;
ANALYSIS_ARG.files_in_exeperiment = 3 ; 

meaDB_Main_script ;


% --- Executes on button press in pushbutton56.
function pushbutton56_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MEA_DB_BURST_file_to_DB_ask_file


% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%---- Get DB parameters -----------
    Experiment_name = get(handles.edit_FILE_DB,'String');
    Arg_file.Experiment_name = Experiment_name ;

    a = get(handles.edit_sigmaDB ,'String'); 
    Arg_file.Sigma_threshold =  str2num( a );

    if (get(handles.checkboxDBmea,'Value') == get(handles.checkboxBurstFile,'Max'))
        Use_meaDB_raster = true ;
    else
        Use_meaDB_raster = false ;
    end
    Arg_file.Use_meaDB_raster = Use_meaDB_raster ;
%----------------------------------

Conenctiv_Extract_Results_from_DB


% --- Executes on button press in checkboxPSTH_connect_analy.
function checkboxPSTH_connect_analy_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPSTH_connect_analy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPSTH_connect_analy


% --- Executes on button press in checkboxOnlyFilteredResp.
function checkboxOnlyFilteredResp_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxOnlyFilteredResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxOnlyFilteredResp


% --- Executes on button press in checkboxInNewFoldeer.
function checkboxInNewFoldeer_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxInNewFoldeer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxInNewFoldeer


% --- Executes on button press in checkboxSB_filter.
function checkboxSB_filter_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSB_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSB_filter


% --- Executes on button press in checkboxCutSuperB.
function checkboxCutSuperB_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxCutSuperB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxCutSuperB


% --- Executes on button press in checkboAutoBurstsAnalysis.
function checkboAutoBurstsAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to checkboAutoBurstsAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboAutoBurstsAnalysis


% --- Executes on button press in pushbutton58.
function pushbutton58_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Auto_Split_and_analyze_raster


% --- Executes on button press in checkboxLeavechan.
function checkboxLeavechan_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxLeavechan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxLeavechan


% --- Executes on button press in checkboxSaveToDB.
function checkboxSaveToDB_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSaveToDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSaveToDB



function editMaxSpikes_Callback(hObject, eventdata, handles)
% hObject    handle to editMaxSpikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMaxSpikes as text
%        str2double(get(hObject,'String')) returns contents of editMaxSpikes as a double


% --- Executes during object creation, after setting all properties.
function editMaxSpikes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMaxSpikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton63.
function pushbutton63_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

     a = get(handles.edit50 ,'String'); 
    Time_start =  str2num( a );
    
    a = get(handles.edit49 ,'String'); 
    Time_end =  str2num( a ); 
    
        a = get(handles.editMaxSpikes ,'String'); 
    MaxSpikes =  str2num( a ); 
    
        a = get(handles.editCycle ,'String'); 
    Dt_step_cycle =  str2num( a ); 
    
Bursts_to_Avi_interval 
% input:   Time_start Time_end MaxSpikes Dt_step_cycle


function edit49_Callback(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit49 as text
%        str2double(get(hObject,'String')) returns contents of edit49 as a double


% --- Executes during object creation, after setting all properties.
function edit49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit50_Callback(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit50 as text
%        str2double(get(hObject,'String')) returns contents of edit50 as a double


% --- Executes during object creation, after setting all properties.
function edit50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editCycle_Callback(hObject, eventdata, handles)
% hObject    handle to editCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCycle as text
%        str2double(get(hObject,'String')) returns contents of editCycle as a double


% --- Executes during object creation, after setting all properties.
function editCycle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboLFP.
function checkboLFP_Callback(hObject, eventdata, handles)
% hObject    handle to checkboLFP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboLFP



function edit52_LFP_stim_num_Callback(hObject, eventdata, handles)
% hObject    handle to edit52_LFP_stim_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit52_LFP_stim_num as text
%        str2double(get(hObject,'String')) returns contents of edit52_LFP_stim_num as a double


% --- Executes during object creation, after setting all properties.
function edit52_LFP_stim_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit52_LFP_stim_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox41_MeaA.
function checkbox41_MeaA_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox41_MeaA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox41_MeaA


% --- Executes on button press in checkbox42_MeaB.
function checkbox42_MeaB_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox42_MeaB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox42_MeaB


% --- Executes on button press in checkbox43_Correct.
function checkbox43_Correct_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox43_Correct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox43_Correct



function edit53_maxart_Callback(hObject, eventdata, handles)
% hObject    handle to edit53_maxart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit53_maxart as text
%        str2double(get(hObject,'String')) returns contents of edit53_maxart as a double


% --- Executes during object creation, after setting all properties.
function edit53_maxart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit53_maxart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxGetFromFile.
function checkboxGetFromFile_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxGetFromFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxGetFromFile


% --- Executes on button press in checkboxGetFromFile.
function checkbox47_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxGetFromFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxGetFromFile


% --- Executes on button press in checkbox43_Correct.
function checkbox46_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox43_Correct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox43_Correct


% --- Executes on button press in checkboxArt.
function checkbox45_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxArt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxArt
