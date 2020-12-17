% PROGRAM med2txt_convertor
% Gets spikes from all files in Files.txt.
% Saves spikes and spike times.




MAX_MEMORY_MB = 3000  ;          % Memory limit for .dat .med load
CH = 64  ;                        % number of channels to convert


files = uigetfile('*.*','Select file');
[pathstr,name,ext,versn] = fileparts( files ) ;
 
DATA_TYPE = ext ;
mkdir(  name  );
init_dir = cd ;
cd(  name );

    tic
    file_to_cluster = files ;

           a = medload( char(file_to_cluster) , 'all' , MAX_MEMORY_MB );
           [pathstr,name,ext,versn] = fileparts ( file_to_cluster ) ;
           file_to_cluster = name ;           


           
    TXT_file =[char(file_to_cluster) '_TXT_data.txt'  ] 
    dlmwrite(TXT_file , a ,'delimiter', '\t' )

      % TXT_file=[char(file_to_cluster) '_TXT_data_2.txt' ]    
       %eval(['save ' char(TXT_file) ' a -ascii']); 

    toc    
 
cd( init_dir ) ;
clear ;
