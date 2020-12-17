%  MED_InterChannels_Realtions 
%  Loads ?_spikesCHX.mat and calculates syncro coeff using Compare_values
%  Runs after MED_Convert and MED_Spike_Sorting
%  Input raster should be in ms


N = 64     ; % Number of channels to analyse
Tmax = 20 ; % max delay for cross correlation in ms
Dist = 150 ; % distancse between channels
Max_Dist = 91 ; % distance, electrodes 
SYNC_TIME_BIN = 2 ; % time bin for synco coeff search, ms
ANALYSE_METHOD = 'Spike_transfer' ; % 'Spike_transfer'  'Syncronisation' 
                                    % 'Test_Test_Test'
DELAY_ON_DIST = 'n' ;

                                      
BUILD_TRACE_ONLINE = 'n' ;
TRACE_BIN = 'ms' ; % traces time bin 'ms' - every point is ms or 'pt' - point
AUTOCORRELATION = 'n' ;
m_2nd_cycle = 'y' ;
m_plot3d = 'y' ;
sr = 20000 ;   

SAVE_PLOT_TO_FILE = 'y' ;

T_Spike_Delay = 5 ;% spike transfer delay , ms
T_tau = 2 ; % spike transfer delay error , ms


DT_i_min = 1 ;
DT_i_max = 2 ;
DT_i_step = 2 ;


[file , pathname]  = uigetfile('*.*','Select file');
if  file ~= 0 
[pathstr,name,ext,versn] = fileparts( file ) ;
filename = file 
init_dir = cd ;
cd( pathname ) ;
file_input = file ;
Raster = load( char( filename ) ) ;

Tbegin = 1 ;
Tend = max( Raster( :,1) ) ;


 

switch ANALYSE_METHOD
     case 'Syncronisation'
         DT_i_min = 1 ;
        DT_i_max = 2 ;
        DT_i_step = 2 ;
     case 'Spike_transfer'
        DT_i_min = 1 ;
        DT_i_max = 30 ;
        DT_i_step = 2 ; 
     case 'Test_Test_Test'         
end         

M = ( N - 1 )* N / 2 ;
Dat = zeros(  M , 2 );
MaxDelays = zeros(  M , 1 );
Dchan = zeros(  M , 1 );
k = 1 ;
DIV = 8 ;
T_Spike_Delay =  T_Spike_Delay * ( sr / 1000 ) ;



if TRACE_BIN == 'pt'
  %Ttrace_len = Trace_Lenght_pionts ;
   T_m = sr / 1e3 ;
  Ttrace_len = max( Raster( : , 1 ) )*T_m ;
  %T_m = sr / 1e3 ;
else
%    Ttrace_len = Trace_length_sec * 1000 ;
T_m = 1 ;
  Ttrace_len = max( Raster( : , 1 ) ) ;
   
end


T_tau =  T_tau * T_m ;
Sync_Bin = SYNC_TIME_BIN * T_m ;
channel_Pb = zeros( 1 ,N ) ;

 
    if BUILD_TRACE_ONLINE ~=  'y'   
     Binary_traces = zeros( Ttrace_len , N ) ; 
     for CHANNEL_i = 1 : N  
      extract_channel_index = find( Raster( : , 2 ) == CHANNEL_i & Raster( : , 1 ) <= Tend & Raster( : , 1 ) > Tbegin )   ;
      Pb_spikes_num = length( extract_channel_index  ) ;
      channel_Pb( CHANNEL_i ) = Pb_spikes_num ;
      channel_index_i =  Raster( extract_channel_index , 1 )   ;
      channel_index_i = floor( channel_index_i * T_m ) ;      
      Binary_traces(  channel_index_i(:) , CHANNEL_i ) = 1 ;      
     end
    end    
    
    
DT_i_i = 0 ;
x =0 :0.01:1 ; 
val_3d = zeros( floor( (DT_i_max - DT_i_min)/DT_i_step ) , length( x ) ) ;
val_3d_all = zeros( floor( (DT_i_max - DT_i_min)/DT_i_step ) , M ) ;

 if AUTOCORRELATION == 'y' 
g_lags = [] ;
MAX_LAG = 20 * T_m ;
 g_c  = zeros(  2*MAX_LAG +1,1 ) ;
 end
 

for DT_i = DT_i_min :  DT_i_step : DT_i_max
    

% Sync_Bin = DT_i * T_m ;
T_Spike_Delay =  DT_i * T_m 
DT_i_i = DT_i_i + 1 ;
C_values = [] ;
C_values2 = [] ;
k2=1 ;

x1 = 0 ; x2 = 0 ; y1 = 1 ; y2 = 0 ;

for CHANNEL_i = 1 : N
    
  if x1 < DIV x1=x1+1 ; else x1=1 ; y1=y1+1 ; end
  
  CHANNEL_i
Binary_trace_i = zeros( Ttrace_len , 1 ) ;
    if BUILD_TRACE_ONLINE == 'y'      
   extract_channel_index = find( Raster( : , 2 ) == CHANNEL_i & Raster( : , 1 ) <= Tend & Raster( : , 1 ) > Tbegin ) ;
    channel_index_i =  Raster( extract_channel_index , 1 )   ;
     channel_index_i = floor( channel_index_i * T_m ) ;
   Binary_trace_i(  channel_index_i(:) ) = 1 ;
 whos extract_channel_index 
    end
  CCC = 0 ;    
 
  x2=0 ; y2=1 ;  
  
  
  
 if AUTOCORRELATION == 'y' 
  maxlags = MAX_LAG  ; 
   [c lags ]  = xcorr( Binary_trace_i , maxlags , 'coeff' ); 
 g_c = g_c + c  ;
 g_lags = lags ;
 end
 
 
  
  if m_2nd_cycle == 'y'
    Pb_spikes_num = 0;
    for CHANNEL_j = 1 :  N
        
     if x2 < DIV x2=x2+1 ; else x2=1 ; y2=y2+1 ; end   
     
     r = sqrt(  ( x1 - x2 ).^2 + ( y1 - y2 ).^2  );
     if ( CHANNEL_j >  CHANNEL_i )&&( r < Max_Dist )
      
         
         Binary_trace_j = zeros( Ttrace_len , 1 ) ;
     if BUILD_TRACE_ONLINE == 'y'           
      extract_channel_index = find( Raster( : , 2 ) == CHANNEL_j & Raster( : , 1 ) <= Tend & Raster( : , 1 ) > Tbegin ) ;
      Pb_spikes_num = length( extract_channel_index  ) ;
      channel_index_j =   Raster( extract_channel_index , 1 )  ;
      channel_index_j = floor(  channel_index_j * T_m ) ;
      Binary_trace_j(  channel_index_j(:) ) = 1 ;
     end
         
             if BUILD_TRACE_ONLINE ~=  'y'   
              Binary_trace_i = Binary_traces( : ,CHANNEL_i ) ;
               Binary_trace_j = Binary_traces( : ,CHANNEL_j ) ;
             end
   
             if DELAY_ON_DIST == 'y'
              Dist_Delay = floor( r * T_Spike_Delay ) ;
             else
              Dist_Delay = T_Spike_Delay ;
             end
              switch ANALYSE_METHOD
               case 'Syncronisation'
               C = Compare_Values( Binary_trace_i , Binary_trace_j , Sync_Bin  );
               case 'Spike_transfer' 
              %  C = Two_traces_Spikes_Transfer_correlation( Binary_trace_i , Binary_trace_j ,Dist_Delay  , Sync_Bin  ) ;
                C = Two_traces_Spikes_Transfer_Pk( Binary_trace_i , Binary_trace_j ,Dist_Delay  , Sync_Bin ) ;
              end
%      C
               d = r * Dist ;
               C_values ( k , 1 ) =    abs( C ) ;
               C_values2 ( k2 , 1 ) =    abs( C ) ;
              Dchan ( k , 1 ) =   d ;              
              CCC = CCC + 1 ;
%               Sy( CHANNEL_i , CCC ) =  abs( C ) ;
              k = k + 1 ;   
                k2 = k2 + 1 ;   
         
     end    
    end
  end 
    
end %%%%%%%%%%%%%%%%%%

 if AUTOCORRELATION == 'y' 
g_c = g_c / N ;
figure
plot( g_lags , g_c ) 
 end

if m_plot3d == 'y'
x =  0 :0.01:1 ; 
Sy = C_values( : , 1 ) ;
Sy = C_values2( : , 1 ) ;
% hist(  Sy ,x)  ;
[n,xout] = hist(  Sy ,x) ;
maxN = max( n ) ;
b = 0 ;  
for x = 0 :0.01:1 ; 
    b = b+1 ;
    val_3d( DT_i_i , b ) = n(b) / maxN ;
end

val_3d_all( DT_i_i , : ) =  C_values2( : , 1 ) ;
% val_3d( DT_i_i , 1 ) = 0 ;
end

end

if m_plot3d == 'y'
maxval = max( max( val_3d ) ); 
x = 0 :0.01:1 ;
y = DT_i_min : DT_i_step  : DT_i_max  ;
figure
imagesc( x , y ,val_3d , [ 0 maxval ] )
% axis( [ 0 1 DT_i_min DT_i_max ] )
colorbar( 'vert' )



maxval = 1 ; 
maxval =  max( max( val_3d_all ) ); 
x = 1:M ;
y = DT_i_min : DT_i_step  : DT_i_max  ;
figure
imagesc( x , y ,val_3d_all , [ 0 maxval ] )
% axis( [ 0 1 DT_i_min DT_i_max ] )
colorbar( 'vert' )


% xlabel('Time, s')
% ylabel('AWSR, spikes per bin') 
if SAVE_PLOT_TO_FILE == 'y' 
imagefile = [ 'Graph_1-' int2str( DT_i_max ) 'ms_V-'  char( DELAY_ON_DIST ) '_.fig' ]    
saveas(gcf, imagefile ,'fig');
end


end

% T =  DT_i_min : DT_i_step : DT_i_max ;
% x = 0 :0.01:1 ;
%  [x,y]=meshgrid( x  , T );
% surf(x,y, val_3d,'EdgeColor','none')



cd( init_dir) ;

end
      