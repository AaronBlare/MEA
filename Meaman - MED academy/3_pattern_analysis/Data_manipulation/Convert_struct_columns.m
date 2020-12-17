

function struct = Convert_struct_columns( struct )
% converts all substruct vectors to columns ;

f = fieldnames( struct );
  for i = 1 : length( f)
      if ~iscolumn( struct.( f{i}) )
        struct.( f{i})  =   struct.( f{i})';
      end
  end
  