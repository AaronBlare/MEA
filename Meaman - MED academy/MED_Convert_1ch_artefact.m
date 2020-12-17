% PROGRAM MED_Convert
% Gets spikes from all files in Files.txt.
% Saves spikes and spike times.
function [ Artefact_file , artefacts_trains_number , ... 
   artefacts_files , artefacts , Artefact_PathName ]    = MED_Convert_1ch_artefact( SIGMATRES , ...
   FILE_LIST_PROCESS , ARTEFACTS_ON ,sigma_from_sec ,  sigma_to_ms , ...
    channel_to_analyze , Arg_plus)


Artefact_file = [];


if nargin == 0
FILE_LIST_PROCESS = 'n' ; % 'y'-process list of files specefied in textfile
SIGMATRES = 8 ;
end


file_in = 'n' ;
if FILE_LIST_PROCESS  ~= 'y'
    if isempty( Arg_plus.filename )
    [filename,PathName] = uigetfile('*.*','Select file');
    else
        filename = Arg_plus.filename ;
        PathName = Arg_plus.PathName ;
    end
        
if filename ~= 0
   file_in = 'y' ; 

fullname = [PathName filename ]; 
if isempty(PathName)
    fullname = filename ;
end 

        c_file = fullname ;
% c_file = filename ;
[pathstr,name,ext  ] = fileparts( c_file ) ;
% DATA_TYPE = ext ;
init_dir = cd ;
if ~isempty(PathName)
cd(  PathName );
end
newdirname = [ 'Test_' char(name) '_' num2str(SIGMATRES,'% 10.1f') '_sigma' ] ;
mkdir(  newdirname  );
cd(  newdirname );
DIR =[ pathstr newdirname ];
n_files = 1 ;
end
else
% list_files = textread(files ,'%s');
[filename, PathName] = uigetfile('*.*','Select file', 'MultiSelect', 'on') ;
if length( filename) > 1
    file_in = 'y' ;
else    
if filename(1) ~= 0
   file_in = 'y' ;
end 
end

if file_in == 'y' 
init_dir = cd ;
% list_files 
list_files = filename ;
list_files{:}
n_files = length(list_files ) ;
end

end

if file_in == 'y' 
for k= 1:n_files %---------------------------------------------------
    
if FILE_LIST_PROCESS == 'y'
c_file = char( list_files{ k } ) 
[pathstr,name,ext,versn] = fileparts( c_file ) ;
% DATA_TYPE = ext ;
dir = c_file( 1 : strfind(   c_file , '.') -1  ) ;
newdirname = [ 'Test_' char(name) '_' int2str(SIGMATRES) '_sigma' ] ;
cd(  PathName  );
mkdir(  newdirname  );
cd( newdirname ) ;
end   

Arg_plus.PathName = pathstr ; 
Artefact_PathName = pathstr;

   [ Artefact_file , artefacts_trains_number , artefacts_files , artefacts ]  =  ...
       MED_Convert_file_1chan_artefacts( c_file , SIGMATRES , ARTEFACTS_ON,sigma_from_sec ,  sigma_to_ms ,channel_to_analyze,Arg_plus ) ;
   
   
Artefact_file
artefacts_trains_number
end


cd( init_dir ) ;
% clear 

end
