% PROGRAM MED_Convert_file
% Gets spikes from all files in Files.txt.
% Saves spikes and spike times.
function [ Artefact_file , artefacts_trains_number , ... 
   artefacts_files , artefacts ]  = MED_Convert_file_1chan_artefacts( Input_file , ...
   SIGMATRES , ARTEFACTS_ON ,sigma_from_sec ,  sigma_to_ms ,...
    channel_to_analyze , Arg_plus ) 

N = 60 ;

ch_1 = channel_to_analyze ;  
ch_2 =  channel_to_analyze  ;% number of channels to convert

      artefacts_files = {} ;
      artefacts_trains_number = 0 ;
      
      
%%%%%%%%%%%%%%
GLOBAL_CONSTANTS_load
%%%%%%%%%%%%%%

handles.par.ARTEFACT_search_around_selected_elec = ...
    Arg_plus.ARTEFACT_search_around_selected_elec  ;
handles.LFP_stim_num=Arg_plus.LFP_stim_num;
if isempty( channel_to_analyze ) 
channel_to_analyze = 1 : 60  ;
end

 
channel_to_analyze_around = [] ;
handles.par.ARTEFACT_thr_search_expected = Arg_plus.ARTEFACT_thr_search_expected  ;
 

if numel( channel_to_analyze ) > 1 
handles.plot_multiple_signals = true ;
else
    handles.plot_multiple_signals = false ;
end

if length( channel_to_analyze_around )>1 
    handles.plot_multiple_signals = true ; 
    channel_to_analyze = [channel_to_analyze  channel_to_analyze_around  ] ;
    
    if ARTEFACTS_ON
        Save_artefacts_many_channels = true ; 
    end
else
%    handles.plot_multiple_signals = false ;  
   Save_artefacts_many_channels = false ; 
end
handles.plot_multiple_signals_colors = [ 'b'  'r' 'g' ] ;



% SIMPLE_RASTER = 'n' ;
SIMPLE_RASTER = 'y' ;
Make_binary_traces = 'n' ;      % Make binary traces for all channels  'y' - yes , 'n' - no
Artefacts_find = ARTEFACTS_ON  ;
CHANNEL_MEA_LETTER = 'A' ; % CHANNEL_MEA_LETTER = 'A';

if  Arg_plus.GetFromFile 
%     [ numc1 , numc2 ] =  meaman_extract_file_param( Input_file ) ;
    [ numc1 , numc2 , ISI] =  meaman_extract_file_param( Input_file );
%     channel_to_analyze  = readChanNum( numc1    ) ;   
    channel_to_analyze  = ( numc1    ) ; 
    if ISI > 0 
    Arg_plus.ARTEFACT_thr_search_expected = ISI ;
    end
end

if ~Arg_plus.analyze_A_mea && Arg_plus.analyze_B_mea  
    CHANNEL_MEA_LETTER = 'B';
    if  Arg_plus.GetFromFile 
     [ numc1 , numc2 , ISI] =  meaman_extract_file_param( Input_file ) ;
%     channel_to_analyze  = readChanNum( numc2    ) ;   
     channel_to_analyze  =  ( numc2    ) ;   
     if ISI > 0 
    Arg_plus.ARTEFACT_thr_search_expected = ISI ;
    end
end
end


Show_raster = 'n' ;
use_6well_mea = true ;



MEA_prefix = '' ;
if strcmp( CHANNEL_MEA_LETTER ,  'B' )
    MEA_prefix = '_meaB_' ;
end


handles.par.stdmin = SIGMATRES ;         %minimum sigma threshold
handles.par.calculate_only_raster = SIMPLE_RASTER ;
% handles.par.Filtered_channel_save = SIMPLE_RASTER ;

handles.par.Artefacts_find = Artefacts_find ;

use_6well_mea = Arg_plus.use_6well_mea  ;
handles.par.Post_stim_potentials_external_artifact_GUI = false ;
 handles.par.Post_stim_potentials_collect = Arg_plus.Post_stim_potentials_collect ;
 if handles.par.Post_stim_potentials_collect
     if ~Artefacts_find 
         handles.par.Post_stim_potentials_external_artifact = true ;
         handles.par.Post_stim_potentials_external_artifact_GUI = true ;
     end
         
 end

Collect_sigma_from = 1+( handles.par.sr  )* sigma_from_sec ;
Collect_sigma_to =     ( handles.par.sr  )* sigma_to_ms  ; % collect sigma till 10 sec


 

% CHANNEL_MEA_LETTER = 'A' ;

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
    artefacts_all_number_each_chan = [] ;
    artefacts_all_std_diff_each_chan = [] ;
    artefacts_vs_ch = [] ;
    artefacts_amps = [] ;
    artefacts_amps_all = [] ;
    artefacts_all_each_channel = {} ;
    artefacts_each_channel   = {} ;
    artefacts_all_each_channel_chan = [] ;
    each_channel_data = [] ;
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
    %a = medload( char(file_to_cluster) , 'all' , 500 );
    switch DATA_TYPE
      case '.med'
            a = medload1ch( char(file_to_cluster) , 1  , 1 , MAX_MEMORY_MB );
            %'1 channel loaded'
           %a = medload( char(file_to_cluster) , 'all' , MAX_MEMORY_MB );
           [pathstr,name,ext ] = fileparts ( file_to_cluster ) ;
           file_to_cluster = name ;  
           
      case '.txt'      
%            a = load('-ascii', char(file_to_cluster)  );
           DATA_a = importdata(char(file_to_cluster) , ' ', 4);
           a = DATA_a.data ;
           clear DATA_a ;
          file_to_cluster = name ;
      case '.mcd'    
          FILENAME = file_to_cluster ;
%           p=cd;
%           p
          OpenMCDfile_for_reanding          
          
           [pathstr,name,ext ] = fileparts ( file_to_cluster ) ;
           file_to_cluster = name ;               
           CH = 60 ;
    end        
   % 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if  DATA_TYPE == '.mcd'        
       time_offset=FileInfo.TimeStampResolution;
       Trace_Lenght_pionts=TimeSpanSamples;
       Trace_length_sec =  Trace_Lenght_pionts / handles.par.sr      
   else
       times = a( : , 1) ;
        time_offset =  times( 1 );
        whos times ;
        Med_note = '' ;
        Trace_Lenght_pionts = length( times ); 
        Trace_length_sec = Trace_Lenght_pionts / handles.par.sr 
        %times = times *1e3/handles.par.sr ;  %1000/sr  - time in ms
        if Make_binary_traces ~= 'y' & DATA_TYPE ~='.txt' 
            clear  times ;
            clear  a ;
        end  
   end
   
   
 
if handles.par.ARTEFACT_search_around_selected_elec
    
    channel_to_analyze_around = [] ;
    
   if numel( channel_to_analyze ) == 1 
%        if channel_to_analyze == 0 
%            channel_to_analyze_around
%        else
           
      if  handles.par.ARTEFACT_search_around_always_test_all_channels  
          channel_to_analyze_around = [ 1 : 60 ] ; 
      else


           channel_to_analyze_around = [] ;
            channel_to_analyze_around =  channel_to_analyze ;
           for  ii = 1 : N 
              dist = MEA_channels_dist( channel_to_analyze , ii ) ;
            if dist <= 1*sqrt(2) && ii ~= channel_to_analyze
               channel_to_analyze_around = [ channel_to_analyze_around ii ] ;
            end
           end
%        end
      end
   end
   channel_to_analyze_around
   
     if handles.par.Art_auto_search_global
         channel_to_analyze_art = channel_to_analyze_around
         
%          handles.par.ARTEFACT_thr_search_expected ;
        
%        if   Arg_plus.ARTEFACT_thr_search_expected == 0  
%            channel_to_analyze_art = [ 1 : 60 ] ;
% 
%        end
         
         Collect_all_art_signals =  handles.par.detect_Show_any_figures ;
       Test_all_channels_find_stim
       
       % output : CHANNEL_NUM
       channel_to_analyze = CHANNEL_NUM ;
     end
   
     
else
    
%     if handles.par.ARTEFACT_thr_search_expected == 0 
    handles.par.Find_one_correct_artefact = false ;
%     end
end
   
   
    minmin = [] ;
%     if DATA_TYPE == '.med'
%                 b= load( char(file_to_cluster) );
%                 
%     end            
       global x ;
       
               if handles.plot_multiple_signals
            hh = figure;
               end
    
    for chi = 1 : length( channel_to_analyze )       %that's for cutting the data into pieces
        % LOAD CONTINUOUS DATA
       % eval(['load ' char(file_to_cluster) ';']);       
        index_all=[];
        spikes_all=[];
        x = [] ;
        channel = channel_to_analyze( chi );
        if handles.plot_multiple_signals
%             hh = figure;
%             handles.plot_multiple_signals_handle = hh ;
            handles.plot_multiple_signals_curr_color = 'b' ;
            if chi < length( handles.plot_multiple_signals_colors ) ;
                 handles.plot_multiple_signals_curr_color = handles.plot_multiple_signals_colors( chi );
            end
        end
        
        

            
        switch DATA_TYPE
           case '.med'
%                 a = [] ;             
%                 a = medload1ch( char(file_to_cluster) , channel  , 'all' , MAX_MEMORY_MB );   
% %                 b= load( char(file_to_cluster) );
%                 x = a( : , 2 )';
%                 a=[];
                
                var.read_one_split_block = false ;    
                 var.blocks_split_num = 2 ;
                 var.blocks_to_read = 1 ; 
                   
                [ x , time_0 ]=  medload1_without_timestampch( char(file_to_cluster_full) , channel  , 'all' , MAX_MEMORY_MB , var)  ;
                 
                x=x';
                 
%                 b= load( char(file_to_cluster) );
                time_0
                
           case '.txt'      
                x =   a( : , channel + 1 )';   
                
           case '.mcd'      
               
                CHANNEL_NUM = channel ;
                Reading_MCD_Channel_Data = 0
                Read_MCD_Channel_Data ;
%                 x=crrData2Save' ;
% x=x' ;
%                 clear crrData2Save
        end        
       
        %if channel == Original_channel_save
        %    SAVE_ORIGINAL = 'y' ;
        %else SAVE_ORIGINAL = 'n'  ;            
        %end 
        %if channel == Filtered_channel_save
        %    SAVE_FILTERED = 'y' ;
        %else  SAVE_FILTERED = 'n';
        %end
        
          
       %  tsmin = (channel-1)*floor(length( data )/handles.par.segments)+1;
        tsmin = 0 ;
        tsmax = floor(length( x ) );
        %if channel == 3  
        %    sampleCH_data = x' ;
       %     sampleCH_data = [ times sampleCH_data ];
       %     CH1_tracenfile=[char(file_to_cluster) '_CH1_trace.txt'  ]
          %  eval(['save ' char(CH1_tracenfile) ' sampleCH_data -ascii']);   % sample 1 channel trace   
       %     clear sampleCH_data ;
       % end
        %x=data ; 
        %clear data;        
        
        
        
        
%         x( 300000 : end) = [] ;
        
        whos x
        
        
        % SPIKE DETECTION WITH AMPLITUDE THRESHOLDING
%         [spikes,thr,index]  = amp_detect2_sound(x,handles);       %detection with amp. thresh.
        if PLAY_CHANNEL_SOUND == 'n' 
            if ~Artefacts_find 
%             [spikes,thr,index,amps,one_sigma_thr]  = amp_detect2( handles);       %detection with amp. thresh.

                handles.par.detect_Show_any_figures = true ;
                if numel( channel_to_analyze ) > 1
                    handles.par.detect_Show_any_figures = false ;
                end
                
                if isfield( Arg_plus  , 'FILE_LIST_PROCESS' )
                    if Arg_plus.FILE_LIST_PROCESS  
                         handles.par.detect_Show_any_figures = false ;
                    end
                    
                end

                handles.par.Artefacts_find = false  ; 
                
                if  handles.par.Post_stim_potentials_collect && handles.par.Detect_spikes_LFP
                     handles.par.Post_stim_potentials_collect = false ;
                     handles.par.Post_stim_potentials_external_artifact= false ;
                     handles.par.Artefacts_find  = false ;  
                     
                     handles.par.Post_stim_spike_response = false ;
                     
                     x0 = x ;
                 [spikes,thr,index,amps,one_sigma_thr,artefacts,option_data, artefact_amps] = ...
                     amp_detect3_artefacts_copy( handles, Collect_sigma_from  , Collect_sigma_to , 'y' );
            
                 
                 
                 
                 
                 
                 handles.par.Post_stim_potentials_collect = true ;
                 handles.par.Post_stim_potentials_external_artifact  = true ;
                 handles.par.Artefacts_find  = true ;
                 
                 
                 
                 index_ms = index *1e3/handles.par.sr   ;
                chan = ( channel - zero_channel ) * ones( 1 , length( index_ms ) )  ;
                index_vs_ch = [ index_ms ; chan ; amps]' ; 
                index_r =  index_vs_ch ;
                
                handles.index_r = index_r ; 
                
                handles.par.Post_stim_spike_response = true ;
                handles.par.channel = channel ;

                handles.flags.Burst_Data_Ver  = Burst_Data_Ver ;
                 x = x0 ;
%                  clear x0 ;
                 handles.par.Post_stim_potentials_LowFreq =   handles.par.Post_stim_potentials_SHOW_LowFreq ;
                  [spikes,thr,index,amps,one_sigma_thr,artefacts,option_data, artefact_amps] = amp_detect3_artefacts_copy( ...
                handles, Collect_sigma_from  , Collect_sigma_to , 'n' );
                 
                else
                
                
                [spikes,thr,index,amps,one_sigma_thr,artefacts,option_data, artefact_amps] = ...
                    amp_detect3_artefacts_copy( ...
                handles, Collect_sigma_from  , Collect_sigma_to , 'y' );
                end
            else
%                 xx = x( floor(  (length( x )*0.38 )) : floor(  (length( x )*0.39 )) );
                    %xx = x ;
                    handles.par.Artefacts_find = true  ;
                handles.par.detect_Show_any_figures = true ;
                if numel( channel_to_analyze ) > 1
                    handles.par.detect_Show_any_figures = false ;
                end
                handles.par.ARTEFACT_thr_search_expected = Arg_plus.ARTEFACT_thr_search_expected ;
           Expected_ISI = Arg_plus.ARTEFACT_thr_search_expected
                
                if isfield( Arg_plus  , 'FILE_LIST_PROCESS' )
                    if Arg_plus.FILE_LIST_PROCESS  
                         handles.par.detect_Show_any_figures = false ;
                    end
                    
                end
                
%                 [spikes,thr,index,amps,one_sigma_thr,artefacts,option_data, artefact_amps] = ...
%                 amp_detect3_artefacts(               handles, Collect_sigma_from  , Collect_sigma_to , 'y' );
            
            
% [spikes,thr,index,amps,one_sigma_thr,artefacts,option_data, artefact_amps] = amp_detect3_artefacts(   handles, Collect_sigma_from  , Collect_sigma_to , 'y' );

            [spikes,thr,index,amps,one_sigma_thr,artefacts,option_data, artefact_amps] = ...
                amp_detect3_artefacts_copy(   handles, Collect_sigma_from  , Collect_sigma_to , 'y' );               
%             artefacts_all  = [ artefacts_all artefacts ];
              artefacts = artefacts' ;
              
              amp_detect3_artefacts_done = 1 
              
              
            end    
            
        else    
        [spikes,thr,index]  = amp_detect2_sound(x,handles);       %detection with amp. thresh.    
        
        end
        
    if  handles.plot_multiple_signals  
        hold on
        cc=lines(  length(channel_to_analyze )  );
                plot(  option_data.signal_x, option_data.signal , 'color',cc( chi,:)   )
                xlim( [ min( option_data.signal_x ) max(option_data.signal_x) ])
        xlabel( 'Time, s' )
        ylabel( 'Voltage, mV')
        legends = {};
        for si = 1 :  length( channel_to_analyze ) 
            s = [ 'Electrode ' num2str( channel_to_analyze(si )) ] ;
            legends{ si } =  s  ;
        end
        legend( legends )
    end
        
        if Compressin > 1             
        DT =  Compressin ;
        index_buf = [] ;
        for ti = 1 : DT :  Trace_Lenght_pionts  - DT
           s = find( index >= ti & index < ti + DT ) ; 
           if s > 0 
             index_buf = [ index_buf  floor( ti / Compressin ) ] ;
           end            
        end            
        index = index_buf ; 
        end
            
        
        
        
        index_all = [index_all index];
        Thr_all = [ Thr_all thr ];
        amps_all = [ amps_all amps ] ;
        Thr_one_sigma_all = [ Thr_one_sigma_all one_sigma_thr ];
%         clear x ;
        channel
            index_ms = index  ;
        
            
            
         %---------------------------ARTEFACTS----------
       if Artefacts_find  
           if numel( artefacts ) > 0
                       artefacts_ms = artefacts' ;
                        if ( Raster_in_ms == 'y' )  
                            artefacts_ms = (artefacts *1e3/handles.par.sr)'   ;
                        end
                         chan2 = ( channel - zero_channel ) * ones(  1, length( artefacts ))  ;      
                         if iscolumn( artefacts_ms ) artefacts_ms=artefacts_ms' ; end
                         if iscolumn( artefact_amps ) artefact_amps=artefact_amps' ; end

%                     artefacts_vs_ch = [ artefacts_ms ; chan2 ]' ;
 
                    
                    artefacts_vs_ch  = [ artefacts_ms'   chan2'  artefact_amps' ]  ;
                    
                    artefacts_all = [ artefacts_all ; artefacts_vs_ch ];
                    
                   
                     if handles.par.detect_Show_any_figures 
                       figure
                       artefacts_ms_diff = diff(artefacts_ms) ;
                       art_x  = 1:numel( artefacts_ms_diff ) ;
                       hold on
                       plot(  artefacts_ms_diff , '-*b')
                       ylabel( 'Inter artifact intervals, ms ' )
                        
                       artefacts_ms_diff_filt = artefacts_ms_diff ;
                       
                       eras = find( artefacts_ms_diff_filt > handles.par.Max_interArtifact_interval_sec * 1000 ) ;
                       artefacts_ms_diff_filt( eras ) = []   ; 
                       art_x( eras ) = [] ; 
                       % filtered intervals for optimal artifact search
                       plot( art_x , artefacts_ms_diff_filt , '*r')
                       % 'Adequate intervals'
                       [h,p]= hist( artefacts_ms_diff_filt , 50 ) ;
                       [mx,mxi] = max( h ) ; % find peak in hist 
                       most_frequent_interval = p( mxi ) / 1000 ;  % get interval at that peak ;
                       most_frequent_interval
                        
%                        figure
%                        hist(  artefact_amps , 10 ) ;
                     end
                     
                        numel_artefact_amps =  numel( artefact_amps ) ;
                        artefacts_ms_diff = diff(artefacts_ms) ;
                        std_artefacts_ms_diff   = std( artefacts_ms_diff ) ;
                     
             else
                         numel_artefact_amps = 0 ;
                         std_artefacts_ms_diff  = 0 ;
                         artefacts_all = [] ;
           end
            
           artefacts_all_add = artefacts_all ;
           artefacts_add = artefacts ;
           if isempty( artefacts_all )
               artefacts_all_add  = 0 ; 
               artefacts_add = 0 ;
            end
            artefacts_all_each_channel = [ artefacts_all_each_channel artefacts_all_add ] ;
            artefacts_all_each_channel_chan = [ artefacts_all_each_channel_chan channel] ; 
            artefacts_each_channel  = [ artefacts_each_channel  artefacts_add ] ; 

                    artefacts_all_number_each_chan = [artefacts_all_number_each_chan ; [ channel  numel_artefact_amps ]] ;
                    
                    artefacts_all_std_diff_each_chan = [artefacts_all_std_diff_each_chan ; [ channel  std_artefacts_ms_diff ]] ;
                    
                    each_channel_data = [ each_channel_data option_data ] ;
                    
      end
               %------------------------------------------------      
            
            
        if length( index ) > 0                

               if ( Raster_in_ms == 'y' )    
                  index_ms = index *1e3/handles.par.sr   ;
           
                  minmin = [ minmin min( index_ms(2:end) - index_ms(1:end-1) ) ] ;
            
                 if Save_time_offset == 'y'
                    index_ms = index_ms + time_offset ;
                   end
               end           
             
               
               
                 chan = ( channel - zero_channel ) * ones( 1 , length( index_ms ) )  ;
%         length( index_ms )
%         length( amps )
% Raster_with_amp
                if ( Raster_with_amp == 'y' )
                  index_vs_ch = [ index_ms ; chan ; amps]' ; 
                else
                	  index_vs_ch = [ index_ms ; chan ]' ;
                end
                if isempty( index_ms )
                    index_vs_ch = [] ; 
                end
                
                if numel( index_ms ) ==1  &&  index_ms(1) == 0 
                    index_vs_ch = [] ; 
                end 
 
%               whos index_vs_ch
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
        
    end    
    clear a ;      
      
    minisi = min( minmin ) ;
%     minisi
    
    if ~isempty( artefacts_all_number_each_chan )
        
         
        Optimal_art_Optimal_Closest_interval_to_expected = [ each_channel_data(:).Optimal_art_Optimal_Closest_interval_to_expected ];; 
        Optimal_art_Optimal_Interval_variability_std_sec = ...
            [ each_channel_data(:).Optimal_art_Optimal_Interval_variability_std_sec ]; 
    Optimal_art_criteria = ...
            [ each_channel_data(:).Optimal_art_criteria ]; 
        
      channel_x =  artefacts_all_number_each_chan(:,1) ;
      art_num_all =  artefacts_all_number_each_chan(:,2) ;
      std_art_all = artefacts_all_std_diff_each_chan(:,2)  ;
   
 if numel( channel_x) > 1     
  figure
  art_num_all_p = art_num_all ;
  art_num_all_p( art_num_all_p == NaN ) = [] ;
   std_art_all_p = std_art_all ;
  std_art_all_p( std_art_all_p == NaN ) = [] ; 
  
    plot(  art_num_all_p , std_art_all_p , '*') ;
    xlabel( 'artefacts number');
    ylabel( 'std interval , ms');
    

    
    %------------------------------
    
    figure
     plot(  art_num_all_p , Optimal_art_criteria , '*') ;
    xlabel( 'artefacts number');
    ylabel( 'Optimal_art_criteria');   
    
    figure
     plot(  art_num_all_p , Optimal_art_Optimal_Interval_variability_std_sec , '*') ;
    xlabel( 'artefacts number');
    ylabel( 'Optimal_Interval_variability_std_sec');
    
    figure
     plot(  Optimal_art_Optimal_Interval_variability_std_sec , Optimal_art_Optimal_Closest_interval_to_expected , '*') ;
    xlabel( 'Optimal_Interval_variability_std_sec');
    ylabel( 'Closest_interval_to_expected');
    
    
    
        figure
     plot(  Optimal_art_criteria , Optimal_art_Optimal_Closest_interval_to_expected , '*') ;
    xlabel( 'Optimal_art_criteria');
    ylabel( 'Closest_interval_to_expected');
    
    
    %------------------------------
    
figure
Ny =2 ;
Nx = 1 ;



subplot( Ny , Nx , 1 )
% plot( artefacts_all_number_each_chan(:,1) , artefacts_all_number_each_chan(:,2) ) ;
f1 = bar(channel_x  , art_num_all ) ; 
title( 'artefacts -   number ') 
ylabel( 'artefacts number')
% set(gca,'YScale','log')
% figure
subplot( Ny , Nx ,2 )

hold on
f2 = bar( channel_x , ( Optimal_art_Optimal_Interval_variability_std_sec ) ) ; 
% set(gca,'YScale','log')
% set(h,'xscale','log')
title( 'artefacts - std interval  ') 
% ylabel( ' std interval , ms')
ylabel( 'Optimal_Interval_variability_std_sec')
% set(f2, 'YScale', 'log')
 end

Artefact_channel_number = 0 ;
handles.par.Find_one_correct_artefact = false
if handles.par.Find_one_correct_artefact
    
 artefacts_all_each_channel  ;
  artefacts_all_each_channel_chan ;

Find_one_correct_artefact
% out : Artefact_channel_number - best one 

  art_i = find( artefacts_all_each_channel_chan == Artefact_channel_number ) ;
  if ~isempty( art_i)
  artefacts_all =  artefacts_all_each_channel{ art_i } ;
  artefacts = artefacts_each_channel{ art_i } ;
whos artefacts_all
  end


% show signal of found artifact channels
  switch DATA_TYPE  
                
           case '.mcd'      
               
               show_additional_par_signal = true ;
               
                CHANNEL_NUM = channel ;
                Read_MCD_Channel_Data ;
%                 x=crrData2Save' ;
%                 clear crrData2Save
                
   sr=handles.par.sr;
                tx = 1:length( x );
                tx = tx / sr ;
                figure
                hold on 
                
              plot(  tx, x * 1 , 'b'  )

                if show_additional_par_signal 
                    
                    
                    y_artefacts= zeros( 1 , length( artefacts ) );
                    % y_artefacts( artefacts) = 0.90;
                    if length( y_artefacts )> 0
                    y_artefacts(:)  = thr * 2 ;
                    
                    artefacts( artefacts == 0 ) = [] ;
                    
                    y_artefacts   = x( floor( artefacts) ) ;
                   
                  
                    if length( y_artefacts )> 0
                      plot(  artefacts / sr, y_artefacts * 1  , 'gv' )
                    end 
                legend( 'Signal' ,   'artefacts' )
                    end
                end




  end

end

hold off
 
    end

%   linkaxes( [ f1 f2 ]   , 'x' );

    
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

if handles.par.Original_channel_save
   Raster_file =[char(file_to_cluster) '_Channel_raw_data.'  Raster_file_ext ] ;
   fid = fopen(Raster_file , 'w');
%    fprintf(fid, '%.5f \n', x');
   fprintf(fid, '%.4f \n', x');
   fclose(fid);
end

    
    Raster_file =[char(file_to_cluster) '_Raster_' Raster_file_ext ] ;
    %dlmwrite(Raster_file , index_r ,'delimiter', '\t',  'precision', '%.3f' )nt2str(floor( SIGMATRES))  'sigma.' Ras
        %dlmwrite(Raster_file , index_r , ' ')
        fid = fopen(Raster_file , 'w');
% fprintf(fid, '%.3f  %d  %.4f\n', index_r');
% fprintf(fid, '%.3f  %d  %.5f\n', index_r');
fprintf(fid, '%.3f  %d  %.4f\n', index_r');

fclose(fid);
% 
% whos index_r
% whos artefacts_all
Artefact_file=[];
if Artefacts_find 
    
    Art_name = '_Artefact_' ;
    if Save_artefacts_many_channels
        if numel( Artefact_channel_number ) > 1 
                Art_name = [ Art_name 'multiple_channels_' ] ;
        end
    end
      Artefact_file =[char(file_to_cluster) Art_name num2str(SIGMATRES, '%.1f\n')  'sigma.' Raster_file_ext ] ;
 
      if Artefact_channel_number > 0 
      channel = Artefact_channel_number ;
      end
      Artefact_file =[char(file_to_cluster) Art_name '_channel_' num2str(channel)  '.' Raster_file_ext ] ; 
      Artefact_file
      
        fid = fopen(Artefact_file , 'w');
%      fprintf(fid, '%.3f  %d\n', artefacts_all');
%      fprintf(fid, '%.3f  %d  %.5f\n', artefacts_all');     
     fprintf(fid, '%.3f  %d  %.4f\n', artefacts_all');     
     
      fclose(fid);    
      
      % save to dir with mcd file
      
%       Arg_plus.PathName 
%       Artefact_file =[Arg_plus.PathName   char(file_to_cluster) MEA_prefix '_Artefact_' num2str(SIGMATRES, '%.1f\n')  'sigma.' Raster_file_ext ] ;
%       Artefact_file =[Arg_plus.PathName   char(file_to_cluster)  MEA_prefix Art_name '_channel_' num2str(channel)  '.' Raster_file_ext ] ; 
  
Artefact_file_full =[Arg_plus.PathName  '\' Artefact_file ]  
 fid = fopen(Artefact_file_full , 'w');
%      fprintf(fid, '%.3f  %d\n', artefacts_all');
%      fprintf(fid, '%.3f  %d  %.5f\n', artefacts_all');     
     fprintf(fid, '%.3f  %d  %.4f\n', artefacts_all');     
     
      fclose(fid); 
 
      artefacts_files = {} ;
      artefacts_trains_number = 0 ;
      
      if  handles.par.ARTEFACT_split_into_files
          
          Spltf  =handles.par.ARTEFACT_split_into_files_art_num ;
          if numel( artefacts ) > Spltf
              Nar = floor( numel( artefacts ) / Spltf ); 
              artefacts_trains_number = Nar ;
              for Ni = 1 : Nar
                  A1 = (Ni-1)*Spltf + 1 ;
                  A2 = (Ni)*Spltf   ;
                  artefacts_all_i = artefacts_all( A1:A2 , : ) ; 
                  
                  Artefact_file =[Arg_plus.PathName ...
                      char(file_to_cluster)  MEA_prefix Art_name '_channel_'  num2str(channel) ...
                      '_part' num2str( Ni) '.' Raster_file_ext ] ; 
  
                  
                  artefacts_files = [ artefacts_files Artefact_file ] ;
                   fid = fopen(Artefact_file , 'w');
%                 fprintf(fid, '%.3f  %d  %.5f\n', artefacts_all_i');  
                fprintf(fid, '%.3f  %d  %.4f\n', artefacts_all');     
%                  fprintf(fid, '%.3f  %d  %.5f\n', artefacts_all');     
                  fclose(fid);    
              end
              
          end
          
      end
          
          
      artefacts = artefacts_all ;
  
       fid = fopen(Artefact_file , 'w');
%      fprintf(fid, '%.3f  %d\n', artefacts_all');
%      fprintf(fid, '%.3f  %d  %.5f\n', artefacts_all');    
     fprintf(fid, '%.3f  %d  %.4f\n', artefacts_all');     
      fclose(fid);   
      
%         fid = fopen(Artefact_file , 'w');
%      fprintf(fid, '%.3f  %d\n', artefacts_all');
%       fclose(fid);    
      
      
end


    % save parameters of traces
    Detect_info  =  char(handles.par.detection)   ; 
    DetailsFile =[char(file_to_cluster) '_Details.mat' ]   ;
    Sample_rate = handles.par.sr ;
%     eval(['save ' char( DetailsFile ) ' Sample_rate Trace_Lenght_pionts Trace_length_sec Detect_info Thr_one_sigma_all Raster_file option_data -mat']); 
    
    


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
