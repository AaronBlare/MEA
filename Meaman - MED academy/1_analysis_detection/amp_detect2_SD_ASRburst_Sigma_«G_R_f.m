function [spikes,thr,index] = amp_detect2(x,handles)
% Detect spikes with amplitude thresholding. Uses median estimation.
% Detection is done with filters set by fmin_detect and fmax_detect. Spikes
% are stored for sorting using fmin_sort and fmax_sort. This trick can
% eliminate noise in the detection but keeps the spikes shapes for sorting.

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
SD = 'y' ; % use standard deviation for treshold

AMP_THR = 0.010 ;
%AMP_THR = 0.002 ;

% HIGH-PASS FILTER OF THE DATA
xf=zeros(length(x),1);

if Original_channel_save == 'y'
    %FF =  [ 'original_trace_' int2str( Original_channel_save ) ] ;
    FF =   'original_trace_' ;
    dax = x' ;
    eval(['save ' char( FF ) ' dax  -ascii']); 
end    

xf_detect=zeros(length(x),1);
[b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
xf_detect=filtfilt(b,a,x);
[b,a]=ellip(2,0.1,40,[fmin_sort fmax_sort]*2/sr);
xf=filtfilt(b,a,x);
lx=length(xf);
clear x;

if Filtered_channel_save == 'y'    
    %FF = [ 'filtered_trace' int2str( Filtered_channel_save ) ]  ;   
    FF =  'filtered_trace' ;
    dax = xf_detect' ;
    eval(['save ' char( FF ) ' dax  -ascii']); 
end

noise_std_detect = median(abs(xf_detect))/0.6745;
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
noise_std_sorted = std(xf) ;    
else
noise_std_detect = median(abs(xf_detect))/0.6745;
noise_std_sorted = median(abs(xf))/0.6745;
end
thr = stdmin * noise_std_detect;        %thr for detection is based on detected settings.
thrmax = stdmax * noise_std_sorted;     %thrmax for artifact removal is based on sorted settings.


% LOCATE SPIKE TIMES
switch detect
    case 'pos'
        nspk = 0;
        xaux = find(xf_detect(w_pre+2:end-w_post-2) > thr) +w_pre+1;
        xaux0 = 0;
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + ref
                [maxi iaux]=max((xf(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment
                nspk = nspk + 1;
                index(nspk) = iaux + xaux(i) -1;
                xaux0 = index(nspk);
            end
        end
    case 'neg'
        nspk = 0;
        xaux = find(xf_detect(w_pre+2:end-w_post-2) < -thr) +w_pre+1;
        xaux0 = 0;
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + ref
                [maxi iaux]=min((xf(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment
                nspk = nspk + 1;
                index(nspk) = iaux + xaux(i) -1;
                xaux0 = index(nspk);
            end
        end
    case 'both'
        nspk = 0;
        xaux = find(abs(xf_detect(w_pre+2:end-w_post-2)) > thr) +w_pre+1;
        xaux0 = 0;
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + ref
                [maxi iaux]=max(abs(xf(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment
                s1 = abs(xf(xaux(i) + iaux -floor(ref/2))) ;
                s2 = abs(xf(xaux(i) + iaux + floor(ref/2))) ;
                
              %  [maxi iaux]=max(abs(xf(xaux(i):xaux(i)+floor(ref)-1)));    %introduces alignment
             %   s1 = abs(xf(xaux(i) + iaux -floor(ref/2))) ;
              %  s2 = abs(xf(xaux(i) + iaux + floor(ref/2))) ;
               
                if maxi - s1 >= AMP_THR && maxi - s2 >= AMP_THR 
                    nspk = nspk + 1;
                    index(nspk) = iaux + xaux(i)-1 ;
                    xaux0 = index(nspk);
                end    
            end
        end
end

% SPIKE STORING (with or without interpolation)
ls=w_pre+w_post;
spikes=zeros(nspk,ls+4);
xf=[xf zeros(1,w_post)];
for i=1:nspk                          %Eliminates artifacts
    if max(abs( xf(index(i)-w_pre:index(i)+w_post) )) < thrmax               
        spikes(i,:)=xf(index(i)-w_pre-1:index(i)+w_post+2);
    end
end
aux = find(spikes(:,w_pre)==0);       %erases indexes that were artifacts
spikes(aux,:)=[];
index(aux)=[];
       
switch handles.par.interpolation
    case 'n'
        spikes(:,end-1:end)=[];       %eliminates borders that were introduced for interpolation 
        spikes(:,1:2)=[];
    case 'y'
        %Does interpolation
        spikes = int_spikes(spikes,handles);   
end












DDT = 50 ; % Bin in ms
SPDT_Thr = 5 ; % spikes per DT threshold for burst detect
Rmax = 2 ;


DT = floor( DDT * sr/1000 ) ;
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

bi_all = find( ASR >= SPDT_Thr );

if length( bi_all ) >= 1
    
%bi = bi_all( 1 ) ;
[c,i] = max( ASR ) ;
bi = i ;
T_start_burst = bi ;
% T_start_burst  = 1704000 ;
T_end_burst = T_start_burst ;
while ASR( T_start_burst ) > 0 
  T_start_burst = T_start_burst - 1 ;  
end
while ASR( T_end_burst ) > 0 
  T_end_burst = T_end_burst + 1 ;  
end
spikes_in_burst = sum(ASR( T_start_burst : T_end_burst) );

T1 = T_start_burst - 1 ;
while ASR( T1 ) < 1 && T1 > 1
  T1 = T1 - 1 ;  
end

%T1 = 1 ;
T1 = T1* DT ;
T_start_burst = T_start_burst * DT ;
T_end_burst = T_end_burst * DT ;
T1 
T_start_burst
T_end_burst
k = 1 ;




% %  b = zeros( 1 , length(xf) )  ;
% % for i= 1 :  length(xf) 
% %    b(i)=xf(i)*xf(i);
% % end
% 
% noise_sigma = [] ; burst_sigma = [] ; ALL_sigma = [] ;
% for R = 0.2 : 0.01 : Rmax
%       noise_sigma( k ) = median(abs( xf( T1 : T_start_burst )   )) / R ; %Burstless interval
%       burst_sigma( k ) = median(abs( xf( T_start_burst : T_end_burst )   )) / R ; %Burst interval
% %        ALL_sigma( k ) = median(abs( xf( 1 : end ) / R  ))  ; %Burst interval
% %     
% %       noise_sigmaSD( k ) =  std( xf( T1 : T_start_burst )) / R    ; %Burstless interval
% %       burst_sigmaSD( k ) =  std( xf(T_start_burst : T_end_burst )) / R     ; %Burst interval
% %       ALL_sigmaSD(k) = std( xf( 1 : end  )) / R  ;
%       
% %       noise_sigma( k ) = median( b( T1 : T_start_burst ) / (R * std(xf( T1 : T_start_burst ))  ) )   ; %Burstless interval
% %       burst_sigma( k ) = median( b( T_start_burst : T_end_burst )  /( R * std(xf(T_start_burst : T_end_burst ))  ) );
% %       ALL_sigma( k ) = median( b( 1 : end )  /( R * std(xf( 1 : end ))  ) );
%       
% %       noise_sigma( k ) =  sqrt( median( b( T1 : T_start_burst ) / R    ) )   ; %Burstless interval
% %       burst_sigma( k ) = sqrt( median( b( T_start_burst : T_end_burst )  / R )  ) ;
% %       ALL_sigma( k ) = sqrt( median( b( 1 : end )  /  R   ) );
%  
%    k = k + 1 ; 
% end
% R = 0.2 : 0.01 : Rmax ;
% % b = burst_sigma - noise_sigma ; 
% figure
% %  plot( R ,  noise_sigma , R , burst_sigma ,  R, ALL_sigma )
%  plot( R ,  noise_sigma ,  R, burst_sigma )
%  
% % figure
% %  plot( R ,  b )
%  
% % noise_sigmaABSX = median(abs( xf( T1 : T_start_burst )   ));
% %  noise_sigmaSTD =  std( xf( T1 : T_start_burst ))      ; %Burstless interval
% %  R  = noise_sigmaABSX / noise_sigmaSTD ;
% %  R 
% 
% % 








R = 2 ;
noiseDT = 50 ; % 50 msec
TTT  = T_start_burst ;
NDT = floor( noiseDT * sr/1000 ) ;
Nsteps = floor( T_start_burst / (NDT * 10 ) ) + 1 ;
noise = [] ;
noise = xf( T_start_burst - NDT : T_start_burst ) ;
% noise = xf( 1   : NDT+1 ) ;
F = zeros( 1 , Nsteps );
 R = 0.2 : 0.1 : Rmax  ;
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

 b = zeros( 1 , length(xf) )  ;
  for i= T_start_burst : T_end_burst
     b(i)=xf(i)*xf(i);
  end
  sigma2( 1 ) = median( b( T_start_burst  : T_end_burst ) / ( R * std(xf( T_start_burst  : T_end_burst )) ) ); 
  sigma1( 1 ) = median(abs( xf( T_start_burst   : T_end_burst ) / R  )); 
  sigmaSD( 1 ) = std( xf( T_start_burst  : T_end_burst ) /  R );  
  freq( 1 ) = spikes_in_burst / ( ( T_end_burst - T_start_burst) / (sr/1000) ) ;
  F( 1 ) = freq( 1 ) ;
  
k = 2 ;
TTT  = T_start_burst ;
for ni = 1 : Nsteps
  TTT = TTT - NDT ;
  xf( TTT   : TTT + NDT   )  = noise ;
  sigma1( k ) = median(abs( xf( TTT   : T_end_burst ) / R  ));
  
  for i= TTT : T_end_burst
     b(i)=xf(i)*xf(i);
  end
  sigma2( k ) = median( b( TTT  : T_end_burst ) / ( R * std(xf( TTT : T_end_burst )) ) ); 
    sigmaSD( k ) = std( xf( TTT  : T_end_burst ) /  R ); 
  freq( k ) = spikes_in_burst / ( ( T_end_burst - TTT) / (sr/1000) ) ;% spikes per ms
  F( ni ) = freq( k ) ; 
  
  k = k + 1 ;  
end  

  for i= T1 : T_end_burst
     b(i)=xf(i)*xf(i);
  end
  for i= 1 : length( noise )
     b_noise(i)=noise(i)*noise(i);
  end
%   sigma2( k ) = median( b( T1  : T_start_burst ) / ( R * std(xf( T1  : T_start_burst )) ) ); 
%   sigma1( k ) = median(abs( xf( T1   : T_start_burst ) / R  )); 
%   sigmaSD( k ) = std( xf( T1  : T_start_burst ) /  R );  
  sigma2( k ) = median( b_noise(1:end) / ( R * std( noise ) ) ); 
  sigma1( k ) = median( abs( noise(1:end) / R  )); 
  sigmaSD( k ) = std( noise(1:end) /  R );  

  freq( k ) = 0 / ( ( T_start_burst - T1) / (sr/1000) ) ; 

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













