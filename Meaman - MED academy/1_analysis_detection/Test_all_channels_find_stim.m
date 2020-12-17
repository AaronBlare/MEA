%  Test_all_channels_find_stim
% output : CHANNEL_NUM

%   figure
%                hold on
%                x_glob = [] ;
%                Tmax_f = 20000 * 10 ;
%                
%                Nc = 60 ;
%                Nc = channel_to_analyze

cut_signal = 0 ;
if handles.par.ARTEFACT_search_around_always_test_all_channels 
    channel_to_analyze_art = [ 1 : 60 ] ;
    cut_signal = [ 20 100 ] ; % take from - to % of signals ;
end


 x_glob = [] ;
if exist( 'Collect_all_art_signals' , 'var')
    Collect_all_sig  = Collect_all_art_signals ;
    
else
    Collect_all_sig  = false ;
end

% Art_amp = 2 ;
 Art_amp =  handles.par.Art_auto_search_thres_AMP;
Channel_art_f = [] ;
Channel_art_s  = [] ;
CHANNEL_NUM_all = [] ;
CHANNEL_NUM2d_all = [] ;
CHANNEL_NUM_all_string = {};
               
    for chi = 1 : length( channel_to_analyze_art )       %that's for cutting the data into pieces
        % LOAD CONTINUOUS DATA
       % eval(['load ' char(file_to_cluster) ';']);       
        
        
        CHANNEL_NUM = channel_to_analyze_art( chi ) ;
        
        [ channel_number_str , channel_number2d ]  = Meaman_electrode_num_1d_to_2d( CHANNEL_NUM ) ;
        
        
         CHANNEL_NUM_all  = [ CHANNEL_NUM_all   CHANNEL_NUM  ] ;
       CHANNEL_NUM2d_all = [ CHANNEL_NUM2d_all  channel_number2d ] ;
%          Reading_MC_Channel_Data = CHANNEL_NUM
%          ticD
        Read_MCD_Channel_Data ;
%         toc
%         figure ; plot(   crrData2Save )

if cut_signal ~= 0 
    ll = length( x ) ;
    cut_signal_fr = [ 1 + floor( ll * (cut_signal( 1 ) / 100 ))   floor( ll * (cut_signal( 2 ) / 100 )) - 1 ] ;
%     ll 
%     cut_signal_fr
    x( cut_signal_fr(1) :  cut_signal_fr(2) ) = [] ;
end
        
        n_peak = find( x > Art_amp )  ;
        stdf = std( n_peak) ;
        Channel_art_f = [ Channel_art_f numel( n_peak ) ] ;
        Channel_art_s = [ Channel_art_s stdf ] ;
        
%         clear crrData2Save
if Collect_all_sig
         x_glob = [  x_glob ;  diff(x)  ] ;
end
        
    end
    
    [ c_peak , n_c_peak ] = max( Channel_art_f ) ;
      [ c_peak , n_c_peak ] = max( Channel_art_s ) ;
%       figure
%         plot(channel_to_analyze_art , Channel_art_s , '*' ) 
%     figure
%      bar(  Channel_art_s  )
 
 
    
    CHANNEL_NUM_max =  channel_to_analyze_art( n_c_peak )
      
        CHANNEL_NUM = channel_to_analyze_art( n_c_peak ) ;
        
        
if Collect_all_sig
    figure 
%   tic
       plot(  x_glob' )
       ylabel( 'Voltage diff')
       legendCell = cellstr(num2str(CHANNEL_NUM2d_all', 'electrode z%-d')) ;
       legend( legendCell ) ;
       
%      toc
end     
        
        
%          Reading_MC_Channel_Data = CHANNEL_NUM
%          
%         Read_MCD_Channel_Data ;
%     
%     figure
%  plot(   x )

 
 
 
% ticD

%     figure
% plot( x_glob' )





