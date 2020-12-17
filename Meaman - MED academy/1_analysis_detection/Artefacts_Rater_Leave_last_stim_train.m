


% Artefacts_Rater_Leave_last_stim_train
% takes artefacts raster recorded from Nlearn and deletes all "spikes"
% before last "spike train"



[filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;


 index_r = load( char( [ pathname filename ] ) ) ;  
 
% cd( pathname ) ;
filename
 
 
    
CH = 1 ;
ind_chan = find( index_r(:,2) == CH ) ;
chan_times = index_r( ind_chan ,1) ;
y=1:length( chan_times );
figure
subplot( 2,1,1)
plot(  y(2:end) , diff( chan_times ) )
subplot( 2,1,2)
plot(  y , ( chan_times ) )

mean_IAI = mean(  diff( chan_times( end - 10 : end ))) ;
last_train_start_ind = 1 ;
last_train_start_time = 1 ;
for ai =  length( chan_times )-11 : -1 : 1 
    if chan_times( ai+1 ) - chan_times( ai) > mean_IAI *2 & last_train_start_ind == 1
        last_train_start_ind = ai  ;        
        last_train_start_time = chan_times( ai );
    end
end

index_r(1:last_train_start_ind,:) = [] ;

ind_chan = find( index_r(:,2) == CH ) ;
chan_times = index_r( ind_chan ,1) ;
y=1:length( chan_times );
figure
plot( chan_times , y )
    

currdir = cd ;
% Raster_file = [ char(name) '_' str_from '-' str_to '_sec' ext ] ;
         [pathname,filename,ext,versn] =  fileparts( filename ) ; 
 fid = fopen( [ pathname filename '_last_train.txt' ]   , 'w');
 [a,p] = size(index_r);

 
 if p == 2
fprintf(fid, '%.3f  %d\n', index_r');     
 end 
 cd( pathname )
fclose(fid);
cd( currdir );



