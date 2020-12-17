
%  MED_AWSR_Find_Bursts
function ANALYZED_DATA = MED_AWSR_Find_Bursts( filename ,  Search_Params)
% function MED_AWSR_Find_Bursts( filename , TimeBin , AWSR_sig_tres , save_bursts_to_files  , Arg_file , Search_Params)
% input: raster filename 
% output: mat file with burst characteristics
%
% Alex Pimashkin, October 2010, Neuro.nnov.ru

SHOW_FIGURES = Search_Params.Show_figures ;
Anallysis_Figure_title = [] ;
if nargin == 0
% if TimeBin == null
% TimeBin = 1000 ; % super burst
TimeBin = 50 ; % burst
AWSR_sig_tres = 1 ;
end

params.show_detection_bursts  = false ;
N_origin = 60 ;

%%%%%%%%%%%%%%%%%%%%%%%%%
GLOBAL_CONSTANTS_load
%%%%%%%%%%%%%%%%%%%%%%%%%

Arg_file = Search_Params.Arg_file ;
%------ Load raster file --------
    % [filename, pathname] = uigetfile('*.*','Select file') ;
    % if filename ~= 0 
    % 
    % Init_dir = cd ;
    % cd( pathname ) ;    
    MED_file_raster_input  =false;
    if filename == 0
        if Arg_file.Use_meaDB_raster %----------- load raster from DB
            [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
                = Load_raster_from_RASTER_DB( Arg_file.Experiment_name , Arg_file.Sigma_threshold ); 
        else  %----------- load raster from file     
          MED_file_raster_input  =false;
        end
    else
        Raster_exists = true ;
    end 

    Original_filename = filename ;
           [pathstr,name,ext] = fileparts( filename ) ; 
           if  ext == '.mat'  %----Load from MAT_raster.mat file
             load( char( filename ) ) ;  
             index_r = RASTER_data.index_r ;
             MED_file_raster_input  = true ;
           else
             index_r = load( char( filename ) ) ;  
             Experiment_name = name ;
             Sigma_threshold = 0 ;
           end  
       
           
         [pathstr,name,ext] = fileparts ( filename ) ;    
           
         Raster_exists = true ;
         ready_to_analyze =  Raster_exists ;
         
         
        Experiment_name0 = Experiment_name ;
        
         
Find_bursts_main_script

