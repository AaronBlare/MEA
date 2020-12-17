function    [  TimeBin_Total_Spikes ,  TimeBin_Total_Spikes_mean , TimeBin_Total_Spikes_std , ...
   Spike_Rate_Patterns ,  Spike_Rate_Signature ,  ... 
   Spike_Rate_Signature_std , Amps_per_channel_per_bin , Amps_Signature , Amps_Signature_std  , ...
   TimeBin_Total_Amps , TimeBin_Total_Amps_mean , TimeBin_Total_Amps_std , Amps_Signature_mean , Total_Amps_mean_all_chan , ...
   Total_Amps_std_all_chan , Amps_each_channel_mean ,  Amps_each_channel_std ,Amps_mean_each_burst , AmpRates ]  ...
      = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N , Nb , bursts1 , ...
      Start_t , Ent_t ,DT_step , bursts_amps , var )
  % Low active channels should be erased before this .  
  %Data_rates1 - Spike Rate Signature
  % SpatioRatePattern1 - Spatio (Spike) Rate Profile
% N=64;
% Spike_Rate_Signature = zeros( fire_bins  , N );  

 
Amps_Signature_mean = [] ;

nargin ;
if nargin < 7 % No bursts_amps in input
  bursts_amps = bursts1 ;  
  bursts_amps_included = true ;
else
  if  ~isempty( bursts_amps )
   bursts_amps_included = true ;  
  else
     bursts_amps_included = false ;   
  end
end

Test_figure_draw_Signature = false ;
bursts_amps_process_simple = true ;
old_slow_analysis = false ;

Analyze_amps_patterns = bursts_amps_process_simple & bursts_amps_included ;

if isfield( var , 'Burst_Data_Ver' )
    Burst_Data_Ver = var.Burst_Data_Ver ;
%     N = var.N ;
else
 a=size( bursts1);
  N=a(2); 
   Burst_Data_Ver = 1 ;
end

if isfield( var , 'Find_only_SpikeRate' )
    Find_only_SpikeRate = var.Find_only_SpikeRate ; 
else
 Find_only_SpikeRate = false ;
end

% Spike_Rates_each_burst = var.Spike_Rates_each_burst ;

Start_t_shift = Start_t ;
Start_t = 0 ; 

 DT = DT_step ;
Burst_len = Ent_t - Start_t ;     
 fire_bins = round((Ent_t - Start_t) / DT_step) ;
  

  
% Data_total_rates1 = zeros(  Nb , N );  
% Data_total_rates_signature1 = zeros(  1 , N );   
Spike_Rate_Signature = zeros( fire_bins  , N ); 
Spike_Rate_Signature_std = zeros( fire_bins  , N ); 
Spike_Rate_Patterns = zeros( fire_bins  , N , Nb );
TimeBin_Total_Spikes = zeros( Nb , fire_bins ); 
TimeBin_Total_Spikes_mean = zeros(1,fire_bins);
TimeBin_Total_Spikes_std = zeros(1,fire_bins);

TimeBin_Total_Amps = zeros( Nb , fire_bins ); 
TimeBin_Total_Amps_mean = zeros(1,fire_bins);
TimeBin_Total_Amps_std = zeros(1,fire_bins);

Amps_per_channel_per_bin = zeros( fire_bins  , N , Nb );
Amps_Signature = zeros( fire_bins  , N ); 
Amps_Signature_std = zeros( fire_bins  , N ); 

AmpRates =zeros(  Nb , N );  
Amps_mean_each_burst = zeros(  Nb , 1 );         
Amps_each_channel_mean = zeros( N , 1); 
Amps_each_channel_std = zeros( N , 1); 

Total_Amps_mean_all_chan = 0 ;
Total_Amps_std_all_chan = 0 ;

%  for ti=1: fire_bins 



% Check_and_Run_matlabpool

if old_slow_analysis
%  if ~Find_only_SpikeRate 
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
 
        chan_firing1_total = zeros( Nb , 1) ; 
        chan_amps_total = zeros( Nb , 1) ;
      for ti=1: fire_bins
         
        dti = DT*(ti-1) ;
        for t = 1 :  Nb   
            if Burst_Data_Ver == 1
            si = find( bursts1( t , ch ,: )>= dti+Start_t & bursts1( t , ch ,: )< dti+DT +Start_t ) ;
            else
            si = find( bursts1{ t }{ ch }>= dti+Start_t & bursts1{ t }{ ch }< dti+DT +Start_t ) ;                
            end
            
            rate =length( si ) ;if ~isfinite(  rate  )  rate= 0 ;end 
             
%             rate = 100 * ( rate / Spike_Rates_each_burst( t )) ;
            
            chan_firing1_total(t) = rate;
            Spike_Rate_Patterns(  ti , ch ,  t  ) = rate ;
            
            if isempty(  si  ) 
                meanAmp = 0 ;
            else
                if Burst_Data_Ver == 1
               meanAmp  = mean( bursts_amps( t , ch , si )  ); 
                else
                    amps =  bursts_amps{ t }{ ch } ;
                    meanAmp  = mean( amps( si )  );   
                end
            end 
            chan_amps_total( t ) = meanAmp ;
            Amps_per_channel_per_bin(  ti , ch ,  t  ) = meanAmp ;  
%             sirate = find( bursts1( t , ch ,: )> Start_t & bursts1( t , ch ,: )<= fire_bins*DT +Start_t ) ;
%             Spikes = length( sirate ) ; if ~isfinite(Spikes) || Spikes==0
%                 Spikes=1 ;end
%           Chan_Corrs( ch ) = Chan_Corrs( ch )  / Spikes ;  
        end      
        Spike_Rate_Signature( ti , ch ) = mea_Mean_defined( chan_firing1_total )  ;
        Spike_Rate_Signature_std( ti ,  ch ) = mea_Std_defined( chan_firing1_total  )  ;
        
        Amps_Signature( ti , ch ) = mea_Mean_defined( chan_amps_total )  ;
        Amps_Signature_std( ti ,  ch ) = mea_Std_defined( chan_amps_total  )  ; 
      end 
   end 
    
else
 
     max_tau = (fire_bins  ) * DT + Start_t ;
     
     for ch = 1 : N   
           DT ;
         for t = 1 :  Nb 
             if Burst_Data_Ver == 1
                si =  bursts1( t , ch ,: )  ;
                if Analyze_amps_patterns 
                     amps =  bursts_amps( t , ch ,: )  ; 
                end
             else
                si =  bursts1{ t }{ ch }  ;      
                if Analyze_amps_patterns
                    amps =  bursts_amps{ t }{ ch }  ;      
                end
             end
             
             si( si >= Ent_t - DT ) = [];
%              si( si >= max_tau ) = [];  
             si( si < Start_t ) = [];
             
             si( si < Start_t_shift ) = [];
             
             dt_i = round( ( si - Start_t ) / DT ) + 1;
             
             
             if ~isempty( si )
                 for si_i = 1 :length(si)   
%                      si  - Start_t
%                      dt_i
                        Spike_Rate_Patterns(  dt_i(si_i)  , ch ,  t  ) = ...
                        Spike_Rate_Patterns(  dt_i(si_i)  , ch ,  t  ) + 1 ;
                    if  Analyze_amps_patterns
                        Amps_per_channel_per_bin(  dt_i(si_i) , ch ,  t  ) = ...
                        Amps_per_channel_per_bin(  dt_i(si_i) , ch ,  t  ) + amps( si_i ) ;
                    end
                 end
               if Analyze_amps_patterns
                   for ti=1: fire_bins
                     if Spike_Rate_Patterns(  ti , ch ,  t  ) > 0
                      Amps_per_channel_per_bin(  ti , ch ,  t  ) = Amps_per_channel_per_bin(  ti , ch ,  t  ) / ...
                          Spike_Rate_Patterns(  ti , ch ,  t  ) ;
                     end
                   end
               end
             end

         end
         for ti=1: fire_bins
         Spike_Rate_Signature( ti , ch )= mean( Spike_Rate_Patterns(  ti , ch ,  :  )  );
         Spike_Rate_Signature_std( ti ,  ch ) = std( Spike_Rate_Patterns(  ti , ch , :  )  )  ;         
         if Analyze_amps_patterns
            amps_chan_ti = Amps_per_channel_per_bin(  ti , ch ,  :  ) ;
            amps_chan_ti( amps_chan_ti == 0 ) =[];
            Amps_Signature_mean( ti , ch )= mean( amps_chan_ti  ) ;
            Amps_Signature( ti , ch )= median( amps_chan_ti  ) ;
            Amps_Signature_std( ti ,  ch ) = std( amps_chan_ti  )  ; 
         end
         end
     end
     
     
end
 

%     Spike_Rate_Signature  = Amps_Signature ;
%     Spike_Rate_Patterns = Amps_per_channel_per_bin  ;
   
%   Data_Rate_Patterns2 = zeros( fire_bins    , N , Nb ); 
% for ch = 1 : N 
%     for t = 1 :  Nb       
%           dt_ti = floor( bursts1{ t }{ ch } / DT ) + 1 ;
%           dt_ti( dt_ti > fire_bins ) = [] ;
%           for dt_ii = 1 : length( dt_ti ) 
%             Data_Rate_Patterns2( dt_ti( dt_ii ) , ch , t ) = Data_Rate_Patterns2( dt_ti( dt_ii ) , ch , t ) + 1 ;
%           end
%     end
% end
%   Spike_Rate_Patterns = Data_Rate_Patterns2 ;
  
  
%   figure
%   hold on
%   s1 = Spike_Rate_Patterns( : , ch , t ) ;
%   s2 = Data_Rate_Patterns2( : , ch , t ) ;
%   plot( s1 + 0.02)
%   plot( s2 , 'r' )
%   hold off
   
  %---------- Statistics in each bin - PSTH 
  for ti=1:fire_bins
      for R = 1 : Nb      
           TimeBin_Total_Spikes( R , ti )= sum( Spike_Rate_Patterns( ti , : ,  R  )) ; 
           TimeBin_Total_Amps( R , ti )= mean( Amps_per_channel_per_bin( ti , : ,  R  )) ;            
      end
      
      TimeBin_Total_Spikes_mean( ti ) = mean( TimeBin_Total_Spikes( : , ti ));
      TimeBin_Total_Spikes_std( ti ) = std( TimeBin_Total_Spikes( : , ti ));
      
      TimeBin_Total_Amps_mean( ti ) = mean( TimeBin_Total_Amps( : , ti ));
      TimeBin_Total_Amps_std( ti ) = std( TimeBin_Total_Amps( : , ti ));
  end     
  
  if ~bursts_amps_included
      Amps_Signature( : , : ) = 0; 
      Amps_Signature_std( : , : ) = 0; 
      Amps_per_channel_per_bin( : , : , : ) = 0; 
  end
   
   if  bursts_amps_included 
     buf = reshape( Amps_per_channel_per_bin , 1 , [] );
     buf( buf == 0 ) =[];
     Total_Amps_mean_all_chan = mean( buf ) ;
     Total_Amps_std_all_chan = std( buf );
 
     for ch = 1 :  N % 60  
         buf = [] ;
         for ti=1: fire_bins % ANALYZED_DATA.DT_BINS_number % fire_bins
             buf2 = Amps_per_channel_per_bin(  ti , ch ,  :  ); % ANALYZED_DATA.Amp_Patterns(  ti , ch ,  :  );
             buf2 = reshape( buf2 , 1 , []);  
             buf = [ buf   buf2 ] ; % Amps_per_channel_per_bin
         end 
         buf( buf == 0 ) =[];
         Amps_each_channel_mean( ch ) = mean( buf );
         Amps_each_channel_std( ch ) = std( buf );
         
         buf = [] ; 
         for R = 1 : Nb           
                 buf2 = Amps_per_channel_per_bin(  : , ch ,  R  ); % ANALYZED_DATA.Amp_Patterns(  ti , ch ,  :  );
                 buf2 = reshape( buf2 , 1 , []); 
                 buf = [ buf   buf2 ] ; % Amps_per_channel_per_bin
                 buf( buf == 0 ) =[];
                AmpRates( R , ch ) = mean( buf );
         end         
         
         
         
     end
     
     for R = 1 : Nb  
         buf  = [];
         for ch = 1: N 
             buf2 =Amps_per_channel_per_bin(  : , ch ,  R  ); % ANALYZED_DATA.Amp_Patterns(  : , ch ,  R  ); 
             buf2 = reshape( buf2 , 1 , []); 
             buf = [ buf   buf2 ] ; % Amps_per_channel_per_bin
         end 
         buf( buf == 0 ) =[];
         mean( buf );
        Amps_mean_each_burst( R )= mean( buf2) ;
     end
     
   end

  
  if Test_figure_draw_Signature
                figure
                  Nx = 2 ; Ny = 1 ;
                  f1 = subplot( Ny , Nx , 1 );
                    x=1:fire_bins ; y = 1:N;
                    Spike_Rate_Signature2 = Spike_Rate_Signature';
                    bb= imagesc(  x *DT  , y ,  Spike_Rate_Signature2    ); 
                    title( ['T_a_c_t (1), spikes/bin (' num2str(DT) ' ms)'] );
                    xlabel( 'Time offset, ms' )
                    ylabel( 'Electrode #' )
                    colorbar
                    
                 f2 = subplot( Ny , Nx ,  2 );
                    x=1:fire_bins ; y = 1:N;
                    Amps_Signature2 = Amps_Signature';
                    Amps_Signature2( isnan( Amps_Signature2 ) ) = 0 ;
                    bb= imagesc(  x *DT   , y ,  Amps_Signature2    ); 
                    title( ['T_a_c_t (2), spikes/bin (' num2str(DT) ' ms)'] );
                    xlabel( 'Amplitude, mV' )
                    ylabel( 'Electrode #' )
                    colorbar
                   
                    linkaxes( [ f1 f2  ] , 'xy' )
        end
  
%                   Patterns_out.TimeBin_Total_Spikes = TimeBin_Total_Spikes ;
%                   Patterns_out.TimeBin_Total_Spikes_mean =TimeBin_Total_Spikes_mean ;
%                   Patterns_out.TimeBin_Total_Spikes_std =TimeBin_Total_Spikes_std ;
%                   Patterns_out.Spike_Rate_Patterns =Spike_Rate_Patterns ;
%                   Patterns_out.Spike_Rate_Signature =Spike_Rate_Signature ;
%                   Patterns_out.Spike_Rate_Signature_std   =Spike_Rate_Signature_std ;  
  
  
%    
%    Data_total_rates_signature1'
%    Spike_Rate_Signature'
