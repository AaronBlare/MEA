
% Response threshold for total spikes in all channels
Thres_spikes_binary_response =   input('input significant response threshold (spikes num [2])') 

% Response threshold for spikes in single channel
Thres_spikes_binary_response_single_chan = 4 ;


Stimuli_per_channel = 5 ;
% Channel_step = 5 ;


% input file should be matrix - columns = channels , rows = stimulus number
[filename, pathname] = uigetfile('*.*','Select file') ;
% Poststim spikes ( channel, stim number)
Ps_ch_s = importdata([ pathname filename ]); 
Ps_ch_s = Ps_ch_s' ;
a = size( Ps_ch_s ) ;
stim_number = a(2) ;

Number_of_stim_channels = stim_number / Stimuli_per_channel ;

% sum all channels to total response for each stim
Ps_all_ch_s = []; Ps_all_ch_s_binary = [];
for s = 1 : stim_number
  Total_spikes_all_channels =   sum( Ps_ch_s( : , s )) ;
  Ps_all_ch_s = [Ps_all_ch_s Total_spikes_all_channels ];
  Ps_all_ch_s_binary = [ Ps_all_ch_s_binary H( Total_spikes_all_channels - Thres_spikes_binary_response ) ];  
end

% statistics for responses for each stim channel 
Responses_trial_sum=zeros( 60,1);
Mean_responses_stim_all_channels= zeros( 60,1);
Mean_responses_stim = zeros( Number_of_stim_channels,1);
Percent_responses_stim_all_channels = zeros( 60,1);
Percent_responses_stim = zeros( Number_of_stim_channels ,1);
PSS_s = [] ;
PSS_binary =[];

Number_of_stim_channels 

for i =1 : Number_of_stim_channels   
    responses_stim_trial  = Ps_all_ch_s( (i-1)*Stimuli_per_channel  + 1  : (i )*Stimuli_per_channel ); 
    whos responses_stim_trial
    PSS_s = [ PSS_s responses_stim_trial' ];
    responses_stim_trial_binary = Ps_all_ch_s_binary( (i-1)*Stimuli_per_channel + 1: (i )*Stimuli_per_channel );
    PSS_binary = [ PSS_binary responses_stim_trial_binary' ] ;
    Responses_trial_sum( (i)*Stimuli_per_channel )  =    sum(  responses_stim_trial')  ;
    Mean_responses_stim_all_channels( (i    )*Stimuli_per_channel)  =     mean(  responses_stim_trial')  ;
    Mean_responses_stim(  i )  =     mean(  responses_stim_trial')  ;
    Percent_responses_stim_all_channels( (i   )*Stimuli_per_channel)= 100*  mean(  responses_stim_trial_binary')  ;
    Percent_responses_stim( i ) = 100*  mean(  responses_stim_trial_binary')  ;
end
PSS_s;
PSS_binary;

Mean_responses_stim_all_channels
Percent_responses_stim_all_channels
Mean_responses_stim 
Percent_responses_stim


figure
subplot( 2 , 1 , 1)
bar( Mean_responses_stim_all_channels )
xlabel( 'Stim channel #')
ylabel( 'Mean total spikes in response')

subplot( 2 , 1 , 2)
bar( Percent_responses_stim_all_channels )
xlabel( 'Stim channel #')
ylabel( '% of significant responses')


save(   [ pathname 'Stim_channel_responses' ] , 'Mean_responses_stim_all_channels' , 'Percent_responses_stim_all_channels' );

