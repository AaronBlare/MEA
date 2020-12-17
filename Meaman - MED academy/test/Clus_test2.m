%  Clus_test2
i =0;
sM = randn( 302  , 2 );
sM( 50:end,1)=sM( 50:end,1) +   i ;
sM( 150:end,1)=sM( 150:end,1) +  12 + i ; 
sM( 250:end,1)=sM( 250:end,1) +  22 + i ; 

small_features  = sM ;

% big_features=get_Start_End_features(ANALYZED_DATA);
%PARAMS
clusters_number=3 ;
nfeat=2;
%PCA PLOT
small_pca=compute_mapping(small_features,'PCA',nfeat);
%big_pca=compute_mapping(big_features,'PCA',2);
small_idx=clustering(small_pca,'mgauss',clusters_number);
% small_idx=clustering(small_pca,'kmeans',clusters_number);

if nfeat>2
    plot_pca_3d(small_idx,small_pca,clusters_number,1,2,3);
else
    plot_pca(small_idx,small_pca,clusters_number,1,2);
end


Nclus=8;
optidb=evalclusters(small_pca,@mgauss_clust,'DaviesBouldin','Klist',[2:Nclus]);
%[centers,clusters, err, DB_all] = kmeans_clusters(small_features , Nclus , 25 );
small_idx_clust=optidb.OptimalY 


