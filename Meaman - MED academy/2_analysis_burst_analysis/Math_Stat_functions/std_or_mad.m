

function result = std_or_mad( x )




total_data_0_if_normal = jbtest( x ) ;
x_is_normal = total_data_0_if_normal == 0 ; 
    if x_is_normal   
       result = std( x )  ;
    else                           
       result = mad( x )  ;                  
    end                    
                        
                        
                        
                        