
%  MED_AWSR_1ch
function MED_AWSR_1ch( TimeBin , CHANNEL , Arg_file )
if nargin == 0
% if TimeBin == NULL
 TimeBin = 50 ;
 CHANNEL = 1 ;% channel to analyse
 end



[filename, pathname] = uigetfile('*.*','Select file') ;
if filename ~= 0
    filename
awsr = AWSR_file_1ch(filename, pathname , CHANNEL, TimeBin );

% FFT_simple( awsr , TimeBin )

end