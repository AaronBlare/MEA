function Clustering_result = Clustering_from_data( data , Nb , var )


analyze_defined_clusters_num = true ;
     defined_Nclusters = 2 ;
 

Nclus = 30 ;

if isfield( var, 'Nb' )
    if var.Nb > 0 
        Nb =  var.Nb ;
    end
end

convert_data = true ;
if isfield( var, 'convert_data' ) 
        convert_data =  var.convert_data   ; 
end

% chn = 60 ;

if convert_data
    data  = Patterns_convert_to_vector( data , Nb ) ;
end
%------------ compare all pairs


%--- Clustering cycle -------------------------
Nclus_optim_all = [] ;
param_all = [] ;
% for Nbi = 30 : 1 : Nb
%     data = [] ;
%     data(  1 : Nbi , :)  = data2(  1 : Nbi , :) ; 
%     Nbi
    
    
 %% +++ Clusterisation ++++++++++++++++++++++++++++++++++
 
    [centers,clusters, err, DB_all] = kmeans_clusters(data , Nclus , 25 ); % find clusterings
    [minDB,i] = min( DB_all) ; % select the one with smallest index
     minDB
     Nclus_optim = i
     
     if analyze_defined_clusters_num 
     Nclus_optim = defined_Nclusters ;
     end
 
    
    
    % Estimation of clustering
    Clustering_estimation = zeros( 4 , 1 );
    est_index_name = { 'Sil'  'DB' 'CH' 'KL' } ;
    for ci = 2 : Nclus 
        [indx,ssw,sw,sb]=valid_clusterIndex(data,clusters{ ci }) ;
    %     indx = [Sil DB CH KL]
        Clustering_estimation = [ Clustering_estimation indx ] ;
    end
    
%     ind = Clustering_estimation( 3 , : );
%     [n , Nclus_optim ] = max( ind( 2 : end) ) ;
%     Nclus_optim = Nclus_optim + 1 ;
   
%     [minch,i] = max( Clus_est( 3 , : )) ;
%     Nclus_optim = i
    
    cluster_index = clusters{ Nclus_optim } ; 
    cluster_index_sorted = {};
    for i=1:Nclus_optim
       f = find( cluster_index == i ) ;
        cluster_index_sorted{ i } = f ;
    end
    
    var.index_ms = [] ; 
    var.centers = centers( Nclus_optim )  ;
    % var.index_ms = ANALYZED_DATA.burst_start  ;
    Clustering_result = Clustering_Motif_stats( cluster_index , Nclus_optim , var ) ;
    
    Clustering_result.cluster_index_total = cluster_index;
    Clustering_result.cluster_index_sorted = cluster_index_sorted; 
    Clustering_result.centers = centers;
    Clustering_result.clusters = clusters;
    Clustering_result.DB_all = DB_all;
    Clustering_result.Nclus_optim = Nclus_optim;
    Clustering_result.Clustering_estimation = Clustering_estimation ; 
    Clustering_result.Clusters_tested = Nclus ; 
    

     
 %% Presentation +++++++++++++++++++++++++++++++++++++

     figure ; Nx =2 ; Ny =2 ;
    for i =1 : 3
       subplot( Ny , Nx , i )
       plot( Clustering_estimation( i , : ) , 'Linewidth' , 2 )
       title( est_index_name{ i } )
       xlim( [ 2 Nclus ] );
        xlabel( 'Clusters number' )
    end
    
     figure
     plot( DB_all , 'Linewidth' , 2  )
     title( 'Clusterisation quality')
     xlim( [ 2 Nclus ] );
     ylabel( 'DB index')
     xlabel( 'Clusters number' )
 
%     %--- /////////// 
%     param_all = [ param_all Nbi ] ;
%      Nclus_optim_all = [ Nclus_optim_all Nclus_optim ] ;    
% end
% Burst_starts_new = Burst_starts_new( 1 : length( cluster_index )) ;
% % --- Clustering cycle end ///////////  

% figure
% plot( param_all , Nclus_optim_all ) 
% xlabel( 'Nb')
% ylabel( 'Clusters' )

     
cluster_index_0 = cluster_index ;
%  c=xcorr( cluster_index_0 , 'unbiased' );
% figure
% plot( c )


 
% figure
% plot( log10( 1:Nclus_optim ) , log10( patt_in_clust_sort ) )




%-- test cluster quality----------
% Clustering_test_stability_k_means
%------------------------------------

%-- test cluster stability ----------

% Clustering_test_stability_block

%------------------------------------



 
% cluster_index = cluster_index_0( 1 : 250 ) ;
% 
%  patt_in_clust = [] ;
% for i = 1 : Nclus_optim
%     f = find( cluster_index == i ) ;
%     patt_in_clust = [ patt_in_clust  length( f) ] ;
% end
% patt_in_clust1 = patt_in_clust ;
% patt_in_clust_sort =  sort( patt_in_clust  ,'descend');
% patt_in_clust_sort = 100 * patt_in_clust_sort / length( cluster_index );
% figure
% bar( patt_in_clust_sort )
% xlabel( 'Pattern #')
% ylabel( 'Probability, %')
% 
%  
% cluster_index = cluster_index_0( 251  :  250 + 274 ) ;
% 
%  patt_in_clust = [] ;
% for i = 1 : Nclus_optim
%     f = find( cluster_index == i ) ;
%     patt_in_clust = [ patt_in_clust  length( f) ] ;
% end
% patt_in_clust2 = patt_in_clust ;
% patt_in_clust_sort =  sort( patt_in_clust  ,'descend');
% patt_in_clust_sort = 100 * patt_in_clust_sort / length( cluster_index );
% figure
% bar( patt_in_clust_sort )
% xlabel( 'Pattern #')
% ylabel( 'Probability, %')
% 
% 
% 
% cluster_index = cluster_index_0(  250 + 274  : end ) ;
% 
%  patt_in_clust = [] ;
% for i = 1 : Nclus_optim
%     f = find( cluster_index == i ) ;
%     patt_in_clust = [ patt_in_clust  length( f) ] ;
% end
% patt_in_clust3 = patt_in_clust ;
% patt_in_clust_sort =  sort( patt_in_clust  ,'descend');
% patt_in_clust_sort = 100 * patt_in_clust_sort / length( cluster_index );
% figure
% bar( patt_in_clust_sort )
% xlabel( 'Pattern #')
% ylabel( 'Probability, %')
% 
% 
% figure
% bar( [ patt_in_clust1'    patt_in_clust2'    patt_in_clust3'  ] )  


% figure
% plot( log10( 1:Nclus_optim ) , log10( patt_in_clust_sort ) ) 


