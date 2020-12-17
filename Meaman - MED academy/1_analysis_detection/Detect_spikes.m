% Detect_spikes



% Detect_spikes = true ;

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



thr;
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
        
    end



end













