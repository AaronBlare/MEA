function FFT_simple( x , DT_ms )

%  ------------ SAMPLE ------------
% sr = 1000  ;
% L_s = 10000  ;
%     Fs = sr ;                    % Sampling frequency
%     T = 1/Fs;                     % Sample time
%     L =  L_s ;                     % Length of signal, points
%     t = (0:L-1)*T;                % Time vector
%      x = 0.7*sin(2*pi*50*t) ; 
%         figure 
%         plot(x )
%     NFFT = 2^nextpow2(L); % Next power of 2 from length of y    
%     Y = fft(x,NFFT)/L; 
%     f = Fs/2*linspace(0,1,NFFT/2+1);
%     figure 
%         plot(f,2*abs(Y(1:NFFT/2+1)) )
%     title('Single-Sided Amplitude Spectrum of y(t)')
%     xlabel('Frequency (Hz)')
%     ylabel('|Y(f)|')  
% % -------------------------------

  L_points = length(x);   
    T = DT_ms /1000  ;          % Sample time , s
    Fs = 1 / T ;
    L =  L_points   ;                     % Length of signal,sec
     t = (0:L-1)*T;                % Time vector

 Signal_length_sec= t(end) ;
 Signal_length_sec
        
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    
    Y = fft(x,NFFT)/L;
%     y_filt = fft(xf_detect,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);

    % Plot single-sided amplitude spectrum.
 
    
    figure
%     plot(f,2*abs(Y(1:NFFT/2+1)) , f , 2*abs(y_filt(1:NFFT/2+1))) 
plot(f,2*abs(Y(1:NFFT/2+1)) )
    title('Single-Sided Amplitude Spectrum')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')    
     
 
    
    
    
    
    