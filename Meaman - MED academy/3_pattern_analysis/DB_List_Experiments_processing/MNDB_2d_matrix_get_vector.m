
function result = MNDB_2d_matrix_get_vector( Data1 )

s = size( Data1);
N=s(1);
result = [];
 for chi = 1 : N 
     for chj = 1 : N 
        if chi > chj 
            result = [ result ;  Data1( chi , chj ) ] ;
        end
     end
 end