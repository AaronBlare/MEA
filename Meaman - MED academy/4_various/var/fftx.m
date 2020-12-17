

sr = 1000 ;
L_s = 10000 ;

    Fs = sr ;                    % Sampling frequency
    T = 1/Fs;                     % Sample time
    L =  L_s ;                     % Length of signal
    t = (0:L-1)*T;                % Time vector
    % Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
%     x = 0.7*sin(200*pi*50*t) + sin(2*pi*120*t); 
%     y = x + 2*randn(size(t));     % Sinusoids plus noise
%     y = x(1:L-1) ;
    x = 0.7*sin(2*pi*50*t) ; 
        figure 
        plot(x )
        
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    
    Y = fft(x,NFFT)/L;
%     y_filt = fft(xf_detect,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);

    % Plot single-sided amplitude spectrum.

    
    figure
%     plot(f,2*abs(Y(1:NFFT/2+1)) , f , 2*abs(y_filt(1:NFFT/2+1))) 
plot(f,2*abs(Y(1:NFFT/2+1)) )
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')    