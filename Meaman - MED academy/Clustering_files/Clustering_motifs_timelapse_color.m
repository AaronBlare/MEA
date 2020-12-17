

function Clustering_motifs_timelapse_color( cluster_index , var )


new_figure = true ;

if nargin > 1 
    if isfield( var, 'new_figure' )
        new_figure =  var.new_figure ; 
    end
end

cmap =  colormap( hot) ; 
cmap =  colormap( jet) ; 
 nclr = size(cmap,1);
 
 motifs_color = ones( max( cluster_index ) , length( cluster_index )) ;
for i = 1 : max( cluster_index )
    f = find( cluster_index == i ) ; 
    motifs_color( i , f ) = 0  ;
%     motifs_color( i , f ) = i  ;
end
 if new_figure
figure
 end
imagesc( motifs_color )
title( 'Burst motifs inside superbursts')
colorbar
colormap hot
% colormap cmap
xlabel( 'Burst #')
ylabel( 'Motif #')