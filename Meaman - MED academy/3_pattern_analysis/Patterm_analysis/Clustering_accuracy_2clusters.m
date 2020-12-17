

function [ Not_distinguishable_points_num , Clustering_error_precent , accuracy]= ...
    Clustering_accuracy_2clusters( x,y , SHOW_FIGURES , Count_zero_values )

N_clusters = 2 ;
cluster_sizes_origin = zeros( N_clusters,1);
% x=randn(20, 2); 
% y=randn(20, 2)+2 ;
if nargin == 2 
    SHOW_FIGURES = true ;
end
whos x
whos y
x_size=size(x);x_size=x_size(1);cluster_sizes_origin(1)=x_size;
y_size=size(y);y_size=y_size(1);cluster_sizes_origin(2)=y_size;
Total_points_size = sum( cluster_sizes_origin );
x_size ;
y_size ;
OriginClass = ones( 1,x_size+y_size);
OriginClass( x_size+1:end)=2;

PATTERNS=[ x ; y ] ; 

whos PATTERNS
% hold on
% plot( x(:,1),x(:,2),'*')
% plot( y(:,1),y(:,2),'*r')
% hold off 

% if SHOW_FIGURES
% figure
% hold on
% plot( x(:,1),x(:,1),'*')
% plot( y(:,1),y(:,1),'*r')
% title('Patterns as point')
% hold off 
% end

D = pdist(PATTERNS,'euclidean');
s = squareform( D ) ;
% PlotColoredMatrixData( s )
% title( 'Clustering accuracy: standard K-means' ) 

% Z = linkage(PATTERNS,'centroid','euclidean');
% cluster_index = cluster(Z,'maxclust',2);
% 
% x
% y
% whos cluster_index    
msg=0 ;
%  try

[cluster_index,ctrs] = kmeans(PATTERNS,2,...
                    'Distance','sqEuclidean', 'emptyaction','singleton',   ...
                    'Replicates',10);
%                 [cluster_index,ctrs] = kmeans(PATTERNS,N_clusters,...
%                     'Distance','sqEuclidean');
% catch ME
% msg = ME.message
%  end 
if msg == 0   % if kmeans not fails
 

        points_in_cluster = 0 ; 
        points_out_cluster= 0 ; 
        clusq_n = cluster_index(1) ;
        clus1 = find( cluster_index == clusq_n ) ;
        new_clus1_size= length( clus1 ); 
        new_clus1_size ;
        points_moved_to2nd_cluster = [] ;
        for i = 1: x_size
            l= find( clus1 == i, 1 ); 
           if ~isempty(  l)
               points_in_cluster = points_in_cluster +1; 
           else
               points_out_cluster = points_out_cluster +1; 
               points_moved_to2nd_cluster=[points_moved_to2nd_cluster i ];
           end
        end 
         points_moved_to2nd_cluster;

         l= find( clus1 > x_size   ); 
           if ~isempty(  l)
               new_points_in_cluster1 = clus1( l ) ;
               new_points_in_cluster1=new_points_in_cluster1';
               new_points_in_cluster1;
           end


        cluster_index;
        OriginClass=OriginClass';
        OriginClass;
        % whos cluster_index
        % whos OriginClass

        [ldaResubCM,grpOrder] = confusionmat( cluster_index  ,  OriginClass );
% ldaResubCM
        
        [ ErrX , ErrX_index ] = min( ldaResubCM( : , 1 ));
        [ ErrY , ErrY_index ] = min( ldaResubCM( : , 2 ));

        if ErrX < ErrY
            ss=find( ldaResubCM( : , 1 ) ==ErrX );
            if length( ss ) >1
                ErrY = min( ldaResubCM( ss , 2 ) );
            else
                if ErrX_index == 1 
                  ErrY =   ldaResubCM( 2 , 2 );
                else 
                  ErrY =   ldaResubCM( 1 , 2 );
                end
            end
        else
           ss=find( ldaResubCM( : , 2 ) ==ErrY );
            if length( ss ) >1
                ErrX = min( ldaResubCM( ss , 1 ) );
            else
                if ErrY_index == 1 
                  ErrX =   ldaResubCM( 2 , 1 );
                else 
                  ErrX =   ldaResubCM( 1 , 1 );
                end
            end 

        end
        
%         ErrX = min( ldaResubCM( : , 1 ));
%         ErrY = min( ldaResubCM( : , 2 )); 

        Not_distinguishable_points_num_E = ErrX +  ErrY ;
        Not_distinguishable_points_num_E;

        %    Not_distinguishable_points_num=new_clus1_size-points_in_cluster+points_out_cluster;
        Not_distinguishable_points_num = Not_distinguishable_points_num_E ;

        Not_distinguishable_points_num     ;
        Clustering_error_precent =  100 * Not_distinguishable_points_num / Total_points_size ;
        accuracy = 100 * ( Total_points_size - Not_distinguishable_points_num ) /  Total_points_size ;
        % Clustering_error_precent 


        % PATTERNS
        % ctrs
        cluster_index_1 = find(cluster_index==2) ;
        if SHOW_FIGURES
            figure
            hold on
            plot( PATTERNS(:,1),PATTERNS(:,1),'*')
            plot( ctrs(:,1),ctrs(:,1),'*g')
            if ~isempty(cluster_index_1) 
            plot( PATTERNS(cluster_index_1,1),PATTERNS(cluster_index_1,1),'*r')
            end
            title( 'points and centroids' )
            hold off    
        end
else
        Not_distinguishable_points_num = 0 ;
        K_MEANS_USUAL_FAILS = true ;
        K_MEANS_USUAL_FAILS
        Clustering_error_precent = 100 ;
end

