
%  AWSR_file
function  AWSR = AWSR_file(filename, pathname , TimeBin )

if  filename ~= 0 
dT  = TimeBin ; % bin  in ms 

currdirr = cd ;


SAVE_PLOT_TO_FILE = 'y' ;
if pathname == '-'
%     SAVE_PLOT_TO_FILE = 'n' ;
end    



[pathstr,name,ext ] = fileparts( filename ) ;
Init_dir = cd ;
if SAVE_PLOT_TO_FILE == 'y' 
%     cd( pathname ) ; 
end



DATA_TYPE = ext ; 

if DATA_TYPE == '.txt'
index_r = load(  char( filename )  ) ; 
else
  load(  char( filename )  ) ; 
end

 AWSR = AWSR_from_index_r( index_r , TimeBin );






cd( Init_dir ) ;
%Fireratefile =[char(file) '_FireRate.txt'  ] ;
%eval(['save ' char(Fireratefile) ' Rate -ascii']);  
end 

