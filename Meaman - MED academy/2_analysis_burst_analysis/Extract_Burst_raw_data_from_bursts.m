%
% Extract_Burst_raw_data_from_bursts
% input - raw data, mat file with bursts timings.
% output - raw data in burst timings

 
handles.par.stdmax = 50 ;         %maximum threshold
handles.par.sr = 20000;                     %sampling frequency, in Hz.
MAX_MEMORY_MB =  8000  ; 
low_freq = 550 ;  %  300
hi_freq = 8192  ;  % 3000 



[filename, pathname] = uigetfile('*.*','Select Burst file') ;
if filename ~= 0 

load( [pathname filename] )
Init_dir = cd ;
cd( pathname ) ;    

%+++++++ LOAD analyzed bursts


%------------------------

%+++++ LOAD med mcd file and create folder for aw data
    [datafilename,DataPathName] = uigetfile('*.*','Select raw data file');
    if datafilename ~= 0 
            fullname = [DataPathName datafilename ]; 
        c_file = fullname ;
%         c_file = filename ;
        [pathstr,name,ext,versn] = fileparts( c_file ) ;
        if ext == '.mcd' 
            MCD_converting=true ;  
        end 
        cd(  DataPathName );
        newdirname = [ 'Bursts_RAW_data_' char(name)    ] ;
%         mkdir(  newdirname  );
    %     cd(  newdirname );
        Dest_dir = newdirname;
        DIR =[ pathstr newdirname ];
        n_files = 1 ;
        mkdir(  newdirname  );  
        cd( newdirname ) ;
%--------------------

%++++++ OPEN file data ++++++++
[pathstr,name,ext,versn] = fileparts( fullname ) ;
[pathstr, Experiment_name , ext , versn] = fileparts( fullname ) ;
DATA_TYPE = ext ;
Input_file = fullname 
DATA_TYPE

 
    switch DATA_TYPE
      case '.med'
            a = medload1ch( char(Input_file) , 1  , 'all' , MAX_MEMORY_MB );
            %'1 channel loaded'
           %a = medload( char(file_to_cluster) , 'all' , MAX_MEMORY_MB );
           [pathstr,name,ext,versn] = fileparts ( Input_file ) ;
           
           file_to_cluster = name ;           
           N_channels = 64 ;
           
      case '.txt'      
%            a = load('-ascii', char(file_to_cluster)  );
           DATA_a = importdata(char(Input_file) , ' ', 4);
           a = DATA_a.data ;
           clear DATA_a ;
          file_to_cluster = name ;
           N_channels = 64 ;
      case '.mcd'    
          FILENAME = Input_file ;
          OpenMCDfile_for_reanding 
          
           [pathstr,name,ext,versn] = fileparts ( Input_file ) ;
           file_to_cluster = name ;               
           CH = 60 ;     
           N_channels = 60 ;
    end
    
   switch DATA_TYPE
       case '.mcd' 
       time_offset=FileInfo.TimeStampResolution;
       Trace_Lenght_pionts=TimeSpanSamples;
       Trace_length_sec =  Trace_Lenght_pionts / handles.par.sr  ;   
   case '.med' 
       times = a( : , 1) ;
        time_offset =  times( 1 );
        whos times ;
        Med_note = '' ;
        Trace_Lenght_pionts = length( times ); 
        Trace_length_sec = Trace_Lenght_pionts / handles.par.sr 
        %times = times *1e3/handles.par.sr ;  %1000/sr  - time in ms
%         if Make_binary_traces ~= 'y'  
%             clear  times ;
%             clear  a ;
%          end  
        
   end    
    
   
   
   %---------------------------------
   %---------------------------------
   %---------------------------------
   %---------------------------------
   Burst_Raw_signal = {}  ;
   for bi = 1 : length( burst_start ) 
        Burst_Raw_signal{bi}.Burst_Raw_signal_all_channels = []; 
   end
% for bi = 1 : length( burst_start )   
   %000000000000
%   Burst_Raw_signal_all_channels = [] ;
           
%    Burst_number = bi 
   Total_bursts = length( burst_start )
%    Burst_Raw_signal_all_channels2{bi}.Burst_Raw_signal_all_channels = [];        
           
%  for channel= 1 : N_channels         %that's for cutting the data into pieces  
      for channel= 1 : N_channels         %that's for cutting the data into pieces  
        x = [] ;
        
        switch DATA_TYPE
           case '.med'               
                           
                x = (medload1_without_timestampch( char(Input_file) , channel  , 'all' , MAX_MEMORY_MB ))';   
              
           case '.txt'      
                x =   a( : , channel + 1 )';   
                
           case '.mcd'      
               
                CHANNEL_NUM = channel ;
                Read_MCD_Channel_Data ;
                x=crrData2Save' ;
                clear crrData2Save
                
        end          
       
        channel 
    for bi = 1 : length( burst_start )   
%          whos x
       %  tsmin = (channel-1)*floor(length( data )/handles.par.segments)+1;
        tsmin = 0 ;
        tsmax = floor(length( x ) );
        

            Curr_burst_start = floor( ( burst_start( bi )/1000 ) * handles.par.sr ) ;
            Curr_burst_end = floor( ( burst_end( bi )/1000 ) * handles.par.sr )  ;
            Burst_Raw_signal_one_channel = x(  Curr_burst_start : Curr_burst_end );
%             figure
%             plot( Burst_Raw_signal )
%          Burst_Raw_signal_all_channels = [ Burst_Raw_signal_all_channels  Burst_Raw_signal' ];    
        Burst_Raw_signal{bi}.Burst_Raw_signal_all_channels = [ ...
              Burst_Raw_signal{bi}.Burst_Raw_signal_all_channels  Burst_Raw_signal_one_channel' ];   
%         if channel == 3  
%            sampleCH_data = x' ;
%            sampleCH_data = [ times sampleCH_data ];
%            CH1_tracenfile=[char(file_to_cluster) '_CH1_trace.txt'  ]
%            eval(['save ' char(CH1_tracenfile) ' sampleCH_data -ascii']);   % sample 1 channel trace   
%            clear sampleCH_data ;
%         end 
    end
      
        x = [];   
        
 end       
  
%            sampleCH_data = [ times sampleCH_data ];
           Burst_filename=[char(name) '_Raw_bursts.mat']
           eval(['save ' char(Burst_filename) ' Burst_Raw_signal -mat']);   % sample 1 channel trace   
%            clear sampleC H_data ;
 
 
% end   
% for bi = 1 : length( burst_start )   
%---------------------------------

 cd(Init_dir ) ;



    end
end
    
    
    
    
    
    
    
    
    
    