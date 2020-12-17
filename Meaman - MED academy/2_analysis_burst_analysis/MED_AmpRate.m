% MED_AmpRate
function MED_AmpRate( TimeBin )
if nargin == 0
% if TimeBin == NULL
 TimeBin = 50 ;
 end

[filename, pathname] = uigetfile('*.*','Select file') ;

if filename ~= 0
filename
AmpRate_file(filename , pathname , TimeBin);

end