function [  overlapped_values , overlapped_valuse_precent , Optimal_Threshold ,...
    Dissimilar_points_precent , Dissimilar_points ] ...
      =Matrix_Similarities_overlap( x,y , Count_zero_values , SIMILARITIES )
 
PATTERNS=[ x ; y ] ; 
  
if nargin == 3 
D = pdist(PATTERNS,'euclidean');
Similarity_matrix = squareform( D ) ;
% PlotColoredMatrixData( Similarity_matrix ) 
else
   Similarity_matrix = SIMILARITIES ;
%     PlotColoredMatrixData( SIMILARITIES ) 
%     title('000000000000')
%     PlotColoredMatrixData( Similarity_matrix )
end


x_size=size(x);x_size=x_size(1); 
y_size=size(y);y_size=y_size(1); 
P1=[]; P2=[]; 
for x=1:  x_size + y_size
    for y=1:  x_size + y_size
        if x>y 
            if x >  x_size && y <= x_size
            val=Similarity_matrix( y,x);
            P1=[P1 val]; 
            else
             val=Similarity_matrix(    y ,  x )  ;
            P2=[P2 val ];   
            end
        end
    end
end

% figure
% hold on
% plot( P1  )
% plot( P2, 'r')
% hold off
% whos P1
% whos P2
% P1
% P2
[ overlapped_values , overlapped_valuse_precent,Optimal_Threshold , overlap_values_Optim_Thres_precent , overlap_values_Optim_Thres ...
    ] = Overlapping_Values( P1 , P2 , Count_zero_values   )  ;
% Optimal_Threshold
Dissimilar_points = 0 ;
Point_num_diss=[];
    for y=1:  x_size  
        M = Similarity_matrix(y,1:x_size) ; M=M( M>0 );
       if  mean( M ) > Optimal_Threshold % points are not similar in common
          Dissimilar_points = Dissimilar_points + 1;
          Point_num_diss=[Point_num_diss y ];
       end
    end   
    for y=1:  y_size  
        M  = Similarity_matrix(y + x_size , x_size+1:x_size+y_size);M=M( M>0 );
       if  mean( M ) > Optimal_Threshold % points are not similar in common
          Dissimilar_points = Dissimilar_points + 1;
          Point_num_diss=[Point_num_diss y+x_size ];
       end
    end   
 
    for y=1:  x_size  
        M=Similarity_matrix( y , x_size+1:x_size+y_size );M=M( M>0 );
%            if y < 5
% %         SIMILARITIES( y , x_size+1:x_size+y_size ) =0;
%         
%             end
       if  mean( M ) < Optimal_Threshold % points are not similar in common
        
          ss=find( Point_num_diss == y, 1 );
          
          if isempty( ss)
            Point_num_diss=[Point_num_diss y ];
            Dissimilar_points = Dissimilar_points + 1;
          end
       end
    end   
    for y=1:  y_size  
        M=Similarity_matrix( 1: x_size , y+ x_size ) ;M=M( M>0 );
     
       if  mean( M ) < Optimal_Threshold % points are not similar in common
            ss=find( Point_num_diss == y + x_size, 1 );
          if isempty( ss)
            Point_num_diss=[Point_num_diss y+x_size ];
            Dissimilar_points = Dissimilar_points + 1;
          end
       end
    end  
%     Point_num_diss 
Point_num_diss   ;
total_points = ( x_size + y_size )
Dissimilar_points_precent =  100* Dissimilar_points / ( x_size + y_size );

  overlap_values_Optim_Thres ;
  
  
  
  
  