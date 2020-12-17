fid = fopen('activ.txt', 'w'); 
F1_txt = {'Chambers_A_B_evoked_percent';'Chambers_A_Spikes_per_sec' ; 'Chambers_A_Amps_mean_all_spikes';  'Chambers_A_Nbursts_per_min';  'Chambers_A_Amp_mean_bursts'; 'A_InteBurstInterval'; 'A_BurstDurations'; ...
    'A_Active_channels_number';  'Chambers_B_A_evoked_percent'; 'Chambers_B_Spikes_per_sec'; 'Chambers_B_Amps_mean_all_spikes';  'Chambers_B_Nbursts_per_min';  'Chambers_B_Amp_mean_bursts'; 'B_InteBurstInterval'; 'B_BurstDurations'; 'B_Active_channels_number' };


Burst_dur_A_txt = median (ANALYZED_DATA.ANALYZED_DATA_A.BurstDurations);
Burst_dur_B_txt = median(ANALYZED_DATA.ANALYZED_DATA_B.BurstDurations);
Inter_Burst_A_txt =  median (ANALYZED_DATA.ANALYZED_DATA_A.InteBurstInterval);
Inter_Burst_B_txt = median (ANALYZED_DATA.ANALYZED_DATA_B.InteBurstInterval);

F2_txt = [ANALYZED_DATA.Chambers_A_B_evoked_percent; ANALYZED_DATA.Chambers_A_Spikes_per_sec; ANALYZED_DATA.Chambers_A_Amps_mean_all_spikes;  ANALYZED_DATA.Chambers_A_Nbursts_per_min;  ANALYZED_DATA.Chambers_A_Amp_mean_bursts; Inter_Burst_A_txt; ...
    Burst_dur_A_txt; ANALYZED_DATA.ANALYZED_DATA_A.Active_channels_number; ANALYZED_DATA.Chambers_B_A_evoked_percent; ANALYZED_DATA.Chambers_B_Spikes_per_sec; ANALYZED_DATA.Chambers_B_Amps_mean_all_spikes;  ANALYZED_DATA.Chambers_B_Nbursts_per_min; ...
    ANALYZED_DATA.Chambers_B_Amp_mean_bursts; Inter_Burst_B_txt; Burst_dur_B_txt;  ANALYZED_DATA.ANALYZED_DATA_B.Active_channels_number];
% F_txt = [F1_txt, F2_txt];
fprintf(fid, '%.4f\r\n', F2_txt'); 
fclose(fid);