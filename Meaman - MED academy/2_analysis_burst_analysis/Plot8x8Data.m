%  Plot8x8Data
function h_pict = Plot8x8Data( dat , new_figure , smooth_plot , MinV , MaxV , colorbaronvar )

if nargin == 3 
  smooth_plot_argin = smooth_plot ;   
   MinV = 0 ;
   MaxV = 0 ;
else
    GLOBAL_CONSTANTS_load
   smooth_plot_argin  = GLOBAL_const.Plot8x8Data_cubic_interp ;

end

colorbaron = true ;

if nargin == 6
   colorbaron = colorbaronvar ;
end

if nargin ==2    
   MinV = 0 ;
   MaxV = 0 ;
end

Nchan = length( dat ) ;
Data = zeros(8,8);
DIV = 8 ;

Nchan ;

if nargin == 1 
    new_figure = true ;
end
    
if Nchan == 64
   mea_type = 1 ; % med64 type
end
if Nchan <= 60
   mea_type = 2 ; % mea type
end

%  mea_type = 1 ;
%  dat = reshape( dat , 1,[]);
%  dat = [ dat   0  0  0  0 ];

if mea_type == 1  % Med64 MEA 64 channels
    

    N = 64;
    x1 = 0 ; x2 = 0 ; y1 = 1 ; y2 = 0 ;
    for i = 1 : N    
      if x1 < DIV x1=x1+1 ; else x1=1 ; y1=y1+1 ; end  

         Data(    y1 , x1) = dat( i ) ;     

    end
    
else 
     if   mea_type == 2 % 60 channels MEA
%          N = 60 ;
         N = Nchan ;
     load( 'MEAchannel2dMap.mat');   
    % MEA_channel_coords(i).chan_X_coord , i=1..60
    %     MEA_channel_coords(i).chan_Y_coord
    
%     Data_test_num = [] ;
    
        for i = 1 : N    
             Data(  MEA_channel_coords(i).chan_Y_coord  , MEA_channel_coords(i).chan_X_coord ) = dat( i ) ;     
%              Data_test_num(  MEA_channel_coords(i).chan_Y_coord  , MEA_channel_coords(i).chan_X_coord ) = i  ;  
        end
        if MaxV > 0 
            Data( 1 , 1 ) = MaxV ;
            Data( 1 , 8 ) = MinV ; 
        end
     end  
end

x = 1: DIV ;
y = x ;
if new_figure
    figure
end



if smooth_plot_argin
    Data=interp2(Data,5,'cubic');
    x = ( x / 8)*9.0 - 0.622 ;
    y = ( y / 8)*9.0 - 0.622 ; 
end

h_pict = imagesc( x,y, Data );
axis square
if colorbaron
colorbar
end

