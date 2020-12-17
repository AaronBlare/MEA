% MED_AmpRate_1ch
function MED_AmpRate_1ch( TimeBin , CHANNEL )
if nargin == 0
% if TimeBin == NULL
 TimeBin = 50 ;
 end

[filename, pathname] = uigetfile('*.*','Select file') ;

if filename ~= 0
filename
AmpRate_file_1ch(filename , pathname , CHANNEL ,TimeBin);

end