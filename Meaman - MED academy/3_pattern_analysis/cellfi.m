
function Name_index = cellfi( fieldname , field_cell_strings )
% finds match of fieldname (string) in field_cell_strings ( cell array of strings) 
% and returns first index of match
Name_index = strmatch( fieldname , field_cell_strings  ) ;
Name_index = Name_index(1);