% MED_AWSR
function MED_AWSR( TimeBin , Arg_file)
if nargin == 0
% if TimeBin == NULL
 TimeBin = 50 ;
 end

Using_DB_data = false ;
init_dir = cd ;


if Arg_file.Use_meaDB_raster %----------- load raster from DB
    [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
        = Load_raster_from_RASTER_DB( Arg_file.Experiment_name , Arg_file.Sigma_threshold ); 
    Using_DB_data = true ;
else     %----------- load raster from file
[filename, pathname] = uigetfile('*.*','Select file') ;    
[pathstr,name,ext] = fileparts( filename ) ; 
   if  ext == '.mat' 
        load( char( [ pathname filename ] ) ) ;  
        index_r = RASTER_data.index_r ;
   else
         % opens file and looks if it has ',' in line. If yes, then change ',' to
     % '.' in all lines and save to the same file
     Correct_delimiter_to_point_save( [ pathname filename ] )   
     index_r = load( char( [ pathname filename ] ) ) ;  
   end
cd( pathname ) ;
filename

Raster_exists = true ;
end


if Raster_exists %------------------- Data from experiment loaded, work next



% awsr = AWSR_file(filename , pathname , TimeBin);
 awsr = AWSR_from_index_r( index_r  , TimeBin );

% FFT_simple( awsr , TimeBin )

AWSR_sig_tres = 00.1 ;
Spike_Rates_each_burst_tot = [];
SigTres=[];

% for AWSR_sig_tres=0.000 :0.05:0.5
%   [burst_start,burst_max,burst_end , InteBurstInterval , BurstDurations,Spike_Rates_each_burst]= ...
%         Extract_bursts( awsr , TimeBin , AWSR_sig_tres )
%     Spike_Rates_each_burst_tot = [ Spike_Rates_each_burst_tot mean(Spike_Rates_each_burst) ] ;
%     SigTres=[SigTres AWSR_sig_tres];
%     close all
% end
% whos Spike_Rates_each_burst_tot
% whos SigTres
% figure
% plot( SigTres , Spike_Rates_each_burst_tot)




% amprate = AmpRate_file(filename , pathname , TimeBin);

% figure 
% scatter( amprate , awsr ) ;
end
end