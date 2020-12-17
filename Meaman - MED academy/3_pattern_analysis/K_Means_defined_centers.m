    

function [ Centroid_Error_points , Centroid_Error_precent ] = ...
    K_Means_defined_centers( Patterns1 , Patterns2 , Patterns1_center , Patterns2_center , SHOW_FIGURES )

Nb = length( Patterns1 );
Nb2 = length( Patterns2 );

     D1 = [ Patterns1_center' ; Patterns1  ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
     s = size( size( Similarity_matrix )) ; 
     DIM = s(2) ; 
     Patterns_more_than2 = false ;
     if DIM >= 2 Patterns_more_than2 = true ; end
     if Patterns_more_than2
     S1_C1 = Similarity_matrix( 1 , 2:end) ;
     S1_C1=S1_C1';
     else S1_C1 =0 ; end 
        
     D1 = [ Patterns2_center' ; Patterns1  ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
%      S1_C2 = Similarity_matrix( 1 , 2:end)';
     if Patterns_more_than2
     S1_C2 = Similarity_matrix( 1 , 2:end)';
     else S1_C2 =0 ; end
     
     D1 = [ Patterns2_center' ; Patterns2 ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
%      S2_C2 = Similarity_matrix( 1 , 2:end)';
     if Patterns_more_than2
     S2_C2 = Similarity_matrix( 1 , 2:end)';
     else S2_C2 =0 ; end
        
     D1 = [ Patterns1_center' ; Patterns2 ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
%      S2_C1 = Similarity_matrix( 1 , 2:end)';
     if Patterns_more_than2
     S2_C1 = Similarity_matrix( 1 , 2:end)';
     else S2_C1 =0 ; end
            

     if SHOW_FIGURES
     figure
         
%      subplot( 2 ,2 , 2)  

%      subplot( 2 ,2 , 1)
         hold on 
         h1 = plot(   [ S1_C1 ; S2_C1 ] ) ;
         h2 = plot(   [ S1_C2 ; S2_C2 ], 'r' ) ;
         legend( 'Set 1,2 dist to C1','Set 1,2 dist to C2')
              hNextStim = plot(  [ Nb Nb ] ,[ 0 1.2*max( max(S1_C2),max(S2_C2))  ] ) ;
         set(h1,'Marker'          , '.'    )
          set(h2,'Marker'          , '.'    )
         set(hNextStim                         , ...
                      'Color'           , [0 .5 0] , ...
                      'LineWidth'       , 2      );  
         title( 'Pattern Distance to centroids')
         hold off
          
     end
 ss =length( find(  S1_C1 >= S1_C2 ) ) ;
 if ~isempty( ss )  Centroid_Error_points = ss ; else Centroid_Error_points = 0 ; end
 ss =length( find(  S2_C2 >= S2_C1 ) ) ;
    if ~isempty( ss )  Centroid_Error_points = Centroid_Error_points + ss ; end
   Centroid_Error_precent = 100 * Centroid_Error_points/ (  Nb+Nb2  );
    Centroid_Error_points
   Centroid_Error_precent  