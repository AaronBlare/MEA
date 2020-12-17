%  Clus_test

% for i = 0:5
i =0;
sM = randn( 302  , 2 );
sM( 50:end,1)=sM( 50:end,1) +   i ;
sM( 150:end,1)=sM( 150:end,1) +  12 + i ; 
sM( 250:end,1)=sM( 250:end,1) +  22 + i ; 

close all
figure
plot( sM(:,1) , sM(:,2), '*')



   [c, p, err, ind] = kmeans_clusters2(sM , 4  ); % find clusterings
   [minDB,i] = min(ind) ; % select the one with smallest index
 minDB
 Nclus_optim = i 
   
% end 