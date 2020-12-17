function [spikes,thr,index,amps,one_sigma_thr] = amp_detect2( handles)
% Detect spikes with amplitude thresholding. Uses median estimation.
% Detection is done with filters set by fmin_detect and fmax_detect. Spikes
% are stored for sorting using fmin_sort and fmax_sort. This trick can
% eliminate noise in the detection but keeps the spikes shapes for sorting.
global x ;

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
Original_channel_save = 'n' ; %handles.par.Original_channel_save ;
Filtered_channel_save = 'n' ; %handles.par.Filtered_channel_save ;
Show_filtered_trace_hist = 'n' ;
Build_FFT_of_signal = 'n' ; % FFT of signal
Calc_characteristics = 'n' ;
Thr_fragment = 'y' ;
if handles.par.thresholdtype == 'sd' 
   SD = 'y' ; % use standard deviation for treshold 
else
   SD = 'n' ; 
end
SIMPLE_RASTER = handles.par.calculate_only_raster ;

AMP_THR = 0.005 ;
%AMP_THR = 0.002 ;

% HIGH-PASS FILTER OF THE DATA
xf=zeros(length(x),1);
L_s =  length( x ) ;  % length( x ) ;                     % Length of signal
if Original_channel_save == 'y'
    %FF =  [ 'original_trace_' int2str( Original_channel_save ) ] ;
    FF =   'original_trace_' ;
    dax = x' ;
    eval(['save ' char( FF ) ' dax  -ascii']); 
end    




xf_detect=zeros(length(x),1);
[b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
xf_detect=filtfilt(b,a,x);

if SIMPLE_RASTER ~= 'y' 
[b,a]=ellip(2,0.1,40,[fmin_sort fmax_sort]*2/sr);
xf=filtfilt(b,a,x);
lx=length(xf);
end
if Filtered_channel_save == 'y'    
    %FF = [ 'filtered_trace' int2str( Filtered_channel_save ) ]  ;   
    FF =  'filtered_trace' ;
    dax = xf_detect' ;
    eval(['save ' char( FF ) ' dax  -ascii']); 
end

if Build_FFT_of_signal == 'y' 
    Fs = sr ;                    % Sampling frequency
    T = 1/Fs;                     % Sample time
    L =  L_s ;                     % Length of signal
    t = (0:L-1)*T;                % Time vector
    % Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
%     x = 0.7*sin(200*pi*50*t) + sin(2*pi*120*t); 

%     y = x + 2*randn(size(t));     % Sinusoids plus noise
%     y = x(1:L-1) ;

    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    
    Y = fft(x,NFFT)/L;
    y_filt = fft(xf,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);

    % Plot single-sided amplitude spectrum.
    figure
    plot(f,2*abs(Y(1:NFFT/2+1)) , f , 2*abs(y_filt(1:NFFT/2+1))) 
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
    
end

clear x;


if Show_filtered_trace_hist == 'y'
   x = -0.03:0.0005:0.03;   
   [count bins] = hist(xf_detect,x);
   figure
   plot(bins,count)   
   indices = find( bins >= noise_std_detect )
   yyy = find(indices > 0 );
   yyy = count( indices )
   text(noise_std_detect,yyy(1),'\leftarrow median', 'HorizontalAlignment','left')
end



if SD == 'y'
noise_std_detect = std(xf_detect) ;
if SIMPLE_RASTER ~= 'y'  noise_std_detect = std(xf) ;    end
else
noise_std_detect = median(abs(xf_detect))/0.6745;
if SIMPLE_RASTER ~= 'y'  noise_std_detect = median(abs(xf))/0.6745; end
end

one_sigma_thr = noise_std_detect ;
thr = stdmin * noise_std_detect;        %thr for detection is based on detected settings.
thrmax = stdmax * noise_std_detect;     %thrmax for artifact removal is based on sorted settings.
% thrmax = stdmax * noise_std_sorted;     %thrmax for artifact removal is based on sorted settings.

thr

% LOCATE SPIKE TIMES
switch detect
    case 'pos'
        nspk = 0;
        xaux = find(xf_detect(w_pre+2:end-w_post-2) > thr) +w_pre+1;
        xaux0 = 0;
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + ref
                [maxi iaux]=max((xf_detect(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment

                
                s1 = xf(xaux(i) + iaux -floor(ref/2)) ;
                s2 = xf(xaux(i) + iaux + floor(ref/2)) ;                
                if  maxi - s1 >= AMP_THR && maxi - s2  >= AMP_THR 
                    nspk = nspk + 1;
                    index(nspk) = iaux + xaux(i)-1 ;
                    xaux0 = index(nspk);
                    amps(nspk) = maxi ;
                end                    
                
            end
        end
    case 'neg'
        nspk = 0;
        if ( Thr_fragment == 'y' )
        xaux = find((xf_detect(ref+2:end-ref-2) < -thr ) & ...
                    (xf_detect(ref+2:end-ref-2) > -thrmax )) +ref+1 ;    
        else            
        xaux = find(xf_detect(ref+2:end-ref-2) < -thr) +ref+1;
        end
        xaux0 = 0;
        for i=1:length(xaux) - floor(ref )
             if xaux(i) >= xaux0 + ref
                [maxi iaux]=min((xf_detect(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment

                if   xaux(i) + iaux + floor(ref/2) < length( xf_detect )
                    point_beyond_thr = find(xf_detect(xaux(i) + iaux - floor(ref/2): ...
                                                  xaux(i) + iaux + floor(ref/2)) < -thr)  ;
%                     min_point_per_spike = floor( ref *0.3 * abs(thr / maxi ) );
%                     if min_point_per_spike < 1 min_point_per_spike = 1 ; end
                    min_point_per_spike = 1 ;
                    if  length( point_beyond_thr ) >= min_point_per_spike
                        s1 = xf_detect(xaux(i) + iaux -floor(ref/2)) ;
                        s2 = xf_detect(xaux(i) + iaux + floor(ref/2));                
                        if abs( maxi - s1) >= AMP_THR && abs( maxi - s2 ) >= AMP_THR 
                            nspk = nspk + 1;
                            index(nspk) = iaux + xaux(i)-1 ;
                            xaux0 = index(nspk);
                            amps(nspk) = maxi ;
                        end                    
                    end
                end
            end
        end

    case 'both'
        nspk = 0;
       if ( Thr_fragment == 'y' )
        xaux = find(abs(xf_detect(w_pre+2:end-w_post-2) > thr ) & (abs(xf_detect(w_pre+2:end-w_post-2) < thrmax ))) +w_pre+1;    
        else            
        xaux = find(abs(xf_detect(w_pre+2:end-w_post-2)) > thr) +w_pre+1;
        end          
        
        xaux0 = 0;
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + ref
                [maxi iaux]=max(abs(xf_detect(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment
                s1 = abs(xf(xaux(i) + iaux -floor(ref/2))) ;
                s2 = abs(xf(xaux(i) + iaux + floor(ref/2))) ;
                
              %  [maxi iaux]=max(abs(xf(xaux(i):xaux(i)+floor(ref)-1)));    %introduces alignment
             %   s1 = abs(xf(xaux(i) + iaux -floor(ref/2))) ;
              %  s2 = abs(xf(xaux(i) + iaux + floor(ref/2))) ;
               
                if maxi - s1 >= AMP_THR && maxi - s2 >= AMP_THR 
                    nspk = nspk + 1;
                    index(nspk) = iaux + xaux(i)-1 ;
                    xaux0 = index(nspk);
                    amps(nspk) = maxi ;
                end    
            end
        end
end

% amps 
% dlmwrite( 'AMPS.txt' , amps , '-append');

ls=w_pre+w_post;
if SIMPLE_RASTER ~= 'y' 
% SPIKE STORING (with or without interpolation)
    spikes=zeros(nspk,ls+4);
    xf=[xf zeros(1,w_post)];
for i=1:nspk                          %Eliminates artifacts
%     if max(abs( xf_detect(index(i)-w_pre:index(i)+w_post) )) > 0.8              
        spikes(i,:)=xf_detect(index(i)-w_pre-1:index(i)+w_post+2);
%         artefacts = [ artefacts i ] ;
%     end
end 


    if nspk > 0
        whos spikes
%         whos index 
    for i=1:nspk                          %Eliminates artifacts
        if max(abs( xf(index(i)-w_pre:index(i)+w_post) )) < thrmax               
            if index(i)+w_post+2 > length( xf )
                spikes(i,:)=xf(index(i)-w_pre-1:index(i)+w_post+2);
            end
        end
    end
    end

    aux=[];
    for i=1:nspk                          %Eliminates artifacts
        f = abs( amps( i ));
        if f==0 
            aux = [ aux i ] ;
        end
    end

    % aux = find(spikes(:,w_pre)==0);       %erases indexes that were artifacts
    spikes(aux,:)=[];
    index(aux)=[];
    amps(aux)=[];    

    switch handles.par.interpolation
        case 'n'
            spikes(:,end-1:end)=[];       %eliminates borders that were introduced for interpolation 
            spikes(:,1:2)=[];
        case 'y'
            %Does interpolation
            spikes = int_spikes(spikes,handles);   
    end

else
     spikes=zeros(nspk,ls+4);   
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
  sigma1( 1 ) = median(abs( signal( 1  : DT  ) / R  )); 
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

end













