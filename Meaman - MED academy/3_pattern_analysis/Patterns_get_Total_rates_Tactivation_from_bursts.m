
% Patterns_get_Total_rates_Tactivation_from_bursts
% Patterns.bursts -> Patterns.Spike_Rates Patterns.burst_activation ...


   Start_t_shift = Patterns.Poststim_interval_START ;
 
   
%  Burst_len = Patterns.Poststim_interval_END - Patterns.Poststim_interval_START ;
 Burst_len = Patterns.Poststim_interval_END   ;

  Nb= Patterns.Number_of_Patterns ;
   N = Patterns.N_channels ;
   fire_bins = round( ( Burst_len )/ ...
       Patterns.DT_bin );
Patterns.DT_bins_number = fire_bins ;

Patterns.burst_activation=zeros( Nb ,N);
Patterns.burst_activation_absolute=zeros( Nb ,N);
Patterns.burst_activation_amps =zeros( Nb ,N); 
Patterns.burst_start =  zeros( Nb  ,1);   
Patterns.burst_start_Tact_mean =  zeros( Nb  ,1);   
Patterns.Spike_Rates = zeros(  Nb , N );     
Patterns.Spike_Rates_each_burst  = zeros( Nb  ,1);  
    Patterns.burst_activation_mean  = zeros( N,1);
    Patterns.burst_activation_2_mean  = zeros( N,1);
    Patterns.burst_activation_normalized_mean  = zeros( N,1);
    Patterns.Spike_Rate_per_electrode= zeros( N,1);
    Patterns.Spike_Rates_each_channel_mean  = zeros(  N , 1 );
    Patterns.Spike_Rates_each_channel_std  = zeros(  N , 1 );  
    Patterns.Amp_each_channel_mean  = zeros(  N , 1 );
    

if iscell( Patterns.bursts )
    Burst_Data_Ver =2;
else
    Burst_Data_Ver=1;
end
 
    for t = 1 :  Nb  
        for ch = 1 : N   
            if Burst_Data_Ver == 1  
                si = find(  Patterns.bursts( t , ch ,: ) >= Patterns.Poststim_interval_START & ...
                            Patterns.bursts( t , ch ,: )< Burst_len +Patterns.Poststim_interval_START ) ;
            else
                si = find(  Patterns.bursts{ t }{ ch } >= Patterns.Poststim_interval_START & ...
                            Patterns.bursts{ t }{ ch }< Burst_len +Patterns.Poststim_interval_START ) ; 
 
            end
           rate =length( si ) ;
           if  isempty(  si  )
               rate = 0 ;
              Patterns.burst_activation( t , ch )=  0 ;
              Patterns.burst_activation_absolute( t , ch )= Patterns.artefacts( t )  ;
           else
               if Burst_Data_Ver == 1  
                  Patterns.burst_activation( t , ch )= Patterns.bursts( t , ch , si(1) ) ; 
                  Patterns.burst_activation_amps( t , ch )= Patterns.bursts_amps( t , ch , si(1) ) ; 
                  Patterns.burst_activation_absolute( t , ch )= Patterns.artefacts( t ) +  Patterns.bursts( t , ch , si(1) ) ; 
               else
                  Patterns.burst_activation( t , ch )= Patterns.bursts{ t }{ ch }( si(1) ) ; 
                  Patterns.burst_activation_amps( t , ch )= Patterns.bursts_amps{ t }{ ch }( si(1) ) ; 
                  Patterns.burst_activation_absolute( t , ch )= Patterns.artefacts( t ) + Patterns.bursts{ t }{ ch }( si(1) ) ; 
               end
           end
           Patterns.Spike_Rates( t , ch  ) = rate ;
        end 
      Patterns.Spike_Rates_each_burst( t ) = sum( Patterns.Spike_Rates( t , :)); 
      
      if Patterns.Normalize_responses
          if Patterns.Spike_Rates_each_burst( t ) > 0
            Patterns.Spike_Rates( t , :) = 100* (Patterns.Spike_Rates( t , :) / Patterns.Spike_Rates_each_burst( t )) ;
          else
            Patterns.Spike_Rates( t , :) = 0 ;
          end
      end
      
      % find response burst start
     Tact_all =  Patterns.burst_activation_absolute( t , : ) ;
     Tact_all( Tact_all==0) = [] ;
     if isempty( Tact_all )
         Tact_all = 0 ;
         Tact_mean= 0 ;
     end
     Tact_min = min( Tact_all ) ;
     Tact_mean = mean( Tact_all ) ;
       Patterns.burst_start( t ) =  Tact_min ;    
       Patterns.burst_start_Tact_mean( t ) =  Tact_mean ;    
%          Patterns.burst_end   
    end

      for ch = 1 : N   
            Patterns.burst_activation_mean( ch  ) = mean_or_median( Patterns.burst_activation( : , ch )); 
%       hist(  burst_activation( : , ch ) )       
%             Patterns.Spike_Rate_per_electrode( ch ) = length( find( index_r( : , 2 ) == ch ) ) / Tmax_s ; 
%             Patterns.burst_activation_normalized_mean( ch) = mean_or_median( Patterns.burst_activation_normalized( : , ch ));
            % burst_activation(ch) = burst(1,ch);
            amps = [] ;
             Ampmean = 0 ;
            for t = 1 :  Nb  
               amps = [ amps ; Patterns.bursts_amps{ t }{ ch } ] ;
            end
            if ~isempty( amps )
           	Ampmean = mean( amps ) ;
            end
            if isnan( Ampmean )
                Ampmean = 0 ;
            end
            Patterns.Amp_each_channel_mean( ch ) = Ampmean ;
        
      end 
     
       for ch = 1 : N  
           Patterns.Spike_Rates_each_channel_mean( ch )  = mean( Patterns.Spike_Rates(    :, ch ));
           Patterns.Spike_Rates_each_channel_std( ch )  = std( Patterns.Spike_Rates(   :, ch ));        
       end
       
        

      
 if isfield( var , 'simple_activation_patterns' )
 if ~var.simple_activation_patterns 
    
        Patterns_get_smooth_profiles_Tact
         
 end     
 end    
    