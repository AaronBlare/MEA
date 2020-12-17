%  MED_Sync_Neurons 
%  Loads ?_spikesCHX.mat and calculates syncro coeff using Compare_values
%  Runs after MED_Convert and MED_Spike_Sorting
clear ;

N = 2      ; % Number of channels to analyse
Tmax = 20 ; % max delay for cross correlation in ms
Dist = 150 ; % distancse between channels
Max_Dist = 4 ; % distance, electrodes
COMBINE_SPIKES = 'y' ;
ANALYSE_METHOD = 'Spike_transfer' ; % 'Spike_transfer'  'Sync'
SHOW_SAVE_RASTER = 'y' ;

sr = 20000 ;         

T_Spike_Delay = 5 ;% spike transfer delay , ms
T_tau = 2 ; % spike transfer delay error , ms

DT_i_min = 1 ;
DT_i_max = 2 ;
DT_i_step = 1 ;



Sync_Bin = Tmax * ( sr / 1000 ) ;
M = ( N - 1 )* N / 2 ;

Dat = zeros(  M , 2 );
MaxDelays = zeros(  M , 1 );
Dchan = zeros(  M , 1 );
k = 1 ;
DIV = 8 ;
T_Spike_Delay =  T_Spike_Delay * ( sr / 1000 ) ;
T_tau =  T_tau * ( sr / 1000 ) ;



[file , pathname]  = uigetfile('*.*','Select file');
[pathstr,name,ext,versn] = fileparts( file ) ;
strfind(   name , '_CH') ;
init_dir = cd ;
cd( pathname ) ;
file = name( 1 : strfind(   name , '_CH') - 1  ) 
file_input = file 

eval(['load ' char( file_input ) '_Details']);



xxx = zeros( Trace_Lenght_pionts , 1 ) ;
yyy = zeros( Trace_Lenght_pionts , 1 ) ;


Binary_trace_i = [] ;
Binary_trace_j = [] ;
CC = zeros(1, 2*Tmax + 1 ) ;
Sy = [] ;
Raster = [] ;




DT_i_i = 0 ;
x =0 :0.01:1 ; 
val_3d = zeros( floor( (DT_i_max - DT_i_min)/DT_i_step ) , length( x ) ) ;

for DT_i = DT_i_min :  DT_i_step : DT_i_max
    
Sync_Bin = DT_i * ( sr / 1000 ) ;
T_Spike_Delay =  DT_i * ( sr / 1000 ) ;
DT_i_i = DT_i_i + 1 ;
C_values = [] ;

x1 = 0 ; x2 = 0 ; y1 = 1 ; y2 = 0 ;
for CHANNEL_i = 1 : N
  if x1 < DIV x1=x1+1 ; else x1=1 ; y1=y1+1 ; end
  
  CHANNEL_i
     
     channel_file =['times_' char( file_input  ) '_CH' int2str( CHANNEL_i ) ] ;
     if exist( [ pathname '\' channel_file '.mat' ]  )
     eval(['load ' char( channel_file  ) ]);
     else
       cluster_class = zeros( 10 , 2);
     end
     Binary_trace_i = [] ;
     Neurons_count_i = max( cluster_class(:,1 ) ) ;
     if COMBINE_SPIKES == 'y' 
         Binary_trace_i =  zeros( Trace_Lenght_pionts , 1 ) ;
         Neurons_count_i  = 1 ;
     else  
         Neurons_count_i = Neurons_count_i ;
         Binary_trace_i =  zeros( Trace_Lenght_pionts , Neurons_count_i  ) ;         
     end    
     
     for N_i = 1 : Neurons_count_i    
        if COMBINE_SPIKES == 'y'
           extract_channel_index =  find ( cluster_class(:,1 ) > 0 ) ;
        else 
           extract_channel_index = find ( cluster_class(:,1 ) == N_i  ) ;
%            extract_channel_index
        end
        if length( extract_channel_index ) > 0
            channel_index = cluster_class( extract_channel_index , 2 ) ; 
          first_spike_t = extract_channel_index( 1 ) ;
         
        if COMBINE_SPIKES == 'y'
           chan = (CHANNEL_i ) * ones(1, length( channel_index ) );
           ch_index = channel_index' ;
           index_buff = [ ch_index ; chan ]' ;
           Raster = [ Raster ; index_buff ] ;   
        end 
        
         channel_index = floor( channel_index / ( 1e3/sr ) );
           Events_num_i( N_i ) = length( channel_index  );
%            Ampl = sum(  spikes( : , 15  )  ) / size( spikes , 1 ) 
%            if Ampl > 0  % >0 Positive spike            
%               Neuron_flag_i( N_i ) = 1 ;
%            else    
%               Neuron_flag_i( N_i ) = -1 ; 
%           end
            
        whos extract_channel_index 
        Binary_trace_i(   ( channel_index(:) ) ,  N_i ) = 1 ;
        end %  if length( extract_channel_index ) > 0
        
     end   

     

     
  CCC = 0 ;    
  for Neuron_i = 1 : Neurons_count_i
    x2=0 ; y2=1 ;  
      
    for CHANNEL_j = 1 :  N
     if x2 < DIV x2=x2+1 ; else x2=1 ; y2=y2+1 ; end   
     
     r = sqrt(  ( x1 - x2 ).^2 + ( y1 - y2 ).^2  );
     if ( CHANNEL_j >  CHANNEL_i )&( r < Max_Dist )
         
        channel_file =['times_' char( file_input  ) '_CH' int2str( CHANNEL_j ) ] ;
        if exist( [ pathname '\' channel_file '.mat' ]  )
        eval(['load ' char( channel_file  ) ]);
        else
         cluster_class = zeros( 10 , 2);
        end
         Binary_trace_j = 0 ;
        Neurons_count_j = max( cluster_class(:,1 ) ) ;
       if COMBINE_SPIKES == 'y' 
            Binary_trace_j =  zeros( Trace_Lenght_pionts , 1 ) ;
            Neurons_count_j  = 1 ;
       else  
           Neurons_count_j  = Neurons_count_j ;
            Binary_trace_j =  zeros( Trace_Lenght_pionts , Neurons_count_j  ) ;            
       end         
           for N_j = 1 : Neurons_count_j    
           if COMBINE_SPIKES == 'y'
             extract_channel_index = find ( cluster_class(:,1 ) > 0 ) ;
           else 
            extract_channel_index = find ( cluster_class(:,1 ) == N_j ) ;
           end        
           if length( extract_channel_index ) > 0
             first_spike_t = extract_channel_index( 1 ) ;
             channel_index = cluster_class( extract_channel_index , 2 ) ;
             channel_index = floor( channel_index / ( 1e3/sr )) ;
             Events_num_j( N_j ) = length( channel_index  );
             
%              Ampl = sum(  spikes( : , 15  )  ) / size( spikes , 1 ) ;
%              if Ampl > 0  % >0 Positive spike            
%                 Neuron_flag_j( N_j ) = 1 ;
%              else    
%                 Neuron_flag_j( N_j ) = -1 ; 
%              end
            
%              whos extract_channel_index             
                 Binary_trace_j( (  channel_index(:) ) , N_j ) = 1 ;
             end  %  if length( extract_channel_index ) > 0 
           end   
           
           
%           if COMBINE_SPIKES == 'y'  
%                Neuron_flag_i(:) = 1 ;  Neuron_flag_j(:) = 1 ; 
%           end 
               
          for Neuron_j = 1 : Neurons_count_j      
            %if  Neuron_flag_i( Neuron_i )* Neuron_flag_j( Neuron_j ) > 0
               
               %  a = Binary_trace_i(:, Neuron_i );
              %  b = Binary_trace_j(:, Neuron_j );
              %  C = Compare_values( a , b  );
              %  C = Compare_values( Binary_trace_i(:, Neuron_i ) , Binary_trace_j(:, Neuron_j )  );
              xxx =  Binary_trace_i(:, Neuron_i ) ;
              yyy =  Binary_trace_j(:, Neuron_j ) ;
              switch ANALYSE_METHOD
               case 'Sync'
               C = Compare_values( xxx , yyy , Sync_Bin  );
               case 'Spike_transfer' 
               C = Two_traces_Spikes_Transfer_correlation( xxx , yyy , T_Spike_Delay , T_tau  ) ;
              end
              
               %   [ C , lags ] = xcorr( Binary_trace_i(:, Neuron_i ) , Binary_trace_j(:, Neuron_j ) , Tmax , 'coeff' );
               %   LAGS = lags ;
               %   [ M , I ] = max( C ) ; 
               %   CC( k , : ) = C ;
               %   C = lags( I ) ;
                
               d = sqrt(  ( x1 - x2 ).^2 + ( y1 - y2 ).^2  );
               d = d * Dist ;
               C_values ( k , 1 ) =    abs( C ) ;

              Dchan ( k , 1 ) =   d ;
              
              CCC = CCC + 1 ;
              Sy( CHANNEL_i , CCC ) =  abs( C ) ;
              k = k + 1 ;
           % end
          end % Neuron_j   
        end   
    end % Channel j
  end % Neuron_i  
end



% figure
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
% hist(  C_values ) 


[ C_values ; Dchan ]' ;
% C_values
% if COMBINE_SPIKES == 'y'
%   dlmwrite( 'C_channels.txt' , [ Dchan C_values   ] ,'delimiter', '\t' )
% else 
%   dlmwrite( 'C_neurons.txt' , [ Dchan  C_values   ] ,'delimiter', '\t' )   
% end  

y = C_values(:,1);
x = Dchan(:,1);
%   plot( CC' ), grid on
% figure
%   plot( x ,y , 'd' ), grid on

end  
  
if SHOW_SAVE_RASTER == 'y'
   Raster_file = 'Raster_Sync_Neurons.txt';
 fid = fopen(Raster_file , 'w');
fprintf(fid, '%.3f  %d\n', Raster');
fclose(fid);
figure 
        subplot(1,1,1); plot( Raster(:,1) / 1000 , Raster(:,2) , 'k*' )
         axis( [ 0 Trace_length_sec 0 65 ] ) ;
        xlabel( 'Time, s' )
        ylabel( 'Electrode' )
end


T =  DT_i_min : DT_i_step : DT_i_max ;
x = 0 :0.01:1 ;
 [x,y]=meshgrid( x  , T );
surf(x,y, val_3d,'EdgeColor','none')

cd( init_dir) ;
 % --------------------------------------------------------------------
% function ReadIndex(hObject, eventdata, handles)
 

% --------------------------------------------------------------------