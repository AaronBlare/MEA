function [spikes,thr,index,amps,one_sigma_thr,artefacts, option_data , artefact_amps] = ...
    amp_detect3_artefacts_copy(  handles,collect_sigma_from,collect_sigma_to,Show_volt_index_art_in)
% Detect spikes with amplitude thresholding. Uses median estimation.
% Detection is done with filters set by fmin_detect and fmax_detect. Spikes
% are stored for sorting using fmin_sort and fmax_sort. This trick can
% eliminate noise in the detection but keeps the spikes shapes for sorting.
%% Init 
global x ;
artefacts = [] ;
option_data = [] ;
sr=handles.par.sr;
w_pre=handles.par.w_pre;
w_post=handles.par.w_post;
ref=handles.par.ref;
detect = handles.par.detection;
stdmin = handles.par.stdmin;
stdmax = handles.par.stdmax;
fmin_detect = handles.par.detect_fmin;
fmax_detect = handles.par.detect_fmax;
fmin_sort = handles.par.sort_fmin;
fmax_sort = handles.par.sort_fmax;
ARTEFACT_threshold = handles.par.ARTEFACT_threshold ;
Original_channel_save = 'n' ; %handles.par.Original_channel_save ;
Filtered_channel_save = handles.par.Filtered_channel_save ;
Show_filtered_trace_hist = 'n' ;

Filter_50Hz_of_signal = handles.par.Filter_50Hz_of_signal ;  %  'n' ; % FFT of signal
 Filter_50Hz_iirnotch_sig  = handles.par.sig_50Hz_iirnotch ;


show_additional_par_signal = true ;
show_figures =handles.par.detect_Show_any_figures;

Each_plot_set_color = true ;

Artefacts_find = handles.par.Artefacts_find ; 
ARTEFACT_thr_search_expected = handles.par.ARTEFACT_thr_search_expected ; % % Expected ISI (sec)
New_Artefact_detect_method = true ;

if handles.par.Artefacts_find
%     fmin_detect = handles.par.Artifact_low_freq ;
end

if  handles.par.Post_stim_potentials_collect
  fmin_detect_LFP =  handles.par.Post_stim_potentials_LowFreq   ; % Hz
   fmax_detect_LFP =  handles.par.Post_stim_potentials_HighFreq   ; % Hz
    Filter_50Hz_of_signal_LFP =     handles.par.Post_stim_potentials_50Hz_filter ;
    
%     use_signal_copy_LFP = true ;
     use_signal_copy_LFP = false ;   
    
    % if we use different filtering for LFP and spikes then make signal
    % copy for LFP
    
        %     if fmin_detect == fmin_detect_LFP && fmax_detect == fmax_detect_LFP   ...
        %                 && Filter_50Hz_of_signal_LFP == Filter_50Hz_of_signal 
        %        use_signal_copy_LFP = false ;   
        %     else
        %         xf_detect= x ;
        %         use_signal_copy_LFP = true ;
        %     end
            
    
%     fmin_detect = 550 ;
end

if Artefacts_find
%     handles.par.threshold_fromFit_method = false ;
end
 

simple_detection = handles.par.simple_detection ;

analyzing_all_channels = false ;
if isfield( handles , 'analyzing_all_channels' )
    analyzing_all_channels = handles.analyzing_all_channels ;
end

if analyzing_all_channels
    Amplitudes_histogram = false ;
else
    Amplitudes_histogram = ...
           handles.par.Details_Options1chan_include_amps_show_hist ;
end

if  handles.plot_multiple_signals
    Amplitudes_histogram = false ;
end

if ~isfield( handles.par , 'threshold_use_defined' )
    handles.par.threshold_use_defined = false;
end


Calc_characteristics = 'n' ;
Thr_fragment = 'n' ;
POST_STIM_MS_TO_ERASE = handles.par.post_stimulus_erase ;
 
Build_FFT_of_signal = handles.par.Build_FFT_of_signal ;  %   % FFT of signal



Show_volt_index_art = Show_volt_index_art_in ;
if Show_volt_index_art == 'y' 
%     Original_channel_save  = 'y' ;
end

index = [] ;
amps = [] ;
spikes= [] ;
artefact_amps = [] ;
thr= [] ;  
one_sigma_thr= [] ;
artefacts= [] ;
option_data= [] ;

if handles.par.thresholdtype == 'sd' 
   SD = 'y' ; % use standard deviation for treshold 
else
   SD = 'n' ; 
end
SIMPLE_RASTER = handles.par.calculate_only_raster ;

AMP_THR = 0.005 ;

Thr_from = handles.par.collect_sigma_from ;
Thr_To = handles.par.collect_sigma_to ;

Thr_from = 1+( handles.par.sr  )* Thr_from ;
Thr_To = ( handles.par.sr  )* Thr_To  ; % collect sigma till 10 sec


Dat = ( sr / 1000 )* POST_STIM_MS_TO_ERASE  ; % 10 msec erase spikes after & before artefacts

Show_any_figures = true ;
Show_any_figures  = handles.par.detect_Show_any_figures ;

%AMP_THR = 0.002 ;

% HIGH-PASS FILTER OF THE DATA
% xf=zeros (length(x),1);
L_s =  length( x ) ;  % length( x ) ;                     % Length of signal
if Original_channel_save == 'y'
    %FF =  [ 'original_trace_' int2str( Original_channel_save ) ] ;
    FF =   'original_trace_' ;
    dax = x' ;
    dax( end - floor( length( dax )*0.65):end)=[];
% %     eval(['save ' char( FF ) ' dax  -ascii']); 
    eval(['save ' char( FF )    ' dax   -ascii  ']); 
%     save(char( FF ), 'dax',  '-ascii', '-tabs' )
    fid = fopen('original_trace.txt', 'w');

% fprintf(fid, '%.5f \n', dax );
fprintf(fid, '%.4f \n', dax );

fclose(fid);
clear dax

end   

if length(x) > 25332000 
%     l2=floor( length(x) /2 ) ;
%     x1=x(1:l2);
%     x2=x(l2+1:end);
%     clear x;
% x1=zeros(length(x1),1);
% [b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
% xf_detect1=filtfilt(b,a,x1);
% xf_detect2=zeros(length(x2),1);
% [b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
% xf_detect2=filtfilt(b,a,x2);   
% xf_detect = [xf_detect1 xf_detect2];
% clear xf_detect2
% clear xf_detect1
%    
% else
end
  
% 
% figure
% hold on
% plot( x )
% plot( xf_detect , '-r')
% hold off

       option_data.Optimal_art_criteria = 0 ;
            option_data.Optimal_art_Optimal_Closest_interval_to_expected = 0 ;
            option_data.Optimal_art_Optimal_Number_of_Artifacts=0 ;
            option_data.Optimal_art_Optimal_Interval_variability_std_sec = 0 ;
      
%% Artifacts         

%   if ~handles.par.Post_stim_potentials_external_artifact 
   if ~handles.par.Post_stim_potentials_external_artifact_GUI    
%         xaux = find(abs(xf_detect(1:end- Dat )) > ARTEFACT_threshold   ) ; 
        

 if Artefacts_find 
       
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
     Detect_art
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     Plot_multi_signals_while_working
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
 end
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
Filter_spikes_near_artifacts

else  % Post_stim_potentials_external_artifact_GUI
       
%% Load External artifacts   
    handles.par.Post_stim_potentials_external_artifact_file
    if  ~strcmp(  handles.par.Post_stim_potentials_external_artifact_file , '' )
        fullname =handles.par.Post_stim_potentials_external_artifact_file ;  
    else
             [filename,PathName] = uigetfile('*.*','Select file');
             fullname = [PathName filename ]; 
            
    end
    fullname
        artefacts = load( fullname ) ;   
        
    if ~isempty( artefacts )
        artefacts = (artefacts / ( 1e3/handles.par.sr))   ;
        artefacts = artefacts( :,1);
    end
%         artefacts( 5 :end) = [] ;
%  artefacts( 1 :3) = [] ;
 
    
   end       
   
   
  %% Post_stim_potentials_collect

 if  handles.par.Post_stim_potentials_collect 
 Post_stim_potentials_collect
 end 
   
%% Detect_spikes_script
   
   
% handles.par.threshold_fromFit_method = true ;
Detect_spikes_script
 
% aux = find(spikes(:,w_pre)==0);       %erases indexes that were artifacts
% spikes(artefacts,:)=[];
% index(artefacts)=[];
% amps(artefacts)=[];   

 

 %% Stuff
 

if handles.par.Details_Options1chan_include_amps && Amplitudes_histogram
  
   option_data.Amplitudes_one_channel =  amps' ;
   
   handles.par.Details_Options1chan_amps_hist_x
   
   x_hist = handles.par.Details_Options1chan_amps_hist_x;
   histo = histc( amps , x_hist );
    histo = 100 * histo / length( amps );
    
    option_data.Amplitudes_amps_hist_x = x_hist' ;
    option_data.Amplitudes_amps_hist  = histo' ;

    if Amplitudes_histogram
        if ~isempty( histo )
        figure
        bar( x_hist * 1000 , histo );
        ylabel( 'Count, %')
        xlabel( 'Spike amplitude, uV' )
        end
    end
   
end

%% amp_Calc_characteristics




amp_Calc_characteristics














