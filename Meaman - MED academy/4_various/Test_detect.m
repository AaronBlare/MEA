
% Test_detect



close all
load Raster_only_pause_one_chan_12_2018_08_06_h2d16_h5d16_d16_stim_z42_plus800_isi3
handles.par.Filtered_channel_save = false  ;
[spikes,thr,index,amps,one_sigma_thr,artefacts,option_data, artefact_amps] = ...
                amp_detect3_artefacts_copy(               handles, Collect_sigma_from  , Collect_sigma_to , 'n' );
       