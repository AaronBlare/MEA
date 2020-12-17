%Union_2bursts_matfiles


% burst_activation                 % first spikes relative to burst begin
% burst_activation_absolute        % first spikes relative to 0 time
% burst_activation_not_filtered    % first spikes relative to 0 time
% bursts_absolute                  %  spikes relative to burst begin
% bursts_spike_num                 %  spikes number per burst per channel
% bursts                           %  spikes relative to 0
% bursts_not_filtered              %  spikes relative to 0
% One_sigma_in_channels            %  sigma value for each channel
% burst_activation_amps            %  spike amps in first spikes
% Spike_Rates_each_burst                 %  spikes number per burst at all channels
% burst_activation_not_filtered_amps % spike amps in first spikes
% bursts_amps                      %  spike amps in bursts
% bursts_not_filtered_amps         %  spike amps in bursts
% burst_start                      %  burst start times
% burst_end                        %  burst end times
% artefacts                        %  artefact times
% NUMBER_OF_STIMULS                %  number of artefacts

[filename, pathname] = uigetfile('*.*','Select file') ;
 [filename2, pathname2] = uigetfile('*.*','Select file') ;
cd( pathname ) ; 
% index_r = load( char( filename ) ) ;
m1 = load( char( filename ) ) ; 

if filename2 ~= 0 
cd( pathname2 ) ;  
m2 = load( char( filename2 ) ) ;
 
TShift = floor( m1.burst_end(end)  + m1.burst_end(end)*0.05 );
 

    m2.burst_activation_absolute= m2.burst_activation_absolute +TShift;
    m2.bursts_absolute=m2.bursts_absolute   +TShift;
    m2.burst_start = m2.burst_start +TShift;
    m2.burst_end = m2.burst_end +  TShift;
    m2.artefacts = m2.artefacts +  TShift; 
    
    burst_activation=[ m1.burst_activation ; m2.burst_activation ];
    burst_activation_absolute=[ m1.burst_activation_absolute ; m2.burst_activation_absolute ];
    burst_activation_not_filtered=[ m1.burst_activation_not_filtered ; m2.burst_activation_not_filtered ];
    bursts_absolute=[ m1.bursts_absolute ; m2.bursts_absolute ];
    bursts_spike_num=[ m1.bursts_spike_num ; m2.bursts_spike_num ];
    bursts=[ m1.bursts ; m2.bursts ];
    bursts_not_filtered =[ m1.bursts_not_filtered ; m2.bursts_not_filtered ];
    One_sigma_in_channels =[ m1.One_sigma_in_channels ; m2.One_sigma_in_channels ];
    burst_activation_amps =[ m1.burst_activation_amps ; m2.burst_activation_amps ];
    Spike_Rates_each_burst =[ m1.Spike_Rates_each_burst ; m2.Spike_Rates_each_burst ];
    burst_activation_not_filtered_amps  =[ m1.burst_activation_not_filtered_amps ; m2.burst_activation_not_filtered_amps ];
%   bursts_absolute_amps=[  m1.bursts_absolute_amps  m2.bursts_absolute_amps ];
    bursts_amps=[ m1.bursts_amps ; m2.bursts_amps ];
    bursts_not_filtered_amps =[ m1.bursts_not_filtered_amps ; m2.bursts_not_filtered_amps ];
    
    burst_start =[ m1.burst_start ; m2.burst_start ];
    burst_end =[ m1.burst_end ; m2.burst_end  ];
    artefacts =[ m1.artefacts ; m2.artefacts ]; 
NUMBER_OF_STIMULS=[ m1.NUMBER_OF_STIMULS ; m2.NUMBER_OF_STIMULS ] ;




     [pathstr,name,ext,versn] = fileparts( filename ) ;
finame = [ 'Unified_2_files_' name '.mat' ] ; 
finame
cd( pathname ) ; 
eval(['save ' char( finame )...
    ' burst_activation burst_activation_absolute bursts_absolute bursts burst_start burst_end  ' ...
    'burst_activation_not_filtered bursts_not_filtered NUMBER_OF_STIMULS   '...
    ' burst_activation_amps   bursts_absolute bursts_amps  bursts_spike_num  Spike_Rates_each_burst burst_activation_not_filtered_amps  '...
    'One_sigma_in_channels bursts_not_filtered_amps  artefacts -mat']); 
% bursts_spike_num(i,CHANNEL_i) number of spikes per channel per burst
% Spike_Rates_each_burst 


end