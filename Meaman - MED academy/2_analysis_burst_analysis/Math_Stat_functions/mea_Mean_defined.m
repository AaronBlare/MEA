
function result = mea_Mean_defined( x )
 
Use_mean = true ;
% Use_mean = false ;


if Use_mean 
  result = mean( x )  ; 
else
  result = median( x )  ;  
end

% if length( x )>2
% total_data_0_if_normal = jbtest( x ) ;
% x_is_normal = total_data_0_if_normal == 0 ; 
%     if x_is_normal   
%        result = mean( x )  ;
%     else                           
%        result = median( x )  ;                  
%     end                    
% else
%     result = mean( x )  ; 
% end