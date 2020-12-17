%-- test cluster stability ----------
% Clustering_test_stability_k_means

mean_dist_all = [] ;
x_all = [] ;
Nbl= 20 ;



for Nbl = 15 : 5 : 30  
    Nbl
    
    patt_in_clust_all = [];
    for NN = 1 : 4 
        NN
        [centers,clusters, err, DB_all] = kmeans_clusters(data , 10 , Nbl ); % find clusterings
        [minDB,i] = min( DB_all) ; % select the one with smallest index
         minDB;
         Nclus_optim = 5;

         if analyze_defined_clusters_num 
         Nclus_optim = defined_Nclusters ;
         end
         
         cluster_index = clusters{ Nclus_optim } ; 
         patt_in_clust = [] ;
        for i = 1 : Nclus_optim
            f = find( cluster_index == i ) ;
            patt_in_clust = [ patt_in_clust  length( f) ] ;
        end 
         patt_in_clust = sort(  patt_in_clust , 'descend' ) ;
        
        patt_in_clust_all = [ patt_in_clust_all ;  patt_in_clust  ] ; 

%         patt_in_clust_all = [ patt_in_clust_all Nclus_optim ] ;
    end
    
  dists = patt_in_clust_all ;
%     
    dist_all = pdist( patt_in_clust_all ) ; 
    dist_all = squareform(dist_all) ;
    s=size( dist_all );
    dists = [] ;
    for i=1 : s(1)
        for j = i+1 : s(1)
           dists = [ dists dist_all(i,j) ] ;
        end
    end

% figure
% plot( patt_in_clust_all )
    
    mean_dist_all = [ mean_dist_all std( dists ) ] ;
    x_all = [x_all Nbl ] ;
    
end
figure
plot( x_all , mean_dist_all )
xlabel( 'Iterations k-means')
ylabel( 'Error')
%------------------------------------