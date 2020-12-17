function Result = clear_cell_fromNanInfEmpt( input ) 


 


                emptyIndex = cellfun(@isempty,input);       %# Find indices of empty cells 
                
                 
                input(emptyIndex) = {0}; 
                 
             if ~ iscell( input )
                
                fh = @(x) all(isnan(x(:)));
%                 input(cellfun(fh, input)) = [];
                input(cellfun(fh, input)) = {0} ;
                
                
                 fh = @(x) all(isinf(x(:)));
%                 input(cellfun(fh, input)) = [];
                input(cellfun(fh, input)) = {0};
                
%                 infIndex = cellfun(@isinf,input , 'UniformOutput' , 0 );
%                 input(infIndex) = {0}; 
                
%                 nanIndex = cellfun(@isnan,input);
%                 input(nanIndex) = {0};          
             end
                Result =  input  ;
                
              