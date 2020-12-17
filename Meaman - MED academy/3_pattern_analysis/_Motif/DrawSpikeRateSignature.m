

function [ Data_Rate_Signature1 , DT_BIN_ms , DT_BINS_number ,  bb ] = DrawSpikeRateSignature( Bursts_num ,  Bursts , Burst_Len , DT_BIN )
 

% N=64; 
Nb = Bursts_num ;
 Start_t = 1 ;   
 Burst_Len ;
 DT_step=  DT_BIN; % 10 ;    
  DT = DT_step    ;
  DT_BIN_ms=DT;
  fire_bins = floor(  (Burst_Len ) / DT) ;
DT_BINS_number= fire_bins;
  
  a=size( Bursts);
  N=a(2);  
    [ Data_total_rates1,  Data_total_rates2 ,  Data_total_rates_signature1 , Data_total_rates_signature2  ...
   Data_Rate_Patterns1 ,  Data_Rate_Patterns2 ,Data_Rate_Signature1 , Data_Rate_Signature2 ,...
   Data_Rate_Signature1_std , Data_Rate_Signature2_std  ] ...
      = Get_Electrodes_Rates_at_TimeBins( N ,Nb , Nb ,  Bursts   ,Bursts  , Start_t , Burst_Len ,DT_step );
   
  
  %------Draw aet1   signatures-----------------
% figure 

% bar(  Data_Rate_Signature1( : , 1))
Data_Rate_Signature1 = Data_Rate_Signature1';
figure
x=1:fire_bins; y = 1:N;
bb= imagesc(  x *DT  , y ,  Data_Rate_Signature1 );
%  set( bb ,'alphadata', ~isnan(Data_Rate_Signature1))
%  alpha(0.5);
% title( 'Difference between 2 pattern:1-stat diff,2-rates overlap %,3-mean rate diff');
title( ['Spike Rate Burst profile, spikes/bin (' num2str(DT) ' ms)'] );
xlabel( 'Burst time offset, ms' )
ylabel( 'Electrode #' )
colorbar
% colormap hot

% figure
% b2= imagesc(  x *DT  , y ,  Data_Rate_Signature1 )
% title( 'Spike Rate Burst profile, spikes/bin (10ms)');
% xlabel( 'Burst time offset, ms' )
% ylabel( 'Electrode #' )
% colorbar 