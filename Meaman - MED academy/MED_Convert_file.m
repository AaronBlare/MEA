
function [Result_MAT_file , Raster_file] = MED_Convert_file( Input_file , SIGMATRES , ARTEFACTS_ON ,...
    sigma_from_sec ,  sigma_to_ms , Dest_dir , Mea_flag ,  Arg_plus  )

% PROGRAM MED_Convert_file
% Gets spikes from all files in Files.txt.
% Saves spikes and spike times.

% input:  Input_file - filename
%   SIGMATRES - sigma coefficient for spike detection
%   ARTEFACTS_ON - extract stimulus artifacts (logical)
%     sigma_from_sec - for each take signal for threshold estimation from (sec)
%     sigma_to_ms - for each take signal for threshold estimation to (sec)
%     Dest_dir  - destination dir
%     Mea_flag - .mcd mea flag (A,B)
% output: lfp
% X_MAT_raster.mat - raster, artefacts, thresholds etc :
%          [  Sample_rate Trace_Lenght_pionts Trace_length_sec Detect_info Thr_one_sigma_all
%            Thr_all Sigma_number_threshold Raster_file index_r Artefacts_included artefacts_all  ]
% X_Raster.txt - raster file : each line - spike time (ms) and amplitude
% (mV)
% Alex Pimashkin, October 2010, Neuro.nnov.ru

CH = 64 ;                        % initial number of channels to convert

%%%%%%%%%%%%%%
GLOBAL_CONSTANTS_load
%%%%%%%%%%%%%%

handles.plot_multiple_signals = false ;
handles.plot_multiple_signals = true ;

Make_binary_traces = 'n' ;      % Make binary traces for all channels  'y' - yes , 'n' - no
Artefacts_find = ARTEFACTS_ON  ;
Collect_sigma_from = 1+( handles.par.sr  )* sigma_from_sec ;
Collect_sigma_to = ( handles.par.sr  )* sigma_to_ms  ; % collect sigma till 10 sec
CHANNEL_MEA_LETTER = Mea_flag ; % CHANNEL_MEA_LETTER = 'A';
Show_raster = 'n' ;

use_6well_mea = Arg_plus.use_6well_mea  ;

handles.par.Post_stim_potentials_collect = Arg_plus.Post_stim_potentials_collect ;


handles.par.stdmin = SIGMATRES ;         %minimum sigma threshold
handles.par.calculate_only_raster = SIMPLE_RASTER ;

handles.par.Artefacts_find = false ; % by default we not search artefacts if analyzing all channels

avg_spike_duration =  3   ; % spike duration in ms, not important
avg_spike_dur_points = 60;% avg_spike_duration * handles.par.sr/1000 ;%avg_spike_duration *handles.par.sr/1000);
DATA_TYPE = 'txt' ; % 'txt'  'med'

if First_channel_is_0 == 'y'
    zero_channel = 1 ;
else
    zero_channel = 0 ;
end
%
% % [files , pathname] = textread('Files.txt','%s');
% files = uigetfile('*.*','Select file');
%
% if FILE_LIST_PROCESS == 'n'
% c_file = files ;
% [pathstr,name,ext,versn] = fileparts( c_file ) ;
% %cd(pathname);
% DATA_TYPE = ext ;
% mkdir(  name  );
% init_dir = cd ;
% cd(  name );
% DIR =[ pathstr name ];
% n_files = 1 ;
% else
% list_files = textread(files ,'%s');
% init_dir = cd ;
% list_files
% n_files = length(list_files ) ;
% end



% for k= 1:n_files %---------------------------------------------------

% if FILE_LIST_PROCESS == 'y'
% c_file = char( list_files( k ) )
% [pathstr,name,ext,versn] = fileparts( c_file ) ;
% DATA_TYPE = ext ;
% dir = c_file( 1 : strfind(   c_file , '.') -1  ) ;
% cd(  init_dir  );
% mkdir(  dir  );
% cd( dir ) ;
% end


[pathstr,name,ext ] = fileparts( Input_file ) ;
[pathstr, Experiment_name , ext  ] = fileparts( Input_file ) ;
DATA_TYPE = ext ;
Input_file
DATA_TYPE
if SIMPLE_RASTER ~= 'y'
    SPIKESDIR = 'SPIKES' ;
    mkdir(  SPIKESDIR  );
end

sampleCH_data = [] ;
sample_spikes_only_CH_data = [] ;

tic
file_to_cluster = Input_file ;
index_all_channels=[];
index_all=[];
index_ms = [];
spikes_all=[];
artefacts = [];
artefacts_all = [] ;
artefacts_vs_ch = [] ;
amps_all = [] ;
Thr_all = [] ;
Thr_one_sigma_all = [] ;
Channel_event_rate = [] ;
Channel_events = [] ;
Channel_event_number = [] ;
index_r = [] ;
CH_num = [] ;
a = [] ;
file_to_cluster_full = file_to_cluster;
option_data_all = [] ;
%     option_data.post_stim_signals_all = [] ;

if handles.par.save_filtered_signals_to_mat_file
    Signals_all = [   ] ;
end

%a = medload( char(file_to_cluster) , 'all' , 500 );
%     file_to_cluster
switch DATA_TYPE
    case '.med'
        [a , nChannels , Trace_length_sec , Trace_length_points ] = medload1ch( char(file_to_cluster) , 1  , 'all' , 10 );
        %'1 channel loaded'
        %a = medload( char(file_to_cluster) , 'all' , MAX_MEMORY_MB );
        [pathstr,name,ext ] = fileparts ( file_to_cluster ) ;
        
        file_to_cluster = name ;
        N_channels = 64 ;
        
    case '.txt'
        %            a = load('-ascii', char(file_to_cluster)  );
        DATA_a = importdata(char(file_to_cluster) , ' ', 4);
        a = DATA_a.data ;
        clear DATA_a ;
        file_to_cluster = name ;
        N_channels = 64 ;
    case '.mcd'
        FILENAME = file_to_cluster ;
        OpenMCDfile_for_reanding
        
        [pathstr,name,ext ] = fileparts ( file_to_cluster ) ;
        file_to_cluster = name ;
        CH = 60 ;
        N_channels = 60 ;
    case '.h5'
        FILENAME = file_to_cluster ;
        OpenHDF5file_for_reading
        
        [pathstr,name,ext ] = fileparts ( file_to_cluster ) ;
        file_to_cluster = name ;
        CH = 60 ;
        N_channels = 60 ;
end
%
% a = load('-ascii', char(file_to_cluster)  );

switch DATA_TYPE
    case '.mcd'
        time_offset=FileInfo.TimeStampResolution;
        Trace_Lenght_pionts = TimeSpanSamples;
        Trace_length_sec = Trace_Lenght_pionts / handles.par.sr  ;
    case '.med'
        times = a( : , 1) ;
        time_offset =  times( 1 );
        whos times ;
        Med_note = '' ;
        %         Trace_Lenght_pionts = length( times );
        %         Trace_length_sec = Trace_Lenght_pionts / handles.par.sr
        Trace_length_sec
        Trace_Lenght_pionts = Trace_length_points ;
        %times = times *1e3/handles.par.sr ;  %1000/sr  - time in ms
        if Make_binary_traces ~= 'y'
            clear  times ;
            clear  a ;
        end
    case '.h5'
        time_offset=FileInfo.TimeStampResolution;
        Trace_Lenght_pionts=TimeSpanSamples;
        Trace_length_sec = Trace_Lenght_pionts / handles.par.sr ;
end
minmin = [] ;
%     if DATA_TYPE == '.med'
%                 b= load( char(file_to_cluster) );
%
%     end
global x ;
%     whos a

handles.par.Post_stim_potentials_external_artifact_GUI = false ;
if  handles.par.Post_stim_potentials_collect
    %     if handles.par.Post_stim_potentials_external_artifact
    %          [filename,PathName] = uigetfile('*.*','Select file');
    %          fullname = [PathName filename ];
    %         handles.par.Post_stim_potentials_external_artifact_file = fullname ;
    %     end
    handles.par.Post_stim_potentials_external_artifact = true ;
    handles.par.Post_stim_potentials_external_artifact_GUI = true ;
    
    if isempty( Arg_plus.Artefact_file )
        [filename,PathName] = uigetfile('*.*','Select file',pathstr);
        fullname = [PathName filename ]  ;
        
        
        handles.par.Post_stim_potentials_external_artifact_file
        
        
        handles.par.Post_stim_potentials_external_artifact_file = fullname ;
    else
        
        if  isempty( Arg_plus.Artefact_Path )
            cc = Arg_plus.Artefact_file    ;
        else
            cc = [ Arg_plus.Artefact_Path  '\' Arg_plus.Artefact_file  ];
        end
        
        
        Artefact_file_c = cc
        handles.par.Post_stim_potentials_external_artifact_file = Artefact_file_c;
        
        %         handles.par.Post_stim_potentials_external_artifact_file = Arg_plus.Artefact_file ;
    end
    
end

CH = handles.par.MED_Convert_file_Channels_num ;
%% - ------------------------
for channel= 1 : CH         %that's for cutting the data into pieces
    % LOAD CONTINUOUS DATA
    % eval(['load ' char(file_to_cluster) ';']);
    index_all=[];
    spikes_all=[];
    index=[];
    x = [] ;
    thr =[];
    amps=[];
    one_sigma_thr=[];
    
    switch DATA_TYPE
        case '.med'
            
            var.read_one_split_block = false ;
            if Trace_length_sec > handles.par.Data_split_max_recording_duration_sec
                var.read_one_split_block = true ;
                var.blocks_split_num = handles.par.Data_split_Number_of_blocks_channel_split ;
                var.blocks_to_read = 1 ;
            end
            %                var.read_one_split_block = true ;
            
            if var.read_one_split_block
                index_all0 = [ ];
                Thr_all0 = [  ];
                amps_all0 = [  ] ;
                Thr_one_sigma_all0 = [];
                
                handles.par.threshold_use_defined = false ; % use defined spike detection threshold
                handles.par.threshold_one_sigma = 0 ;
                
                %                    x_all = [];
                tic
                for bi = 1 : var.blocks_split_num
                    var.blocks_to_read = bi ;
                    tic
                    [data , time_0 ,Trace_length_points  ]...
                        =  medload1_without_timestampch( char(file_to_cluster_full) , channel  , 'all' , MAX_MEMORY_MB , var) ;
                    read_sec = toc;
                    
                    tic
                    x=data';
                    op2=toc;
                    
                    %                         x_all=[x_all  x ];
                    
                    
                    %-- detection script-------
                    Detection_X_to_index;
                    % input: x
                    %--------------------------
                    detect_sec = toc;
                    
                    if bi == 1 && ~handles.par.recalc_threshold_each_block
                        handles.par.threshold_use_defined = true ; % use defined spike detection threshold
                        handles.par.threshold_one_sigma = one_sigma_thr ;
                    end
                    % input x handles
                    % output: index
                    %                         time_0
                    %                         figure
                    %                          plot( index )
                    index(:) = index(:) + Trace_length_points * ( bi -1) ;
                    
                    size_index_all0 = size(  index_all0 );
                    max_index_time_sec = (max( index) / 1000 ) *1e3/handles.par.sr ;
                    time_0_sec= ( time_0 / 1000 ) ;
                    index_all0 = [index_all0 index];
                    %                         Thr_all0 = [ Thr_all0 thr ];
                    amps_all0 = [ amps_all0 amps ] ;
                    %                         Thr_one_sigma_all0 = [ Thr_one_sigma_all0 one_sigma_thr ];
                end
                time_one_channel_process = toc
                index = index_all0 ;
                %                  thr = Thr_all0 ;
                amps = amps_all0 ;
                %                  one_sigma_thr = Thr_one_sigma_all0 ;
            else
                [x , time_0 ] ...
                    =  medload1_without_timestampch( char(file_to_cluster_full) , channel  , 'all' , MAX_MEMORY_MB , var) ;
                x=x';
                %                     x_all=[  x ];
                whos x
                Detection_X_to_index;
                % input x handles
                % output: index
                
                max_index_time_sec = max( index) / 1000;
                time_0_sec= time_0 / 1000 ;
                
                a=0;
            end
            
            %                figure
            %                plot( x_all )
            
            max_index = max( index ) ;
            a=0;
        case '.txt'
            x =   a( : , channel + 1 )';
            
        case '.mcd'
            
            CHANNEL_NUM = channel  ;
            if CHANNEL_NUM ~= 15 % Ground channel on MC MEA
                Read_MCD_Channel_Data ;
                %                         if exist( 'crrData2Save' ,'var' )
                %                              x=crrData2Save' ;
                if handles.par.save_filtered_signals_to_mat_file
                    Signals_all = [ Signals_all ; x ] ;
                end
                %                              clear crrData2Save
                handles.analyzing_all_channels = true ;
                Detection_X_to_index
                
                %                         end
            end
            
         case '.h5'
            
            CHANNEL_NUM = channel  ;
            if CHANNEL_NUM ~= 15 % Ground channel on MC MEA
                Read_H5_Channel_Data ;
                if handles.par.save_filtered_signals_to_mat_file
                    Signals_all = [Signals_all; x];
                end
                handles.analyzing_all_channels = true;
                Detection_X_to_index
            end
            
    end
    
    channel ;
    %         figure
    %         plot( index )
    %if channel == Original_channel_save
    %    SAVE_ORIGINAL = 'y' ;
    %else SAVE_ORIGINAL = 'n'  ;
    %end
    %if channel == Filtered_channel_save
    %    SAVE_FILTERED = 'y' ;
    %else  SAVE_FILTERED = 'n';
    %end
    
    %          whos x ;
    %  tsmin = (channel-1)*floor(length( data )/handles.par.segments)+1;
    tsmin = 0 ;
    tsmax = floor(length( x ) );
    
    
    
    
    index_all = [index_all index];
    Thr_all = [ Thr_all thr ];
    amps_all = [ amps_all amps ] ;
    Thr_one_sigma_all = [ Thr_one_sigma_all one_sigma_thr ];
    
    index_ms = index  ;
    Spikes_number = length( index ) ;
    Spikes_number ;
    
    if length( index ) > 0
        
        if ( Raster_in_ms == 'y' )
            index_ms = index *1e3/handles.par.sr   ;
            
            minmin = [ minmin min( index_ms(2:end) - index_ms(1:end-1) ) ] ;
            
            if Save_time_offset == 'y'
                index_ms = index_ms + time_offset ;
            end
        end
        
        
        %---------------------------ARTEFACTS----------
        if Artefacts_find == 'y'
            artefacts_ms = artefacts' ;
            if ( Raster_in_ms == 'y' )
                artefacts_ms = (artefacts *1e3/handles.par.sr)'   ;
            end
            chan2 = ( channel - zero_channel ) * ones(  1, length( artefacts ))  ;
            artefacts_vs_ch = [ artefacts_ms ; chan2 ]' ;
            artefacts_all = [ artefacts_all ; artefacts_vs_ch ];
            
        end
        %------------------------------------------------
        chan = ( channel - zero_channel ) * ones( 1 , length( index_ms ) )  ;
        %         length( index_ms )
        %         length( amps )
        if ( Raster_with_amp == 'y' )
            one_sigma = amps;
            one_sigma(:) = -1*one_sigma_thr ;
            index_vs_ch = [ index_ms ; chan ; amps ; one_sigma]' ;
        else
            index_vs_ch = [ index_ms ; chan ]' ;
        end
        
        index_r = [ index_r ; index_vs_ch ];
        
        chan = (channel ) * ones(1, length( index ) );
        index_buff = [ index ; chan ]' ;
        index_all_channels = [ index_all_channels ; index_buff ] ;
        
        %  index( : ) = index( : ) - rem( avg_spike_dur_points ,2 ) ;
        % for s= 1 : avg_spike_dur_points
        %  index( : ) = index( : ) + 1 ;
        % spikes_traces(  index( : )  , channel ) = 1 ;
        %  end
        spikes_all = [spikes_all; spikes];
        
        
        Freq = length( index ) / Trace_length_sec ; %frequency HZ
        Channel_event_rate = [ Channel_event_rate   Freq ];
        Channel_event_number = [ Channel_event_number   length( index ) ];
        Channel_events = [ Channel_events   length( index )  Freq   ];
    else
        Channel_event_rate = [ Channel_event_rate  0 ];
        Channel_event_number = [ Channel_event_number   0 ];
        Channel_events = [ Channel_events   0  0  ];
    end
    
    CH_num = [ CH_num  channel   ] ;
    
    %         index = index_all *1e3/handles.par.sr;                  %spike times in ms.
    
    spikes = spikes_all;
    % saving each channel spikes and spike times for clustering
    if SIMPLE_RASTER ~= 'y'
        init_dir = cd ;
        cd(    SPIKESDIR);
        channel_spikes =[char(file_to_cluster) '_CH' int2str(channel) '_spikes' ];
        eval(['save ' char(channel_spikes) ' spikes index']);    %saves Sc files
        cd(init_dir);
    end
    %digits=round(handles.par.stdmin * 100);
    % nfile=[char(file_to_cluster) '_sp_th' num2str(digits)]
    % eval(['save ' nfile ' spikes index']);    %save files for analysis
    
    
    % if data file is too long then save raster during analysis
    if var.read_one_split_block
        Buffer_raster_filename = [ char(file_to_cluster) '_Raster_temp.' Raster_file_ext ];
        Raster_file =[ Buffer_raster_filename ] ;
        fid = fopen(Raster_file , 'w');
        fprintf(fid, '%.3f  %d  %.4f %.4f\n', index_r');
        fclose(fid);
    end
    
end
clear a ;


if  handles.par.Post_stim_potentials_collect
    %     if handles.par.Post_stim_potentials_external_artifact
    if    handles.par.Post_stim_potentials_external_artifact_GUI
        handles.par.Post_stim_potentials_external_artifact_file = '' ;
        
        Details.option_data_all = option_data_all ;
        
        shows = true ;
        
        if isfield( Arg_plus  , 'FILE_LIST_PROCESS' )
            if Arg_plus.FILE_LIST_PROCESS
                shows = false ;
            end
        end
        
        if shows
            %          clear option_data_all ;
            Show_all_post_stim_signals_8x8
            
        end
        
        
        
    end
end

if var.read_one_split_block
    delete( Buffer_raster_filename );
end

if strcmpi(DATA_TYPE,'.mcd')
    MCD_file_close ;
end
%     Dest_dir
currdir = cd ;
currdir
%     cd( Dest_dir )


minisi = min( minmin ) ;
%     minisi



whos index_r ;
Thr_all ;

%Channel_event_rate = [ CH_num ; Channel_event_rate ]'   ;
%Channel_event_number = [ CH_num ; Channel_event_number ]'   ;
Channel_events = [ CH_num ;  Channel_event_number ; Channel_event_rate  ]'   ;



nfile=[char(file_to_cluster) '_spike_rate_at_channels.txt' ];
nfile2=[char(file_to_cluster) '_spike_events_at_channels.txt' ];
filefrequency =[char(file_to_cluster) '_Channel_Frequency.txt' ]  ;

%dlmwrite(nfile , Channel_event_rate ,'delimiter', ' ' )
% dlmwrite(nfile2 , Channel_event_number ,'delimiter', ' ' )
%     dlmwrite( filefrequency , Channel_events  ,'delimiter', '\t' )

Raster_file =[char(file_to_cluster) '_Raster_' int2str( floor( SIGMATRES) )  'sigma.' Raster_file_ext ] ;
%dlmwrite(Raster_file , index_r ,'delimiter', '\t',  'precision', '%.3f' )
%dlmwrite(Raster_file , index_r , ' ')

save_raster = true ;

if  handles.par.Post_stim_potentials_collect
    
    save_raster = false ;
    if handles.par.Detect_spikes_when_collectingLFP
        save_raster = true ;
    end
end

if save_raster && ~isempty( index_r)
    
    fid = fopen(Raster_file , 'w');
    fprintf(fid, '%.3f  %d  %.4f %.4f\n', index_r');
    fclose(fid);
    
end
%
% whos index_r
% whos artefacts_all

if Artefacts_find == 'y'
    Artefact_file =[char(file_to_cluster) '_Artefact_'  num2str(SIGMATRES, '%.1f\n')  'sigma.' Raster_file_ext ] ;
    
    fid = fopen(Artefact_file , 'w');
    fprintf(fid, '%.3f  %d\n', artefacts_all');
    fclose(fid);
end


% save parameters of traces
Sigma_number_threshold =  SIGMATRES ;
%     Detect_info  =  char(handles.par.detection)   ;
Detect_info =  handles.par ;
Details.Detect_info = Detect_info ;
DetailsFile =[char(file_to_cluster) '_Details.mat' ]

Sample_rate = handles.par.sr ;

Details.Sample_rate = Sample_rate;
Details.Trace_Lenght_pionts = Trace_Lenght_pionts ;
Details.Trace_length_sec= Trace_length_sec ;
Details.Detect_info = Detect_info ;
Details.N_channels = N_channels   ;
Details.MEA_type     = DATA_TYPE       ;
Details.option_data_all = option_data_all ;

%
%         eval(['save ' char( DetailsFile ) ' Details Sample_rate Trace_Lenght_pionts Trace_length_sec Detect_info Thr_one_sigma_all' ...
%         ' Thr_all Sigma_number_threshold Raster_file  -mat']);



if AWSR_MAKE_AND_SAVE_TO_BMP == 'y'
    AWSR_file(Raster_file , cd , 50) ;
end
% eval(['save ' char( Raster_file ) '  index_r  -scii']);

%     Raster_file =[char(file_to_cluster) '_Raster.mat'  ];
%     eval(['save ' char( Raster_file ) '  index_r  -mat']);



if Make_binary_traces == 'y'
    spikes_traces = [ times zeros( Trace_Lenght_pionts , CH  ) ];
    for channel= 2 : CH    +1
        extract_channel_index = find ( index_all_channels(:,2 ) == channel -1   ) ;
        channel_index = index_all_channels( extract_channel_index , 1 ) ;
        spikes_traces(  channel_index(:) , channel ) = 1 ;
    end
    mattracenfile=[char(file_to_cluster) '_Binary_Traces.txt' ]    ;
    eval(['save ' char(mattracenfile) ' spikes_traces -ascii']);
end

if Show_raster == 'y'
    subplot(1,1,1); plot( index_r(:,1) / 1000 , index_r(:,2) , 'k*' )
    axis( [ 0 Trace_length_sec 0 65 ] ) ;
    xlabel( 'Time, s' )
    ylabel( 'Electrode' )
end



%--------------------save Raster and all info in one mat file
Sigma_number_threshold =  SIGMATRES ;
Detect_info  =  char(handles.par.detection)   ;
Result_MAT_file =[char(file_to_cluster) '_MAT_raster.mat' ]

% index_r  - raster
if Artefacts_find == 'y'
    Artefacts_included = true ;
else
    Artefacts_included = false ;
    artefacts_all=[];
end

if ~isempty( Arg_plus.Artefact_file )
    Artefacts_included = true ;
    artefacts_all = Arg_plus.artefacts_all ;
end


bursts_analyzed = false ;

RASTER_data.Thr_one_sigma_all = Thr_one_sigma_all ;
RASTER_data.Thr_all =Thr_all;
RASTER_data.Sigma_threshold = Sigma_number_threshold;
RASTER_data.Raster_file = Raster_file;
RASTER_data.Experiment_name = Experiment_name;
RASTER_data.index_r = index_r;
RASTER_data.artefacts =artefacts_all;
RASTER_data.N_channels=N_channels;
RASTER_data.Detect_info=Detect_info;
RASTER_data.spikes_exist = true ;
RASTER_data.Raster_Flags = zeros( 40 , 1 ) ;
RASTER_data.Raster_Flags( RASTER_FLAG_Artefacts_included ) = Artefacts_included ;
RASTER_data.Raster_Flags( RASTER_FLAG_bursts_analyzed ) = false ;
RASTER_data.Raster_Flags( RASTER_FLAG_all_data_included ) = 1 ;
% c == 0 - empty RASTER_DATA
% c == 1 - all data fine
% c == 2 - only index_r
% c == 3 - artifacts also

Parameters.Experiment_name = Experiment_name ;
if exist( 'Original_filename')
    Parameters.Original_filename = Original_filename ;
    [pathstr,name,ext] = fileparts( Original_filename ) ;
    Parameters.Original_path  = pathstr ;
end
Parameters.Burst_Data_Ver = Burst_Data_Ver ;
Parameters.N_channels = CH ;
DateTime_created.Analysis_TimeAndDateAsVector = clock ;
DateTime_created.Analysis_DateAsString = date ;
Parameters.DateTime_created = DateTime_created ;
Parameters.Search_Params = Search_Params ;
Parameters.Global_flags = Global_flags ;


%     eval(['save ' char( Result_MAT_file ) 'Experiment_name  N_channels  Sample_rate Trace_Lenght_pionts Trace_length_sec Detect_info Thr_one_sigma_all' ...
%         'Details Thr_all Sigma_number_threshold Raster_file index_r Artefacts_included bursts_analyzed artefacts_all  -mat']);

if  handles.par.Post_stim_potentials_collect || length( handles.par.Details_Options1chan_amps_hist_x )
    
    if isfield( option_data , 'post_stim_signals_all' )
        
        Sigma_number_threshold =  SIGMATRES ;
        Detect_info  =  char(handles.par.detection)   ;
        Result_LFP_file =[char(file_to_cluster) '_LFP_signals.mat' ]
        
        
        eval(['save ' char( Result_LFP_file )  ' Details   Experiment_name  RASTER_data  -mat']);
        Details.option_data_all = [] ;
    end
end

if handles.par.save_filtered_signals_to_mat_file
    eval(['save ' char( Result_MAT_file )  ' Details   Experiment_name  RASTER_data  Signals_all -mat']);
else
    eval(['save ' char( Result_MAT_file )  ' Details   Experiment_name  RASTER_data  -mat']);
end

%-----------------------------------------------------


%--------------- RASTER DATABASE create raster
%     Experiment_name

%            RASTER_data.Thr_one_sigma_all = Thr_one_sigma_all ;
%             RASTER_data.Thr_all =Thr_all;
%             RASTER_data.Sigma_threshold = Sigma_number_threshold;
%             RASTER_data.Raster_file=Raster_file;
%             RASTER_data.Experiment_name = Experiment_name;
%             RASTER_data.index_r = index_r;
%             RASTER_data.artefacts =artefacts_all;
%             RASTER_data.Artefacts_included =Artefacts_included;
%             RASTER_data.bursts_analyzed=bursts_analyzed;
%             RASTER_data.N_channels=N_channels;
%             RASTER_data.Detect_info=Detect_info;
%             RASTER_data.Bursts_analyzed = false ;
%             RASTER_data.PostStim_response_analyzed = false ;
%
%     Details.Sample_rate = Sample_rate;
%     Details.Trace_Lenght_pionts = Trace_Lenght_pionts ;
%     Details.Trace_length_sec= Trace_length_sec ;
%     Details.Detect_info = Detect_info ;
%     Details.N_channels = N_channels   ;
%     Details.MEA_type     = DATA_TYPE       ;
%     Details.Experiment_comment = '' ;

if Global_flags.autosave_to_DB
    [Raster_exists ,Raster_exists_with_other_sigma ] = Add_new_Raster_RASTER_DB( Experiment_name , ...
        Sigma_number_threshold   ,RASTER_data , Details ) ;
end
%     up =userpath ; up(end)=[];
%     DB_dir_name = 'DB_meadata';
%     DB_dir = [char(up) '\' DB_dir_name ];
%     Result_MAT_file_DATABASE =[char(DB_dir) '\' char(Experiment_name) '.mat' ]   ;
%
%     Result_MAT_file_DATABASE;
%
%     if exist(DB_dir,'dir') == 0
%             mkdir(up, DB_dir_name);
%     end
%
%
%     if exist(Result_MAT_file_DATABASE,'file') > 0
%        DB = load( Result_MAT_file_DATABASE );
% %        DB.rasters_number;
%        if  ~isfield( DB ,'rasters_number')
%             DB.rasters_index.Sigma_threshold = Sigma_number_threshold;
%             DB.rasters_index.index_of_raster = 1;
%             DB.rasters_number=1;
%             DB.RASTER_data = RASTER_data;
%        else
% %            rasters_index_in_DB = find( DB.rasters_index(:).Sigma_threshold  == Sigma_number_threshold );
%            [rasters_index_in_DB,n] = find(cat(1,DB.rasters_index.Sigma_threshold) == Sigma_number_threshold );
% %            rasters_index_in_DB;
%             if length( rasters_index_in_DB)>0
%                 %raster exists
%                 ;
%             else
%                DB.rasters_number= DB.rasters_number+1;
%                DB.rasters_index( DB.rasters_number ).Sigma_threshold = Sigma_number_threshold;
%                DB.rasters_index( DB.rasters_number).index_of_raster = DB.rasters_number ;
%                DB.RASTER_data = [ DB.RASTER_data RASTER_data ];
%             end
%        end
%     else
%          DB.rasters_index.Sigma_threshold = Sigma_number_threshold;
%             DB.rasters_index.index_of_raster = 1;
%             DB.rasters_number=1;
%             DB.RASTER_data =RASTER_data;
%     end
%
%     RASTER_data = DB.RASTER_data;
%     rasters_number = DB.rasters_number ;
%     rasters_index = DB.rasters_index ;
%     MEA_type = DATA_TYPE ; % '.mcd' '.med'
%     Experiment_comment = '' ;
%
%      eval(['save ' char( Result_MAT_file_DATABASE ) '    Sample_rate Trace_Lenght_pionts Trace_length_sec  ' ...
%         '   RASTER_data rasters_number rasters_index MEA_type Experiment_comment -mat']);







%---------------------------------------------------
%sample_spikes_only_CH_data = spikes_traces ( : , 3 ) ;
%sample_spikes_only_CH_data = [ times sample_spikes_only_CH_data ];
%CH1spikes_tracenfile=[char(file_to_cluster) '_CH1_binary_trace.txt'  ]
%  eval(['save ' char(CH1spikes_tracenfile) ' sample_spikes_only_CH_data -ascii']);    %sample spikes 1 channel

%clear sample_spikes_only_CH_data ;
times = [] ;


toc
% end  % list files for
% cd( init_dir ) ;
% clear
