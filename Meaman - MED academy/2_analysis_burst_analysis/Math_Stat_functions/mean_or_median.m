

function result = mean_or_median( x )



if length( x )>2
total_data_0_if_normal = jbtest( x ) ;
x_is_normal = total_data_0_if_normal == 0 ; 
    if x_is_normal   
       result = mean( x )  ;
    else                           
       result = median( x )  ;                  
    end                    
else
    result = mean( x )  ;
    
end
                        
                        
                        