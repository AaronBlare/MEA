%  Plot8x8Data
function PlotColoredMatrixData( data , new_figure )


if nargin == 1
    new_figure = true ;
end

siz=size( data ) ;
 Yn = siz(1) ;
 Xn=siz(2) ; 
 

x = 1:  Yn ;
y = 1:  Xn ;
if new_figure 
    figure
end 
imagesc( x,y, data )

colorbar