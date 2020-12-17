function [ numc1 , numc2 , ISI] =  meaman_extract_file_param( name )


numc1 = 0  ;
numc2 = 0 ;
 ISI =  0 ; 
% name = '15_2018_06_04_h1h5_d13_stim_z52_z67_minus800_p30' 
%    name = '01_2018_06_04_h5_d18_z36_stim_minus200_p30' ;
   
% l1 = 'stim' ;
% 
% k = strfind(name, l1 ) ; 
% 
% numc_str = name( k : end ) ;

numc_str = name ;

GLOBAL_CONSTANTS_load 

prefix_str =  handles.par.Stim_chan_prefix_str ;
% handles.par.Stim_chan_prefix_str = '_z' ;
% prefix_str = handles.par.Stim_chan_prefix_str ;
           % prefix_str = '_z'  ;
            % prefix_str = '_el'  ;


% k = strfind(numc_str,'_z'  ) ; 
% k = strfind(numc_str,'_el'  ) ; 
k = strfind(numc_str,prefix_str  ) ; 
lpref = length( prefix_str) - 1 ;

if isempty( k )
    prefix_str  =   '_el' ;
end

k = strfind(numc_str,prefix_str  ) ; 
lpref = length( prefix_str) - 1 ;

if ~isempty( k )
    
    if length( k ) > 0 
       numc1 =  numc_str( k(1)+lpref + 1   : k(1) + lpref + 2 ) ; 
       
       c12 = num2str( numc1 ) ;
       c1 = c12(1);
       c2= c12(2) ;
    x1 = str2num( c1 ) ;
    y1 = str2num( c2 ) ;
    
   load( 'MEAchannel2dMap.mat');   
   
   N = 60 ;
        for i = 1 : N    
          if  MEA_channel_coords(i).chan_Y_coord  == y1 && ...
            MEA_channel_coords(i).chan_X_coord  == x1 
                numc = i ;
          end
        end
   
        
        numc1 = numc ;
       Channel_1_found_2d_number = numc  
    end
    
 if length( k ) == 2 
%       numc2 =  numc_str( k(2)+1 : k(2) + 3 ) ;   
      numc2 =  numc_str( k(2)+lpref + 1   : k(2) + lpref + 2 ) ; 
      
      
          c12 = num2str( numc2 ) ;
       c1 = c12(1);
       c2= c12(2) ;
    x1 = str2num( c1 ) ;
    y1 = str2num( c2 ) ;
    
   load( 'MEAchannel2dMap.mat');   
   
   N = 60 ;
        for i = 1 : N    
          if  MEA_channel_coords(i).chan_Y_coord  == y1 && ...
            MEA_channel_coords(i).chan_X_coord  == x1 
                numc = i ;
          end
        end
   
        
        numc2 = numc ;
     Channel_2_found_2d_number = numc2   
       
       
 end
 
 
 prefix_str =  handles.par.Stim_ISI_prefix_str ;

 k = strfind(numc_str,prefix_str  ) ; 
lpref = length( prefix_str) - 1 ;
    
if ~isempty( k )
    
    
    if length( k ) > 0 
       isi_str =  numc_str( k(1)+lpref + 1   : k(1) + lpref + 2 ) ; 
       
       [ isi_num0 , status ] = str2num( isi_str ) ;
       
       if ~status
           [ isi_num0 , status ] = str2num( isi_str(1) ) ;
       end
       
       if  status
          ISI = isi_num0 ; 
          Found_ISI_sec = ISI
       end
    end
end
 
 
end









