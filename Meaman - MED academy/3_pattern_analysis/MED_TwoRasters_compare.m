%  MED_InterChannels_Realtions 
%  Loads ?_spikesCHX.mat and calculates syncro coeff using Compare_values
%  Runs after MED_Convert and MED_Spike_Sorting
%  Input raster should be in ms
clear ;

N = 4      ; % Number of channels to analyse
Tmax = 20 ; % max delay for cross correlation in ms
Dist = 150 ; % distancse between channels
Max_Dist = 3 ; % distance, electrodes 
ANALYSE_METHOD = 'Sync' ; % 'Spike_transfer'  'Sync'
BUILD_TRACE_ONLINE = 'y' ;
TRACE_BIN = 'pt' ; % traces time bin 'ms' - every point is ms or 'pt' - point
sr = 20000 ;         

T_Spike_Delay = 5 ;% spike transfer delay , ms
T_tau = 2 ; % spike transfer delay error , ms

DT_i_min = 1 ;
DT_i_max = 2 ;
DT_i_step = 2 ;



M = ( N - 1 )* N / 2 ;

Dat = zeros(  M , 2 );
MaxDelays = zeros(  M , 1 );
Dchan = zeros(  M , 1 );
k = 1 ;
DIV = 8 ;
T_Spike_Delay =  T_Spike_Delay * ( sr / 1000 ) ;







[file , pathname]  = uigetfile('*.*','Select file');
[pathstr,name,ext,versn] = fileparts( file ) ;
filename = file ;
init_dir = cd ;
cd( pathname ) ;
file = name( 1 : strfind(   name , '_Ra') - 1  ) 
file_input = file ;

eval(['load ' char( file_input ) '_Details']);

if TRACE_BIN == 'pt'
  Ttrace_len = Trace_Lenght_pionts ;
  T_m = sr / 1e3 ;
else
   Ttrace_len = Trace_length_sec * 1000 ;
   T_m = 1 ;
end


T_tau =  T_tau * T_m ;
Sync_Bin = Tmax * T_m ;

Raster = load( char( filename ) ) ;
 
    if BUILD_TRACE_ONLINE ~=  'y'   
     Binary_traces = zeros( Ttrace_len , N ) ; ;
     for CHANNEL_i = 1 : N  
      extract_channel_index = find( Raster( : , 2 ) == CHANNEL_i ) ;
      channel_index_i =  Raster( extract_channel_index , 1 )   ;
      channel_index_i = floor( channel_index_i * T_m ) ;      
      Binary_traces(  channel_index_i(:) , CHANNEL_i ) = 1 ;
      
       
     end
    end



DT_i_i = 0 ;
x =0 :0.01:1 ; 
val_3d = zeros( floor( (DT_i_max - DT_i_min)/DT_i_step ) , length( x ) ) ;

for DT_i = DT_i_min :  DT_i_step : DT_i_max
    

Sync_Bin = DT_i * T_m ;
T_Spike_Delay =  DT_i * T_m ;
DT_i_i = DT_i_i + 1 ;
C_values = [] ;


x1 = 0 ; x2 = 0 ; y1 = 1 ; y2 = 0 ;

for CHANNEL_i = 1 : N
    
  if x1 < DIV x1=x1+1 ; else x1=1 ; y1=y1+1 ; end
  
  CHANNEL_i
    if BUILD_TRACE_ONLINE == 'y'    
  Binary_trace_i = zeros( Ttrace_len , 1 ) ;
   extract_channel_index = find( Raster( : , 2 ) == CHANNEL_i ) ;
    channel_index_i =  Raster( extract_channel_index , 1 )   ;
     channel_index_i = floor( channel_index_i * T_m ) ;
   Binary_trace_i(  channel_index_i(:) ) = 1 ;
 whos extract_channel_index 
    end
  CCC = 0 ;    
 
  x2=0 ; y2=1 ;  
  
    for CHANNEL_j = 1 :  N
        
     if x2 < DIV x2=x2+1 ; else x2=1 ; y2=y2+1 ; end   
     
     r = sqrt(  ( x1 - x2 ).^2 + ( y1 - y2 ).^2  );
     if ( CHANNEL_j >  CHANNEL_i )&( r < Max_Dist )
          
     if BUILD_TRACE_ONLINE == 'y'    
       Binary_trace_j = zeros( Ttrace_len , 1 ) ;
      extract_channel_index = find( Raster( : , 2 ) == CHANNEL_j ) ;
      channel_index_j =   Raster( extract_channel_index , 1 )  ;
      channel_index_j = floor(  channel_index_j * T_m ) ;
      Binary_trace_j(  channel_index_j(:) ) = 1 ;
     end
         
             if BUILD_TRACE_ONLINE ~=  'y'   
              Binary_trace_i = Binary_traces( : ,CHANNEL_i ) ;
               Binary_trace_j = Binary_traces( : ,CHANNEL_j ) ;
             end
   
               
              switch ANALYSE_METHOD
               case 'Sync'
               C = Compare_Values( Binary_trace_i , Binary_trace_j , Sync_Bin  );
               case 'Spike_transfer' 
               C = Two_traces_Spikes_Transfer_correlation( Binary_trace_i , Binary_trace_j , T_Spike_Delay , T_tau  ) ;
              end
     
               d = r * Dist ;
               C_values ( k , 1 ) =    abs( C ) ;
              Dchan ( k , 1 ) =   d ;              
              CCC = CCC + 1 ;
              Sy( CHANNEL_i , CCC ) =  abs( C ) ;
              k = k + 1 ;   
         
     end    
    end
    
    
end %%%%%%%%%%%%%%%%%%

x =  0 :0.01:1 ; 
Sy = C_values( : , 1 ) ;
% hist(  Sy ,x)  ;
[n,xout] = hist(  Sy ,x) ;
b = 0 ;  
for x = 0 :0.01:1 ; 
    b = b+1 ;
    val_3d( DT_i_i , b ) = n(b) ;
end
val_3d( DT_i_i , 1 ) = 0 ;


end

maxval = max( max( val_3d ) ); 
imagesc( val_3d , [ 0 maxval ] )
% axis( [ 0 1 DT_i_min DT_i_max ] )
colorbar( 'vert' )

% T =  DT_i_min : DT_i_step : DT_i_max ;
% x = 0 :0.01:1 ;
%  [x,y]=meshgrid( x  , T );
% surf(x,y, val_3d,'EdgeColor','none')

cd( init_dir) ;
         