


function result = MNDB_Compare_2sets_matrix_diff( Data1 , Data2 )

N = numel( Data1);
result = [];
 for chi = 1 : N 
     for chj = 1 : N 
        if chi > chj
        Tact_diff = ( Data2( chi ) - Data2( chj )) - ...
                    ( Data1( chi ) - Data1( chj )) ;
        result = [ result ; Tact_diff ] ;
        end
     end
 end