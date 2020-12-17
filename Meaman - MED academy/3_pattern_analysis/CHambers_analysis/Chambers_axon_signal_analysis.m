% Chambers_axon_signal_analysis 
% input - index_r

Connectivity_parameters_init
 Connectiv_data.params.tau_max = 100 ;
 Connectiv_data.params.tau_delta = 1 ;
    Connectiv_data.params.epsilon_tau =  0.5  ;  
    
    
Axon_chan = Global_flags.Search_Params.Chamber_channels_electrodes ;
s = size( Axon_chan );
N_axons = s(1);
Chan_per_axon = s(2);
axon_i = 4 ;
ch1 = 1 ;
ch2 = 2 ;

use_index_r = false ;

index_r_axons = [];
raster_axons = [] ;
RASTER_data = [];
raster_axons.RASTER_data = [];
Spiketimes_all = cell(  Chan_per_axon  ,1);
Total_Spike_Rates_all_channels = [] ;
for cha = 1 : Chan_per_axon
    if use_index_r
    index_ch = find( index_r( : , 2 ) == Axon_chan( axon_i , cha )) ;
    else
      index_ch = [];
         for nbi = 1 : Nb
            index_ch  = [ index_ch   ; bursts_absolute{ nbi }{ ch }   ] ;
         end
      
    end
   index_r_buf =  index_r( index_ch , 1 );
   inch = ones( length( index_r_buf ) , 1) * cha ;
   
%    isi = diff( index_r_buf );
%    isi( isi > 10 )= [] ;
%    figure
%    hist( isi , 100);
   
   Spiketimes_all{ cha } = index_r_buf ;
   RASTER_data.index_r = index_r_buf ;
   RASTER_data.channel_num = cha ;
   raster_axons.RASTER_data = [ raster_axons.RASTER_data  RASTER_data ];
   Total_Spike_Rates_all_channels= [ Total_Spike_Rates_all_channels length( index_r_buf ) ] 
         
   index_r_buf = [ index_r_buf inch ] ;
   index_r_axons = [ index_r_axons ; index_r_buf ] ;
   
   
end



NormY = Total_Spike_Rates_all_channels( ch1 )  ;
tau_x =  0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max ; %  delays for fitting ;

M_of_tau  = Sp_trans_fast_01( Spiketimes_all{ ch1 }'   , Spiketimes_all{ ch2 }'    , ...
                                Connectiv_data.params.tau_delta   , Connectiv_data.params.tau_max_sign*Connectiv_data.params.tau_max   ,...
                                Connectiv_data.params.epsilon_tau    )  ;
 
% epsilon = Connectiv_data.params.epsilon_tau ; 
% tau_delta = Connectiv_data.params.tau_delta ;
% M_of_tau=[];
% tau_x = [];
% for d= 0 : tau_delta : Connectiv_data.params.tau_max 
%     M = 0 ;
%    for chi = 1:Total_Spike_Rates_all_channels( ch1 )
%       
%        
%        for chj = 1 : Total_Spike_Rates_all_channels( ch2 )
%           if Spiketimes_all{ ch1 }( chi ) >= Spiketimes_all{ ch2 }(chj) - d - epsilon  &&...
%              Spiketimes_all{ ch1 }( chi ) < Spiketimes_all{ ch2 }(chj) - d + epsilon 
%             M=M+1 ;
%           end
%            
%        end
%        
%    end
%     M
%    tau_x = [ tau_x d ] ; 
%    M_of_tau = [ M_of_tau M ]; 
% end 
figure                            
% plot(  tau_x , M_of_tau / NormY )                              
plot(  tau_x ,  M_of_tau / NormY )           
                         
% figure
% Raster_Plot_from_index_r_func( index_r_axons)
 
