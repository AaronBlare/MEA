

% build spike rate diagram from raster
function  AWSR = AWSR_from_index_r( index_r  , TimeBin , params )
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

MakeAVI = 'n' ;

Tdim = 0 ; % ms
Tmax =  round(max(index_r(:,1) ))   ; % ms
Nt = floor( Tmax / dT ) +1; 
N = max( index_r( : , 2 ));
Nt ;
Number_of_channels_in_raster = N
whos index_r

t = 0 ;
    T1 =  t * dT ;
    T2 = T1 + dT ;

AWSR = zeros(1,Nt) ;
for ti = 1 : length( index_r(:,1) )
 Asdr_ti = floor( index_r(  ti  ,1 ) / dT )+1  ;
 AWSR( Asdr_ti ) =   AWSR( Asdr_ti ) + 1 ;      
end



if MakeAVI == 'y'
maxA = max(max(AWSR_i));
maxA;
figure
clims = [ 1  maxA ] ;
% for t = floor(Nt*0.6) : floor(Nt*0.7)
t1 = floor(800 / (dT / 1000));
t2 = t1 + 20*(1000/dT) ;
 for t = t1 : t2
      t  ;
       Data = zeros(8,8);
    DIV = 8 ;
    N = 64;
    x1 = 0 ; x2 = 0 ; y1 = 1 ; y2 = 0 ;
    for i = 1 : N    
      if x1 < DIV x1=x1+1 ; else x1=1 ; y1=y1+1 ; end  

         Data( x1 , y1 ) = AWSR_i( i , t ) ;          
    end
    x = 1: DIV ;
    y = x ;
    imagesc( x,y, Data, clims )
    colorbar
     figname = [ filename '_AVI_' int2str( t ) '_'  int2str( TimeBin ) 'ms_TimeBin.bmp' ] ;
    saveas(gcf,  figname ,'bmp');   
    % close
end    
    
end

% AWSR_sig_tres=  0.1 ;
% AWSR = AWSR ;
% Threshold = AWSR_calc_tres( AWSR , AWSR_sig_tres );




% xt = [ 0 max(x) ];
% yt = [ Threshold Threshold ];
params

if params.show_figures
    
    x = [ 1 : (Nt )  ] ;
    x = x *dT / 1000  ;
    y = AWSR ;
    
    if params.new_figure 
        figure
    end
    % set(gcf,'position');
    hold on
    plot( x ,  y  ,'MarkerEdgeColor',[.04 .52 .78]) , grid on
    % plot( xt ,  yt  , 'r' )
    hold off
    if params.x_label
         xlabel('Time, s')
    end
    ylabel(['TSR, spikes per bin']) 
    % set(p,'Color',[.04 .52 .78])
end

if SAVE_PLOT_TO_FILE == 'y' 
figname = [ name '_AWSR_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gcf,  figname ,'fig');
end
 

% AWSR = AWSR ;