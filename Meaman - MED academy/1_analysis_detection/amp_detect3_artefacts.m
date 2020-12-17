function [spikes,thr,index,amps,one_sigma_thr,artefacts, option_data , artefact_amps] = amp_detect3_artefacts( ...
    handles,collect_sigma_from,collect_sigma_to,Show_volt_index_art_in)
% Detect spikes with amplitude thresholding. Uses median estimation.
% Detection is done with filters set by fmin_detect and fmax_detect. Spikes
% are stored for sorting using fmin_sort and fmax_sort. This trick can
% eliminate noise in the detection but keeps the spikes shapes for sorting.
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

Each_plot_set_color = true ;

Artefacts_find = handles.par.Artefacts_find ; 
ARTEFACT_thr_search_expected = handles.par.ARTEFACT_thr_search_expected ; % % Expected ISI (sec)
New_Artefact_detect_method = true ;

if handles.par.Artefacts_find
    fmin_detect = handles.par.Artifact_low_freq ;
end

if  handles.par.Post_stim_potentials_collect
  fmin_detect_LFP =  handles.par.Post_stim_potentials_LowFreq   ; % Hz
   fmax_detect_LFP =  handles.par.Post_stim_potentials_HighFreq   ; % Hz
    Filter_50Hz_of_signal_LFP =     handles.par.Post_stim_potentials_50Hz_filter ;
    
    use_signal_copy_LFP = true ;
    
    % if we use different filtering for LFP and spikes then make signal
    % copy for LFP
    if fmin_detect == fmin_detect_LFP && fmax_detect == fmax_detect_LFP   ...
                && Filter_50Hz_of_signal_LFP == Filter_50Hz_of_signal 
       use_signal_copy_LFP = false ;   
    else
        xf_detect= x ;
        use_signal_copy_LFP = true ;
    end
            
    
%     fmin_detect = 550 ;
end

if Artefacts_find
    handles.par.threshold_fromFit_method = false ;
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

Detect_spikes = true ;

%% Detect spikes
% If not collectim LFP then filter and find spikes
% if  ~handles.par.Post_stim_potentials_collect
if handles.par.Post_stim_potentials_collect 
  if  ~handles.par.Detect_spikes_when_collectingLFP
      Detect_spikes = false ; 
  end
    
end
    
if Detect_spikes
    
    
% xf_detect=zeros(length(x),1);


%% Build_FFT_of_signal
if Build_FFT_of_signal  
    
%      x =  xf_detect ;
Spectrum_color = '-b' ;
     figure 
     
    Fs = sr ;                    % Sampling frequency
    T = 1/Fs;                     % Sample time
    L =  L_s ;                     % Length of signal
    t = (0:L-1)*T;                % Time vector
    % Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
%     x = 0.7*sin(200*pi*50*t) + sin(2*pi*120*t); 
%     y = x + 2*randn(size(t));     % Sinusoids plus noise
%     y = x(1:L-1) ;
     
    NFFT= 2^(nextpow2(length( x ))); 

    % Take fft, padding with zeros so that length(fftx) is equal to nfft 
    fftx = fft(x,NFFT); 

% Calculate the numberof unique points
NumUniquePts = ceil((NFFT+1)/2); 

    % FFT is symmetric, throw away second half 
    fftx = fftx(1:NumUniquePts); 
    
    
    % Take the magnitude of fft of x and scale the fft so that it is not a
    % function of the length of x
    mx = abs(fftx)/length(x); 
    
    % Take the square of the magnitude of fft of x. 
    mx = mx.^2; 
    
     if rem(NFFT, 2) % odd nfft excludes Nyquist point
      mx(2:end) = mx(2:end)*2;
    else
      mx(2:end -1) = mx(2:end -1)*2;
     end  

    % This is an evenly spaced frequency vector with NumUniquePts points. 
    freq_fft = (0:NumUniquePts-1)*Fs/NFFT; 
     
     DF_smooth_parameter = handles.par.DF_smooth_parameter  ; 
    FFT_smooth_window = DF_smooth_parameter * NFFT  / Fs  ;
    mx = smooth( mx , FFT_smooth_window , 'loess')   ;
     mx( mx < 0) = 0 ;
    
    
    result.freq_fft = freq_fft ;
    result.fft_power = mx ;
     
%     y_filt = fft(xf_detect,NFFT)/L;
%     f = Fs/2*linspace(0,1,NFFT/2+1);

    % Plot single-sided amplitude spectrum.
    min_freq_value = handles.par.FFT_min_freq_show ; 
    max_freq_value = handles.par.FFT_max_freq_show ; 
    
%     Spectrum_color = '-b' ;
    CG_FFT_Line_width = 2 ;
    
%     plot(f,2*abs(Y(1:NFFT/2+1)) , f , 2*abs(y_filt(1:NFFT/2+1))) 
       plot( result.freq_fft , result.fft_power  , Spectrum_color , 'LineWidth', CG_FFT_Line_width, 'MarkerSize',3 );  
       
       
end
  
%% Filtering 
a = [];
if fmax_detect < sr /2  && fmax_detect >0  && fmin_detect > 0  
[b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
else
    if fmin_detect > 0  &&  fmax_detect == 0 
    [b,a]=ellip(2,0.1,40,[fmin_detect ]*2/sr, 'high');
%     [b,a] = butter(9,fmin_detect/(sr/2), 'high');
    else 
        
    end
     
    if fmax_detect < sr /2 && fmax_detect >0   &&  fmin_detect == 0
      [b,a]=ellip(2,0.1,40,[fmax_detect ]*2/sr, 'low');  
    end
    
    if fmin_detect == 0  &&  fmax_detect == 0 
         
    end
    
end

% xf_detect=filtfilt(b,a,x);

if ~isempty( a )  
  x=filtfilt(b,a,x);
else
%   xf_detect= x ; 
end


if Filter_50Hz_of_signal  && ~Artefacts_find
Wo = 50 /(  floor( sr ) / 2);  BW = Wo/ Filter_50Hz_iirnotch_sig ;   

%  Filter_50Hz_iirnotch  = handles.par.Post_stim_potentials_SHOW_50Hz_iirnotch ;
 
 
  [b,a] = iirnotch(Wo,BW);  
%  x = filter(b,a,x); 
  x = filtfilt(b,a,x); 
 
 
% Wo = 100 /(  floor( sr ) / 2);  BW = Wo/Filter_50Hz_iirnotch_sig ;   ;   
%   [b,a] = iirnotch(Wo,BW);  
%   x = filtfilt(b,a,x); 
  
end       
        

%% Build_FFT_of_signal - filtered

if Build_FFT_of_signal  
    
%      x =  xf_detect ;
Spectrum_color = '-b' ;
%      figure
     
     
     
    Fs = sr ;                    % Sampling frequency
    T = 1/Fs;                     % Sample time
    L =  L_s ;                     % Length of signal
    t = (0:L-1)*T;                % Time vector
    % Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
%     x = 0.7*sin(200*pi*50*t) + sin(2*pi*120*t); 
%     y = x + 2*randn(size(t));     % Sinusoids plus noise
%     y = x(1:L-1) ;
     
    NFFT= 2^(nextpow2(length( x ))); 

    % Take fft, padding with zeros so that length(fftx) is equal to nfft 
    fftx = fft(x,NFFT); 

% Calculate the numberof unique points
NumUniquePts = ceil((NFFT+1)/2); 

    % FFT is symmetric, throw away second half 
    fftx = fftx(1:NumUniquePts); 
    
    
    % Take the magnitude of fft of x and scale the fft so that it is not a
    % function of the length of x
    mx = abs(fftx)/length(x); 
    
    % Take the square of the magnitude of fft of x. 
    mx = mx.^2; 
    
     if rem(NFFT, 2) % odd nfft excludes Nyquist point
      mx(2:end) = mx(2:end)*2;
    else
      mx(2:end -1) = mx(2:end -1)*2;
     end  

    % This is an evenly spaced frequency vector with NumUniquePts points. 
    freq_fft = (0:NumUniquePts-1)*Fs/NFFT; 
     
     DF_smooth_parameter = handles.par.DF_smooth_parameter  ; 
    FFT_smooth_window = DF_smooth_parameter * NFFT  / Fs  ;
    mx = smooth( mx , FFT_smooth_window , 'loess')   ;
     mx( mx < 0) = 0 ;
    
    
    result.freq_fft = freq_fft ;
    result.fft_power = mx ;
     
%     y_filt = fft(xf_detect,NFFT)/L;
%     f = Fs/2*linspace(0,1,NFFT/2+1);

    % Plot single-sided amplitude spectrum.
    min_freq_value = handles.par.FFT_min_freq_show ; 
    max_freq_value = handles.par.FFT_max_freq_show ; 
    
    Spectrum_color = '-r' ;
    CG_FFT_Line_width = 2 ;
    hold on
    
%     plot(f,2*abs(Y(1:NFFT/2+1)) , f , 2*abs(y_filt(1:NFFT/2+1))) 
       plot( result.freq_fft , result.fft_power  , Spectrum_color , 'LineWidth', CG_FFT_Line_width, 'MarkerSize',3 );  
        xlim( [min_freq_value max_freq_value  ] )

%     plot(  f , 2*abs(Y(1:NFFT/2+1))) 
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')    
end
        
%% Detecting next

% x = xf_detect( Thr_from  : Thr_To ) ; 
% x = xf_detect( Thr_from  : Thr_To ) ; 
% end

if SIMPLE_RASTER ~= 'y' 
% [b,a]=ellip(2,0.1,40,[fmin_sort fmax_sort]*2/sr);
% xf=filtfilt(b,a,x);
% lx=length(xf);
end

if Filtered_channel_save    
    %FF = [ 'filtered_trace' int2str( Filtered_channel_save ) ]  ;   
    FF =  'filtered_trace.txt' ;
    dax = x' ;
    
     figure
    plot( dax )
    
    eval(['save ' num2str(FF ,3) ' dax  -ascii']); 
    clear dax
    
   
end


% clear x;

if Show_filtered_trace_hist == 'y'
   signal_hist_x = handles.par.Details_Options1chan_signal_hist_x  ; 
%    [count bins] = hist(xf_detect,x);
   histo = histc( x , signal_hist_x );
   histo = 100 * histo / length( x ); 
   figure
   plot(signal_hist_x,histo)   
   xlabel( 'Signal, mV')
%    indices = find( bins >= noise_std_detect )
%    yyy = find(indices > 0 );
%    yyy = count( indices )
%    text(noise_std_detect,yyy(1),'\leftarrow median', 'HorizontalAlignment','left')
 
end

if handles.par.Details_Options1chan_signal_hist 
   signal_hist_x = handles.par.Details_Options1chan_signal_hist_x  ;   
%    [count bins] = hist(xf_detect,x);
   histo = histc( x , signal_hist_x );
   histo = 100 * histo / length( x ); 
    
    option_data.signal_hist_x = signal_hist_x ;
   option_data.signal_hist_percent =  histo ;
   
%    figure
%    plot(signal_hist_x,histo)   


%    indices = find( bins >= noise_std_detect )
%    yyy = find(indices > 0 );
%    yyy = count( indices )
%    text(noise_std_detect,yyy(1),'\leftarrow median', 'HorizontalAlignment','left')
 
end
 

if ~ handles.par.threshold_use_defined
    if handles.par.threshold_fromFit_method
        GLOBAL_CONSTANTS_load
        amp_detect_extimate_thres_fit
        % input 
        %     handles.par.threshold_fromFit_signal_hist_x = -0.03:0.0002:0.03 ; 
        %     handles.par.threshold_fromFit_fitting_bounds_sample = 0.004 ;% if 0.004 then gauss will be estimated from -0.004 to 0.004
        %     handles.par.threshold_fromFit_fitting_bounds_Gaussfit = 0.05 ;% if 0.05 then Gauss model fit will be built -0.05 to 0.05
        %     handles.par.threshold_fromFit_percentile_GaussFit = 0.001 ; % if 0.001 then 0.1 % of fitted gauss hist will be used as thresh (similar to Gauss width)
        %     handles.par.threshold_fromFit_show_hists = true ; % shows estimations
        % xf_detect
        % output : thr_val
        one_sigma_thr = abs(thr_val) ;
        noise_std_detect= abs(thr_val) ;
    else
        if SD == 'y'
        noise_std_detect = std(x( Thr_from  : Thr_To ) ) ;
        if SIMPLE_RASTER ~= 'y'  noise_std_detect = std(x( Thr_from  : Thr_To )) ;    end
        else
            noise_std_detect = median(abs(x( Thr_from  : Thr_To )))/0.6745;
            if SIMPLE_RASTER ~= 'y'  noise_std_detect = median(abs(x( Thr_from  : Thr_To )))/0.6745; end
        end
        one_sigma_thr = noise_std_detect ;
    end
else
  one_sigma_thr =  handles.par.threshold_one_sigma   ; 
  noise_std_detect = one_sigma_thr ;
end


thr = stdmin * noise_std_detect;        %thr for detection is based on detected settings.
thrmax = stdmax * noise_std_detect;     %thrmax for artifact removal is based on sorted settings.
% thrmax = stdmax * noise_std_sorted;     %thrmax for artifact removal is based on sorted settings.



thr
% ref


% LOCATE SPIKE TIMES
switch detect
    case 'pos'
%         nspk = 0;
%         xaux = find(xf_detect(w_pre+2:end-w_post-2) > thr) +w_pre+1;
%         xaux0 = 0;
%         for i=1:length(xaux)
%             if xaux(i) >= xaux0 + ref
%                 [maxi iaux]=max((xf_detect(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment
% 
%                 
%                 s1 = xf_detect(xaux(i) + iaux -floor(ref/2)) ;
%                 s2 = xf_detect(xaux(i) + iaux + floor(ref/2)) ;                
%                 if  maxi - s1 >= AMP_THR && maxi - s2  >= AMP_THR 
%                     nspk = nspk + 1;
%                     index(nspk) = iaux + xaux(i)-1 ;
%                     xaux0 = index(nspk);
%                     amps(nspk) = maxi ;
%                 end                    
%                 
%             end
%         end
        Spike_detection_positive_script

    case 'neg'
        if ~simple_detection
            Spike_detection_negative_script
        else
            Spike_detection_negative_script_simple
        end
            
        
    case 'both'
%         nspk = 0;
%        if ( Thr_fragment == 'y' )
%         xaux = find(abs(xf_detect(w_pre+2:end-w_post-2) > thr ) & (abs(xf_detect(w_pre+2:end-w_post-2) < thrmax ))) +w_pre+1;    
%         else            
%         xaux = find(abs(xf_detect(w_pre+2:end-w_post-2)) > thr) +w_pre+1;
%        end  
        
        if ( Thr_fragment == 'y' )
        xaux = find((abs(x(ref+2:end-ref-2)) < -thr ) & ...
                    (abs(x(ref+2:end-ref-2)) > -thrmax )) +ref+1 ;    
        else            
        xaux = find(abs(x(ref+2:end-ref-2)) < -thr) +ref+1;
        end
           
        xaux0 = 0;
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + ref
                [maxi iaux]=max(abs(x(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment
                s1 = abs(x(xaux(i) + iaux -floor(ref/2))) ;
                s2 = abs(x(xaux(i) + iaux + floor(ref/2))) ;
                maxi_real = x(xaux(i) + iaux  ) ;
              %  [maxi iaux]=max(abs(xf(xaux(i):xaux(i)+floor(ref)-1)));    %introduces alignment
             %   s1 = abs(xf(xaux(i) + iaux -floor(ref/2))) ;
              %  s2 = abs(xf(xaux(i) + iaux + floor(ref/2))) ;
%                if maxi - s1 >= AMP_THR && maxi - s2 >= AMP_THR 
%                     nspk = nspk + 1;
%                     index(nspk) = iaux + xaux(i)-1 ;
%                     xaux0 = index(nspk);
%                     amps(nspk) = maxi ;
%                 end 
                if maxi - s1 >= AMP_THR && maxi - s2 >= AMP_THR 
                    add_spike = true;
                    if numel( amps )>0
                    if amps(nspk) * maxi_real < 0  % prev spike opposite form
                      dt = (iaux + xaux(i)-1) - index(nspk)  ;
                      dt_ms = dt / Fs ;
                      if Fdt_ms <= ref * 1.9 % prev spike is close to new
                          if abs( maxi_real ) > 1.5 * amps(nspk) % if new spike greater then prev
                             index(nspk) = (iaux + xaux(i)-1) ;
                             amps(nspk) = maxi_real ;
                             add_spike = false ;
                          end
                      end
                    end
                    end
                    
                    if add_spike
                    nspk = nspk + 1;
                    index(nspk) = iaux + xaux(i)-1 ;
                    xaux0 = index(nspk);
                    amps(nspk) = maxi_real ;
                    end
                end    
            end
        end
end

% amps 
% dlmwrite( 'AMPS.txt' , amps , '-append');

ls=w_pre+w_post;
%  spikes=zeros(nspk,ls+4);   
 spikes = [] ;
 nart = 0 ;
 artefacts = [] ;
 
if SIMPLE_RASTER ~= 'y' 
% SPIKE STORING (with or without interpolation)


    
spikes=zeros(nspk,ls+4);
xf=[x zeros(1,w_post)];



for i=1:nspk                          %Eliminates artifacts
%     if max(abs( xf_detect(index(i)-w_pre:index(i)+w_post) )) > 0.8  
t1 = index(i)-w_pre-1 ;
t2 = index(i)+w_post+2 ;
if  t1 > 0 && t2 <= length( x )
        spikes(i,:)=x(t1:t2);
end
%         artefacts = [ artefacts i ] ;
%     end
end 

end

end

%% Done detecting, global x - raw signal
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
      
            

%   if ~handles.par.Post_stim_potentials_external_artifact 
   if ~handles.par.Post_stim_potentials_external_artifact_GUI    
%         xaux = find(abs(xf_detect(1:end- Dat )) > ARTEFACT_threshold   ) ; 
       

 


 if Artefacts_find 

 %_=+++++++++++++++++++++++++++++++++++   
 %_=+++++++++++++++++++++++++++++++++++
 %_=+++++++++++++++++++++++++++++++++++
   Automatic_artefacts_scan_adjust  
   
   Automatic_artefacts_scanning = 0 
   
   
%_=+++++++++++++++++++++++++++++++++++
%_=+++++++++++++++++++++++++++++++++++\
%_=+++++++++++++++++++++++++++++++++++
    
 else
     if  Artefacts_find
         artefact_amps =  [] ;
         
        if ARTEFACT_threshold > 0 
            xaux = find( x(1:end- Dat  ) > ARTEFACT_threshold   ) ; 
            
        else
            xaux = find( x(1:end- Dat  ) <  ARTEFACT_threshold   ) ; 
        end 

%         xaux = find( xf_detect(1:end- Dat  ) > ARTEFACT_threshold   ) ; 
%         xaux = find( xf_detect(1:end- Dat  ) < -ARTEFACT_threshold   ) ; 
         
        
        if ~isempty( xaux )
        xaux2= xaux( 1 )  ;
        for i=2:length(xaux)
%            if   xaux( i )  -   xaux( i - 1 )  >= Dat*3
%                xaux2 = [ xaux2 xaux( i )];
%            end
           if   xaux( i )  -   xaux( i - 1 )  <= Dat*3
               if length( xaux2 ) > 1
                    xaux2( end  ) = [] ;
                    xaux2 = [ xaux2 xaux( i )];
               else
                  xaux2 = []; 
                  xaux2 =  xaux( i ) ;
               end
               
           else
              xaux2 = [ xaux2 xaux( i )]; 
           end
        end
        xaux=xaux2;
        end
%         whos xaux
        xaux0 = 0;
        for i=1:length(xaux)
            
          if ARTEFACT_threshold > 0 
                 
            if xaux(i) >= xaux0 + Dat
%              if xaux(i)<= xaux0 - Dat 
                [maxi iaux]=max( x(xaux(i):xaux(i)+floor( Dat )-1)  );    %introduces alignment 
                    nart = nart + 1;
                    artefacts(nart) = iaux + xaux(i)-1 ;
%                     artefact_amps(nart) = xf_detect( artefacts(nart) ) ;
                    xaux0 = artefacts(nart); 
            end  
            
          else                 
                  if xaux(i) <= xaux0 + Dat 
                   [maxi iaux]=min( x(xaux(i):xaux(i)+floor( Dat )-1)  );    %introduces alignment 
                    nart = nart + 1;
                    artefacts(nart) = iaux + xaux(i)-1 ;
%                     artefact_amps(nart) = xf_detect( artefacts(nart) ) ;
                    xaux0 = artefacts(nart); 
                  end
           end
        end
        artefact_amps  = x( artefacts ) ;
     end

 end   


   if  Artefacts_find
     

 
 if Show_any_figures
    figure
    
  hold on
        
    plot( x_diff ) ;
    
      artefact_amps_dff =  x_diff( artefacts ) ;  
      
      tx = 1:length( x_diff );   
      
 
      
    if length( artefacts )> 0
          plot(  artefacts , artefact_amps_dff * 1  , 'gv' )
    end 
    plot(  [ 0 length( tx ) ] , [ ARTEFACT_threshold ARTEFACT_threshold ] , 'g--'   )
    
    hold off
    ylabel( 'signal derrivative [ mV ]')
    
    Thr_from = collect_sigma_from ;
    Thr_To =  collect_sigma_to ;
    if Thr_To > 0  
        whos artefacts
    artefacts = artefacts(  artefacts > collect_sigma_from );
    artefacts = artefacts(  artefacts < collect_sigma_to );
    whos artefacts
    end
 end
 
 
 artefacts ;
 
  artefact_amps  = x( artefacts ) ;  
   end
 
 
 




% aux = find(spikes(:,w_pre)==0);       %erases indexes that were artifacts
% spikes(artefacts,:)=[];
% index(artefacts)=[];
% amps(artefacts)=[];   



    SSDD = [] ;

    for i=1:  length( artefacts   )
        ssdd = [] ;
      ssdd = find( index(:) > artefacts(i)-Dat  & index(:) < artefacts(i) + Dat );
    %    whos SSDD
    %    whos ssdd
      if ~isempty( ssdd )
      SSDD = [ SSDD ; ssdd ] ;
      end
    end    
    if ~isempty( SSDD )

    index(SSDD)=[];
    amps(SSDD)=[];  
    end 

    if SIMPLE_RASTER ~= 'y' 
        spikes(SSDD,:)=[];

        switch handles.par.interpolation
            case 'n'
                spikes(:,end-1:end)=[];       %eliminates borders that were introduced for interpolation 
                spikes(:,1:2)=[];
            case 'y'
                %Does interpolation
                spikes = int_spikes(spikes,handles);   
        end
    end
 
else
    
    if  ~strcmp(  handles.par.Post_stim_potentials_external_artifact_file , '' )
        fullname =handles.par.Post_stim_potentials_external_artifact_file ;  
    else
             [filename,PathName] = uigetfile('*.*','Select file');
             fullname = [PathName filename ]; 
            
    end
           artefacts = load( fullname ) ;   
        artefacts = (artefacts / ( 1e3/handles.par.sr))   ;
        artefacts = artefacts( :,1);
%         artefacts( 5 :end) = [] ;
%  artefacts( 1 :3) = [] ;
 
    
  end

  % Post_stim_potentials_collect
    
%% Post_stim_potentials_collect
   if  handles.par.Post_stim_potentials_collect  % take all artifacts and collect post sti signals to matrix
       post_stim_signals_all = [] ;
       DA_s = handles.par.Post_stim_potentials_start_interval * sr / 1000 ; 
       DA_p = handles.par.Post_stim_potentials_end_interval * sr / 1000 ; 
       post_interv_ms = handles.par.Post_stim_potentials_end_interval - handles.par.Post_stim_potentials_start_interval ; 
       
       fmin_detect = handles.par.Post_stim_potentials_LowFreq ;
        fmax_detect = handles.par.Post_stim_potentials_HighFreq ;
       Filter_50Hz_of_signal = handles.par.Post_stim_potentials_50Hz_filter ;
               
       if  handles.par.Detect_spikes_when_collectingLFP
        fmin_detect =  handles.par.Post_stim_potentials_SHOW_LowFreq ;
       end
       
       if use_signal_copy_LFP
          x =  xf_detect ;
       end
               
 
%        if numel(  artefacts ) > 0 
%            for i=1:  length( artefacts   )
%               if artefacts(i) + DA_p  < length( xf_detect )
%                post_stim = xf_detect( artefacts(i) + DA_s : artefacts(i) + DA_p ) ;
%                post_stim_signals_all = [ post_stim_signals_all  ; post_stim ] ;
%               end
%            end

        if handles.par.Post_stim_potentials_Filter_during_collect 
            fmin_detect = handles.par.Post_stim_potentials_LowFreq ;
            fmax_detect = handles.par.Post_stim_potentials_HighFreq ;
           Filter_50Hz_of_signal = handles.par.Post_stim_potentials_50Hz_filter ;
           Filter_50Hz_iirnotch =  handles.par.Post_stim_potentials_50Hz_filter ;
               
%               xf_detect=zeros(length(x),1);
                a = [];
                if fmax_detect < sr /2  && fmax_detect >0  && fmin_detect > 0  
                [b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
%                 [b,a] = butter(9,[fmin_detect fmax_detect]*2/sr);
                else
                    if fmin_detect > 0  &&  fmax_detect == 0 
                    [b,a]=ellip(2,0.1,40,[fmin_detect ]*2/sr, 'high');
%                     [b,a] = butter(9,fmin_detect/(sr/2), 'high');
                    else 

                    end

                    if fmax_detect < sr /2 && fmax_detect >0   &&  fmin_detect == 0
%                       [b,a]=ellip(2,0.1,40,[fmax_detect ]*2/sr, 'low');  
                      [b,a]=ellip(2,0.1,40,[fmax_detect ]*2/sr, 'low');  
                    end

                    if fmin_detect == 0  &&  fmax_detect == 0 

                    end

                end 
                if ~isempty( a )  
%                    xf_detect=filtfilt(b,a,x);
                    x=filtfilt(b,a,x);
                else
%                   xf_detect= x ; 
                end


                if Filter_50Hz_of_signal  && ~Artefacts_find
                Wo = 50 /(  floor( sr ) / 2);  BW = Wo/ Filter_50Hz_iirnotch_sig ;   
%                 BW = 0.99 ;
 ;   

                BW = Wo/ Filter_50Hz_iirnotch ;  
                  [b,a] = iirnotch(Wo,BW  );  
%                   x0=filtfilt(b,a,x);
%                   figure ; plot( x0(1:10000) )
%                   
%                  xf_detect = filter(b,a,xf_detect); 
%                  x=filtfilt(b,a,x);
                 
%                  deg = 3 ;%filter deg
%                     Wn = [45*2/sr,60*2/sr];
%                     [b,a]  = butter(deg,Wn,'stop'); 

                  x=filtfilt(b,a,x);

                 
                end  
           
        else
%              x =  xf_detect ;    
             ;
        end
           
spikes_ms_all = []; 
spikes_amps_all = [] ;

LFP_stim_num = handles.LFP_stim_num ;
if ~isempty(   LFP_stim_num )
if       LFP_stim_num(1) ~=0
  artefacts=  artefacts(   LFP_stim_num )  ;
end
end

       if numel(  artefacts ) > 0 
           for i=1:  length( artefacts   )
              if artefacts(i) + DA_p  < length( x )
               post_stim = x( artefacts(i) + DA_s : artefacts(i) + DA_p ) ;
               post_stim_signals_all = [ post_stim_signals_all  ; post_stim ] ;
               
               if  handles.par.Detect_spikes_when_collectingLFP
               index_art = find( index >= artefacts(i) + DA_s & index < artefacts(i) + DA_p );
               spikes_ms = index( index_art ) - artefacts(i)+1 ; 
               spikes_ms = (spikes_ms * ( 1e3/handles.par.sr)) ;
               spikes_amps = amps( index_art ) ;  
               spikes_ms_all = [ spikes_ms_all spikes_ms ];
               spikes_amps_all = [ spikes_amps_all  spikes_amps ] ;
               end
              end
           end           
         
       p_i = numel( post_stim );
       post_x = ((1:p_i)/ p_i )* post_interv_ms + handles.par.Post_stim_potentials_start_interval ;
        post_stim_signals_mean = mean( post_stim_signals_all ) ;
       post_stim_signals_std = std( post_stim_signals_all ) ;
        if   strcmp(  handles.par.Post_stim_potentials_external_artifact_file , '' )

            Nx = 1 ; Ny = 2 ;
            if  handles.par.Detect_spikes_when_collectingLFP
                 Ny = 2 ;
            end
            figures_f = [] ;
            figure
            Fi = 0 ;  
          Fi = Fi + 1  ;
          f = subplot( Ny , Nx , Fi ) ; 
               figures_f = [ figures_f f ] ;
            
       if Each_plot_set_color 
              
               % Set color of plot
               
            s = size( post_stim_signals_all );
            Nsig = s(1);
               
             % RGB gradient
        MaxT = 2*pi ;
        MinT = 0 ; 
        T_bin = (MaxT - MinT )/   Nsig ;
%         t = 0:0.1:2*pi ; 
        t = MinT:T_bin : MaxT  ;
        lt = length( t ); 
        
            redc =  ( 1 * (1+cos(  t  ))) / 2 ;
            redc( floor( lt/2) : end ) = 0  ; 
            
            greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 

            bluec = ( 1 * (1+cos(  t ))) / 2 ;
            bluec(1 : floor( lt/2)   ) = 0  ; 
            
             % R -> G     
        MaxT = pi ;
        MinT = 0 ; 
        T_bin = (MaxT - MinT )/   Nsig ;
%         t = 0:0.1: pi ; 
        t = MinT:T_bin : MaxT  ;
        lt = length( t );  
            
            %             redc =  ( 1 * (1 +cos(  t * 1.0 ))) / 2 ; 
            redc =  ( 1 * ( ( MaxT - t * 1.0 ))) / MaxT   ; 
            redc = redc * 1.0 + 0.0  ;
            
%             greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 
            greenc =  ( 0 + (  t  ) )/ MaxT ; 
            greenc = greenc * 0.99 + 0.0  ;   

            bluec = ( 1 + sin(  t - pi/2 ) )/ 2 ;  
            
            bluec(:) = 0.0 ;
            
            
             Nsig = s(1);
               
             % R -> B    
        MaxT = pi ;
        MinT = 0 ; 
        T_bin = (MaxT - MinT )/   Nsig ;
%         t = 0:0.1: pi ; 
        t = MinT:T_bin : MaxT  ;
        lt = length( t ); 
        
                  redc =  ( 1 * (1 +cos(  t * 1.0 ))) / 2 ; 
            redc =  ( 1 * ( ( MaxT - t * 1.0 ))) / MaxT   ; 
            redc = redc * 1.0 + 0.0  ;
            
%             greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 
            greenc =  ( 0 + (  t  ) )/ MaxT ; 
             greenc(:) = 0.0  ;

            bluec =  ( 0 + (  t  ) )/ MaxT ;  
            
            bluec  = bluec * 1.0 + 0.0  ; 
 
%             figure
           hold on
           for ci  = 1 : Nsig              
               
               color_i = [ redc( ci ) greenc( ci ) bluec( ci ) ] ;
               plot( post_x  ,  post_stim_signals_all( ci , : ) , 'Color' , color_i  )
           end
           
           plot( spikes_ms_all  ,  spikes_amps_all , 'g*'    )
           
           legend( 'Red - first signal' , 'Blue - last signal')
            hold off    
      else
%           figure
%              title( 'All post-stim signals')
           plot( post_x , post_stim_signals_all )
%            xlabel( 'time, ms');
      end 
            
%             
% if handles.par.Post_stim_spike_response 
%      
%                 flags.Burst_Data_Ver = handles.flags.Burst_Data_Ver ; 
%                 Post_stim_interval_end = 50 ;
%                 Post_stim_interval_start= 5 ;
%                 DT_bin = 1 ;
%                 N = 60 ;
%                 
%                     fire_bins = floor(( Post_stim_interval_end -  Post_stim_interval_start) /  DT_bin) ; 
%                          %//////////////////////////////////////////    
%                          [ Patterns ] = Patterns_Get_Responses_in_Interval_from_Raster( N , artefacts ,handles.index_r ,Post_stim_interval_start , ...
%                            Post_stim_interval_end  , DT_bin ,flags );
%                           % index_r, intervals post stim -> bursts burst_activation
%                           % One_sigma_in_channels ... 
%                          d=0; 
%                          
%                   POST_STIM_RESPONSE =    Patterns ;
%                  Nb = POST_STIM_RESPONSE.Number_of_Patterns ;
%                  CH_i = handles.par.channel ;
%                  hold on
%                  for bi = 1 : Nb
%                     spikes_ms = [];
%                     spikes_ms =  POST_STIM_RESPONSE.bursts{ bi }{ CH_i }  ;
%                     if ~isempty( spikes_ms ) 
% %                     signal_ms = Details.option_data_all(i).post_stim_signals_time_x_ms ;
%                     spikes_amps =  POST_STIM_RESPONSE.bursts_amps{ bi }{ CH_i } ;
% %                     [ dd , mins ]= min( signal_ms) ;
% %                     spikes_ms = spikes_ms - dd ;
% %                     spikes_frames = ( (spikes_ms - dd) * sr / 1000 ) ;
% %                     y_s =  y( floor( spikes_frames) ) ;
%                     
% %                     plot( spikes_ms  ,  y_s , '*' , 'Color' , color_i  )
%                     plot( spikes_ms  ,  spikes_amps , 'g*'    )
%                     end
%                  end
%                   hold off  
% end
            
%        figure
       title( 'All post-stim signals')
%        plot( post_x , post_stim_signals_all )
       xlabel( 'time, ms');
       
      
       
%        figure
Fi = Fi + 1  ;
f = subplot( Ny , Nx , Fi ) ; 
      figures_f = [ figures_f f ] ;

       
       hold on
       plot( post_x , post_stim_signals_mean ) 
       plot( post_x , post_stim_signals_mean- post_stim_signals_std/2 , '--r' ) ;
       plot( post_x , post_stim_signals_mean+ post_stim_signals_std/2 , '--r' ) ;
       xlabel( 'time, ms');
       title( 'mean and std post-stim signals')
       
       plot( spikes_ms_all  ,  spikes_amps_all , '*' )
%       xlabel( 'time, ms');
%        ylabel( 'Spike amplitude');

linkaxes( figures_f   , 'xy' );   
         
      end
      
       option_data.post_stim_signals_all = post_stim_signals_all ;
       option_data.post_stim_signals_time_x_ms = post_x ;
       option_data.post_stim_signals_mean = post_stim_signals_mean ;
       option_data.post_stim_signals_std = post_stim_signals_std ;
       
          
       end
       
       if  handles.par.Detect_spikes_when_collectingLFP
%            Fi = Fi + 1  ;
%        f = subplot( Ny , Nx , Fi ) ; 
% %        figures_f = [ figures_f f ] ;
%                figures_f = [ figures_f f ] ;
%                plot( spikes_ms_all  ,  spikes_amps_all , '*' )
%                      xlabel( 'time, ms');
%                      ylabel( 'Spike amplitude');
%        title( 'Spike smplitudes')
       
       end
            
               
   end
%% -----------
  


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




Plot_signal_spikes = true ;

 if handles.par.Post_stim_potentials_collect
        if handles.par.Detect_spikes_when_collectingLFP 
            Plot_signal_spikes = true ;
        else
            Plot_signal_spikes = false ;
        end
 end    
        
% % whos artefacts
% % whos index
if Plot_signal_spikes
if Show_volt_index_art == 'y'  
    
   
    
    if isempty( index)
%         index = 0 ;
    end
    
    y_index = [ ];
        if ~isempty( index)
 y_index = zeros( 1 , length( index ) );
% y_index( index) = 0.20;
y_index(:)  = thr ;
y_index =  x( floor( index) ) ;
        end
    
        

y_artefacts= zeros( 1 , length( artefacts ) );
% y_artefacts( artefacts) = 0.90;
if length( y_artefacts )> 0
y_artefacts(:)  = thr * 2 ;
y_artefacts   = x( floor( artefacts) ) ;

end

if ~handles.plot_multiple_signals % analyzing only one channel
    figure 
    color = 'b' ;
    hold on
else
   color = handles.plot_multiple_signals_curr_color ; 
   hold on
end
    
tx = 1:length( x ); 
tx = tx / sr ;
%     
    
    if  ~handles.plot_multiple_signals % analyzing only one channel
        
        plot(  tx, x * 1 , color  )
        
        if show_additional_par_signal 
            if ~isempty( index)
            plot(  index / sr , y_index * 1 , 'r*'   )
            end
%          plot(  [ 0 length( tx ) ] , [ -thr -thr ] , 'g--'   )
            if length( y_artefacts )> 0
              plot(  artefacts / sr, y_artefacts * 1  , 'gv' )
            end 
        legend( 'Signal' , 'Spikes' , 'Threshold' , 'artefacts' )
        end
        
        hold off
        xlim( [ min( tx ) max(tx) ])
        xlabel( 'Time, s' )
        ylabel( 'Voltage, mV')
        
        
    else
%         plot( handles.plot_multiple_signals_handle , x, x * 1 , color  )
%         plot( handles.plot_multiple_signals_handle , index / sr , y_index * 1 , 'r*'   )
%                 plot(  x, xf_detect * 1 , color  )
%         plot(  index / sr , y_index * 1 , 'r*'   )

 if Artefacts_find 
    if handles.plot_multiple_signals_derrivative 
 
        option_data.signal =  x_diff ;
        option_data.signal_x = tx(1:end-1) ;
    else
        option_data.signal = x ;
        option_data.signal_x = tx ;
    end
        
 else
           option_data.signal = x ;
        option_data.signal_x = tx ;  
 end
    end


end
end


% figure
% hold on
% for i=1:length( index )                           %Eliminates artifacts
% 
%     plot( spikes(i,:) ) ;
%         
%  
% end 







                                                                        if Calc_characteristics == 'y'


                                                                        DDT = 50 ; % Bin in ms
                                                                        FreqBin_ms = 50 ;
                                                                        SPDT_Thr = 5 ; % spikes per DT threshold for burst detect
                                                                        Rmax = 2 ;
                                                                        Nsteps = 20  ;


                                                                        DT = floor( DDT * sr/1000 ) ;
                                                                        FreqBin = floor( FreqBin_ms * sr/1000 ) ;
                                                                        ASR = [] ;
                                                                        k = 1 ;
                                                                        for ti = 1 : DT : ( length( xf ) - DT )
                                                                          s = length( find( ( index >= ti ) & ( index < ti + DT ) ) ) ;
                                                                          ASR( k ) = s ;
                                                                          k = k + 1 ;
                                                                        end
                                                                        ti = 1 : DT : ( length( xf ) - DT ) ;
                                                                        figure
                                                                         plot( ti , ASR )



                                                                        [c,i] = max( ASR ) ;
                                                                        [cmin,imin] = min( ASR ) ;
                                                                        bi = i ;
                                                                        T_start_burst = bi ;

                                                                        Msx_freq_spikes = c  ;
                                                                        Min_freq_spikes = cmin   ;
                                                                        T_msx_freq = i*DT ;
                                                                        T_min_freq = imin*DT ;



                                                                        noise = zeros(1 , DT ) ;
                                                                        signal = zeros(1 , ( Nsteps + 500 ) * DT  ) ;
                                                                         b = zeros( 1 ,  (Nsteps + 500 ) * DT )   ;

                                                                        signal( 1 : DT ) = xf( T_msx_freq : T_msx_freq + DT - 1 ) ;
                                                                        noise( 1 : DT ) = xf( T_min_freq : T_min_freq + DT - 1 ) ;

                                                                        R = 0.1 : 0.2 : 2 ;

                                                                        Dr_SD = zeros( 1 , length(R) );
                                                                        Dr_absX = zeros( 1 , length(R) );
                                                                        Dr_x2 = zeros( 1 , length(R) );

                                                                        Rk = 0 ;
                                                                        R = 1 ;
                                                                        %   for R = 0.2 : 0.1 : Rmax  %------------
                                                                        Rk = Rk + 1 ;

                                                                        sigma1 = [] ;
                                                                        sigma2 = [] ;
                                                                        sigmaSD = [] ;
                                                                        freq = [] ;


                                                                          for i= 1 :  DT
                                                                             b(i)=signal(i)*signal(i);
                                                                          end
                                                                          sigma2( 1 ) = median( b( 1  : DT ) / ( R * std(signal( 1  : DT  )) ) ); 
                                                                          sigm( 1 ) = median(abs( signal( 1  : DT  ) / R  )); 
                                                                          sigmaSD( 1 ) = std( signal( 1  : DT  ) /  R );  
                                                                          freq( 1 ) = Msx_freq_spikes / ( ( DT ) / (sr/1000) ) ;
                                                                          F( 1 ) = freq( 1 ) ;

                                                                        k = 2 ;
                                                                        Ns = 20 ;
                                                                        TTT  = DT ;
                                                                        for i=1 : Ns
                                                                          signal( DT * i : DT*i + DT - 1 ) =   signal( 1 : DT ) ;
                                                                          TTT = TTT + DT ;
                                                                        end





                                                                        N_noise_added = 0 ;
                                                                        for ni = 1 : Nsteps

                                                                          for tn = 1 :  ni 
                                                                          TTT = TTT + DT ;
                                                                          signal( TTT - DT + 1 : TTT    )  = noise ;
                                                                          N_noise_added = N_noise_added + 1 ;
                                                                          end
                                                                          sigma1( k ) = median(abs( signal( 1   : TTT ) / R  ));

                                                                          for i= 1 : TTT
                                                                             b(i)=signal(i)*signal(i);
                                                                          end
                                                                          sigma2( k ) = median( b( 1  : TTT ) / ( R * std( signal( 1  : TTT )) ) ); 
                                                                            sigmaSD( k ) = std( signal( 1  : TTT ) /  R ); 
                                                                          freq( k ) = (Msx_freq_spikes*Ns + N_noise_added * Min_freq_spikes) / ( (    TTT ) / (sr/1000) ) ;% spikes per ms
                                                                          F( ni ) = freq( k ) ; 

                                                                          k = k + 1 ;  
                                                                        end  





                                                                          for i= 1 : DT
                                                                             b_noise(i)=noise(i)*noise(i);
                                                                          end
                                                                        %   sigma2( k ) = median( b( T1  : T_start_burst ) / ( R * std(xf( T1  : T_start_burst )) ) ); 
                                                                        %   sigma1( k ) = median(abs( xf( T1   : T_start_burst ) / R  )); 
                                                                        %   sigmaSD( k ) = std( xf( T1  : T_start_burst ) /  R );  
                                                                          sigma2( k ) = median( b_noise(1:end) / ( R * std( noise ) ) ); 
                                                                          sigma1( k ) = median( abs( noise(1:end) / R  )); 
                                                                          sigmaSD( k ) = std( noise(1:end) /  R );  

                                                                          freq( k ) = Min_freq_spikes / ( (  TTT ) / (sr/1000) ) ; 

                                                                          figure
                                                                        % %    plot( freq ,  sigma1 , freq , sigma2  )  
                                                                        plot( freq , sigmaSD , freq , sigma1 , freq ,  sigma2  )

                                                                        % delta1 =  max( sigma1 ) - min( sigma1 ) ;
                                                                        % delta2 =  max( sigma2 ) - min( sigma2 ) ;
                                                                        % 
                                                                        % delta1
                                                                        % delta2

                                                                        % Dr_SD( Rk ) = max( sigmaSD ) - min( sigmaSD ) ;
                                                                        % Dr_absX( Rk ) = max( sigma1 ) - min( sigma1 ) ;
                                                                        % Dr_x2( Rk ) = max( sigma2 ) - min( sigma2 ) ;
                                                                        R_absX = sigma1(k) / sigmaSD(k) ;
                                                                        R_x2 = sigma2(k) / sigmaSD(k) ;
                                                                        sigma1 = sigma1 / R_absX ;
                                                                        sigma2 = sigma2 / R_x2 ;
                                                                        R_absX
                                                                        R_x2
                                                                        Dr1_SD = max( sigmaSD ) - min( sigmaSD ) ;
                                                                        Dr1_absX = max( sigma1 ) - min( sigma1 ) ;
                                                                        Dr1_x2 = max( sigma2 ) - min( sigma2 ) ;
                                                                        Dr1_SD 
                                                                        Dr1_absX 
                                                                        Dr1_x2

                                                                        %   end  %------------------
                                                                        %  R = 0.2 : 0.1 : Rmax 
                                                                        figure
                                                                        % plot( R , Dr_SD , R , Dr_absX , R ,Dr_x2 )
                                                                        plot( freq , sigmaSD , freq , sigma1 , freq ,  sigma2  )  

                                                                        end

 













