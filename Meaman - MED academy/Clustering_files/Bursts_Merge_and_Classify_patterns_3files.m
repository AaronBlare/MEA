
% Bursts_Merge_and_Classify_patterns_3files
% input ANALYZED_DATA

close all

Build_merged_raster = false ;
Merged_raster_processed = false ;
chn = 60 ;
Nb_read = 80 ;
Nb_read = 0 ;

% filesnum = 5 ;

%--- Open files -------
data = [] ;
Nb_all = [] ;
Nb_start = [  ] ;
Nb_end = [] ;
bursts_absolute ={} ;
BurstDurations = [];
burst_start = [];

files = uipickfiles 
                
filesnum = length( files) ; 
for i = 1 : filesnum
%         [filename,PathName] = uigetfile('*.*','Select file');
%         if filename ~= 0 
            
%             load( [ PathName filename ] )
            load( files{ i } )
             
%              data1 = ANALYZED_DATA.TimeBin_Total_Spikes ;
%             data1 = ANALYZED_DATA.Spike_Rates ;
%             data1 = ANALYZED_DATA.SpikeRate_burst_profile_1ms_all ; 
%             data1 = ANALYZED_DATA.burst_activation_amps ;
%             data1 = ANALYZED_DATA.burst_activation ; 
            % data1 = ANALYZED_DATA.burst_activation_normalized ;
            % data1 = ANALYZED_DATA.burst_activation_2 ;
            % data2 = data ;
% 
%                     data1 = ANALYZED_DATA.Amp_Patterns ;
%                     data1 = ANALYZED_DATA.Amp_Patterns_1ms ;
                    data1 = ANALYZED_DATA.Spike_Rate_Patterns ; 
%             data1 = ANALYZED_DATA.Spike_Rate_Patterns_1ms ;
             var = [] ;

            bursts_absolute = [ bursts_absolute ; ANALYZED_DATA.bursts_absolute ];
            BurstDurations = [ BurstDurations ; ANALYZED_DATA.BurstDurations ];
            burst_start = [  burst_start   ANALYZED_DATA.burst_start ];
            BurstDurations( end) = BurstDurations(end) + 2000 ;
             
            if Nb_read == 0 
               Nb = ANALYZED_DATA.Number_of_bursts ;
            else
               Nb = Nb_read ; 
            end
            
            data1  = Patterns_convert_to_vector( data1 , Nb ) ;

            Nb_start = [Nb_start 1 + sum( Nb_all )];
            
            Nb_all = [ Nb_all Nb ] ;
            data = [ data ; data1 ] ;
            
            Nb_end = [Nb_end sum( Nb_all )];
            
%         end 
end
%----------------------




var = [] ;
 var.convert_data  = false ;

 Nb = sum( Nb_all) ;

Clustering_result = Clustering_from_data( data , Nb , var );

 

Nx = filesnum ; Ny =1 ;
figure

cluster_index_0 = Clustering_result.cluster_index ;
Nclus_optim = Clustering_result.Nclus_optim ;
patt_in_clust_all = [] ;
patt_in_clust_sort_all = [] ;

for ci = 1 : filesnum 
    
    
    cluster_index = cluster_index_0( Nb_start( ci ) : Nb_end(ci)) ;

     patt_in_clust = [] ;
    for i = 1 : Nclus_optim
        f = find( cluster_index == i ) ;
        patt_in_clust = [ patt_in_clust  length( f) ] ;
    end
    patt_in_clust1 = patt_in_clust ;
    patt_in_clust1 = 100 * ( patt_in_clust / length( cluster_index));
    patt_in_clust_all= [patt_in_clust_all ; patt_in_clust1 ] ;
    patt_in_clust_sort =  sort( patt_in_clust  ,'descend');
    patt_in_clust_sort = 100 * patt_in_clust_sort / length( cluster_index );
    patt_in_clust_sort_all =[ patt_in_clust_sort_all ; patt_in_clust_sort ];
    % figure
    subplot( Ny , Nx , ci ) 
    bar( patt_in_clust_sort )
    xlabel( 'Pattern #')
    ylabel( 'Probability, %')

    % var.index_ms = [] ; 
    % var.centers = centers( Nclus_optim )  ;
    % % var.index_ms = ANALYZED_DATA.burst_start  ;
    %  Clustering_Motif_stats( cluster_index , Nclus_optim , var )   
    % 
end

figure
subplot( 2 , 1 , 1 ) 
bar( patt_in_clust_all' )
xlabel( 'Motif #')
ylabel( 'Patterns, %')

subplot( 2 , 1 , 2 ) 
bar( patt_in_clust_sort_all' )
xlabel( 'Motif #')
ylabel( 'Patterns, %')











times=[];
last_time = 0 ;
Burst_starts_new = [ 1 ] ;

for Ni = 1 : Nb
    Ni;
    if Ni > 1 
        last_time =  last_time +  BurstDurations( Ni-1 ) + 100  ;
        Burst_starts_new = [ Burst_starts_new last_time ] ;
    end
end

Nb

if Build_merged_raster
    
    index_r  =[];
    last_time = 0 ;
% %---- Merged bursts rastet ---------------------
for Ni = 1 : Nb
    Ni
    if Ni > 1 
        last_time =  last_time +   BurstDurations( Ni-1 ) + 100  ;
%         Burst_starts_new = [ Burst_starts_new last_time ] ;
    end
    for ch = 1 : chn 
        a =  bursts_absolute{ Ni }{ ch };
        s = numel( a );
        if Ni > 1
             
        times = a  -  burst_start( Ni )   +   last_time ; 
         
        else
           times = a  -   burst_start( Ni ) ; 
           
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

















 data  = Patterns_convert_to_vector( data , Nb ) ;
D = pdist( data    );

Z = squareform( D ) ;

figure
imagesc( Z )
colorbar
title( 'Pattern similarity')
xlabel( 'Pattern #')
ylabel( 'Pattern #')









save( 'workspace_02.mat' )
            
cmap = colormap ; 
 nclr = size(cmap,1);
if Merged_raster_processed
 Old_school_raster_presentation = false ;
%             Old_school_raster_presentation
%             index_r
        figure
            Plot_Raster_from_index_r 
            hold on
%             plot( Burst_starts_new/1000 , 10 * ones(1,length( Burst_starts_new ) ), '*r' )
%             plot( Burst_starts_new/1000 , (60 / Nclus_optim ) * cluster_index , '*r'  , 'LineWidth',3 )
            for  i = 1 : length( Burst_starts_new )
                ci  = floor( ( (Clustering_result.cluster_index(i)  ) / (Clustering_result.Nclus_optim ) ) *  nclr )    ;
                plot( Burst_starts_new(i)/1000 , (10 / Clustering_result.Nclus_optim ) * Clustering_result.cluster_index(i) + 64, '*r'  , 'LineWidth',3 , ...
                        'Color' , cmap(ci     ,:) ) 
            end
            
            hold off 
            
      figure
             
            hold on
%             plot( Burst_starts_new/1000 , 10 * ones(1,length( Burst_starts_new ) ), '*r' )
%             plot( Burst_starts_new/1000 , (60 / Nclus_optim ) * cluster_index , '*r'  , 'LineWidth',3 )
            for  i = 1 : length( Burst_starts_new )
                ci  = floor( ( (Clustering_result.cluster_index(i)  ) / (Clustering_result.Nclus_optim ) ) *  nclr )    ;
                plot( burst_start(i)/1000 , (1 ) * Clustering_result.cluster_index(i) , '*r'  , 'LineWidth',3 , ...
                        'Color' , cmap(ci     ,:) ) 
            end
%             colorbar
            hold off          

dlmwrite( 'Raster_Merged.txt'  , index_r  ,'delimiter','\t','precision',8,'newline','pc');
% save( 'Raster_filtered.txt' ,  'index_r0' ,  '-ascii' )
end

