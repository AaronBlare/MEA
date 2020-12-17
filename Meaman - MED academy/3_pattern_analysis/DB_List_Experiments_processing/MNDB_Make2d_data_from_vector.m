
function result = MNDB_Make2d_data_from_vector( Data  )

N = length( Data ); 
result = zeros( N , N );
 for chi = 1 : N 
     for chj = 1 : N 
%         if chi > chj
        diff =  Data( chj ) - Data( chi )   ;
        result( chi , chj ) = diff ;
%         end
     end
 end