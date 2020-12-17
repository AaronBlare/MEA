% Plot_bursts_stats_many_graphs

f = figure ;
if ~isempty( Anallysis_Figure_title )
    set(f, 'name', Anallysis_Figure_title ,'numbertitle','off' )
end

if ~isnan( Mean_Burst_Duration )
% % xh = 0:1:1.1*max( max_ISI );
% [n,xout] = hist( max_ISI , 90 ) ;
% ibi_1 = bar(xout*DimenM,n/length(max_ISI) );
% xlabel(['Inter Burst Interval, ' tdim ])
% ylabel('Bursts %')
% h = findobj(ibi_1,'Type','patch');
% set(h,'FaceColor',[.04 .52 .78])
Ny = 3;
Nx= 4 ;

 if isfield( Search_Params , 'Show_additional_profiles')
     Search_Params.Show_additional_profiles = Search_Params.Show_additional_profiles ;
 else
      if exist( 'Global_flags_init' , 'var')
           Search_Params.Show_additional_profiles = Global_flags_init.Search_Params.Show_additional_profiles;
       end
%      Search_Params.Show_additional_profiles = Global_flags.Search_Params.Show_additional_profiles;
 end;
 
if Search_Params.Show_additional_profiles 
    Nx = 4  ;
else
    Nx = 2 ;
end

subplot( Ny , Nx ,1:2)
%   if  max(max_ISI)  > Number_of_BIN_in_Hist * 2 
      HStep =   max(max_ISI) / Number_of_BIN_in_Hist ;
%   else
%       HStep = 1 ;
%   end
    if ~isempty( max_ISI ) 
        xxx =  0 : HStep: max(max_ISI) ;
    
    % [h,p] = hist(RS_values_total ,xxx) ;
    %  bar(p,h) 
    [h,p] = histc(max_ISI ,xxx) ;
    xout_bar = xxx *DimenM ;
     
%      bar(xxx, h)
     ibi_1 = bar(xxx*DimenM,100*(h/length(max_ISI)) );
    xlabel(['Inter Burst Interval, ' tdim ])
    ylabel('Bursts, %')
     xlim( [   min(xout_bar)- 0.05*( max( xout_bar)-min(xout_bar) ) max(xout_bar)+0.2*( max( xout_bar)-min(xout_bar) )   ] )
    h = findobj(ibi_1,'Type','patch');
    set(h,'FaceColor',[.04 .52 .78])
   end
% figure
% % xh = 0:1:1.1*max( BurstDurations );
% % xh = xh *dT / 1000  ;
% [n,xout] = hist( BurstDurations ) ;
% bdur =bar(xout*DimenM,n/length(BurstDurations) );
% % axis( [ 0 1.1*max( BurstDurations )*(dT / 1000) 0 1.1*max(n) ] )
% xlabel([ 'Burst duration, ' tdim ])
% ylabel('Bursts %')
% h = findobj(bdur,'Type','patch');
% set(h,'FaceColor',[.04 .52 .78])

subplot(Ny , Nx , Nx + 1: Nx + 2)  
%   if  max(BurstDurations)  > Number_of_BIN_in_Hist * 2 
if ~isempty( BurstDurations ) 
      HStep =   max(BurstDurations) / Number_of_BIN_in_Hist ;
%   else
%       HStep = 1 ;
%   end
  xxx =  0 : HStep: max(BurstDurations) ;
  xout = xxx ;
  [h,p] = histc(BurstDurations ,xxx) ; 
  n = h ; 
  xout_bar = xout ; 
  bar_y =100* (n/length(BurstDurations)) ;
    bdur =bar( xout_bar , bar_y); 
%           axis( [   min(xout_bar)-1 max(xout_bar)+0.2*( max( xout_bar)-min(xout_bar) )  0 1.2 * max( bar_y  ) ] )
          xlim( [   min(xout_bar)- 0.05*( max( xout_bar)-min(xout_bar) ) max(xout_bar)+0.2*( max( xout_bar)-min(xout_bar) )   ] )
%     xlabel([ 'Burst duration, ' tdim ])
    xlabel(  'Burst duration, ms'  )
    ylabel('Bursts, %')
    h = findobj(bdur,'Type','patch');
    set(h,'FaceColor',[.04 .52 .78])
end
% figure
% % xh = 0:1:1.1*max( Spike_Rates_each_burst );
% [n,xout] = hist( Spike_Rates_in_Burst ) ;
% nospb = bar(xout ,n/length(Spike_Rates_in_Burst)  );
% xlabel('Burst spike rate, spikes/s.')
% ylabel('Bursts')
% h = findobj(nospb,'Type','patch');
% set(h,'FaceColor',[.04 .52 .78])
 
subplot( Ny , Nx ,2*Nx + 1: 2*Nx +  2)  
if ~isempty( BurstDurations ) 
%   if  max(Spike_Rates_each_burst)  > Number_of_BIN_in_Hist * 2 
      HStep =   max(Spike_Rates_each_burst) / Number_of_BIN_in_Hist ;
%   else
%       HStep = 1 ;
%   end
  xxx =  0 : HStep: max(Spike_Rates_each_burst) ;
  xout = xxx ;
  [h,p] = histc(Spike_Rates_each_burst ,xxx) ; 
  xout_bar = xout ; 
  n = h ;
    nospb = bar(xout  ,100* (n/length(Spike_Rates_each_burst)) ); 
    xlabel('Burst spike rate, spikes/burst.')
    ylabel('Bursts, %')
%     xlim( [   min( xout )-1 max( xout )+0.2*( max( xout)-min(xout) )   ] )
    xlim( [   min(xout_bar)- 0.05*( max( xout_bar)-min(xout_bar) ) max(xout_bar)+0.2*( max( xout_bar)-min(xout_bar) )   ] )
    h = findobj(nospb,'Type','patch');
    set(h,'FaceColor',[.04 .52 .78])
end   
    
if Search_Params.Show_additional_profiles
bb1 =  subplot( Ny , Nx ,[ 3 Nx+3 2*Nx+3 ] )    ;  
    
%     Spike_Rate_Signature = Spike_Rate_Signature';
if exist( 'Spike_Rate_Signature_1ms_smooth' , 'var')
    Spike_Rate_Signature = Spike_Rate_Signature_1ms_smooth' ;
    DT_step_plot = 1 ;
else
    Spike_Rate_Signature = Spike_Rate_Signature' ;
    DT_step_plot = DT_BIN_ms ;
end
%     Spike_Rate_Signature = Spike_Rate_Signature_1ms';
    
    s=size( Spike_Rate_Signature ) ;
    if s(2) == N
        Spike_Rate_Signature = Spike_Rate_Signature' ;
        s=size( Spike_Rate_Signature ) ;
    end
    x=1: s( 2) ; y = 1:N;
    imagesc(  x *DT_step_plot  , y ,  Spike_Rate_Signature  ); 
    title( ['Burst profile, spikes/bin (' num2str(DT_step_plot) ' ms)'] );
    xlabel( 'Time offset, ms' )
    ylabel( 'Electrode #' )
    colorbar
    
bb2 = subplot( Ny , Nx ,[ 4 Nx+4 2*Nx+4 ] )   ;   
    
%     Amps_Signature = Amps_Signature';

if exist( 'Spike_Rate_Signature_1ms_smooth' , 'var')
    Amps_Signature =  Amps_Signature_1ms_smooth' ;
else
    Amps_Signature = Amps_Signature' ;
end
%     Amps_Signature = Amps_Signature_1ms';
     s=size( Amps_Signature ) ;
     if s(2) == N
        Amps_Signature = Amps_Signature' ;
        s=size( Amps_Signature ) ;
    end
    x=1: s( 2) ; y = 1:N;
     imagesc(  x *DT_step_plot  , y ,  Amps_Signature  ); 
    title( ['mV/bin (' num2str(DT_step_plot) ' ms)'] );
    xlabel( 'Time offset, ms' )
    ylabel( 'Electrode #' )
    colorbar
    
    linkaxes( [ bb1 bb2 ] , 'xy' )
end
end 
    
    
    
    
    
    
    
    