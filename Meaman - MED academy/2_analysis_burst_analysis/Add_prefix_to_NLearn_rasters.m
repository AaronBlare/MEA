% Add_prefix_to_NLearn_rasters
% Selec dir - scans all Nlearn_RASTER.txt in all subfolders and add prefix
% 2012_12_12\01_ctrl\Nlearn_RASTER.txt will be
% ...\2012_12_12_01_ctrl_Nlearn_RASTER.txt


folder_name = uigetdir ;
filename = dir2( folder_name ,'Nlearn_RASTER');


        n_files = length( filename ) ;
        n_files
        for k= 1:n_files         
            [pathstr,name,ext] = fileparts( filename{ k } ) ;
            PathName_all_subfolders{k} = pathstr ;
            pathstr;
            slash_i = find( pathstr == '\'  );
            if length( slash_i ) > 2
                pathstr_modified = pathstr ;
                pathstr_modified( slash_i(end) )= '-' ;
                pathstr_modified( slash_i(end-1) )= '-' ;
                New_Prefix = pathstr_modified( slash_i(end-2)+1:end);
                New_filename_k = [ New_Prefix '__' name ext ]
                New_fullname_k = [ pathstr '\' New_filename_k ] ;
                New_fullname_k
                copyfile( filename{ k }  , New_fullname_k ); 
                delete( filename{ k }   ); 
            end
        end














