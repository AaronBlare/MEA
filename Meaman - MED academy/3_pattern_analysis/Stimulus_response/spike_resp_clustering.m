% spike_resp_clustering
 
show_figs = false ;

s = size( spikes_ms_all   );
  s = size(      spikes_amps_all );
  
  spikes_amps_all = spikes_amps_all ;
  
  
  sM_all = [ spikes_ms_all spikes_amps_all ] ;
   
   
   sM  = [   spikes_amps_all ] ;  
 
   
   small_features  = sM ;

% big_features=get_Start_End_features(ANALYZED_DATA);
%PARAMS


% %% Oleg PCA
% clusters_number=3 ;
% nfeat=2;
% %PCA PLOT
% small_pca=compute_mapping(small_features,'PCA',nfeat);
% 
% Nclus=22;
% optidb=evalclusters(small_pca,@mgauss_clust,'DaviesBouldin','Klist',[2:Nclus]);
% %[centers,clusters, err, DB_all] = kmeans_clusters(small_features , Nclus , 25 );
% small_idx_clust=optidb.OptimalK 
% clusters_number = small_idx_clust
% 
% %big_pca=compute_mapping(big_features,'PCA',2);
% small_idx=clustering(small_pca,'mgauss',clusters_number);
% % small_idx=clustering(small_pca,'kmeans',clusters_number);
% 
% if nfeat>2
%     plot_pca_3d(small_idx,small_pca,clusters_number,1,2,3);
% else
%     plot_pca(small_idx,small_pca,clusters_number,1,2);
% end


%% Kmeans
   

   
%   figure
% plot( sM(:,1) , sM(:,2), '*')
clusters_number=   2 ;
   [c, p, err, ind] = kmeans_clusters2(sM , clusters_number  ); % find clusterings
   [minDB,i] = min(ind) ; % select the one with smallest index
 minDB
 Nclus_optim = i 
%  figure
%  plot( ind )
%  ylabel( 'DB index' ) 
%  xlabel( 'clusters' ) 
  
     indd = p(Nclus_optim ) ;
     indd = cell2mat( indd ) ;
    

     
     Ncl = [] ;
     for ni =  1 : Nclus_optim
         f = indd == ni ;
         f( f==0) = [] ;
         Ncl = [ Ncl  numel(  f ) ] ;
     end
     [ mi , nmi ] = min( Ncl );
     
     Nclus_optim_max = nmi ;
     
     sM_times = spikes_ms_all( indd ==Nclus_optim_max  ) ;
     sM = sM_times ;
     sM_amp  = spikes_amps_all( indd ==Nclus_optim_max  ) ;
     
     sM_filt = [ sM_times sM_amp ] ;
%     colormap jet ;
%     cmap=colormap ; 
%     hold on
% %     for i = 1 : Nclus_optim 
% i = Nclus_optim_max ;
%         dc = floor(  ( 64 / Nclus_optim ) / 2  ); 
%         cii =   floor( ( i/(Nclus_optim) )*64)  - dc ; 
%     Plot_color=cmap( cii ,:);      
%        plot( sM_all( indd == i   ,1) , sM_all( indd == i  ,2), '*' , 'Color' , Plot_color  )   
% %     end
     

     clusters_number =  5 ;
   [c, p, err, ind] = kmeans_clusters2(sM , clusters_number  ); % find clusterings
   [minDB,i] = min(ind) ; % select the one with smallest index
 minDB
 Nclus_optim = i 
 
 if show_figs
    % Estimation of clustering
    clusters =  p; 
    data = sM ; 
    Nclus = clusters_number ;
    Clustering_estimation = zeros( 4 , 1 );
    est_index_name = { 'Sil'  'DB' 'CH' 'KL' } ;
    for ci = 2 : Nclus 
        [indx,ssw,sw,sb]=valid_clusterIndex(data,clusters{ ci }) ;
    %     indx = [Sil DB CH KL]
        Clustering_estimation = [ Clustering_estimation indx ] ;
    end
    
    figure ; Nx =2 ; Ny =2 ;
    for i =1 : 4
       subplot( Ny , Nx , i )
       plot( Clustering_estimation( i , : ) , 'Linewidth' , 2 )
       title( est_index_name{ i } )
       xlim( [ 2 Nclus ] );
        xlabel( 'Clusters number' )
    end
%     figure
    
 
%  figure
%  plot( err )
%  ylabel( 'DB index' ) 
%  xlabel( 'clusters' )  
%   figure
%  plot( ind )
%  ylabel( 'DB index' ) 
%  xlabel( 'clusters' )  
%               
 end
  
     indd = p(Nclus_optim ) ;
     indd = cell2mat( indd ) ;
     
 
      
     colormap jet ;
cmap=colormap ;
Nclus_optim0 = Nclus_optim ;
  
% for clusi = 2:Nclus_optim0
%     Nclus_optim = clusi ;
%      indd = p(Nclus_optim ) ;
%      indd = cell2mat( indd ) ;

 if show_figs
figure
 end
    hold on
    for i = 1 : Nclus_optim 
        dc = floor(  ( 64 / Nclus_optim ) / 2  ); 
        cii =   floor( ( i/(Nclus_optim) )*64)  - dc ; 
        Plot_color=cmap( cii ,:);      
       plot( sM_times( indd == i   ,1) , sM_amp( indd == i  ,1), '*' , 'Color' , Plot_color  )   
    end
% end  
%   if show_figs
% figure
%  end
    
    
    
    

     
    
% colorbar  




