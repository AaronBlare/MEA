%-- test cluster stability ----------
% Clustering_test_stability_block

mean_dist_all = [] ;
Nbl_dist_all = [] ;
for Nbl = 20 : floor( Nb /2 ) - 1 ;
    Nbl_dist_all = [ Nbl_dist_all Nbl ] ;
    patch_num = floor( Nb / Nbl ) - Nbl;
    patt_in_clust_all = [];
    
    for NN = 1 : floor( Nb / Nbl ) 
       new_patch = cluster_index( (NN-1)*Nbl+1 : NN*Nbl );
        patt_in_clust = [] ;
        for i = 1 : Nclus_optim
            f = find( new_patch == i ) ;
            patt_in_clust = [ patt_in_clust  length( f) ] ;
        end 
        patt_in_clust = 100 * patt_in_clust / Nbl ;
        patt_in_clust_all = [ patt_in_clust_all ; patt_in_clust ] ;
            
    end
    
%     figure
%     bar( patt_in_clust_all' )
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
    
    mean_dist_all = [ mean_dist_all mean( dists ) ] ;
    
end
figure
plot( Nbl_dist_all , mean_dist_all )
xlabel( 'Patterns number in block')
ylabel( 'Cluster statistics difference')
%------------------------------------