% Raster_file
function Raster_file(filename , pathname , Arg_file , params_raster )
% input:  filename pathname
% output: 
% Alex Pimashkin, October 2010, Neuro.nnov.ru

SAVE_PLOT_TO_FILE = 'y' ;

GLOBAL_CONSTANTS_load

if nargin == 3
    params_raster.awsr_raster_on_single_plot = false ;
    
end
if nargin == 4
    Search_Params = params_raster.Search_Params ;
end
 params_raster.awsr_raster_on_single_plot = true ;

init_dir = cd ;
Using_DB_data = false ;

Old_school_raster_presentation = false;
Raster_show_color_amplitudes  = GLOBAL_const.Raster_show_color_amplitudes ;
Raster_show_color_amplitudes_minAmp = GLOBAL_const.Raster_show_color_amplitudes_minAmp ;


% if isfield( Arg_file , 'Use_meaDB_raster' )
if Arg_file.Use_meaDB_raster %----------- load raster from DB
    [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
        = Load_raster_from_RASTER_DB( Arg_file.Experiment_name , Arg_file.Sigma_threshold ); 
    Using_DB_data = true ;
else     %----------- load raster from file
[filename, pathname] = uigetfile('*.*','Select file') ;    
[pathstr,name,ext] = fileparts( filename ) ; 
   if  ext == '.mat' 
        load( char( [ pathname filename ] ) ) ;  
        if exist( 'RASTER_data' , 'var')
            if isfield( RASTER_data , 'index_r' )
                index_r = RASTER_data.index_r ;
            end
        end
        
        if exist( 'RASTER_data' , 'var')
            if isfield( RASTER_data , 'index_r' )
                index_r = RASTER_data.index_r ;
            end
        end
   else
         % opens file and looks if it has ',' in line. If yes, then change ',' to
     % '.' in all lines and save to the same file
     Correct_delimiter_to_point_save( [ pathname filename ] )   
     index_r = load( char( [ pathname filename ] ) ) ;  
   end
cd( pathname ) ;
filename

Raster_exists = true ;
end

if Raster_exists %------------------- Data from experiment loaded, work next
    
% CH = 1 ;
% ind_chan = find( index_r(:,2) == CH ) ;
% chan_times = index_r( ind_chan ,1)/1000 ;
% y=1:length( chan_times );
% figure
% plot( chan_times , y )
% ylabel( 'spike number')
% xlabel( 'spike time, sec')
% title( 'Spike time in channel 1');
 
    
 mint = min( index_r(:,1) );
 maxt = max(  index_r(:,1) );
 if maxt - mint < mint 
    index_r(:,1) = index_r(:,1) - mint + 100 ;  
 end
 
%  isis = index_r(:,1) ;
%  isis = diff( isis );
%  isis( isis < 0 )=[];
%  isis( isis > 3  ) = [] ;
%  figure
%    hist( isis , 50 );
%  min_isi = min( isis ) ;

    
if Arg_file.Use_6well_mea
    
    Six_well_processing
    
else
    
    %//// Draw double figure with awsr and raster
     if params_raster.awsr_raster_on_single_plot
         
          
            figure     
            
%             Old_school_raster_presentation
%             index_r
            Plot_Raster_from_index_r 
            
         
     end
     
     %///// Raster ////////////
     
     if ~GLOBAL_const.Raster_plot_only_AWSR_raster
               %-------- RASTER ------------------------ 
                % N = 64 ;
                figure
                Tmax = max( index_r( : , 1 )/1000 ) ;
                N = max( index_r( : , 2 )  ) ;

                % set(gcf,'position');

                if Old_school_raster_presentation
                    plot( index_r(:,1)/1000 , index_r(:,2) , '.','MarkerEdgeColor',[.04 .52 .78] )
                else
                    vertHexX=[  0 0     ] ;
                    vertHexY=[  0 0.5       ] ; 
                    plotCustMark(  index_r(:,1)/1000  , index_r(:,2) ,vertHexX,vertHexY, 1.5)
                end 

                axis( [ 0 (Tmax+min(index_r(:,1))/1000) 0 N+1 ] )
                xlabel( 'Time, s' )
                ylabel( 'Electrode' )
 
     end
     
end

 
if SAVE_PLOT_TO_FILE == 'y' 
figname = [ name '_plot.fig' ] ;
saveas(gcf,  figname ,'fig');
end


cd(init_dir)

end