

function result = mea_Std_defined( x )

Use_mean = false ;



if Use_mean 
  result = std( x )  ;
else
  result = mad( x )  ;    
end

% 
% total_data_0_if_normal = jbtest( x ) ;
% x_is_normal = total_data_0_if_normal == 0 ; 
%     if x_is_normal   
%        result = std( x )  ;
%     else                           
%        result = mad( x )  ;                  
%     end                    
                        
                        
                        
                        