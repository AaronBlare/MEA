function    [  TimeBin_Total_Spikes ,  TimeBin_Total_Spikes_mean , TimeBin_Total_Spikes_std , ...
   Data_Rate_Patterns1 ,  Data_Rate_Signature1 ,  ... 
   Data_Rate_Signature1_std , Amps_per_channel_per_bin , Amps_Signature , Amps_Signature_std , TimeBin_Total_Amps , ...
   TimeBin_Total_Amps_mean  , TimeBin_Total_Amps_std , var ]  ...
      = Get_Electrodes_Rates_at_TimeBins_1pattern( N , Nb , bursts1 ,  Start_t , Ent_t ,DT_step , bursts_amps , var )
  % Low active channels should be erased before this .  
  %Data_rates1 - Spike Rate Signature
  % SpatioRatePattern1 - Spatio (Spike) Rate Profile
% N=64;
 
nargin ;

if ~isfield( var , 'filter_bad_responses')
    var.filter_bad_responses = false ;
end
    
if var.filter_bad_responses 
    Filter_bad_responses = true ; 
else
  Filter_bad_responses = false ; 
end
    
    
if nargin > 7 % No bursts_amps in input
%   bursts_amps = bursts1 ;  
  bursts_amps_included = true ;
else
   bursts_amps_included = false ;  
end

% Spike_Rates_each_burst = var.Spike_Rates_each_burst ;

 DT = DT_step ;
Burst_len = Ent_t - Start_t ;     
 fire_bins = floor((Ent_t - Start_t) / DT_step) ;
  
  a=size( bursts1);
  N=a(2); 
  
% Data_total_rates1 = zeros(  Nb , N );  
% Data_total_rates_signature1 = zeros(  1 , N );   
Data_Rate_Signature1 = zeros( fire_bins  , N ); 
Data_Rate_Signature1_std = zeros( fire_bins  , N ); 
Data_Rate_Patterns1 = zeros( fire_bins  , N , Nb );
TimeBin_Total_Spikes = zeros( Nb , fire_bins ); 
TimeBin_Total_Spikes_mean = zeros(1,fire_bins);
TimeBin_Total_Spikes_std = zeros(1,fire_bins);

TimeBin_Total_Amps = zeros( Nb , fire_bins ); 
TimeBin_Total_Amps_mean = zeros(1,fire_bins);
TimeBin_Total_Amps_std = zeros(1,fire_bins);

Amps_per_channel_per_bin = zeros( fire_bins  , N , Nb );
Amps_Signature = zeros( fire_bins  , N ); 
Amps_Signature_std = zeros( fire_bins  , N ); 

%  for ti=1: fire_bins 
chan_firing1_total = zeros( Nb , 1) ; 
chan_amps_total = zeros( Nb , 1) ;


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
        chan_amps_total = [];
        for t_nb = 1 :  Nb   
            t = t_nb ;
            if var.use_selected_artifacts_list 
                t = var.selected_artifacts( t_nb);
            end
                
            si = find( bursts1( t , ch ,: )> dti+Start_t & bursts1( t , ch ,: )<= dti+DT +Start_t ) ;
            rate =length( si ) ;if ~isfinite(  rate  )  rate= 0 ;end 
             
%           rate = 100 * ( rate / Spike_Rates_each_burst( t )) ;
            
            chan_firing1_total(t) = rate;
            Data_Rate_Patterns1(  ti , ch ,  t_nb  ) = rate ;
            
            if isempty(  si  ) 
                meanAmp = 0 ;
            else
               Amps  =  bursts_amps( t , ch , si )   ; 
               meanAmp = mean( Amps);
               chan_amps_total  = [ chan_amps_total meanAmp ];
            end             
            Amps_per_channel_per_bin(  ti , ch ,  t_nb  ) = meanAmp ;  
%             sirate = find( bursts1( t , ch ,: )> Start_t & bursts1( t , ch ,: )<= fire_bins*DT +Start_t ) ;
%             Spikes = length( sirate ) ; if ~isfinite(Spikes) || Spikes==0
%                 Spikes=1 ;end
%           Chan_Corrs( ch ) = Chan_Corrs( ch )  / Spikes ;  
        end      
        Data_Rate_Signature1( ti , ch ) = Calc_Centroid_value_1D( chan_firing1_total )  ;
        Data_Rate_Signature1_std( ti ,  ch ) = std( chan_firing1_total  )  ;
        
        Amps_Signature( ti , ch ) = Calc_Centroid_value_1D( chan_amps_total )  ;
        Amps_Signature_std( ti ,  ch ) = std( chan_amps_total  )  ; 
      end 
   end 
   
  %---------- Statistics in each bin - PSTH 
  for ti=1:fire_bins
      for R = 1 : Nb      
           TimeBin_Total_Spikes( R , ti )= sum( Data_Rate_Patterns1( ti , : ,  R  )) ; 
      end
       
  end     
  
  
  
  %----- Check if not responses but bursts spont
  if Filter_bad_responses
                   
                   delete_responses = [];
                   for R = 1 : Nb       
                         fire_bins_list = Start_t : DT_step :Ent_t-1  ;
                         true_responses_bins = find( fire_bins_list > 20 & fire_bins_list <= 50 );
                         false_responses_bins = find(   fire_bins_list > 50 ); 
                          
                         True_reponses_spikes =  sum( TimeBin_Total_Spikes( R , true_responses_bins ) );
                         False_reponses_spikes =  sum( TimeBin_Total_Spikes( R , false_responses_bins ) );
                         if False_reponses_spikes  > True_reponses_spikes 
                             delete_responses=[delete_responses R];
                         end
                   end 
                 %---------------------------------
 
  %=============================Erase  false responses=================
      if ~isempty( delete_responses )
            selected_artifacts= 1: length(  var.selected_artifacts ) ;
      selected_artifacts( delete_responses ) = [];
       var.selected_artifacts =   selected_artifacts ;
      TimeBin_Total_Spikes( delete_responses , :)=[];

      Nb=Nb - length( delete_responses ) ; 
  end
  
  %====================================================================
  end            
                 
  for ti=1:fire_bins 
      
      TimeBin_Total_Spikes_mean( ti ) = mean( TimeBin_Total_Spikes( : , ti ));
      TimeBin_Total_Spikes_std( ti ) = std( TimeBin_Total_Spikes( : , ti ));
  end               
                  
  
  for ti=1:fire_bins
      for R = 1 : Nb      
          Amps = Amps_per_channel_per_bin( ti , : ,  R  ) ;
          Amps(Amps>=0) =[];
        	if isempty( Amps )
                  Amps=0;
             end
           TimeBin_Total_Amps( R , ti )= mean( Amps ) ; 
      end
      Amps = TimeBin_Total_Amps( : , ti ) ;
      Amps(Amps>=0) =[];
      if isempty( Amps )
          Amps=0;
      end
      TimeBin_Total_Amps_mean( ti ) = mean( Amps );
      TimeBin_Total_Amps_std( ti ) = std( Amps );
  end   
  
  
  if ~bursts_amps_included
      Amps_Signature( : , : ) = 0; 
      Amps_Signature_std( : , : ) = 0; 
      Amps_per_channel_per_bin( : , : , : ) = 0; 
  end
   
%                   Patterns_out.TimeBin_Total_Spikes = TimeBin_Total_Spikes ;
%                   Patterns_out.TimeBin_Total_Spikes_mean =TimeBin_Total_Spikes_mean ;
%                   Patterns_out.TimeBin_Total_Spikes_std =TimeBin_Total_Spikes_std ;
%                   Patterns_out.Data_Rate_Patterns1 =Data_Rate_Patterns1 ;
%                   Patterns_out.Data_Rate_Signature1 =Data_Rate_Signature1 ;
%                   Patterns_out.Data_Rate_Signature1_std   =Data_Rate_Signature1_std ;  
  
  
%    
%    Data_total_rates_signature1'
%    Data_Rate_Signature1'
