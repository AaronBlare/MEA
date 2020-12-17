function   Patterns_out  ...
      = Get_Electrodes_Rates_at_TimeBins_1pattern_v2( Patterns )
  % Low active channels should be erased before this .  
  %Data_rates1 - Spike Rate Signature
  % SpatioRatePattern1 - Spatio (Spike) Rate Profile
% N=64;
 DT_step = Patterns.DT_bin ;
 DT = DT_step ;
 Start_t = Patterns.Poststim_interval_START ;
 Ent_t = Patterns.Poststim_interval_END ;
 Nb = Patterns.Number_of_Patterns ;
 N = Patterns.N_channels ;
 Burst_len = Ent_t - Start_t ;     
 fire_bins = floor((Ent_t - Start_t) / DT_step) ;
  
 Patterns_out = Patterns ;
 
%     a=size( bursts1);
%   N=a(2); 
  
% Data_total_rates1 = zeros(  Nb , N );  
% Data_total_rates_signature1 = zeros(  1 , N );   
Data_Rate_Signature1 = zeros( fire_bins  , N ); 
Data_Rate_Signature1_std = zeros( fire_bins  , N ); 
Data_Rate_Patterns1 = zeros( fire_bins  , N , Nb );
TimeBin_Total_Spikes = zeros( Nb , fire_bins ); 
TimeBin_Total_Spikes_mean = zeros(1,fire_bins);
TimeBin_Total_Spikes_std = zeros(1,fire_bins);

%  for ti=1: fire_bins 
chan_firing1_total = zeros( Nb , 1) ; 



   for ch = 1 : N      
       
       % get total rates
%         for t = 1 :  Nb  
%            si = find( bursts1( t , ch ,: )> Start_t & bursts1( t , ch ,: )<= Burst_len +Start_t ) ;
%            rate =length( si ) ;if ~isfinite(  rate  )  rate= 0 ;end
%            Data_total_rates1( t , ch  ) =  rate ;
%         end
%       
%         Data_total_rates_signature1( ch ) =  Calc_Centroid_value_1D( Data_total_rates1( : , ch) );
%         Data_total_rates_signature1( ch ) = mean( Data_total_rates1( : , ch));
           
      for ti=1: fire_bins
         
        dti = DT*(ti-1) ;
        for t = 1 :  Nb   
            
            si = find( Patterns.bursts( t , ch ,: )> dti+Start_t & Patterns.bursts( t , ch ,: )<= dti+DT +Start_t ) ;
            rate =length( si ) ;if ~isfinite(  rate  ) rate= 0 ;end 
            chan_firing1_total(t) = rate;
            Data_Rate_Patterns1(  ti , ch ,  t  ) = rate ;
            
%             sirate = find( bursts1( t , ch ,: )> Start_t & bursts1( t , ch ,: )<= fire_bins*DT +Start_t ) ;
%             Spikes = length( sirate ) ; if ~isfinite(Spikes) || Spikes==0
%                 Spikes=1 ;end
%           Chan_Corrs( ch ) = Chan_Corrs( ch )  / Spikes ;  
        end
        Data_Rate_Signature1( ti , ch ) = Calc_Centroid_value_1D( chan_firing1_total )  ;
        Data_Rate_Signature1_std( ti ,  ch ) = std( chan_firing1_total  )  ;
        
        
      end 
   end 
   
  %---------- Statistics in each bin - PSTH 
  for ti=1:fire_bins
      for R = 1 : Nb      
           TimeBin_Total_Spikes( R , ti )= sum( Data_Rate_Patterns1( ti , : ,  R  )) ; 
      end
      
      TimeBin_Total_Spikes_mean( ti ) = mean( TimeBin_Total_Spikes( : , ti ));
      TimeBin_Total_Spikes_std( ti ) = std( TimeBin_Total_Spikes( : , ti ));
  end     
   
                  Patterns_out.TimeBin_Total_Spikes = TimeBin_Total_Spikes ;
                  Patterns_out.TimeBin_Total_Spikes_mean =TimeBin_Total_Spikes_mean ;
                  Patterns_out.TimeBin_Total_Spikes_std =TimeBin_Total_Spikes_std ;
                  Patterns_out.Data_Rate_Patterns1 =Data_Rate_Patterns1 ;
                  Patterns_out.Data_Rate_Signature1 =Data_Rate_Signature1 ;
                  Patterns_out.Data_Rate_Signature1_std   =Data_Rate_Signature1_std ;  
  
  
%    
%    Data_total_rates_signature1'
%    Data_Rate_Signature1'
