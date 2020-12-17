function   Patterns  ...
      = Recalc_all_Post_stim_data( Patterns , flags )
  % Calculate all post stim stats depending on N Start_t Ent_t DT_step 
  % Patterns should contain:  bursts , bursts_amps
  % flags should contain : flags.normalize - normalizes all responses 
  % Number_of_Patterns - in case if it changed
  % INPUT :
%  Patterns.Poststim_interval_START ;
%  Patterns.Poststim_interval_END ;
%  Patterns.Number_of_Patterns ;
%  Patterns.N_channels ;
%  Patterns.DT_bin ;
%  Patterns.bursts
%  Patterns.bursts_amps  
%  Patterns.artefacts 

GLOBAL_CONSTANTS_load
  
Patterns.Number_of_Patterns = length( Patterns.artefacts );

 DT = Patterns.DT_bin ;
 DT_step= DT ;
 Start_t = Patterns.Poststim_interval_START ;
 Ent_t = Patterns.Poststim_interval_END ;
 Nb = Patterns.Number_of_Patterns ;
 N = Patterns.N_channels ;
 
 if nargin == 1
    flags.normalize = false; 
 end
 
 Normalize_responses = flags.normalize ;
 
 
 Burst_len = Ent_t - Start_t ;     
 fire_bins = floor((Ent_t - Start_t) / DT_step) ;  
  
 
% Patterns.burst_activation=zeros( Nb ,N);
% Patterns.burst_activation_absolute=zeros( Nb ,N);
% Patterns.burst_activation_amps =zeros( Nb ,N); 

% Patterns.Amps_per_channel_per_bin = zeros( fire_bins  , N , Nb ); 
% Patterns.Spike_Rates = zeros(  Nb , N );    
% Patterns.Spike_Rates_each_channel_zero_values_num  = zeros(  N , 1 );  
% Patterns.Spike_Rates_per_channel_per_bin = zeros( fire_bins  , N , Nb ); 
% Patterns.Spike_Rates_each_burst  = zeros( Nb  ,1); 
% Patterns.TimeBin_Total_Spikes = zeros( Nb , fire_bins ); 
 
NUMBER_OF_STIMULS = Nb ; 
  
Patterns.NUMBER_OF_STIMULS = Patterns.Number_of_Patterns ; 
Patterns.DT_bins_number =   fire_bins ;  

%  for ti=1: fire_bins 
% chan_firing1_total = zeros( Nb , 1) ; 
% chan_amps_total = zeros( Nb , 1) ; 

   
% Patterns_get_Total_rates_Tactivation_from_bursts
% Patterns.bursts -> Patterns.Spike_Rates Patterns.burst_activation ...
var.simple_activation_patterns = false ;
Patterns_get_Total_rates_Tactivation_from_bursts
  
  
% Patterns_get_BIN_rates_from_bursts
 % Patterns.bursts -> Patterns.Spike_Rates_per_channel_per_bin ,
 % Patterns.Amps_per_channel_per_bin
  Patterns_get_BIN_rates_from_bursts
   
    
 % Patterns_get_TimeBin_Total_Spikes
%  Spike_Rates_per_channel_per_bin - > TimeBin_Total_Spikes
% Amps_per_channel_per_bin -> TimeBin_Total_Amps     
var.use_selected_patterns = false;
%   Patterns_get_TimeBin_Total_Spikes
  
   
 %----------Patterns_get_Statistsic_all_parameters     
% Patterns.TimeBin_Total_Spikes  ... -> TimeBin_Total_Spikes_mean
Patterns_get_Statistsic_all_parameters

     


Patterns_Show_random_pattern_responses

     
                 %  Patterns.Poststim_interval_START ;
                %  Patterns.Poststim_interval_END ;
                %  Patterns.Number_of_Patterns ;
                %  Patterns.N_channels ;
                %  Patterns.DT_bin ;
                %  Patterns.bursts
                %  Patterns.bursts_amps  
                %  Patterns.artefacts
     
     
%                   Patterns.burst_activation = burst_activation ;
%                   Patterns.burst_activation_absolute = burst_activation_absolute;
%                   Patterns.burst_activation_amps = burst_activation_amps;
%                   Patterns.burst_activation_mean = burst_activation_mean ;
%                     
%                   Patterns.Amps_per_channel_per_bin = Amps_per_channel_per_bin ;
%                   Patterns.Amps_Signature = Amps_Signature ; 
%                   Patterns.Amps_Signature_std = Amps_Signature_std ;
%                      
%                   Patterns.Spike_Rates = Spike_Rates  ;  
%                   Patterns.Spike_Rates_each_channel_mean=Spike_Rates_each_channel_mean;
%                   Patterns.Spike_Rates_each_channel_std=Spike_Rates_each_channel_std;
%                   Patterns.Spike_Rates_each_channel_zero_values_num=Spike_Rates_each_channel_zero_values_num;    
%                   Patterns.Spike_Rates_Signature =Spike_Rates_Signature ;
%                   Patterns.Spike_Rates_Signature_std   =Spike_Rates_Signature_std ;  
%                   Patterns.Spike_Rates_per_channel_per_bin =Spike_Rates_per_channel_per_bin ; 
%                   Patterns.Spike_Rates_each_burst  = Spike_Rates_each_burst ;
%                   Patterns.Spike_Rates_each_burst_mean  = Spike_Rates_each_burst_mean ;
%                   Patterns.Spike_Rates_each_burst_std  = Spike_Rates_each_burst_std ;
%   
%                   Patterns.TimeBin_Total_Spikes = TimeBin_Total_Spikes ;
%                   Patterns.TimeBin_Total_Spikes_mean =TimeBin_Total_Spikes_mean ;
%                   Patterns.TimeBin_Total_Spikes_std =TimeBin_Total_Spikes_std ;
%  

  
%    
%    Data_total_rates_signature1'
%    Spike_Rates_Signature'
