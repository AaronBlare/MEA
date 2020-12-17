function   [ total_number_of_active_electrodes , Stat_selective_electrodes_num ,...
    Stat_Selective_electrodes_precent , Selective_electrodes_lin_div_num ,Selective_electrodes_lin_div_precent , Overlaps_lin_div ...
    Channels_overlap , Channels_is_selective , Channel_is_active ] ...
      = Selective_Electrodes_Rate(N ,Nb ,Nb2, bursts1 , bursts2  , Start_t , Pattern_length_ms ,OVERLAP_TRESHOLD )
  % Low active channels should be erased before this . CHECKIN ONLY RATES >
  % 0 
% STIM_RESPONSE_BOTH_INPUTS = 0 ;  
OVERLAP_NOT_RESPOND_TO_BOTH = 100 ;


Selective_electrodes_lin_div_num=0 ;
Selective_electrodes_lin_div_precent=0;
PVAL_Threshold = 0.05 ;
OVERLAP_TRES = OVERLAP_TRESHOLD ;
Stat_selective_electrodes_num = 0 ; 
total_number_of_active_electrodes = 0 ; 
Overlaps_lin_div=[];
Data_Rate_Patterns1 = zeros(  N ,  Nb);
Data_Rate_Patterns2 = zeros(  N ,  Nb2);
Channels1 = zeros(  N ,1 );
Channels_std1 = zeros(  N ,1 );
Channels2 = zeros(  N ,1 );
Channels_std2 = zeros(  N ,1 );
Channels_overlap = zeros(  N ,1 );
Channels_is_selective= zeros(  N ,1 );
Channel_is_active = zeros(  N ,1 );
% N = 40 ;
ttt = 0; 
   for ch = 1 : N  
       
       chan_rates1 = [] ;
chan_rates2 = [] ; 
       
      ch_r=0;
      ch_r2 = 0;
      for t = 1 : Nb       
          si = find( bursts1( t , ch ,: )>= Start_t & bursts1( t , ch ,: )< Pattern_length_ms +Start_t ) ;
          rate =length( si ) ;if ~isfinite(  rate  )  rate= 0 ;end
           ch_r = ch_r +  rate; 
           Data_Rate_Patterns1( ch , t ) = rate ;
          chan_rates1 = [ chan_rates1 rate ] ; 
      end
      for t = 1 : Nb2      
          si = find( bursts2( t , ch ,: )>= Start_t & bursts2( t , ch ,: )< Pattern_length_ms +Start_t ) ;
          rate =length( si ) ;if ~isfinite(  rate  )  rate= 0 ;end
           ch_r2 = ch_r2 +  rate ;
           Data_Rate_Patterns2( ch , t ) = rate ;
           chan_rates2 = [ chan_rates2 rate ] ;
      end   
      
      if ch_r > 0 && ch_r2 > 0
%         if ch_r/Nb > MIN_RATE_PER_RESPONSE && ch_r2/Nb2 > MIN_RATE_PER_RESPONSE
      
    [ StatisitcallyDifferent_if1 , LinearyDifferent_if1 , overlap_values_Optim_Thres_precent ,Zero_values_total_precent...
    ,Zero_values_in_Data1_precent,Zero_values_in_Data2_precent , overlap_val_STABLE_Optim_Thres_precent , is_Stable_response ]= ...
          SelectiveValues( chan_rates1,chan_rates2, PVAL_Threshold , OVERLAP_TRES , false ) ;
      
      Overlaps_lin_div = [Overlaps_lin_div overlap_values_Optim_Thres_precent ];     
      Selective_electrodes_lin_div_num = Selective_electrodes_lin_div_num + LinearyDifferent_if1 ;      
      total_number_of_active_electrodes = total_number_of_active_electrodes + 1 ;
      Stat_selective_electrodes_num = Stat_selective_electrodes_num + StatisitcallyDifferent_if1 ;
   
      Channel_is_active(ch) = 1 ;
Channels1(ch) = mean( chan_rates1 ) ;
Channels2(ch) = mean( chan_rates2) ;
Channels_std1(ch) = std( chan_rates1 ) ;
Channels_std2(ch) = std( chan_rates2) ; 
Channels_overlap(ch) = overlap_values_Optim_Thres_precent ;
Channels_is_selective(ch) = StatisitcallyDifferent_if1 ;
      
      
%      if overlap_values_Optim_Thres_precent <= OVERLAP_TRESHOLD &  ttt <7
%          ttt=ttt+1; 
     if StatisitcallyDifferent_if1 &  ttt <7
         ttt=ttt+1;          
%          && Zero_values_total_precent < 20
 
         xxx = max(max(chan_rates1),max(chan_rates2));
         xxx = 0: xxx/10 :xxx;
         chan_rates1' 
         chan_rates2'
%          xxx
           [n,x] = hist(chan_rates1 , xxx);
           n=100* n/ length( chan_rates1 );
            [n2,x2] = hist(chan_rates2 , xxx);
            n2=100* n2/ length( chan_rates2 );
            figure  
            subplot( 2,1,1);
            bar( [ x' x2' ],[ n' n2' ] )       
            title( ['Selective electrodes totalRate, overlap=' ...
                num2str( overlap_val_STABLE_Optim_Thres_precent ) ])
            subplot( 2,1,2);
             hold on
             
%             bar( chan_rates1 , 'BarWidth',0.6)
%             bar( chan_rates2, 'r','BarWidth',0.3)
             plot( chan_rates1 , '--' , 'MarkerSize'      , 6 ,'Marker'          , '.'  )
            plot( chan_rates2, 'r','MarkerSize'      , 6 ,'Marker'          , '.'  )
            title( ['Channel ' int2str(ch)] )
            xlabel( 'Stimulus #');
            ylabel( 'Spike rate, spikes/response');
            hold off
%             pause
     end
          
      else
        Overlaps_lin_div = [Overlaps_lin_div OVERLAP_NOT_RESPOND_TO_BOTH  ]; 
      Channels_overlap(ch) = OVERLAP_NOT_RESPOND_TO_BOTH ;
        Channels_is_selective(ch) = 0 ;
          Channel_is_active(ch) = 0 ;
      end
      
   end
%    Selective_electrodes_lin_div_num
  Selective_electrodes_lin_div_precent = 100 *( Selective_electrodes_lin_div_num / total_number_of_active_electrodes );
  Stat_Selective_electrodes_precent = 100 *( Stat_selective_electrodes_num / total_number_of_active_electrodes );
 
%   Data_Rate_Patterns1(  63 ,  : )  
%    Data_Rate_Patterns2(  63 ,  : )  
% a = mean( [ Data_Rate_Patterns1(  63 ,  : ) Data_Rate_Patterns2(  63 ,  : )  ] );

 
 xxx =  0 : 5 : 50 ;
 [n,x] = hist(Overlaps_lin_div ,xxx); 
 n=100* n/ length( Overlaps_lin_div );


figure
    subplot(2,1,1);
 bar( [ Channels1 Channels2  ] ) 
title( 'Mean Firing rate in 2 pattern sets' )
% end      
% figure  
subplot(2,1,2);
hold on
   errorbar( Channels1  , Channels_std1 , 'x' )  
      errorbar( Channels2  , Channels_std2  , 'xr')
      title( 'Mean Firing rate in 2 pattern sets' )
hold off

    figure
    subplot(3,1,1);
    bar( Channels_is_selective  )
     title( 'Selective electrodes if 1'  )
     
%          figure
         subplot(3,1,2);
    bar( Channels_overlap  )
     title( 'Overlap, similar rates %' )

         subplot(3,1,3);
        bar(   x   ,  n     )
     title( 'Total Rate Overlaps Distribution, %' )


             Plot8x8Data( Overlaps_lin_div )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Overlaps in Electrode Rates' )
     
     
             Plot8x8Data( Channels_is_selective )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Stat selective in Electrode Rates' )
     colormap gray
 
     
     Overlaps_lin_div( Overlaps_lin_div >50 ) = [];
     
     
     
     
          
          