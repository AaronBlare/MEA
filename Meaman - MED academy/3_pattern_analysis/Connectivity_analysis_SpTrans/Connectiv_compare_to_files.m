

% Connectiv_compare_to_files

[filename, pathname0] = uigetfile('*.*','Select file') ;
 
    if filename
       [pathname,name,ext,versn] = fileparts( filename ) ;
  
       [filename2, pathname20] = uigetfile('*.*','Select file') ;
 
        if filename2
           [pathname2,name2,ext2,versn2] = fileparts( filename2 ) ;
           
       if ext == '.mat' & ext2 == '.mat' 
           
           Experiment_name = name ;
           
           % Loading connectiv data -----------------------
           filename
           load( [ pathname0 filename ] );
           if exist( 'ANALYZED_DATA')
           Connectiv_data1 =  ANALYZED_DATA.Connectiv_data ;
           Connectiv_data1_0 =  ANALYZED_DATA.Connectiv_data ;
           ANALYZED_DATA_1=ANALYZED_DATA;
           else
               Connectiv_data1 =  RASTER_data.ANALYZED_DATA.Connectiv_data ;
               Connectiv_data1_0 =  RASTER_data.ANALYZED_DATA.Connectiv_data ;
               ANALYZED_DATA_1= RASTER_data.ANALYZED_DATA ;
           end
           
           
           Connectiv_data = Connectiv_data1  ;
   
           
           s = size( Connectiv_data.Connectiv_matrix_tau_of_max_M  );
           N = s(1) ;
           Connectiv_matrix_statistics_figures
            
           filename2
           load( [ pathname20 filename2 ] );           
           if exist( 'ANALYZED_DATA')
           Connectiv_data2 =  ANALYZED_DATA.Connectiv_data ;
           Connectiv_data2_0 =  ANALYZED_DATA.Connectiv_data ;
           ANALYZED_DATA_2=ANALYZED_DATA;
           else
               Connectiv_data2 =  RASTER_data.ANALYZED_DATA.Connectiv_data ;
               Connectiv_data2_0 =  RASTER_data.ANALYZED_DATA.Connectiv_data ;
               ANALYZED_DATA_2= RASTER_data.ANALYZED_DATA ;
           end
           
%            Connectiv_data2 =  ANALYZED_DATA.Connectiv_data ;
%            Connectiv_data2_0 =  ANALYZED_DATA.Connectiv_data ;
%            ANALYZED_DATA_2=ANALYZED_DATA;
           
           Connectiv_data = Connectiv_data2  ;
           Connectiv_matrix_statistics_figures
           %-----------------------------------------------
           
             
             
             

             
             
           Connectiv_data1 = Connectiv_data1_0 ;
           Connectiv_data2 = Connectiv_data2_0 ;
           
           
           Global_flags.Connects_min_tau_diff = 1 ; % if delay of connection less than this, then this is not connection
           
            Connectiv_Compare_2_connectiv_data_script
            % Input : Connectiv_data1, Connectiv_data2 , Global_flags
            % Output: Comp_result

            
            % Connectiv_data struct :
            % Connectiv_matrix_M_on_tau ( N x N x Connectiv_data.params.tau_number ) 
            % Connectiv_matrix_max_M (NxN) , 
            % Connectiv_matrix_tau_of_max_M ( NxN )
            % max_M - Maximum % of spikes transferred , tau - delay of max_M
            % Connectiv_matrix_tau_of_max_M_vector 
            % Connectiv_matrix_tau_of_max_M_vector_non_zeros
            % Connectiv_matrix_max_M_vector
            % Connectiv_matrix_max_M_vector_non_zeros
            % Connectiv_data.params
           
           
       end
       
        end
    end
    
   