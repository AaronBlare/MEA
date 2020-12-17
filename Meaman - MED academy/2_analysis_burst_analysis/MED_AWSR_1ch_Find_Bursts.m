
%  MED_AWSR_1ch_Find_Bursts
function MED_AWSR_1ch_Find_Bursts( TimeBin , CHANNEL , AWSR_sig_tres )
if nargin == 0
% TimeBin = 1000 ; % super burst
TimeBin = 50 ; % burst
AWSR_sig_tres = 1 ;
CHANNEL = 1 ;% channel to analyse
end


[filename, pathname] = uigetfile('*.*','Select file') ;
if filename ~= 0 


Init_dir = cd ;
cd( pathname ) ;    
    
AWSR = AWSR_file_1ch(filename, '-' , CHANNEL , TimeBin );
[burst_start,burst_max,burst_end] = Extract_bursts( AWSR ,TimeBin , AWSR_sig_tres) ;


if 1 > 0
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_AWSR_Bursts_' int2str(TimeBin) 'ms_TimeBin_Channel' int2str(CHANNEL) '.fig' ] ;
saveas(gcf,  figname ,'fig');
end
cd( Init_dir ) ;

end