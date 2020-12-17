
%  Find_bursts_from_raster
% - input:
% index_r
% Search_Params.show_figures 
% Search_Params.Simple_analysis
% Search_Params.Filter_Superbursts
% Search_Params.Filter_small_bursts
% Search_Params.Simple_analysis  
% - Output:
% ANALYZED_DATA struct

% GLOBAL_CONSTANTS_load

Search_Params.show_figures = true  ;
TimeBin = Search_Params.TimeBin ; 
Search_Params.show_buffer_figures = true ;

 
%---- Calculate average bursts profile with 1 ms bib -------------------- 
      params2.show_figures = false ;
      params2.new_figure = false ; 
      params2.x_label = '' ;

if  Search_Params.use6well_raster
  Search_Params.show_buffer_figures = false ;  
end

if ~exist( 'Burst_flags' , 'var')
    Burst_flags = [];
else
    Burst_flags ;
end


SHOW_FIGURES = Search_Params.Show_figures ;

Test_figure_draw_Tact_3type_of_with_Tact_on_1msSignature = false ;

if ~isfield( Search_Params , 'Simple_analysis')
    Simple_analysis = true ; 
else
    Simple_analysis = Search_Params.Simple_analysis ; 
end

if ~isfield( Search_Params , 'Analyze_Connectiv')
    Analyze_Connectiv = false ; 
else
    Analyze_Connectiv = Search_Params.Analyze_Connectiv ; 
end

 if isfield( Search_Params , 'Spike_Rate_Signature_max_duration')
     Search_Params.Spike_Rate_Signature_max_duration = Search_Params.Spike_Rate_Signature_max_duration ;
 else
     Search_Params.Spike_Rate_Signature_max_duration = Global_flags.Search_Params.Spike_Rate_Signature_max_duration;
 end
 dur_max = Search_Params.Spike_Rate_Signature_max_duration ; %median(ANALYZED_DATA.BurstDurations) ;
   if isfield( Search_Params , 'Chamber_analysis_AB' ) && ...
    isfield( Search_Params , 'Chamber_A_electrodes' ) 
     if Search_Params.Chamber_analysis_AB || Search_Params.Chamber_analysis_BA
          if isfield( Search_Params , 'Chambers_Burst_duration_AB')
             Search_Params.Chambers_Burst_duration_AB = Search_Params.Chambers_Burst_duration_AB ;
         else
             Search_Params.Chambers_Burst_duration_AB = Global_flags.Search_Params.Chambers_Burst_duration_AB;
         end;
 
        dur_max = Search_Params.Chambers_Burst_duration_AB    ;
     end
    end

% Start analysis of the raster index_r
%--------------------------------------------------------------
N = 60 ;


N = max(index_r( : , 2 ));
if N <= 60
    N = 60 ;
else
    N = 64 ;
end

   
%-------- erase silence at hte begining
%     first_spike =   min(index_r( : , 1 ));          
%     index_r( : , 1 ) =  index_r( : , 1 ) -   first_spike + 1 ;
%---------------------------------   
   

 %-------- fix delay on med64 32 channels -----
 if N == 64 && GLOBAL_const.med64_fix_32channels_delay > 0
    for ch = 1 : 32    
        index_ch = find( index_r( : , 2 ) == ch );
        if ~isempty( index_ch )
            index_r( index_ch ,1 ) =  index_r( index_ch ,1 ) - GLOBAL_const.med64_fix_32channels_delay ;  
        end
     end
 end
%---------------------------------   

%--- Get raster from one set of electrodes
if isfield( Search_Params , 'Chamber_analysis_AB' ) && ...
    isfield( Search_Params , 'Chamber_A_electrodes' ) 
    if Search_Params.Chamber_analysis_AB 
        index_r_A = index_r ;   
        
%         if  ~Search_Params.Chamber_analysis_BA
%              Channel_to_delete =  Global_flags.Search_Params.Chamber_B_electrodes  ;
%                 Channel_to_leave = Global_flags.Search_Params.Chamber_A_electrodes  ;
% 
%             Channel_to_delete = 1: N ;
%             Channel_to_delete( Channel_to_leave ) = [] ;
%             for i = 1 : length(Channel_to_delete)
%                 Channel = Channel_to_delete( i );
%                    ss = find( index_r_A( : , 2 ) == Channel ) ;
%                    if  ~isempty( ss )
%                         index_r_A( ss , : ) = [] ;
%                    end 
%             end 
%         end 
%         
%         if  Search_Params.Chamber_analysis_BA
%             Channel_to_delete =  Global_flags.Search_Params.Chamber_A_electrodes  ;
%             Channel_to_leave = Global_flags.Search_Params.Chamber_B_electrodes  ;
% 
%             Channel_to_delete = 1: N ;
%             Channel_to_delete( Channel_to_leave ) = [] ;
%             for i = 1 : length( Channel_to_delete  )
%                 Channel = Channel_to_delete( i );
%                    ss = find( index_r_A( : , 2 ) == Channel ) ;
%                    if  ~isempty( ss )
%                         index_r_A( ss , : ) = [] ;
%                    end 
%             end
%             
%         end 

%              figure
%               vertHexX=[  0 0     ] ;
%               vertHexY=[  0 0.5       ] ; 
%               plotCustMark(  index_r_A(:,1)/1000  , index_r_A(:,2) ,vertHexX,vertHexY, 1.5)
              
        AWSR_1ms = AWSR_from_index_r( index_r_A  , 1 , params2 );
    else
       AWSR_1ms = AWSR_from_index_r( index_r  , 1 , params2 );
    end
else
    AWSR_1ms = AWSR_from_index_r( index_r  , 1 , params2 );
end
%--------------

   tic 
   %-----------%-----------%-----------%-----------%----------- 
   %-----------%-----------%-----------%-----------%----------- 
        Extract_and_adjust_bursts         
        %-----------%-----------%-----------%-----------%----------- 
        %-----------%-----------%-----------%-----------%----------- 
   toc
   

   
   
         
    index_r_size = size( index_r ); 
    spikes_num_total = index_r_size(1) ;
    last_spike = index_r( end , 1 ) / 1000 ; % last spike time in sec
    last_spike = max( index_r( : , 1 )) / 1000 ; % last spike time in sec 
    Spikes_per_sec = spikes_num_total / last_spike ;
    Spikes_per_sec    
    all_amp = index_r( : , 3 );
    Amplitude_mean_all_spikes = mean( all_amp );
    Amplitude_std_all_spikes = std(  all_amp );
    Amplitude_median_all_spikes = median( all_amp );
    Amplitude_mad_all_spikes = mad( all_amp );
    Raster_duration_ms = last_spike * 1000 ;
    Raster_duration_sec = last_spike ;
    Total_firing_rates_each_channel = Total_firing_rates_each_channel / Raster_duration_sec ;
    
    if Search_Params.Active_channel_By_burst_Thr
            Active_channels_index = find( Spike_Rates_each_channel_mean > Search_Params.Active_channel_Spike_rate_each_burst_Thr );
    else
        Active_channels_index = find( Total_spikes_each_channel > Search_Params.Active_channel_Spike_rate_each_burst_Thr );
    end
    Active_channels_number = length( Active_channels_index ) ;
    
    Firing_rate_per_channel = Spikes_per_sec / Active_channels_number ;
%-----------%-----------%-----------%-----------%----------- 
%-----------% Superbursts analysis %-----------%----------- 
        Superbursts_analysis_from_AWSR
%-----------%-----------%-----------%-----------%-----------    
    

%-----------%-----------%-----------%-----------%----------- 
    if Search_Params.Filter_Superbursts
                
        burst_index_in_Superbursts = []; 
        for si = 1 : Superbrsts.Number_of_Superbursts 
            NB_in_SB = find( Superbrsts.SB_start( si ) < burst_start &  burst_start <  Superbrsts.SB_end( si )  );
            burst_index_in_Superbursts= [ burst_index_in_Superbursts  NB_in_SB ] ; 
        end 
        
                    %--delete short bursts
                        Burst_to_erase =burst_index_in_Superbursts ;
%                         low_values_data_index ;
%                         High_values_data_index
                            %-----------%-----------%-----------%-----------%-----------
                                Number_of_bursts_before_cut = Nb ;
                                Erase_defined_bursts 
                                Number_of_bursts_after_cut = Nb ;
                        %     ( index in Burst_to_erase) 
                            %-----------%-----------%-----------%-----------%----------- 
                                      
                        %-------------
    end

    
    
 %-----------%-----------%-----------%-----------%-----------    
%     if Search_Params.Filter_small_bursts

           Classification_data = [0 0 ; 0 0 ] ;
           Small_bursts_number =  0 ;
           Small_bursts_index = [] ;
           Number_of_bursts_before_cut = Nb ;

        if strcmp( Search_Params.Filter_small_bursts_TYPE , 'BurstDurations' )
            Classification_data = BurstDurations ;
        end
        
       if strcmp( Search_Params.Filter_small_bursts_TYPE , 'Spike_Rates_each_burst' )
            Classification_data = Spike_Rates_each_burst ;
       end
       
%        if strcmp( Filter_small_responses , 'BurstDurations' )
%             Classification_data = BurstDurations ;
%         end        




         
        Small_bursts_data = [] ;  
        if Search_Params.Filter_bursts_clasterisation 
            
            Small_bursts_data = [] ;
           Small_bursts_filter_Davies_Bouldin_SB_Clustering_index = 0 ; 
            
           if isempty( Classification_data ) || numel( Classification_data )==1
           Classification_data = [0 0 0; 0 0 0] ;
           Small_bursts_number =  0 ;
           Small_bursts_index = [] ;
           Number_of_bursts_before_cut = Nb ;
           else
          %-----------%-----------%-----------%-----------%----------- 
          
          
             [centers,clusters,errors,ind] = kmeans_clusters( Classification_data , 2 , 15 ); 
        
        
                clusters = clusters{2,1};
                clusters_last=clusters ;
                Data1= Classification_data( clusters == 1);
                Data2= Classification_data( clusters == 2);
                if max(Data2) > max(Data1)
                    Data_classify_thresh = floor((max(Data1)+min(Data2))/2) 
                    High_values_data_Percent = 100* length( Data2 ) / (length( Data2 ) + length( Data1 ));
                    Cluster1 = 1 ; Cluster2 = 2 ; 
                else
                    Data_classify_thresh = floor((max(Data2)+min(Data1))/2) 
                    High_values_data_Percent = 100* length( Data1 ) / (length( Data2 ) + length( Data1 )) ;
                    Cluster1 = 2 ; Cluster2 = 1 ; 
                end
             
 
                Small_bursts_filter_Davies_Bouldin_SB_Clustering_index = ind(2);
                Small_bursts_filter_Davies_Bouldin_SB_Clustering_index
                squared_sum_of_errors_CLUSTERING_SB = errors(2) /10000 ;
                squared_sum_of_errors_CLUSTERING_SB        
                
                
            
                  if ~isempty( Data1 ) || length( Data1 ) ~= Nb      
                        patterns_list = 1 :  Nb   ;

                        High_values_data_index =   patterns_list(clusters == Cluster2 ) ;
                        low_values_data_index  =   patterns_list(clusters == Cluster1 );
                        High_values_data_number =  length( High_values_data_index )   
                        low_values_data_number  =  length(  low_values_data_index )  
                        Small_bursts_filter_Davies_Bouldin_SB_Clustering_index
                        var.Davies_Bouldin_Clustering_index = Small_bursts_filter_Davies_Bouldin_SB_Clustering_index ;
                        
                        
%                         GLOBAL_CONSTANTS_load
                        
                        var.figure_title = 'Small bursts filtering' ;
                        var.xlabel_defined = true ;
                        var.xlabel = Search_Params.Filter_small_bursts_TYPE ;
                        k = strfind(var.xlabel , '_');
                        var.xlabel( k) = ' ' ;
                        
                      if params.show_figures
         
                        Show_figure_2clusters_separation
                        % input :
                        %    var.figure_title = 'Small bursts filtering' ;
                        %   var.xlabel_defined   ;
                        %   var.xlabel
                        % Data1 Data2 Data_classify_thresh Classification_data High_values_data_number 
                      end
                      
                      Small_bursts_data = [] ;
                      Small_bursts_data.Spike_Rates_each_burst = Spike_Rates_each_burst( low_values_data_index);
                      Small_bursts_data.Spike_Rates = Spike_Rates( low_values_data_index , ch ) ;
                      Small_bursts_data.BurstDurations = BurstDurations( low_values_data_index);
                      Small_bursts_data.burst_start = burst_start( low_values_data_index);
                      Small_bursts_data.burst_end = burst_end( low_values_data_index);
                      Small_bursts_data.burst_activation = burst_activation( low_values_data_index , : ) ;
                      Small_bursts_data.burst_activation_normalized = burst_activation_normalized( low_values_data_index , : );  
                      Small_bursts_data.Small_bursts_number = length( low_values_data_index );      
                        
                      
%                       low_values_data_index
%                       Superbrsts.burst_index_in_Superbursts
%                       Superbrsts.burst_index_in_each_Superbursts
%                       
%                       S = Superbrsts.burst_index_in_Superbursts ;
%                       for hb = 1 : length( High_values_data_index )
%                           f = find( S < High_values_data_index( hb )) ;
%                           if hb > 1 
%                               f = find( f > High_values_data_index( hb -1 ));
%                               f = f ;
%                           end
%                           if ~isempty( f )
%                               S( f ) = S(f ) - hb ;
%                           end
%                       end
%                       Superbrsts.burst_index_in_Superbursts = S;
                          
                          
                      
                        %--delete big or small bursts
                        Burst_to_erase =low_values_data_index ;
%                         low_values_data_index ;
%                         High_values_data_index
                        Small_bursts_number = length( Burst_to_erase );
                        Small_bursts_index = Burst_to_erase ;
                        Number_of_bursts_before_cut = Nb ;
                            %-----------%-----------%-----------%-----------%-----------
                            if Search_Params.Filter_small_bursts
                                
                                if Small_bursts_filter_Davies_Bouldin_SB_Clustering_index <= Search_Params.Small_bursts_filter_Davies_Bouldin_index_Threshold     
                                    if ~Search_Params.Filter_big_bursts 
                                        Number_of_bursts_after_cut = Nb ;
                                    else
                                        Burst_to_erase = High_values_data_index;
                                        Number_of_bursts_after_cut = Small_bursts_number ;
                                    end
                                    Erase_defined_bursts 
                                end
                             
                                 
                                burst_index_in_each_Superbursts = {}; 
                                burst_in_superbursts=[];
                                for si = 1 : Superbrsts.Number_of_Superbursts
                                    NB_in_SB = find( Superbrsts.SB_start( si ) < burst_start &  burst_start <  Superbrsts.SB_end( si )  ); 
                                    burst_index_in_each_Superbursts = [burst_index_in_each_Superbursts NB_in_SB] ; 
                                    NB_in_SB = length( NB_in_SB );
                                    burst_in_superbursts = [ burst_in_superbursts NB_in_SB ]; 
                                end
                                Superbrsts.burst_index_in_each_Superbursts = burst_index_in_each_Superbursts ;
                                Superbrsts.burst_in_superbursts = burst_in_superbursts ;
                            end
                        %     ( index in Burst_to_erase) 
                            %-----------%-----------%-----------%-----------%----------- 
                                      
                        %-------------
                  end

       
           end
        else
%             Search_Params.Filter_bursts_clasterisation = 0 ;
            Small_bursts_filter_Davies_Bouldin_SB_Clustering_index = 0 ; 
            
        end
    
            
  % Erase all spikes after specified duration of the burst
   if Search_Params.Burst_delete_spikes_burst_tail > 0 
        Find_bursts_erase_portion_of_bursts
   end    
 %=====================================================================
 %============= Here all bursts found =================================
 %=====================================================================
 
    
 
%---- Calculate average bursts profile with 1 ms bib -------------------- 
%       params2.show_figures = false ;
%       params2.new_figure = false ; 
%       params2.x_label = '' ;
%       AWSR_1ms = AWSR_from_index_r( index_r  , 1 , params2 );
    % Input - index_r , TimeBin , params.show_figures , params.new_figure ,
    % params.x_label

     %  AWSR_burst = AWSR( burst_start( 1 ) : burst_end( 1 ) );
    %  figure
    %  plot( AWSR_burst );

%     max_dur = floor(  max( Durations ) *dT / 1000 ) + 1 ;


 if isfield( Search_Params , 'SpikeRate_profile_1ms_max_duration')
     Search_Params.SpikeRate_profile_1ms_max_duration = Search_Params.SpikeRate_profile_1ms_max_duration ;
 else
     if isfield( Global_flags.Search_Params , 'SpikeRate_profile_1ms_max_duration')
     Search_Params.SpikeRate_profile_1ms_max_duration = Global_flags.Search_Params.SpikeRate_profile_1ms_max_duration;
     else
       if exist( 'Global_flags_init' , 'var')
           Search_Params.SpikeRate_profile_1ms_max_duration = Global_flags_init.Search_Params.SpikeRate_profile_1ms_max_duration;
       end
     end
 end
 
    max_dur = Search_Params.SpikeRate_profile_1ms_max_duration  ;
    SpikeRate_burst_profile_1ms_max_dur = max_dur ;
    SpikeRate_burst_profile_1ms_all = zeros( Nb , max_dur  )  ;
    for Nb_i = 1 : Nb
        if burst_end( Nb_i ) <= length( AWSR_1ms )
        burst_buf = AWSR_1ms( burst_start( Nb_i ) : burst_end( Nb_i ) ); 

        SpikeRate_burst_profile_1ms_all( Nb_i , 1 : length(burst_buf)) = burst_buf ;
        end
    end
    SpikeRate_burst_profile_1ms = mean( SpikeRate_burst_profile_1ms_all , 1 ) ;

    % whos SpikeRate_burst_profile_1ms_all_mean 
    % figure
    % plot( SpikeRate_burst_profile_1ms )
    % xlabel( 'time, ms' )
    % ylabel( 'Spikes per 1 ms')
 
 %-------------------------------------------------------------------------
 
    %-----------------------------    
    %----- Bursts plotting nice ---------------------
       Threshold = AWSR_calc_tres( AWSR , Search_Params.AWSR_sig_tres );
       Threshold_AWSR = Threshold ;
       
        Tmax =  length( AWSR )   ; % ms
        Nt = floor(Tmax / dT) +1;
        x = [ 1 : (  length( AWSR )  )  ] ;
        x = x *dT / 1000  ;
        y = 100*( AWSR / max(AWSR)) ; 
        whos x
        whos y
        xt = [ 0 max(x) ];
        Threshold = 100*( Threshold / max(AWSR)) ;  
        
        yt = [ Threshold Threshold ]; 
        
%         params.show_figures = true ;
         show_detection_figure = false ; 
        if params.show_figures
           show_detection_figure = true ; 
        end
    
        if params.show_detection_bursts 
           show_detection_figure = true ; 
        end   
        if show_detection_figure    
           
%             GLOBAL_CONSTANTS_load
            
            figure('name', GLOBAL_const.Burst_detect_result_title);
 
            Nx = 1 ;
            Ny =3 ;
            subplot( Ny , Nx , [1 2 ] )
                %- Total Raster 
                Plot_Detailed_Raster
                
            subplot( Ny , Nx , 3 )   
            %- Total Raster 
                Plot_Detailed_Raster
%                 xbi_start xbi_start
                if length( burst_start )>0
                    axis( [ burst_start(1)/1000 - 0.1 burst_end(1)/1000 + 0.1 0 N+1 ]) 
                end
%                 axis( [ 0 GM_Bursts_example_raster_duration 0 100 ]) 
                title( '' ) ;
                legend( 'off');
                ylabel('')
                
                drawnow 
        end    
   %---------------------------------------------------    
   %--------------------------------------------------- 
    

    
    max_ISI = diff( burst_max ) ;
    % max_ISI = b_ISI ;
    g_div = 1000 ; % if g_div = 1000 then all characterisitics in [ms] will be [s]
    InteBurstInterval = max_ISI   / g_div  ;
    Median_InterBurstInterval = median( max_ISI )   / g_div  ;
    MAD_InterBurstInterval = mad( max_ISI ,1)   / g_div  ;
    Mean_InterBurstInterval = mean( max_ISI )  /g_div  ;
    STD_InterBurstInterval = std( max_ISI )  / g_div  ;
    Mean_Spike_Rates_each_burst = mean( Spike_Rates_each_burst );
    STD_Spike_Rates_each_burst = std( Spike_Rates_each_burst );
    Median_Spike_Rates_each_burst = median( Spike_Rates_each_burst );
    MAD_Spike_Rates_each_burst = mad( Spike_Rates_each_burst );
    Mean_Burst_Duration = mean( BurstDurations ) / g_div    ;
    STD_Burst_Duration = std( BurstDurations )   / g_div   ;
    Median_Burst_Duration = median( BurstDurations )  / g_div   ;
    MAD_Burst_Duration = mad( BurstDurations ,1  )  / g_div   ;

    % Spike_Rates_in_Burst = Spike_Rates_each_burst(:) / ( Durations(:) *dT / 1000 ) ;
    % Median_Burst_FiringRate =  Median(Spike_Rates_in_Burst ) ;
    % MAD_Burst_FiringRate =  mad(Spike_Rates_in_Burst , 1 ) ; 

    Mean_Burst_FiringRate = mean( Firing_Rates_each_burst ) ;
    STD_Burst_FiringRate = std( Firing_Rates_each_burst ,1) ;
    Median_Burst_FiringRate = median( Firing_Rates_each_burst ) ;
    MAD_Burst_FiringRate = mad( Firing_Rates_each_burst ,1) ;
    Bursts_number = length( index );

    Bursts_number  

    Median_Burst_Duration 
    MAD_Burst_Duration

    Median_InterBurstInterval
    MAD_InterBurstInterval

    Median_Burst_FiringRate  
    MAD_Burst_FiringRate

    Median_Spike_Rates_each_burst
    MAD_Spike_Rates_each_burst


    Mean_Burst_Duration
    STD_Burst_Duration

    Mean_InterBurstInterval
    STD_InterBurstInterval

    Mean_Burst_FiringRate
    STD_Burst_FiringRate

    Mean_Spike_Rates_each_burst 
    STD_Spike_Rates_each_burst 

    Statistical_ANALYSIS = [ Mean_Burst_Duration ; STD_Burst_Duration ;Mean_InterBurstInterval ;STD_InterBurstInterval; ...
          Mean_Burst_FiringRate; STD_Burst_FiringRate; Mean_Spike_Rates_each_burst ;STD_Spike_Rates_each_burst  ] ;

    Statistical_ANALYSIS_median_values= [ Median_Burst_Duration ; MAD_Burst_Duration ;Median_InterBurstInterval ;MAD_InterBurstInterval; ...
          Median_Burst_FiringRate; MAD_Burst_FiringRate; Median_Spike_Rates_each_burst ;MAD_Spike_Rates_each_burst   ] ;

% Median_Burst_Duration
% MAD_Burst_Duration
% Median_InterBurstInterval
% MAD_InterBurstInterval
% Median_Burst_FiringRate
% MAD_Burst_FiringRate
% Median_Spike_Rates_each_burst
% MAD_Spike_Rates_each_burst

%       Mean_Burst_Duration
%       STD_Burst_Duration
%       Mean_InterBurstInterval
%       STD_InterBurstInterval
%       Mean_Burst_FiringRate
%       STD_Burst_FiringRate
%       Mean_Spike_Rates_each_burst
%       STD_Spike_Rates_each_burst
%       Active_channels_number
        
        
%     if ~isempty( BurstDurations)



        fire_bins = floor(max(BurstDurations) / DT_step) ;
        DT_BINS_number=fire_bins;
        DT_BIN_ms = DT_step; 
     
% figure
burst_activation_mean  = zeros( N,1);
burst_activation_normalized_mean  = zeros( N,1);
Spike_Rate_per_electrode= zeros( N,1);
      for ch = 1 : N   
            burst_activation_mean( ch  ) = mea_Mean_defined( burst_activation( : , ch )); 
%       hist(  burst_activation( : , ch ) )       
            Spike_Rate_per_electrode( ch ) = length( find( index_r( : , 2 ) == ch ) ) / Tmax_s ; 
            burst_activation_normalized_mean( ch) = mea_Mean_defined( burst_activation_normalized( : , ch ));
            % burst_activation(ch) = burst(1,ch);
      end 
      
      
      

        % [ Spike_Rate_Signature , DT_BIN_ms , DT_BINS_number ,  bb ] = DrawSpikeRateSignature( Nb ,  bursts , mean(BurstDurations) , 20 );

        var.Spike_Rates_each_burst = Spike_Rates_each_burst ; 
 
           DT_BIN_ms  = DT_step ;
           DT_BINS_number  = 0 ;   
           fire_bins= 0 ;
           Start_t =0 ;
           
%            dur_max = mean_or_median(BurstDurations) + std_or_mad( BurstDurations );
           if isfield( Search_Params , 'Spike_Rate_Signature_max_duration_auto')
     Search_Params.Spike_Rate_Signature_max_duration_auto = Search_Params.Spike_Rate_Signature_max_duration_auto ;
 else
     Search_Params.Spike_Rate_Signature_max_duration_auto = Global_flags.Search_Params.Spike_Rate_Signature_max_duration_auto;
 end
           if  Search_Params.Spike_Rate_Signature_max_duration_auto
               dur_max = mean_or_median(BurstDurations) + std_or_mad( BurstDurations );
           end
           
           DT_BINS_number = floor((dur_max - Start_t) / DT_step);
           
           TimeBin_Total_Spikes = [] ;  
           TimeBin_Total_Spikes_mean = [] ; 
           TimeBin_Total_Spikes_std = [] ; 
           
           TimeBin_Total_Amps = [] ;
           TimeBin_Total_Amps_mean = [] ;
           TimeBin_Total_Amps_std = [] ;
           
           Spike_Rate_Patterns = [] ; 
           Spike_Rate_Signature = [] ;  
           Spike_Rate_Signature_std = [] ; 
           Spike_Rate_Signature_step_ms = DT_step ;
           Spike_Rate_Signature_max_duration_ms = dur_max ; 
                  Amp_Patterns    = [];
                  Amp_Patterns_1ms  = [];
                  Amps_Signature = [] ;
                  Amps_Signature_std = [] ;
                  Amps_Signature_1ms = [];
                  Amps_Signature_1ms_std = []; 
                  Amps_Signature_mean = []; 
                  
                  Total_Amps_mean_all_chan = [] ;
                Total_Amps_std_all_chan  = [] ;
                Amps_each_channel_mean = [] ; 
                Amps_each_channel_std = [] ; 
                Amps_mean_each_burst = [] ; 
                burst = [] ;AmpRates  = [] ;
                
                 
%         if  Simple_analysis
%             var.Find_only_SpikeRate = true ;
%         else
%             var.Find_only_SpikeRate = false ;    
%         end
         var.Find_only_SpikeRate = false ; 
         
            var.Burst_Data_Ver =  Burst_Data_Ver ; 
            var.N = N ;
%             var.Find_only_SpikeRate = true ; 
            
           if Burst_Data_Ver == 1 
               [  TimeBin_Total_Spikes ,  TimeBin_Total_Spikes_mean , TimeBin_Total_Spikes_std , ...
               Spike_Rate_Patterns ,  Spike_Rate_Signature ,  ... 
               Spike_Rate_Signature_std , Amp_Patterns , Amps_Signature , Amps_Signature_std ]   ...
                  = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N ,Nb  ,bursts , ...
                  Start_t ,   dur_max , DT_step  ,bursts_amps ,var );
%             Spike_Rate_Signature = zeros( fire_bins  , N ); 
%             Spike_Rate_Signature_std = zeros( fire_bins  , N ); 
%             Spike_Rate_Patterns = zeros( fire_bins  , N , Nb );              
           else
               if Nb > 0
               [  TimeBin_Total_Spikes ,  TimeBin_Total_Spikes_mean , TimeBin_Total_Spikes_std , ...
               Spike_Rate_Patterns ,  Spike_Rate_Signature ,  ... 
               Spike_Rate_Signature_std , Amp_Patterns , Amps_Signature , Amps_Signature_std , ...
                TimeBin_Total_Amps ,  TimeBin_Total_Amps_mean ,   TimeBin_Total_Amps_std , Amps_Signature_mean , Total_Amps_mean_all_chan , ...
   Total_Amps_std_all_chan , Amps_each_channel_mean ,  Amps_each_channel_std ,Amps_mean_each_burst ,AmpRates ]  ...
                          = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N ,Nb  , bursts_cell_Nb_N , ...
                  Start_t ,  dur_max , DT_step  ,bursts_cell_amps_Nb_N ,var );              
               end
           end
           
  %>>>>>>>>>> Analyze spikerate profiles
                if isfield( Search_Params , 'Calc_Spikerate_profile_1ms_bin')
     Search_Params.Calc_Spikerate_profile_1ms_bin = Search_Params.Calc_Spikerate_profile_1ms_bin ;
                else
                   if exist( 'Global_flags_init' , 'var')
                       Search_Params.Calc_Spikerate_profile_1ms_bin = Global_flags_init.Search_Params.Calc_Spikerate_profile_1ms_bin;
                   end
%                    Search_Params.Calc_Spikerate_profile_1ms_bin = Global_flags.Search_Params.Calc_Spikerate_profile_1ms_bin;
                end;
               
               
              Calc_Spikerate_profile_1ms_bin = Search_Params.Calc_Spikerate_profile_1ms_bin ;
              SR_Search_Params = Global_flags.Search_Params  ; 
     if Calc_Spikerate_profile_1ms_bin
%               [ TimeBin_Total_Spikes_1ms , TimeBin_Total_Spikes_mean_1ms , TimeBin_Total_Spikes_std_1ms , Spike_Rate_Patterns_1ms , ...
%                    Spike_Rate_Signature_1ms , Spike_Rate_Signature_std_1ms , Spike_Rate_1ms_smooth_Max_corr_delay , ...
%                    Spike_Rate_Signature_1ms_smooth , Amp_Patterns_1ms , Amps_Signature_1ms  , Amps_Signature_1ms_std , Amps_Signature_1ms_smooth , ...
%                    Spike_Rate_1ms_Max_corr_delay , Spike_Rate_Signature_1ms_interp , DT_bin_interp ]   = ...
               [  TimeBin_Total_Spikes_1ms , TimeBin_Total_Spikes_std_1ms , Spike_Rate_Patterns_1ms ,  ...
                   Spike_Rate_Signature_1ms ,  Spike_Rate_Signature_std_1ms ,  Spike_Rate_1ms_smooth_Max_corr_delay , ...
                   Spike_Rate_Signature_1ms_smooth , Amp_Patterns_1ms , Amps_Signature_1ms  , Amps_Signature_1ms_std , Amps_Signature_1ms_smooth , ...
                   Spike_Rate_1ms_Max_corr_delay , Spike_Rate_Signature_1ms_interp , DT_bin_interp ] =  ...   
             SR_profile_1ms_calc( Calc_Spikerate_profile_1ms_bin ,  N , Nb ,bursts_cell_Nb_N , bursts_cell_amps_Nb_N , SR_Search_Params , Mean_Burst_Duration ) ;
           
%>>>>>>>>>>
           fire_bins = floor( Spike_Rate_Signature_max_duration_ms  / DT_step ) ;
            times_fire_bins =DT_step * ( 1 : fire_bins );
      
        %--- Burst activation based on average activity ---------------   
       
        DT_bin_1ms = 1 ;
        if  SR_Search_Params.Calc_Spikerate_profile_1ms_interp 
            Spike_Rate_Signature_1ms_for_Tact = Spike_Rate_Signature_1ms_interp ;
            DT_bin_1ms_Tact =   DT_bin_interp ;
        else
            Spike_Rate_Signature_1ms_for_Tact = Spike_Rate_Signature_1ms_smooth ;
            DT_bin_1ms_Tact =   DT_bin_1ms ;
        end
         
       %---------------------------------------------------  
         if SR_Search_Params.Plot_Tact3_diff_levels && params.show_figures
          
%              Tact_2d_diff = MNDB_Make2d_data_from_vector( burst_activation_3_smooth_1ms_mean  );
%               var.new_figure = true ;
%              var.calc_bidirection = false ;
%              var.background_1d_vector = true ;
%              var.background_1d_vector_data = burst_activation_3_smooth_1ms_mean ;
%              
%                  Connectiv_Post_proc( Tact_2d_diff  , var  ) 
             
             figure
             Nx = 3 ; Ny = 3 ;
              i = 0 ;
              
             for T_activation_stat_threshold_param = 1 : 9
                 i = i +1 ;
                 subplot( Ny , Nx , i )
                   [ burst_activation_2_mean , burst_activation_2 , burst_activation_3_smooth_1ms_mean , ...
                 burst_max_rate_delay_ms , burst_max_rate_delay_ms_mean    ] = ... 
                SR_profile_Tact2_3_from_1msProfile( N , Nb , Calc_Spikerate_profile_1ms_bin , Search_Params.Burst_activation_based_smooth_find_all_bursts , ...
                 Spike_Rate_Signature_max_duration_ms ,  DT_bin_1ms_Tact , Spike_Rate_Patterns_1ms , ...
                 Search_Params ,  SR_Search_Params.T_activation_stat_threshold_param ,...
                 Search_Params , Spike_Rate_Signature_1ms_for_Tact ,  burst_activation_mean , Spike_Rates_each_channel_mean ) ;
             
%                  Plot8x8Data( burst_activation_3_smooth_1ms_mean , false , false )
                 
                  Tact_2d_diff = MNDB_Make2d_data_from_vector( burst_activation_3_smooth_1ms_mean  );
                 var.new_figure = false ;
                 var.calc_bidirection = false ;
                 var.background_1d_vector = true ;
                 var.background_1d_vector_data = burst_activation_3_smooth_1ms_mean ;
             
                 Connectiv_Post_proc( Tact_2d_diff  , var  )
                title( ['Activation ' num2str( T_activation_stat_threshold_param * 10 ) ' %' ] )
             end 
         end
       %---------------------------------------------------  
          [ burst_activation_2_mean , burst_activation_2 , burst_activation_3_smooth_1ms_mean , ...
     burst_max_rate_delay_ms , burst_max_rate_delay_ms_mean    ] = ... 
            SR_profile_Tact2_3_from_1msProfile( N , Nb , Calc_Spikerate_profile_1ms_bin , SR_Search_Params.Burst_activation_based_smooth_find_all_bursts , ...
             Spike_Rate_Signature_max_duration_ms ,  DT_bin_1ms_Tact , Spike_Rate_Patterns_1ms , ...
             Search_Params , SR_Search_Params.T_activation_stat_threshold_param ,...
             Search_Params , Spike_Rate_Signature_1ms_for_Tact ,  burst_activation_mean , Spike_Rates_each_channel_mean ) ;
        
         
     end
% Search_Params.T_activation_stat_threshold_param 
        
        
%      for ch = 1 : N    
%                if Spike_Rates_each_channel_mean( ch )  < Global_flags.min_spikes_per_channel 
%                    Spike_Rate_Signature( : , ch ) = 0 ;   
%                    burst_activation_normalized_mean( ch) = 0 ;
%                    burst_activation_normalized( ch) = 0 ; 
%                    burst_activation_mean(   ch ) = 0 ;
%                    burst_activation( : , ch ) = 0 ; 
%                end
               
%                
%                 for ch_i = 1 : N 
%                        for ch_j = 1 : N  
%                          if ch_i ~= ch_j  
%                                                                       
%                                 Spike_Rate_1ms_smooth_Max_corr_delay( ch_i , ch_j ) = Max_corr_delay ; 
%                          end
%                        end
%                      end 
%      end   
       
    %---------- Statistics in each bin - PSTH
    if isempty( BurstDurations )
      BurstDurations = 0 ;  
      fire_bins = 1 ; 
    else
%            fire_bins = floor(median(BurstDurations) / DT_step) ;  
           fire_bins =floor(  Search_Params.Spike_Rate_Signature_max_duration    / DT_step) ;  
    end


      TimeBin_Total_Spikes = zeros( Nb , fire_bins );  
      TimeBin_Total_Spikes_mean = zeros(1,fire_bins);
      TimeBin_Total_Spikes_std = zeros(1,fire_bins);
      Nb
      fire_bins
      whos Spike_Rate_Patterns
%       if ~Simple_analysis
          for ti=1:fire_bins
              for R = 1 : Nb      
                   TimeBin_Total_Spikes( R , ti )= sum( Spike_Rate_Patterns( ti , : , R   )) ; 
              end

              TimeBin_Total_Spikes_mean( ti ) = mea_Mean_defined( TimeBin_Total_Spikes( : , ti ));
              TimeBin_Total_Spikes_std( ti ) = mea_Std_defined( TimeBin_Total_Spikes( : , ti ));
          end
%       else
%          TimeBin_Total_Spikes  = []; 
%          TimeBin_Total_Spikes_mean= []; 
%          TimeBin_Total_Spikes_std= []; 
%  
%       end
 %-----------%-----------%-----------%-----------%-----------  
 %-----------%-----------%-----------%-----------%-----------    
if Analyze_Connectiv
    if Burst_Data_Ver >= 2
        bursts_absolute =    bursts_cell_absolute_Nb_N ;
    end
%             Nb , N , bursts_absolute
            Patterns_analysis_connectivity 
            % >>> Input: bursts or bursts_absolute , Spike_Rates , Nb , N ,
            % Burst_Data_Ver  
            % Output >>>: 
            % Connectiv_data struct :
            % Connectiv_matrix_M_on_tau ( N x N x Connectiv_data.params.tau_number ) 
            % Connectiv_matrix_max_M (NxN) , 
            % Connectiv_matrix_tau_of_max_M ( NxN )
            % max_M - Maximum % of spikes transferred , tau - delay of max_M
            % Connectiv_matrix_tau_of_max_M_vector 
            % Connectiv_matrix_tau_of_max_M_vector_non_zeros
            % Connectiv_matrix_max_M_vector
            % Connectiv_matrix_max_M_vector_non_zeros
            % Connectiv_data.params
            
              
    
end

     
    
    
    
%   else
%       SUPERBURSTS = [] ;
%   end
    %-----------%-----------%-----------%-----------%-----------

    % Statistical_ANALYSIS = [ Statistical_ANALYSIS ; Mean_Burst_Duration ; STD_Burst_Duration ;Mean_InterBurstInterval ;STD_InterBurstInterval; ...
    %       Mean_Burst_FiringRate; STD_Burst_FiringRate; Mean_Spike_Rates_each_burst ;STD_Spike_Rates_each_burst  N_SB ] ;
    % Statistical_ANALYSIS = [ Statistical_ANALYSIS ;   N_SB ] ;
         

            Statistical_ANALYSIS = [ Statistical_ANALYSIS ; Spikes_per_sec ; Nb ; N_SB ; mean_Super_Durations_sec ; Active_channels_number ; ...
              Firing_rate_per_channel ; Amplitude_mean_all_spikes ; Amplitude_std_all_spikes ; ...
              Total_Amps_mean_all_chan ; Total_Amps_std_all_chan ] ;
          
          Statistical_ANALYSIS_median_values = [ Statistical_ANALYSIS_median_values ; ...
            Amplitude_median_all_spikes ; Amplitude_mad_all_spikes ] ;
        
        
        %         figure
        %         plot( curr_BURST( : , 1)  , curr_BURST( : , 2) ,
        %         '.','MarkerEdgeColor' ,[.04 .52 .78] )
%         [pathstr,name,ext,versn] = fileparts( filename ) ;


%       Mean_Burst_Duration
%       STD_Burst_Duration
%       Mean_InterBurstInterval
%       STD_InterBurstInterval
%       Mean_Burst_FiringRate
%       STD_Burst_FiringRate
%       Mean_Spike_Rates_each_burst
%       STD_Spike_Rates_each_burst
%       Active_channels_number
%       Spikes_per_sec
%       Nb
%       N_SB
%       mean_Super_Durations
%       Active_channels_number

        
        Analysis_data_cell = cell(1,1) ;
        
        
        InteBurstInterval=InteBurstInterval';
        Spike_Rates_each_burst=Spike_Rates_each_burst';
        % eval(['save ' char( finame ) ...
        %  ' burst_activation bursts_absolute bursts burst_start burst_max
        %  burst_end InteBurstInterval BurstDurations Spike_Rates_each_burst  -mat']); 
        
        
           ANALYZED_DATA.Statistical_ANALYSIS = Statistical_ANALYSIS;
           ANALYZED_DATA.Statistical_ANALYSIS_median_values=Statistical_ANALYSIS_median_values;

           ANALYZED_DATA.Burst_Data_Ver = Burst_Data_Ver ;
           
           ANALYZED_DATA.Active_channels_index = Active_channels_index ;
           ANALYZED_DATA.Active_channels_number = Active_channels_number ;
           
           % raster stats
           ANALYZED_DATA.Total_spikes_each_channel = Total_spikes_each_channel ;
           ANALYZED_DATA.Total_firing_rates_each_channel = Total_firing_rates_each_channel ;
           ANALYZED_DATA.Total_spikes_number = Total_spikes_number ;
           ANALYZED_DATA.Spikes_per_sec = Spikes_per_sec ;
           ANALYZED_DATA.Amps_mean_all_spikes  =  Amplitude_mean_all_spikes ; 
           ANALYZED_DATA.Amps_median_all_spikes = Amplitude_median_all_spikes ;                
           ANALYZED_DATA.Firing_rate_per_channel = Firing_rate_per_channel   ;
           
           % bursts stats
           ANALYZED_DATA.Amps_mean_burst = Total_Amps_mean_all_chan ;
           ANALYZED_DATA.Amps_std_burst = Total_Amps_std_all_chan ;
    
           ANALYZED_DATA.Raster_duration_ms = Raster_duration_ms ;  
           ANALYZED_DATA.Raster_duration_sec = Raster_duration_ms / 1000 ;
           
           ANALYZED_DATA.burst_activation_normalized_mean = burst_activation_normalized_mean ;
           ANALYZED_DATA.burst_activation_mean = burst_activation_mean ;
           if Search_Params.Calc_Spikerate_profile_1ms_bin 
               ANALYZED_DATA.burst_activation_2_mean = burst_activation_2_mean  ;
               ANALYZED_DATA.burst_activation_3_smooth_1ms_mean = burst_activation_3_smooth_1ms_mean ; 
               ANALYZED_DATA.burst_max_rate_delay_ms_mean = burst_max_rate_delay_ms_mean ;
           end
            
           ANALYZED_DATA.burst_start=burst_start;
           ANALYZED_DATA.burst_max=burst_max;
           ANALYZED_DATA.burst_end=burst_end;
            
           ANALYZED_DATA.Number_of_bursts = Nb ;       
           ANALYZED_DATA.Number_of_Patterns = Nb ;  
           ANALYZED_DATA.Bursts_per_sec = 1000 * ( Nb / Raster_duration_ms ) ;
           ANALYZED_DATA.Bursts_per_min = 60 * ANALYZED_DATA.Bursts_per_sec ;

           ANALYZED_DATA.InteBurstInterval=InteBurstInterval;
           ANALYZED_DATA.BurstDurations=BurstDurations;

           ANALYZED_DATA.Spike_Rates = Spike_Rates ;       
           ANALYZED_DATA.Spike_Rates_each_burst = Spike_Rates_each_burst ;
           ANALYZED_DATA.Spike_Rates_each_channel_mean = Spike_Rates_each_channel_mean ; %( 64 x 1 )
           ANALYZED_DATA.Spike_Rates_each_channel_std = Spike_Rates_each_channel_std ; %( 64 x 1 )
           ANALYZED_DATA.Spike_Rates_Signature = Spike_Rate_Signature;% DT_bins number x 64
           ANALYZED_DATA.Spike_Rates_Signature_std = Spike_Rate_Signature_std ; % DT_bins number x 64
           ANALYZED_DATA.Spike_Rates_Signature_step_ms = Spike_Rate_Signature_step_ms ;
           ANALYZED_DATA.Spike_Rates_Signature_max_duration_ms = Spike_Rate_Signature_max_duration_ms ;
           
            if Search_Params.Calc_Spikerate_profile_1ms_bin 
           ANALYZED_DATA.Spike_Rate_Signature_1ms = Spike_Rate_Signature_1ms ;% DT_bins number x 64
           ANALYZED_DATA.Spike_Rate_Signature__std_1ms = Spike_Rate_Signature_std_1ms ; % DT_bins number x 64
           ANALYZED_DATA.Spike_Rates_Signature_step_ms = Spike_Rate_Signature_step_ms ;
           ANALYZED_DATA.Spike_Rates_Signature_max_duration_1ms = Global_flags.Search_Params.Spike_Rate_Signature_1ms_max_duration ;
           ANALYZED_DATA.Spike_Rate_Signature_1ms_smooth = Spike_Rate_Signature_1ms_smooth ;  
           ANALYZED_DATA.Spike_Rate_Signature_1ms_interp = Spike_Rate_Signature_1ms_interp ; 
           ANALYZED_DATA.DT_bin_interp = DT_bin_interp ;  
           ANALYZED_DATA.Spike_Rate_1ms_smooth_Max_corr_delay = Spike_Rate_1ms_smooth_Max_corr_delay ;
           ANALYZED_DATA.Spike_Rate_1ms_Max_corr_delay = Spike_Rate_1ms_Max_corr_delay ;           
           ANALYZED_DATA.burst_max_rate_delay_ms = burst_max_rate_delay_ms ;
            end
             
           ANALYZED_DATA.AmpRates = AmpRates ;
           ANALYZED_DATA.Amps_mean_each_burst =  Amps_mean_each_burst ;                       
           ANALYZED_DATA.Amps_each_channel_mean =  Amps_each_channel_mean ;
           ANALYZED_DATA.Amps_each_channel_std =  Amps_each_channel_std ;
           ANALYZED_DATA.Amps_Signature  = Amps_Signature ;
           ANALYZED_DATA.Amps_Signature_std = Amps_Signature_std ; 
           ANALYZED_DATA.Amps_Signature_step_ms = Spike_Rate_Signature_step_ms ;
           ANALYZED_DATA.Amps_Signature_Signature_max_duration_ms = Spike_Rate_Signature_max_duration_ms ;
           
            if Search_Params.Calc_Spikerate_profile_1ms_bin 
                
           ANALYZED_DATA.Amps_Signature_1ms = Amps_Signature_1ms;
           ANALYZED_DATA.Amps_Signature_1ms_std = Amps_Signature_1ms_std ; 
           ANALYZED_DATA.Amps_Signature_1ms_smooth = Amps_Signature_1ms_smooth ;
            
            
           ANALYZED_DATA.SpikeRate_burst_profile_1ms = SpikeRate_burst_profile_1ms ;
           ANALYZED_DATA.SpikeRate_burst_profile_1ms_max_duration = SpikeRate_burst_profile_1ms_max_dur ;
           ANALYZED_DATA.SpikeRate_burst_profile_1ms_all = SpikeRate_burst_profile_1ms_all ;
            end
            
           ANALYZED_DATA.Firing_Rates = Firing_Rates ;         
           ANALYZED_DATA.Firing_Rates_each_channel_mean = Firing_Rates_each_channel_mean ; 
           ANALYZED_DATA.Firing_Rates_each_channel_std = Firing_Rates_each_channel_std ; 
           ANALYZED_DATA.Firing_Rates_each_burst = Firing_Rates_each_burst ;

           

           ANALYZED_DATA.TimeBin_Total_Spikes = TimeBin_Total_Spikes ; % Ns x DT_bins number 
           ANALYZED_DATA.TimeBin_Total_Spikes_mean = TimeBin_Total_Spikes_mean ;  % 1 x DT_bins number 
           ANALYZED_DATA.TimeBin_Total_Spikes_std = TimeBin_Total_Spikes_std ;  % 1 x DT_bins number  
           ANALYZED_DATA.TimeBin_Total_Amps = TimeBin_Total_Amps; 
           ANALYZED_DATA.TimeBin_Total_Amps_mean = TimeBin_Total_Amps_mean; 
           ANALYZED_DATA.TimeBin_Total_Amps_std = TimeBin_Total_Amps_std; 
            
           ANALYZED_DATA.DT_bin = DT_BIN_ms ; % Used for TimeBin_Total_Spikes_mean, ..      
           ANALYZED_DATA.DT_BINS_number=DT_BINS_number;  
 
           ANALYZED_DATA.Small_bursts_filter_applied = Search_Params.Filter_small_bursts ;
           ANALYZED_DATA.Small_bursts_number = Small_bursts_number ;
           ANALYZED_DATA.Small_bursts_index = Small_bursts_index ;
           ANALYZED_DATA.Small_bursts_Davies_Bouldin_Clustering_index = ...
                Small_bursts_filter_Davies_Bouldin_SB_Clustering_index;
           ANALYZED_DATA.Number_of_bursts_original = Number_of_bursts_before_cut ; % before cut to small bursts
           

           % Superburstrs
           Superbrsts.Small_bursts_data = Small_bursts_data ;
           ANALYZED_DATA.Superbrsts  = Superbrsts ;  
           ANALYZED_DATA.Number_of_Superbursts = N_SB ;
           ANALYZED_DATA.SB_start  = SB_start ;
           ANALYZED_DATA.SB_end  = SB_end ; 
           ANALYZED_DATA.burst_in_superbursts = burst_in_superbursts ;  
           

           % Awsr
           ANALYZED_DATA.AWSR_TimeBin = TimeBin ;
           ANALYZED_DATA.AWSR_sig_tres=Search_Params.AWSR_sig_tres; 
           ANALYZED_DATA.Threshold_AWSR = Threshold_AWSR ;
           
           ANALYZED_DATA.Flags = cell( 30 , 1);
           ANALYZED_DATA.Flags{ BURSTS_Analysis_FLAG_Analysis_version_index } = Burst_Data_Ver ;
%            ANALYZED_DATA.Flags{ 2 } = Burst_flags ;  
           
           DateTime_created.Analysis_TimeAndDateAsVector = clock ;
           DateTime_created.Analysis_DateAsString = date ;
           
           ANALYZED_DATA.Flags{ 2 }.DateTime_created = DateTime_created ;
%            ANALYZED_DATA.Flags{ 3 }.Search_Params = Search_Params ;
           
           ANALYZED_DATA.burst_activation_amps =burst_activation_amps;           %  spike amps in first spikes
           ANALYZED_DATA.burst_activation = burst_activation;          
           ANALYZED_DATA.burst_activation_normalized = burst_activation_normalized ;
            if Search_Params.Calc_Spikerate_profile_1ms_bin  
                
           ANALYZED_DATA.burst_activation_2 = burst_activation_2;
            end
           
           Analysis_data_cell = struct2cell( ANALYZED_DATA );
           ANALYZED_DATA_field_names = fieldnames( ANALYZED_DATA );
           Analysis_data_cell_field_names = ANALYZED_DATA_field_names ;
           
           bursts_analyzed = true         
           
           %======== Convert all structure to cell ============================
            ANALYZED_DATA.Analysis_data_cell = Analysis_data_cell;
            ANALYZED_DATA.Analysis_data_cell_field_names = Analysis_data_cell_field_names ;
           %===============================================================
            if isfield( Search_Params , 'Save_Patterns_1ms_to_file')
                 Search_Params.Save_Patterns_1ms_to_file = Search_Params.Save_Patterns_1ms_to_file ;
             else
%                  Search_Params.Save_Patterns_1ms_to_file = Global_flags.Search_Params.Save_Patterns_1ms_to_file;
                  if exist( 'Global_flags_init' , 'var')
                     Search_Params.Save_Patterns_1ms_to_file = Global_flags_init.Search_Params.Save_Patterns_1ms_to_file;
                    end
            end 
           
                  ANALYZED_DATA.Spike_Rate_Patterns = Spike_Rate_Patterns ;
                  if Search_Params.Save_Patterns_1ms_to_file
                    ANALYZED_DATA.Spike_Rate_Patterns_1ms = Spike_Rate_Patterns_1ms ;
                  end
                    ANALYZED_DATA.Amp_Patterns = Amp_Patterns ;
                  if Search_Params.Save_Patterns_1ms_to_file
                    ANALYZED_DATA.Amp_Patterns_1ms  = Amp_Patterns_1ms;
                  end
                  
           
           if Burst_Data_Ver == 1 
               ANALYZED_DATA.bursts_absolute=bursts_absolute;
               ANALYZED_DATA.bursts=bursts;
               ANALYZED_DATA.bursts_amps  =bursts_amps;                    %  spike amps in bursts
           else
               ANALYZED_DATA.bursts_absolute = bursts_cell_absolute_Nb_N ;
               ANALYZED_DATA.bursts = bursts_cell_Nb_N ; 
               ANALYZED_DATA.bursts_amps = bursts_cell_amps_Nb_N ;
           end
           

           
           if Analyze_Connectiv
             ANALYZED_DATA.Connectiv_data = Connectiv_data ; 
           end
           
           Parameters.Experiment_name = Experiment_name ;
           if exist( 'Original_filename')
            Parameters.Original_filename = Original_filename ;
            [pathstr,name,ext] = fileparts( Original_filename ) ; 
            Parameters.Original_path  = pathstr ;
           end
           Parameters.Burst_Data_Ver = Burst_Data_Ver ; 
           Parameters.N_channels = N ;
            DateTime_created.Analysis_TimeAndDateAsVector = clock ;
            DateTime_created.Analysis_DateAsString = date ;
           Parameters.DateTime_created = DateTime_created ;
           Parameters.Search_Params = Search_Params ;
           Parameters.Global_flags = Global_flags ;
                      
           if GLOBAL_const.Cluster_bursts 
                Bursts_Merge_and_Classify_patterns
           end
%          whos ANALYZED_DATA

%     Spike_Rates_Signature = Spike_Rate_Signature;   
    DT_bin = DT_BIN_ms ; 
    CD = cd ;


    