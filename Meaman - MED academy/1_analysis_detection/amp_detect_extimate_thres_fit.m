% amp_detect_extimate_thres_fit
% input 
%     handles.par.threshold_fromFit_signal_hist_x = -0.03:0.0002:0.03 ; 
%     handles.par.threshold_fromFit_fitting_bounds_sample = 0.004 ;% if 0.004 then gauss will be estimated from -0.004 to 0.004
%     handles.par.threshold_fromFit_fitting_bounds_Gaussfit = 0.05 ;% if 0.05 then Gauss model fit will be built -0.05 to 0.05
%     handles.par.threshold_fromFit_percentile_GaussFit = 0.001 ; % if 0.001 then 0.1 % of fitted gauss hist will be used as thresh (similar to Gauss width)
%     handles.par.threshold_fromFit_show_hists = true ; % shows estimations
% xf_detect
% output : thr_val
signal_hist_x = handles.par.threshold_fromFit_signal_hist_x ; 
fit_bound_sample = handles.par.threshold_fromFit_fitting_bounds_sample ;% if 0.004 then gauss will be estimated from -0.004 to 0.004
fit_bound = handles.par.threshold_fromFit_fitting_bounds_Gaussfit ;% if 0.05 then Gauss model fit will be built -0.05 to 0.05
perc_find = handles.par.threshold_fromFit_percentile_GaussFit ; % if 0.001 then 0.1 % of fitted gauss hist will be used as thresh (similar to Gauss width)


histo = histc( x , signal_hist_x );
histo = 100* (histo/ sum(histo));

 i  = find( signal_hist_x > -fit_bound_sample & signal_hist_x < fit_bound_sample );
signal_hist_x2 = signal_hist_x( i );
histo2 = histo( i ) ;


 x_fit = signal_hist_x2 ; 
 y = histo2 ;
%   figure ;  hold on ;
% plot( signal_hist_x , histo ) 
% plot( signal_hist_x2 , histo2 ,'-r'  ) 


f = fit(x_fit.',y.','gauss1');

xx = -fit_bound : signal_hist_x(2)-signal_hist_x(1)  :fit_bound ;
hist_fit = f( xx);
hist_fit = 100* (hist_fit/ sum(hist_fit));
hist_sum = sum( hist_fit ); 
%  figure ;  plot( xx , hist_fit ) 

% perc_find = 0.001 ;
low_thr = 0 ;
sum_p = 0 ;
gs = [];
low_thr_xi = 1 ;
for xi = 1:length(xx)
    sum_p = sum_p + hist_fit( xi );
    gs=[gs sum_p];
    s = 100*(sum_p / hist_sum );
    if s >= perc_find && low_thr == 0 
       low_thr_xi = xi ;
       thr_val = xx( low_thr_xi )  ;
       low_thr = hist_fit( xi ) ;
        
    end
end



% figure
% hold on 
% plot( xf_detect , '-b'  )
% plot( [1  length(xf_detect)], [   low_thr low_thr ] , '-r' )
% hold off



% figure
% hold on 
% plot( xx, gs)
% plot( xx,hist_fit , '-r' )
% hold off

if handles.par.threshold_fromFit_show_hists
 
figure
hold on
% plot(f,x,y)
plot( signal_hist_x,histo)
plot( xx,hist_fit , '-r' )
plot( thr_val  , low_thr, '*g')
 legend( 'Signal histogram' , 'Gauss fit histogram' , 'Threshold' )
 xlabel( 'uV' ) ; ylabel( 'Count, %');
hold off

end