
% Find_one_correct_artefact

% from >> MED_Convert_file_1chan_artefacts.m
Artefact_channel_number = 0 ;


        std_intervals_good = Optimal_art_Optimal_Interval_variability_std_sec ;

        [  mi , min_i ] = min( std_intervals_good ) ;

        best_chan_ind = ( min_i(1) ) ;

  Artefact_channel_number = artefacts_all_std_diff_each_chan( best_chan_ind ,1) 
  

  
  xa = artefacts_all_std_diff_each_chan( : ,1) ;
  ya = artefacts_all_std_diff_each_chan( : ,2) ;
  ya(:)= 0 ; 
  ya(best_chan_ind) = artefacts_all_std_diff_each_chan( best_chan_ind ,2);

    if ~isempty( best_chan_ind )
        f2 = bar( xa ,ya , 'r' ) ; 
        xlabel( ['Artifact at channel ' num2str( Artefact_channel_number ) ] )
    end
%   end
  
  

%    rem_module = handles.par.Find_artefact_rem_module  ;
% 
%    art_nums = art_num_all  ;
%    art_nums( art_nums == 0 ) = NaN ;
%     rem10s = rem( art_nums , rem_module ) ;
%    %   good_chan_ind  indexes of channels that has good rem by rem_module
%     good_chan_ind = find( rem10s == 0 ); 
%   if ~isempty( good_chan_ind ) 
%         good_channels =  channel_x ;
%         good_channels_num  = good_channels( good_chan_ind ) ;
% 
%         std_intervals_good = std_art_all( good_chan_ind ) ;
% 
%         [  mi , min_i ] = min( std_intervals_good ) ;
% 
%         best_chan_ind = good_chan_ind( min_i(1) ) ;
% 
%   Artefact_channel_number = artefacts_all_std_diff_each_chan( best_chan_ind ,1) 
%   
% 
%   
%   xa = artefacts_all_std_diff_each_chan( : ,1) ;
%   ya = artefacts_all_std_diff_each_chan( : ,2) ;
%   ya(:)= 0 ; 
%   ya(best_chan_ind) = artefacts_all_std_diff_each_chan( best_chan_ind ,2);
% 
%     if ~isempty( best_chan_ind )
%         f2 = bar( xa ,ya , 'r' ) ; 
%         xlabel( ['Artifact at channel ' num2str( Artefact_channel_number ) ] )
%     end
%   end
%      









