function  [ total_number_of_active_electrodes , Stat_selective_electrodes_num ,...
    Stat_Selective_electrodes_precent ,Selective_electrodes_lin_div_num , Selective_electrodes_lin_div_precent , Overlaps_lin_div ] = ...
    Selective_Electrodes_Tactivation(N ,Nb ,Nb2, times1 , times2 , STIM_RESPONSE_BOTH_INPUTS , OVERLAP_TRESHOLD )
 
% STIM_RESPONSE_BOTH_INPUTS = 0 ; 
OVERLAP_NOT_RESPOND_TO_BOTH = 100 ;

Stat_selective_electrodes_num = 0 ;
total_number_of_active_electrodes = 0 ; 
Selective_electrodes_lin_div_num=0 ;
PVAL_Threshold = 0.001 ;
OVERLAP_TRES = OVERLAP_TRESHOLD ;
Overlaps_lin_div=[];
ALL_CHANNELS_Overlaps_lin_div=[];
ALL_CHANNELS_Stat_selective=[];
Channels1 = zeros(  N ,1 );
Channels_std1 = zeros(  N ,1 );
Channels2 = zeros(  N ,1 );
Channels_std2 = zeros(  N ,1 );
Channels_overlap = zeros(  N ,1 );
Channels_is_selective= zeros(  N ,1 );
 ttt=0;
for ch = 1 : N 
      chan_times1 =  [] ;   
      chan_times2 =  [] ; 
      hh=0;
      hh2 = 0;
      for t = 1 : Nb           
          hh = hh + H(  times1( t , ch ) ) ;
          if H(  times1( t , ch ) ) > 0 
             chan_times1 = [ chan_times1   times1( t , ch ) ] ;
          end
      end
      for t = 1 : Nb2      
          hh2 = hh2 + H(  times2(  t , ch ) ) ;
          if H(  times2( t , ch ) ) > 0 
             chan_times2 = [ chan_times2   times2( t , ch ) ] ;
          end
      end
      
%       if ch == 49 || ch==57
%           length( chan_times1 )
%           length( chan_times2 )
%       end
      
      if hh > 0 && hh2 > 0
         [ StatisitcallyDifferent_if1 , LinearyDifferent_if1 , overlap_values_Optim_Thres_precent ,Zero_values_total_precent]= ...
          SelectiveValues( chan_times1,chan_times2, PVAL_Threshold , OVERLAP_TRES , false) ;
           
      Overlaps_lin_div = [Overlaps_lin_div overlap_values_Optim_Thres_precent ];     
      ALL_CHANNELS_Overlaps_lin_div = [ALL_CHANNELS_Overlaps_lin_div overlap_values_Optim_Thres_precent ];     
 
     if hh / ( Nb ) >= STIM_RESPONSE_BOTH_INPUTS && hh2 / ( Nb2) >= STIM_RESPONSE_BOTH_INPUTS
         total_number_of_active_electrodes = total_number_of_active_electrodes + 1 ;
         Stat_selective_electrodes_num = Stat_selective_electrodes_num + StatisitcallyDifferent_if1 ; 
         Selective_electrodes_lin_div_num = Selective_electrodes_lin_div_num + LinearyDifferent_if1;
         Channels_is_selective(ch) = StatisitcallyDifferent_if1 ;
         Channels_overlap(ch) = overlap_values_Optim_Thres_precent ;
         
%         if number_of_selective_electrodes < 5
%             [n,x] = hist(chan_times1);
%             [n2,x2] = hist(chan_times2);
%             figure  
%             bar( [ x' x2' ],[ n' n2' ])       
%             title( 'Activation times (hist) on 1 electrode for selective electrodes Tact')
%         end 
     else 
         Channels_is_selective(ch) = 0 ;
         Channels_overlap(ch) = OVERLAP_NOT_RESPOND_TO_BOTH ;
     end
      
Channels1(ch) = mean( chan_times1 ) ;
Channels2(ch) = mean( chan_times2) ;
Channels_std1(ch) = std( chan_times1 ) ;
Channels_std2(ch) = std( chan_times2) ; 





     if overlap_values_Optim_Thres_precent < OVERLAP_TRESHOLD  & ttt <5
         ttt=ttt+1; 
%          && Zero_values_total_precent < 20
         xxx = max(max(chan_times1),max(chan_times2));
%          xxx = 1:floor(xxx/10):xxx;
    chan_times1'
         chan_times2'
         xxx =  1:floor(xxx/10):xxx; 
         
           [n,x] = hist(chan_times1 , xxx);
           n=100* n/ length( chan_times1 );
            [n2,x2] = hist(chan_times2 , xxx);
            n2=100* n2/ length( chan_times2 );
            
            figure  
            subplot( 2,1,1);
            bar( [ x' x2' ],[ n' n2' ],1 )       
            title( ['Selective electrodes Tact,overlap='...
              int2str(  floor(overlap_values_Optim_Thres_precent)) ])
            subplot( 2,1,2);
             hold on
%             bar( chan_times1 , 'BarWidth',0.6)
%             bar( chan_times2, 'r','BarWidth',0.3)
            plot( chan_times1 ,  '--'  , 'MarkerSize'      , 6 ,'Marker'          , '.')
            plot( chan_times2, 'r','MarkerSize'      , 6 ,'Marker'          , '.'  )
            xlabel( 'Stimulus #');
            ylabel( 'Activation timing, ms');
            title( ['Channel ' int2str(ch)] )
            hold off
%             pause
     end

 

        
 
      
      else
          ALL_CHANNELS_Overlaps_lin_div = [ALL_CHANNELS_Overlaps_lin_div OVERLAP_NOT_RESPOND_TO_BOTH  ];   
                Channels_overlap(ch) = OVERLAP_NOT_RESPOND_TO_BOTH ;
        Channels_is_selective(ch) = 0 ;
      end
      
      
end

    Selective_electrodes_lin_div_precent = 100 *( Selective_electrodes_lin_div_num / total_number_of_active_electrodes );
  Stat_Selective_electrodes_precent = 100 *( Stat_selective_electrodes_num / total_number_of_active_electrodes );
  
   xxx =  0 : 5 : 50 ;
 [n,x] = hist(Overlaps_lin_div ,xxx); 
  n=100* n/ length( Overlaps_lin_div );
  
      figure
    subplot(2,1,1);
 bar( [ Channels1 Channels2  ] ) 
title( 'Mean T activation in 2 pattern sets' )
% end      
% figure  
subplot(2,1,2);
hold on
   errorbar( Channels1  , Channels_std1 , 'x' )  
      errorbar( Channels2  , Channels_std2  , 'xr')
      title( 'Mean T activation in 2 pattern sets' )
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
     title( 'Tact Overlaps Distribution, %' )
  
        Plot8x8Data( ALL_CHANNELS_Overlaps_lin_div )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Overlaps in first spiking times' )
          
                     
        Plot8x8Data( Channels_is_selective )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Stat selective in first spiking times' )
          colormap gray
          
          
          Overlaps_lin_div( Overlaps_lin_div >50 ) = [];
          
  
 