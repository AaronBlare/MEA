
%  Extract_bursts
% function [burst_start,burst_max,burst_end , InteBurstInterval , BurstDurations,Spike_Rates_each_burst,Burst_Firing_Rate , ...
%     ANALYSIS , ANALYSIS_median_values ]= Extract_bursts( AWSR , TimeBin , AWSR_sig_tres )

 
% ANALYSIS - vector of summarized sata about all characteristics


% if nargin == 2
%  AWSR_sig_tres = 0.1  ; % sigma threshold
% end

SAVE_PLOT_TO_FILE = true ;

MIN_BURST_DURATION_MS = 10 ;

MIN_channels_per_burst_max_AWSR = 4 ;

dT = TimeBin ;

% if TimeBin > 500
%     tdim = 's' ;
%     DimenM = dT / 1000 ;
% else
%     tdim = 'ms' ;
%     DimenM = dT ;
% end


tdim = 's' ;
DimenM = dT / 1000 ;

Threshold = AWSR_calc_tres( AWSR ,  Search_Params.AWSR_sig_tres );
% Threshold = AWSR_sig_tres * std( AWSR ) ;
ASDRcopy = AWSR ;
index = find( ASDRcopy(:) <= Threshold ) ;
ASDRcopy( index ) = 0 ;
% hist( AWSR )
% Threshold =  0.1*max(ASDRcopy)   ;



Tmax =  length( AWSR )   ; % ms
Nt = floor(Tmax / dT) +1;
x = [ 1 : (  length( AWSR )  )  ] ;
x = x *dT / 1000  ;
y = AWSR ; 
whos x
whos y
xt = [ 0 max(x) ];
yt = [ Threshold Threshold ]; 
if params.show_figures 
    figure 
    hold on
    plot( x ,  y  ,'MarkerEdgeColor',[.04 .52 .78]) , grid on
    plot( xt ,  yt  , 'r' )
    hold off
    title( 'Burst threshold')
    xlabel('Time, s')
    ylabel(['TSR, spikes per bin'])  
    
    if SAVE_PLOT_TO_FILE
%        figname = [ name '_AWSR_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
       figname = [   'AWSR_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
        saveas(gca,  figname ,'fig')
    end
end


nspk = 0 ;
index = [] ;
index_max = [] ;
index_end = [] ;
Spike_Rates_each_burst = [] ;
Nt = length( AWSR ) ;
for t = 1 : Nt - 1
    
    if (( ASDRcopy( t ) == 0 )&&( ASDRcopy( t+1 ) > 0  ))
         nspk = nspk + 1 ;
         index(nspk) = t  ;
           s = find(  ASDRcopy( t+1:end ) == 0 );
           if length(s) > 0
           right = s(1) + t  ;
           else
            right = Nt ;   
           end 
           index_end(nspk) = right ;
            [maxi iaux]=max(  ASDRcopy( t : right ) );
           
%            index_max = index_max + 1 ; 
           index_max(nspk) = iaux(1) + t - 1 ;
          
           Spike_Rates_each_burst(nspk) = sum( ASDRcopy( index(nspk) : index_end(nspk)  ) );
    end

end 
%filter tiny bursts
% index_x = find( ASDRcopy(index_max(:)) <  0.1*max(ASDRcopy)  ) ;
% index_max( index_x ) = [] ;
% index_end( index_x ) = [] ;
% index( index_x ) = [] ;
% Spike_Rates_each_burst( index_x ) = [] ;

Durations = [] ;
Durations = index_end(:) - index(:) ;




index_x = find( Durations(:) * TimeBin <  MIN_BURST_DURATION_MS ) ;
index_max( index_x ) = [] ;
index_end( index_x ) = [] ;
index( index_x ) = [] ;
Spike_Rates_each_burst( index_x ) = [] ;
Durations( index_x ) = [] ;



% erase bursts where at bin less than MIN_channels_per_burst_max_AWSR spiks
% index_x = find( ASDRcopy(index_max) <  MIN_channels_per_burst_max_AWSR ) ;
% index_max( index_x ) = [] ;
% index_end( index_x ) = [] ;
% index( index_x ) = [] ;
% Spike_Rates_each_burst( index_x ) = [] ;
% Durations( index_x ) = [] ;



%     % ASDRburst = AWSR ;
%     % ASDRburst( : ) = 0 ; 
%     ASDRburst  = zeros( length( AWSR ),1) ;
%     if AWSR_sig_tres > 0  
%     ASDRburst( index_max ) = Threshold;
%     else
%       ASDRburst( index_max ) = 0.1 * max(ASDRcopy) ;
%     end

% Spike_Rates_in_Burst = [] ;
% for i =1:length( Spike_Rates_each_burst )
% Spike_Rates_in_Burst = [ Spike_Rates_in_Burst  Spike_Rates_each_burst(i) / (Durations(i) * (dT / 1000 ) ) ];
% end
% Burst_Firing_Rate = Spike_Rates_in_Burst ;

%     mark_ASDRburst = AWSR ;
%     ix = find( AWSR(:) <= Threshold ) ;
%     mark_ASDRburst( ix ) = 0 ;


% ASDRburst( index ) = 1 
    % b_ISI = [] ;
    % for i = 1:length(index_max) -1
    %   b_ISI = [b_ISI (index( i+1) - index_end(i) )];
    % end


 burst_start =index  *dT / 1000 ;
 burst_max = index_max *dT / 1000 ;
 burst_end = index_end *dT / 1000 ;
% InteBurstInterval = max_ISI *dT / 1000  ;
BurstDurations = Durations   *dT / 1000  ;
%  Spike_Rates_each_burst  ;
% burst_start(1)
% burst_end(1)

%Fireratefile =[char(file) '_FireRate.txt'  ] ;
%eval(['save ' char(Fireratefile) ' Rate -ascii']);  
 