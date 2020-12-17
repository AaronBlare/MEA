function result = Patterns_convert_to_vector( data , Nb )  

s = size( data);

if length( s ) > 1
        data = shiftdim(data, 1);
        data = shiftdim(data, 1);
        result = [];
        for i = 1 : Nb
            data_line = data( i , :,:);
            data_line = reshape( data_line , 1 , [] );
            result = [ result ; data_line ] ; 
        end
        data  = result ;

    s = size( data );
    if Nb < s(1)
       data( Nb+1 : end , :) = [] ;
    end
else 
    result = data ;
 end