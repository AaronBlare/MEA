% Load2Raters_MannWitney

% filename2 = 0 ;
random_channel = 'n' ; 

STIM_RESPONSE_BOTH_INPUTS =  0.6 ;
N = 64 ;

CHECK_SPIKES_NUM_IN_BOTH_RASTERS = 'n' ;
MOTIF_AS_RATE = 'n' ; % Patterns as spike rate on each electrode
CYCLE_NUM_SIGNIFICANT_ELECTRODES = 'n' ;

SHOW_FIGURES = 'y' ;
one_burst_part_at_all = 'n' ;
Show_pattern_dur_hist = 'n';

one_burst_from = 2000 ;
one_burst_to = 2300 ;
TOTAL_ANAYSIS_DATA = [] ;

cd( pathname ) ; 
m1 = load( char( filename ) ) ;
if filename2 ~= 0 
cd( pathname2 ) ; 
m2 = load( char( filename2 ) ) ;
else
    m2 = m1 ;
end

Nb = length( m1.burst_start );          % Number of bursts
Nb2 = length( m2.burst_start ) ;         % Number of bursts


% [burst_start,burst_max,burst_end,InteBurstInterval , BurstDurations,Spike_Rates_each_burst]  = Extract_bursts( AWSR ,TimeBin , AWSR_sig_tres) ;

[pBurstDurations,StatisitcallyDifferent_if1] = ranksum(m1.BurstDurations,m2.BurstDurations );  
BurstDurations_StatisitcallyDifferent_1 = StatisitcallyDifferent_if1;
[pInteBurstInterval,StatisitcallyDifferent_if1] = ranksum(m1.InteBurstInterval,m2.InteBurstInterval );  
InteBurstInterval_StatisitcallyDifferent_1 = StatisitcallyDifferent_if1;
[pSpike_Rates_each_burst,StatisitcallyDifferent_if1] = ranksum(m1.Spike_Rates_each_burst,m2.Spike_Rates_each_burst );  
 Spike_Rates_each_burst_StatisitcallyDifferent_1 = StatisitcallyDifferent_if1 ;
 
 pBurstDurations
 pInteBurstInterval
 pSpike_Rates_each_burst

BurstDurations_StatisitcallyDifferent_1
InteBurstInterval_StatisitcallyDifferent_1
Spike_Rates_each_burst_StatisitcallyDifferent_1



