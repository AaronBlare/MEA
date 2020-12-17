 


function  AmpRate = AmpRate_from_index_r( index_r  , TimeBin , params )
% Input - index_r , TimeBin , params.show_figures , params.new_figure ,
% params.x_label


if nargin == 2
    params.show_figures = true ;
    
    if ~isfield( params , 'new_figure')
        params.new_figure = true ;
    end
    
    if ~isfield( params , 'x_label')
        params.x_label = true ;
    end
    
end

    if ~isfield( params , 'new_figure')
        params.new_figure = true ;
    end
    
    if ~isfield( params , 'x_label')
        params.x_label = true ;
    end
    
SAVE_PLOT_TO_FILE = 'n';
dT = TimeBin ;
 

%  ------------------------------------------------

Tdim = 0 ; % ms
Tmax =  round(max(index_r(:,1) ))   ; % ms
Nt = floor( Tmax / dT ) +1; 
N = 64 ;
AmpRate = zeros(1,Nt) ;
asdr_i = 1 ;

whos index_r

t = 0 ;
     T1 =  t * dT ;
    T2 = T1 + dT ;
    
for t = 1 : Nt
    Nact = 0 ;
    AmpRate( t ) = 0 ;
    for ch = 1: N         
        channel_index =  index_r( : , 2 ) ==  ch   ;
        spike_index =  index_r( channel_index , 1 ) >=  T1 & index_r( channel_index , 1 ) <  T2  ;       
        ss = length( find ( index_r( channel_index , 1 ) >=  T1 & index_r( channel_index , 1 ) <  T2 ) ) ;
        if ss > 0
             avg_amp = sum( index_r( spike_index , 3 ) ) /ss ;
           AmpRate( t ) =   AmpRate( asdr_i ) + avg_amp ;  
           Nact = Nact +1 ;
        end
    end
    if ( Nact > 0 )
     AmpRate( t ) =  AmpRate( t ) / Nact ;
    end  
    asdr_i = asdr_i + 1 ;
     T1 =  t * dT ;
    T2 = T1 + dT ;
end

x = [ 1 : (Nt )  ] ;
x = x *dT / 1000  ;
y = AmpRate ;

if params.show_figures
     if params.new_figure 
        figure
    end
% set(gcf,'position');
plot( x ,  y  ,'MarkerEdgeColor',[.04 .52 .78]) , grid on
xlabel('Time, s')
ylabel(['Average Amplitude, mV per bin']) 
% set(p,'Color',[.04 .52 .78])



end 

if SAVE_PLOT_TO_FILE == 'y' 
figname = [ name '_AmpRate_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gcf,  figname ,'fig');
end

 

  
end 

   

% AWSR = AWSR ;