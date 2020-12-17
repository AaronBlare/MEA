
%  Spike_ISI_histogram
[filename, pathname] = uigetfile('*.*','Select file') ;
Init_dir = cd ;
cd( pathname ) ;




SAVE_PLOT_TO_FILE = 'n' ;

[pathstr,name,ext,versn] = fileparts( filename ) ;

DATA_TYPE = ext ;

Intervals = load(  char( filename )  ) ;

Intervals = sort( Intervals  , 'ascend' );

% ISI = diff( Intervals ) ;
ISI = Intervals ;
Median_ISI = median( ISI ) ;
Mean_ISI = mean( ISI ) ;
STD_max_ISI = std( ISI )  ;
Median_ISI
Mean_ISI
STD_max_ISI

figure
%xh = 0:1:max( ISI ); 
hist( ISI ) ;
ylabel('max_ISI')






 

if SAVE_PLOT_TO_FILE == 'y' 
saveas(gcf,'AWSR.bmp','bmp');
end

cd( Init_dir ) ;

%Fireratefile =[char(file) '_FireRate.txt'  ] ;
%eval(['save ' char(Fireratefile) ' Rate -ascii']);  
 