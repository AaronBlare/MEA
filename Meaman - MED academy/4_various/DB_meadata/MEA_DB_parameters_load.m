% MEA_DB_parameters_load

 
%% ---- DB -------------------
DB_dir_name = 'DB_meadata';     
MATLAB_folder = userpath ; if ~isempty(MATLAB_folder)  MATLAB_folder(end)=[] ; end ;

MEA_DATA_folder = 'C:\Users\User\Documents\MATLAB\DB_meadata'; % Data folder for automatic reanalysis of database files
 %-- Folder with DB mat files for recursive analysis
ANALYSIS_ARG.Path_with_DB_matfiles  = [ MATLAB_folder '\' DB_dir_name ];
ANALYSIS_ARG.DB_dir  = [ MATLAB_folder '\' DB_dir_name ];
% ANALYSIS_ARG.Path_with_DB_matfiles = [];
% ANALYSIS_ARG.Path_with_DB_matfiles = 'S:\MATLAB_DB\DB_meadata_Vuglu_1dec_2013\IN_PROCESS\megatet' ;
% ANALYSIS_ARG.DB_dir  = [ 'S:\MATLAB_DB\' DB_dir_name ];
% userpath reset
%--------------------------------------------------





