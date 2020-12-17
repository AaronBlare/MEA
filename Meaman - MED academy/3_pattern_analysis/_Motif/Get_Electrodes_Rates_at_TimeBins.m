function  [ Data_total_rates1,  Data_total_rates2 ,  Data_total_rates_signature1 , Data_total_rates_signature2  ...
   Data_Rate_Patterns1 ,  Data_Rate_Patterns2 ,Data_Rate_Signature1 , Data_Rate_Signature2 , ... 
   Data_Rate_Signature1_std , Data_Rate_Signature2_std  ] ...
      = Get_Electrodes_Rates_at_TimeBins( N ,Nb ,Nb2, bursts1 , bursts2  , Start_t , Ent_t ,DT_step )
  % Low active channels should be erased before this .  
  %Data_rates1 - Spike Rate Signature
  % SpatioRatePattern1 - Spatio (Spike) Rate Profile
% N=64;
 DT = DT_step ;
Burst_len = Ent_t;    
  fire_bins = floor(Burst_len / DT) ;
  
Data_total_rates1 = zeros(  Nb , N );  
Data_total_rates2 = zeros(  Nb2 , N );  
Data_total_rates_signature1 = zeros(  1 , N );  
Data_total_rates_signature2 = zeros(  1 , N );  

Data_Rate_Signature1 = zeros( fire_bins  , N ); Data_Rate_Signature1_std = zeros( fire_bins  , N ); 
Data_Rate_Signature2 = zeros( fire_bins  , N ); Data_Rate_Signature2_std = zeros( fire_bins  , N ); 
Data_Rate_Patterns1 = zeros( Nb , N ,fire_bins   );
Data_Rate_Patterns2 = zeros( Nb2 , N , fire_bins );


chan_firing_buf1=zeros( 1 , fire_bins   );
%  for ti=1: fire_bins 
     
   for ch = 1 : N      
       
       % get total rates
        for t = 1 :  Nb  
           si = find( bursts1( t , ch ,: )> Start_t & bursts1( t , ch ,: )<= Burst_len +Start_t ) ;
           rate =length( si ) ;if ~isfinite(  rate  )  rate= 0 ;end
           Data_total_rates1( t , ch    ) =  rate ;
        end
      
        Data_total_rates_signature1( ch ) =  Calc_Centroid_value_1D( Data_total_rates1( : , ch) );
%         Data_total_rates_signature1( ch ) = mean( Data_total_rates1( : , ch));
       for t = 1 :  Nb2      
          si = find( bursts2( t , ch ,: )> Start_t & bursts2( t , ch ,: )<= Burst_len +Start_t ) ;
          rate =length( si ) ;if ~isfinite(  rate  )  rate= 0 ;end
          Data_total_rates2( t , ch    ) =  rate ;
        end
          Data_total_rates_signature2( ch ) = Calc_Centroid_value_1D( Data_total_rates2( : , ch));
          
          
      for ti=1: fire_bins
        chan_firing1_total = [];  
        dti = DT*(ti-1) ;
        for t = 1 :  Nb   
            
            si = find( bursts1( t , ch ,: )> dti+Start_t & bursts1( t , ch ,: )<= dti+DT +Start_t ) ;
            rate =length( si ) ;if ~isfinite(  rate  )  rate= 0 ;end 
            chan_firing1_total = [chan_firing1_total rate];
            Data_Rate_Patterns1(  t , ch , ti   ) = rate ;
            
            sirate = find( bursts1( t , ch ,: )> Start_t & bursts1( t , ch ,: )<= fire_bins*DT +Start_t ) ;
            Spikes = length( sirate ) ; if ~isfinite(Spikes) || Spikes==0
                Spikes=1 ;end
%           Chan_Corrs( ch ) = Chan_Corrs( ch )  / Spikes ;  
        end      
        Data_Rate_Signature1( ti , ch ) = Calc_Centroid_value_1D( chan_firing1_total )  ;
        Data_Rate_Signature1_std( ti ,  ch ) = std( chan_firing1_total  )  ;
        
         
        
           chan_firing2_total = [];    
           for t = 1 :  Nb2      
            si = find( bursts2( t , ch ,: )>= dti+Start_t & bursts2( t , ch ,: )< dti+DT +Start_t ) ;
            rate =length( si ) ;if ~isfinite(  rate  )  
                rate= 0 ;end 
            chan_firing2_total = [chan_firing2_total rate];
          Data_Rate_Patterns2( t , ch , ti   ) = rate ;
            
          sirate = find( bursts2( t , ch ,: )>= Start_t & bursts2( t , ch ,: )< fire_bins*DT +Start_t ) ;
          Spikes = length( sirate ) ; if ~isfinite(Spikes) || Spikes==0 Spikes=1 ;end
%           Chan_Corrs( ch ) = Chan_Corrs( ch )  / Spikes ;  
          end    
          
          Data_Rate_Signature2( ti,  ch ) = Calc_Centroid_value_1D( chan_firing2_total );
          Data_Rate_Signature2_std( ti, ch ) = std( chan_firing2_total  );
     
      end 
   end 
%    
%    Data_total_rates_signature1'
%    Data_Rate_Signature1'
