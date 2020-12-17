function [Similarity_matrix ] =Matrix_Similarities( x,y , new_figure  )
  
% x=randn(20, 2); 
% y=randn(20, 2)+2 ;
% whos x
% whos y
if nargin == 2
    new_figure =true ;
end

 

X_size1 = size( y );  
if length( X_size1 ) == 3 
    X_size1 = X_size1(1 ); 
x( end+1:end+X_size1 , :,:)=y;
PATTERNS = x ; 
else
    PATTERNS=[ x ; y ] ; 
end 
D = pdist(PATTERNS,'euclidean');
Similarity_matrix = squareform( D ) ;
PlotColoredMatrixData( Similarity_matrix ,new_figure )

% x_size=size(x);x_size=x_size(1); 
% y_size=size(y);y_size=y_size(1); 
% P1=[]; P2=[];
% 
% 
% for x=1:  x_size + y_size
%     for y=1:  x_size + y_size
%         if x>y 
%             if x >  x_size && y <= x_size
%             val=Similarity_matrix(x,y); 
%             P1=[P1 val]; 
%             else
%              val=Similarity_matrix(    x ,   y )  ;
%             P2=[P2 val ];   
%             end
%         end
%     end
% end

% figure
% hold on
% plot( P1  )
% plot( P2, 'r')
% hold off
% whos P1
% whos P2 
  
  
  
  
  