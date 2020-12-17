
function Result = clear_cell_mat( input ) 

                emptyIndex = cellfun(@isempty,input);       %# Find indices of empty cells 
                input(emptyIndex) = {0}; 
                infIndex = cellfun(@isinf,input);
                input(infIndex) = {0}; 
                nanIndex = cellfun(@isnan,input);
                input(nanIndex) = {0};                 
                Result = cell2mat( input ) ;