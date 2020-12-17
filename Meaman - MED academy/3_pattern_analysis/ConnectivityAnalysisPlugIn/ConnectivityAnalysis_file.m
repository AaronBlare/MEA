

% ConnectivityAnalysis_file
function ConnectivityAnalysis_file(   N  , Edit_from  , Edit_to   )

[filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;

if filename ~= 0
    
    plot_on = 1 ;
    warning off    
    [ SigIJ, TimeIJ ] = ConnectivityAnalysis(  filename , N, Edit_from  , Edit_to, plot_on )
    warning on

end