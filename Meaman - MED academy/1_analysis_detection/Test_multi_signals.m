%  Test_multi_signals


%   figure
%                hold on
               x_glob = [] ;
               Tmax_f = 20000 * 10 ;
%                
%                Nc = 60 ;
%                Nc = channel_to_analyze

channel_to_analyze_art = [ 1 : 4 ] ;

Art_amp = 2 ;

Channel_art_f = [] ;

Searching_electrode_with_artifacts = 1 ;
               
    for chi = 1 : length( channel_to_analyze_art )       %that's for cutting the data into pieces
        % LOAD CONTINUOUS DATA
       % eval(['load ' char(file_to_cluster) ';']);       
        
        
        CHANNEL_NUM = channel_to_analyze_art( chi ) ;
%          Reading_MC_Channel_Data = CHANNEL_NUM
%          ticD
        Read_MCD_Channel_Data ;
%         toc
%         figure ; plot(   crrData2Save )
        
        crrData2Save( Tmax_f : end) = [] ;  
         x_glob = [  x_glob ;  crrData2Save' ] ;
        
    end
    
    figure
    plot( x_glob') 
    
    
        fid = fopen('original_signals.txt', 'w');

% fprintf(fid, '%.5f \n', dax );
fprintf(fid, '%.4f\t \n', x_glob );

fclose(fid);


%     save( 'Signals_test.txt'
 
    
% plot( x_glob' )




