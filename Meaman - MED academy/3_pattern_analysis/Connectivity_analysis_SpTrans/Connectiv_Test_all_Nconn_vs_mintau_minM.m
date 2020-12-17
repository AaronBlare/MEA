



% Connectiv_Test_all_Nconn_vs_mintau_minM
 
min_tau_0 = 3 ; min_tau_max = 5 ; min_tau_step = 1 ;
min_M_thr = 0.05 ; min_M_thr_max = 0.3 ; min_M_thr_step = 0.05 ;
min_SpBur_0 = 15 ; min_SpBur_max = 55 ; min_SpBur_step = 5 ;
 
min_tau =  min_tau_0 : min_tau_step : min_tau_max ; 
mnin_strengths = min_M_thr : min_M_thr_step : min_M_thr_max ;
min_SpBur = min_SpBur_0 : min_SpBur_step : min_SpBur_max ;

min_tau_num = length( min_tau ) ; 
min_strength_num = length(  mnin_strengths );
min_SpBur_num = length( min_SpBur ) ;

Number_of_Connections_all = zeros( min_tau_num , min_strength_num , file_number ) ;
Number_of_Connections_all_3d = zeros( min_tau_num , min_strength_num , min_SpBur_num , file_number ) ;
Number_of_Connections_all_characteristic = zeros( min_tau_num , min_strength_num ) ;
Number_of_Connections_all_characteristic_3d = zeros( min_tau_num , min_strength_num , min_SpBur_num ) ;

min_tau_i = 0 ;
min_strength_i = 0 ;

for Connects_min_tau_diff_THR = min_tau_0 : min_tau_step : min_tau_max
    min_tau_i = min_tau_i + 1 ;
    min_strength_i = 0 ;
    tau_min_title{ min_tau_i } = [ 'tau=' num2str( Connects_min_tau_diff_THR )] ;
    
    
    
    for Strength_THR = min_M_thr : min_M_thr_step : min_M_thr_max 
        min_strength_i = min_strength_i + 1 ;
        min_strength_title{ min_strength_i } = ['M=' num2str( Strength_THR )] ;
            
        
            for fi = 1 : file_number    
                %--- calc number of conn using GLOBAL_const.Connects_min_tau_diff ------------
%                 Number_of_Connections = Connectiv_get_N_connections( All_files_data_TOTAL_cell{ 2 , fi } ,...
%                     Connects_min_tau_diff_THR , Strength_THR );
            
                var.default_params  = false;
                var.Check_Spike_Rates = false ;
                var.Connectiv_data_index = fi ;
                 Connectiv_get_N_connections_script   
                %  input 
                % var.default_params 
                % var.Check_Spike_Rates 
                % ( Connectiv_data , Connects_min_tau_diff_THR , ...
                %         Strength_THR , Total_Spike_Rates_thr )
                % output Number_of_Connections Connection_delays
                
                %-------------------------------------------
                Number_of_Connections_all( min_tau_i , min_strength_i , fi ) = Number_of_Connections ;  
            end 
        
            tic
            
        SpBur_thr_i = 0 ;
        for SpBur_thr = min_SpBur_0 : min_SpBur_step : min_SpBur_max 
            SpBur_thr_i = SpBur_thr_i + 1 ;
            SpBur_min_title{ SpBur_thr_i } = [ 'SpBur=' num2str( SpBur_thr )] ;            
            for fi = 1 : file_number    
                %--- calc number of conn using GLOBAL_const.Connects_min_tau_diff ------------
%                 Number_of_Connections = Connectiv_get_N_connections( All_files_data_TOTAL_cell{ 2 , fi } ,...
%                     Connects_min_tau_diff_THR , Strength_THR , SpBur_thr);
                
                var.default_params  = false;
                var.Check_Spike_Rates = true ;
                var.Connectiv_data_index = fi ;
                 Connectiv_get_N_connections_script  
                %  input 
                % var.default_params 
                % var.Check_Spike_Rates 
                % ( Connectiv_data , Connects_min_tau_diff_THR , ...
                %         Strength_THR , Total_Spike_Rates_thr )
                % output Number_of_Connections Connection_delays                
                %------------------------------------------- 
                Number_of_Connections_all_3d( min_tau_i , min_strength_i , SpBur_thr_i , fi ) = Number_of_Connections ; 
            end 
        end
toc
        Number_of_Connections_all_characteristic(   min_tau_i , min_strength_i ) = ...
          100 * std( Number_of_Connections_all( min_tau_i , min_strength_i , : ) )   /  ...
           mean( Number_of_Connections_all( min_tau_i , min_strength_i , : ) ) ;
    end
    
    
    
end



for min_tau_i = 1 : min_tau_num
   for min_strength_i = 1 : min_strength_num
      for SpBur_thr_i = 1 : min_SpBur_num          
          dat = squeeze( Number_of_Connections_all_3d( min_tau_i , min_strength_i , SpBur_thr_i  , : ) );
          Number_of_Connections_all_characteristic_3d(   min_tau_i , min_strength_i , SpBur_thr_i ) = ...
          100 * std( dat )   /  ...
           mean( dat ) ;
      end       
       
   end
    
end


% conn1 =  squeeze( Number_of_Connections_all( 1 , 1 , : ) )
% conn2 =  squeeze(  Number_of_Connections_all_3d( 1 , 1 , 1 , : ) )


% [ tau_stable_i, strength_stable_i ]=find(Number_of_Connections_all_characteristic==min(min(Number_of_Connections_all_characteristic)));
[minM idx] = min(Number_of_Connections_all_characteristic(:));
[tau_stable_i strength_stable_i] = ind2sub(size(Number_of_Connections_all_characteristic),idx); 
tau_stable = min_tau( tau_stable_i );
strength_stable = mnin_strengths( strength_stable_i );


min_SD_3d = min(min(min(Number_of_Connections_all_characteristic_3d))) ;  
[minM idx] = min(Number_of_Connections_all_characteristic_3d(:));
[tau_stable_i_3d strength_stable_i_3d SpBur_stable_i_3d] = ind2sub(size(Number_of_Connections_all_characteristic_3d),idx);
tau_stable_3d = min_tau( tau_stable_i_3d );
strength_stable_3d = mnin_strengths( strength_stable_i_3d );
SpBur_stable_3d = min_SpBur( SpBur_stable_i_3d );
%--- Figuress-------------------------

figure
Nx = 3 ; Ny = 3 ;

subplot( Ny , Nx , 1 )
        Min_tau_select = 1 ;
        ti = find( min_tau >= Min_tau_select ) ;
       plot_2d = squeeze( Number_of_Connections_all( ti(1) , :, : ) ) ;
       plot( 1:file_number , plot_2d )
       xlabel( 'File number')
       ylabel( 'N connections')
       legend( min_strength_title{1:5} ) 
       title( [ 'N conn vs. strength min, tau min=' num2str( Min_tau_select ) ] )

subplot( Ny , Nx , 2 )
        strength_min = 0.05 ;
        si = find( mnin_strengths >= strength_min ) ;
       plot_2d =  ( Number_of_Connections_all( :, si(1) ,  : ) ) ;
       plot_2d = squeeze( plot_2d ) ;
       plot( 1:file_number , plot_2d )
       xlabel( 'File number')
       ylabel( 'N connections')
       title( [ 'N conn vs. tau min, M_m_i_n=' num2str( strength_min ) ] )
       legend( tau_min_title   ) 
       
 subplot( Ny , Nx , 3 )      
       x = min_tau ;
       y = mnin_strengths ;
        bb= imagesc(  x   , y  ,  Number_of_Connections_all_characteristic' );  
        colorbar               
         xlabel( 'tau' )
         ylabel( 'Strength' )         
         title( 'Relative S.D.' )    
 
 
subplot( Ny , Nx , 4 ) 
       plot_2d =  ( Number_of_Connections_all( tau_stable_i(1), strength_stable_i(1) ,  : ) ) ;
       plot_2d = squeeze( plot_2d ) ;
%        plot_2d = squeeze( plot_2d ) ;
       plot( 1:file_number , plot_2d )
       xlabel( 'File number')
       ylabel( 'N connections')
       title( [ 'N conn, tau min=' num2str( tau_stable(1) )  ',M_m_i_n=' num2str( strength_stable(1)  )  ', RSD=' ...
           num2str( min(min(Number_of_Connections_all_characteristic)) )] ) 
        ylim( [ 0 max( plot_2d )*1.1 ])
 
 
subplot( Ny , Nx , 5 )
%         Min_SpBur_select = 1 ;
%         spi = find( min_SpBur >= Min_SpBur_select ) ;
       plot_2d = squeeze( Number_of_Connections_all_3d( ti(1) , si(1) , : , : ) ) ;
       plot( 1:file_number , plot_2d )
       xlabel( 'File number')
       ylabel( 'N connections')
       legend( SpBur_min_title{1:min_SpBur_num} ) 
       title( [ 'N conn vs. Spikes min, tau min=' num2str( Min_tau_select ) ',M_m_i_n='  num2str( strength_min )  ] ) 
        
 
 subplot( Ny , Nx , 6 )        
       x = min_tau ;
       y = min_SpBur ;
       xy = Number_of_Connections_all_characteristic_3d( : , si(1) , : );
       xy = squeeze(xy );
%        Number_of_Connections_all_characteristic_3d(   min_tau_i , min_strength_i , SpBur_thr_i )
        bb= imagesc(  x   , y  ,  xy' );  
        colorbar               
         xlabel( 'tau' )
         ylabel( 'Spikes' )         
         title( 'Relative S.D.' )  
 
  subplot( Ny , Nx , 7 ) 
       plot_2d =  ( Number_of_Connections_all_3d( tau_stable_i_3d(1), strength_stable_i_3d(1) ,  SpBur_stable_i_3d(1) , : ) ) ;
       plot_2d = squeeze( plot_2d ) ;
%        plot_2d = squeeze( plot_2d ) ;
       plot( 1:file_number , plot_2d )
       xlabel( 'File number')
       ylabel( 'N connections')
       title( [ 'N conn, tau min=' num2str( tau_stable_3d(1) )  ',M_m_i_n=' num2str( strength_stable_3d(1)  )  ...
           ',SpBur_m_i_n='  num2str(SpBur_stable_3d(1)) ',RSD=' ...
           num2str( min_SD_3d )] ) 
        ylim( [ 0 max( plot_2d )*1.1 ])
 
       
  subplot( Ny , Nx , 8 ) 
  
       dat  = All_files_data_TOTAL_cell{ 2 , 1 }.Total_Spike_Rates ;
       hist( dat )
       xlabel( 'spikes per channel')
       ylabel( 'N channels')
       title( 'SpBur histogram' )  
       
       
       
       
