
%% Bursts_Merge_and_Classify_patterns
% input ANALYZED_DATA
% output : clustered patterns
close all

Plot_Tact_diff_vs_elect_dist = false ;

superbursts_times_mark = false ;
Plot_raster_vs_cluster_num = true ;
Build_merged_raster = false ;
% T_activation_stat_threshold_param = Search_Params.T_activation_stat_threshold_param ; 
Plot_mean_pattern = true ;
    Show_Tact_image_diff_Tact = false ; % use   T_ac_stat_0 : T_ac_stat_step = 3 : T_ac_stat_end
    Show_stat_Tact = false ; % false - just burst_activation
        T_activation_stat_threshold_param = 2 ;
        T_ac_stat_end = 9 ; T_ac_stat_0 = 1 ; T_ac_stat_step = 2 ;
Average_R = 3 ; % 0 ... 8  ;




I_el_um_dist = 200 ; % um
Electrodes_max_dist = 7 ;
Max_Tact_diff = 30 ; % max delay , ms


% Plot_raster_vs_cluster_num = false ;

select_file = true ;
select_file = false ;
smooth_2d_image = true ;
% Build_merged_raster = true ;
GLOBAL_CONSTANTS_load

if select_file 
    [filename,PathName] = uigetfile('*.*','Select file');
   [pathstr,name,ext] = fileparts( filename ) ;  
    
end
 
% data = ANALYZED_DATA.TimeBin_Total_Spikes ;
% data = ANALYZED_DATA.Spike_Rates ;
% data = ANALYZED_DATA.SpikeRate_burst_profile_1ms_all ; 
% data = ANALYZED_DATA.burst_activation_amps ;
data = ANALYZED_DATA.burst_activation ; 
% data = ANALYZED_DATA.burst_activation_normalized ;  
% data = ANALYZED_DATA.burst_activation_2 ;
% data2 = data ;

%         data = ANALYZED_DATA.Amp_Patterns ;
%         data = ANALYZED_DATA.Amp_Patterns_1ms ;
%         data = ANALYZED_DATA.Spike_Rate_Patterns ; 
% data = ANALYZED_DATA.Spike_Rate_Patterns_1ms ;
% 
Check_and_Run_matlabpool
var = [] ;
s= size(ANALYZED_DATA.Spike_Rates_each_channel_mean );
chn = s(1) ;
N=chn ;

% data = data(:,1:20);
% N=20 ;

Nb = ANALYZED_DATA.Number_of_bursts ;
if Nb > 1000
% Nb = 220 ;
end
var.superbursts_times_mark = superbursts_times_mark ;
if var.superbursts_times_mark
    if isfield( ANALYZED_DATA , 'Superbrsts' )
        var.burst_in_superbursts = ANALYZED_DATA.Superbrsts.burst_in_superbursts; 
        var.burst_index_in_each_Superbursts = ANALYZED_DATA.Superbrsts.burst_index_in_each_Superbursts;  
        var.Number_of_Superbursts = ANALYZED_DATA.Superbrsts.Number_of_Superbursts ;
    else
      var.superbursts_times_mark = false ;  
    end
end


%% - Tact  vs Dist
if Plot_Tact_diff_vs_elect_dist
 load( 'MEAchannel2dMap.mat');  
 DATA_comp = [];
 Nbi = 5 ;
 DATA_comp_img = zeros( Max_Tact_diff , Electrodes_max_dist  );
 for Nbi = 1  : 20
for i = 1 : N
  for j = i : N
      if j>i
      xstart = MEA_channel_coords( i ).chan_X_coord  ;  
      ystart =  MEA_channel_coords( i ).chan_Y_coord ;    
                  
      xend = MEA_channel_coords( j ).chan_X_coord   ;    
      yend = MEA_channel_coords( j ).chan_Y_coord  ;  
                  
      [th, dist_interchan  ] = cart2pol( [  xend - xstart ],[  yend - ystart ]);
      dist_interchan = dist_interchan * I_el_um_dist ;  
      Tact_diff = abs(data( Nbi , i ) - data( Nbi , j ) );
      DATA_comp  = [ DATA_comp ; [  ( Tact_diff )  ( dist_interchan )] ];
          if Tact_diff > 0  &&  floor( Tact_diff )+1 <   Max_Tact_diff && floor( dist_interchan  / I_el_um_dist) <= Electrodes_max_dist
              DATA_comp_img(  floor( Tact_diff )+1 ,  floor( dist_interchan  / I_el_um_dist)) = ...
                  DATA_comp_img( floor( Tact_diff )+1 , floor( dist_interchan  /I_el_um_dist)) + 1 ;
          end
      end
                   
  end
end
 end
 
 x = DATA_comp( :,1) ;
           y = DATA_comp( :,2) ;
           [x , ix ] =sort(x) ;
           y = y( ix ); 
           
%            x = 1:100;
%            y= x + 3* randn(1,100); 
           P1 = polyfit(x,y, 1 )
           yhat = polyval(P1,x)  ;
           
           [R,P]=corrcoef( x , y ) ;
           R = R(2)
           p_val = P(2)
           
           [p,err] = polyfit(x,y,1);   % First order polynomial
           y_fit = polyval(p,x,err);   % Values on a line
            y_dif = y - y_fit;          % y value difference (residuals)
            SSdif = sum(y_dif.^2);      % Sum square of difference
            SStot = (length(y)-1)*std(y)*std(y);   % Sum square of y taken from variance
            rsq = 1-SSdif/SStot;        % Correlation 'r' value. If 1.0 the correlelation is perfec
            rsq
             
           figure
           hold on
            plot(x,y,'b*')
            plot( x,yhat,'r-', 'Linewidth' , 2)
            hold off
            xlabel X
            ylabel Y
            grid on 
            xlabel( 'Tact, ms' )
           ylabel( 'Dist ')

    figure
    x = 1: Electrodes_max_dist * I_el_um_dist ;
    y = 0 : Max_Tact_diff ;
    imagesc( x,y,DATA_comp_img ) ;
    xlabel('Inter-electrode distance, um')
    ylabel( 'Activation time difference, ms')
    colorbar
end

%% Clustering
Clustering_result = Clustering_from_data( data , Nb , var );
% Output:
%     Clustering_result.cluster_index_total = cluster_index;
%     Clustering_result.cluster_index_sorted = cluster_index_sorted; 
%     Clustering_result.centers = centers;
%     Clustering_result.clusters = clusters;
%     Clustering_result.DB_all = DB_all;
%     Clustering_result.Nclus_optim = Nclus_optim;
%     Clustering_result.Clustering_estimation = Clus_est ; 
%     Clustering_result.Clusters_tested = Nclus ;
if select_file
save( [ PathName name '_Clustering_result.mat' ] , 'Clustering_result' ,'ANALYZED_DATA' )
else
 save(   'Clustering_result.mat'  , 'Clustering_result' ,'ANALYZED_DATA' )   
end

%% Tact stat vs clustering
if  Clustering_result.Nclus_optim < 7  && Plot_mean_pattern

figure
if ~Show_Tact_image_diff_Tact 
    Nx = Clustering_result.Nclus_optim ; 
    Ny =1 ;
    T_ac_stat_0 = T_activation_stat_threshold_param ;
    T_ac_stat_step =2 ; T_ac_stat_end = 2;
else
f = T_ac_stat_0 : T_ac_stat_step : T_ac_stat_end ;
Nx = length( f ) ; 
Ny = Clustering_result.Nclus_optim ;
end

 Nclus_optim  = Clustering_result.Nclus_optim  ;
 fig_i = 0 ;
for i = 1 : Nclus_optim
 for T_activation_stat_threshold_param = T_ac_stat_0 : T_ac_stat_step : T_ac_stat_end   
     
    fig_i = fig_i + 1 ;
    subplot( Ny,Nx, fig_i  )
    patterns_list = 1 : Nb ;
    patterns_list( Clustering_result.cluster_index_sorted{ i }) = [];
    Patterns  = Patterns_erase_defined_set( ANALYZED_DATA , patterns_list   );
%     Patterns = ANALYZED_DATA ;
    Nb_index = Clustering_result.cluster_index_sorted{ i }  ;
    Nb1 = length( Nb_index );
    Nb1;
     %----------Patterns_get_Statistsic_all_parameters     
     % Patterns.TimeBin_Total_Spikes  ... -> TimeBin_Total_Spikes_mean
%     Patterns_get_Statistsic_all_parameters
  for ch = 1 : N  
        Patterns.burst_activation_mean( ch ) = mean(  Patterns.burst_activation(:, ch )  ) ;   
  end

  if Show_stat_Tact
[  TimeBin_Total_Spikes_1ms , TimeBin_Total_Spikes_std_1ms , Patterns.Spike_Rate_Patterns_1ms ,  ...
                   Spike_Rate_Signature_1ms ,  Spike_Rate_Signature_std_1ms ,  Spike_Rate_1ms_smooth_Max_corr_delay , ...
                   Spike_Rate_Signature_1ms_smooth , Amp_Patterns_1ms , Amps_Signature_1ms  , Amps_Signature_1ms_std , Amps_Signature_1ms_smooth , ...
                   Spike_Rate_1ms_Max_corr_delay , Spike_Rate_Signature_1ms_interp  , DT_bin_interp ] =  ...   
             SR_profile_1ms_calc( true  ,  N , Nb1 ,Patterns.bursts  ...
             , Patterns.bursts_amps , GLOBAL_const , mean( Patterns.BurstDurations ) ) ;
           
         
    DT_bin_1ms_Tact = DT_bin_interp ; 

    Calc_Spikerate_profile_1ms_bin = true ;
     [ Patterns.burst_activation_2_mean , Patterns.burst_activation_2 , Patterns.burst_activation_3_smooth_1ms_mean , ...
         Patterns.burst_max_rate_delay_ms , Patterns.burst_max_rate_delay_ms_mean    ] = ... 
            SR_profile_Tact2_3_from_1msProfile( N , Nb1 , Calc_Spikerate_profile_1ms_bin , ...
            false , ...
             GLOBAL_const.Spike_Rate_Signature_max_duration ,  DT_bin_1ms_Tact , Patterns.Spike_Rate_Patterns_1ms , ...
             GLOBAL_const ,  T_activation_stat_threshold_param ,...
             Global_flags , Spike_Rate_Signature_1ms_interp ,  Patterns.burst_activation_mean , Patterns.Spike_Rates_each_channel_mean ) ;
         
     Tact_2d_diff = MNDB_Make2d_data_from_vector( Patterns.burst_activation_3_smooth_1ms_mean  );
     var.background_1d_vector_data = Patterns.burst_activation_3_smooth_1ms_mean ;     
  else
      
   Tact_2d_diff = MNDB_Make2d_data_from_vector( Patterns.burst_activation_mean  );
    var.background_1d_vector_data = Patterns.burst_activation_mean ; %burst_activation_3_smooth_1ms_mean ;
  end
%   
   var.new_figure = false ;
   var.calc_bidirection = false ;
   var.background_1d_vector = true ;
    
   
   var.smooth_2d_image = smooth_2d_image ;
   var.Average_R =  Average_R ;
   var.plotting = true ;
   Connectiv_Post_proc( Tact_2d_diff  , var  );
   
   Pattern_prcnt_of_total = 100 * (Nb1 / Nb ) ;
   title( ['Motif # ' num2str( i   )  ' (' num2str( Pattern_prcnt_of_total ) ' %)'] )
   drawnow
 end
end
end

%% plot cluster
times=[];
last_time = 0 ;
Burst_starts_new = [  ] ;
if Build_merged_raster
Burst_starts_new = [ 1 ] ;
end


if Plot_raster_vs_cluster_num 
    
    
    for Ni = 1 : Nb
        if Ni > 1 
            if Build_merged_raster
                last_time =  last_time +  ANALYZED_DATA.BurstDurations( Ni-1 ) + 30  ;
            else
               last_time =  ANALYZED_DATA.burst_start( Ni-1 )  ; 
            end
            Burst_starts_new = [ Burst_starts_new last_time ] ;
        end
    end
    
    index_r  =[];
    last_time = 0 ;
% %---- Merged bursts rastet ---------------------
parfor Ni = 1 : Nb
    Ni;
    if Ni > 1 
%         last_time =  last_time +  ANALYZED_DATA.BurstDurations( Ni-1 ) + 100  ;
        last_time =  sum( ANALYZED_DATA.BurstDurations( 1: Ni-1 ) ) + ( Ni-1 ) * 30  ;
%         Burst_starts_new = [ Burst_starts_new last_time ] ;
    end
    for ch = 1 : chn 
        a = ANALYZED_DATA.bursts_absolute{ Ni }{ ch };
        s = numel( a );
        if Build_merged_raster
            if Ni > 1 
               times = a  - ANALYZED_DATA.burst_start( Ni )   +   last_time ;  
            else
               times = a  -  ANALYZED_DATA.burst_start( Ni ) ;  
            end
        else
            times = a  ;
        end
  
        ch_col = ones( s , 1 );
        
        
        index_r1 = [ times ch_col * ch ];
        index_r  = [ index_r  ; index_r1 ];
    end
    Merged_raster_processed = true ;
    
end
% 
whos index_r 
% %-------------------------------------------------
 
end









%  data  = Patterns_convert_to_vector( data , Nb ) ;
% D = pdist( data    );
% 
% Z = squareform( D ) ;
% 
% figure
% imagesc( Z )
% colorbar
% title( 'Pattern similarity')
% xlabel( 'Pattern #')
% ylabel( 'Pattern #')









% save( 'workspace_02.mat' )
    ff2 = figure ;        
cmap = colormap( ff2 , hsv); 
 nclr = size(cmap,1);
if Plot_raster_vs_cluster_num
 Old_school_raster_presentation = false ; 
       
       colormap( ff2 , jet);
       Raster_show_color_amplitudes = false ;
            Plot_Raster_from_index_r 
            hold on
%             plot( Burst_starts_new/1000 , 10 * ones(1,length( Burst_starts_new ) ), '*r' )
%             plot( Burst_starts_new/1000 , (60 / Nclus_optim ) * cluster_index , '*r'  , 'LineWidth',3 )
            for  i = 1 : length( Burst_starts_new )
                ci  = nclr + 1 -  floor( ( (Clustering_result.cluster_index_total(i)  ) / (Clustering_result.Nclus_optim ) ) *  nclr )    ;
                plot( Burst_starts_new(i)/1000 , (10 / Clustering_result.Nclus_optim ) * Clustering_result.cluster_index_total(i) + 64,...
                    '-*'  , 'LineWidth',3 , 'MarkerSize',2,...  
                       'MarkerFaceColor', cmap(ci     ,:) , 'Color'  ,  cmap(ci     ,:) ) 
                 
                    
%                 plot( Burst_starts_new(i)/1000 , (10 / Clustering_result.Nclus_optim ) * Clustering_result.cluster_index_total(i) + 64,...
%                     '-*r'  , 'LineWidth',3 , ...
%                         'Color' , cmap(ci     ,:) )     
               
    
            end
            
            hold off 
            
%       figure
%              
%             hold on
% %             plot( Burst_starts_new/1000 , 10 * ones(1,length( Burst_starts_new ) ), '*r' )
% %             plot( Burst_starts_new/1000 , (60 / Nclus_optim ) * cluster_index , '*r'  , 'LineWidth',3 )
%             for  i = 1 : length( Burst_starts_new )
%                 ci  = floor( ( (Clustering_result.cluster_index_total(i)  ) / (Clustering_result.Nclus_optim ) ) *  nclr )    ;
%                 plot( ANALYZED_DATA.burst_start(i)/1000 , (1 ) * Clustering_result.cluster_index_total(i) , '*r'  , 'LineWidth',3 , ...
%                         'Color' , cmap(ci     ,:) ) 
%             end
%             
%             hold off          

% dlmwrite( 'Raster_Merged.txt'  , index_r  ,'delimiter','\t','precision',8,'newline','pc');
end

