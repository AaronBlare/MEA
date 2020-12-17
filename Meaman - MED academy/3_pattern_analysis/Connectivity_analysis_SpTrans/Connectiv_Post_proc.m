
function Result_struct = Connectiv_Post_proc( Data2d_chan_to_chan , var  )  
% input : 2d array i-j relations var.new_figure var.calc_bidirection
% if you have 1d array -> 2d = MNDB_Make2d_data_from_vector( 1d   
% example:
%  Tact_2d_diff = MNDB_Make2d_data_from_vector( burst_activation_3_smooth_1ms_mean  );
%  var.new_figure = false ;
%  var.calc_bidirection = false ;
%  var.background_1d_vector = true ;
%  var.background_1d_vector_data = burst_activation_3_smooth_1ms_mean ;



Normalize_vectors = true ;
DR = 4 ; % number of electrodes area
if isfield( var , 'Average_R')
   DR = var.Average_R ;
end


if nargin == 2
    new_figure = var.new_figure ;
    calc_bidirection = var.calc_bidirection ; 
    
    if isfield( var , 'background_plot' ) 
        background_plot = var.background_plot ; 
    else
        background_plot = true ;
    end
    
    background_1d_vector = var.background_1d_vector ;  
    if isfield( var , 'background_2d_data' )
        background_2d  = true ;
        background_2d_data = var.background_2d_data ; 
    else
        background_2d = false ;
    end
    
    if isfield( var , 'smooth_2d_image' ) 
        smooth_2d_image = var.smooth_2d_image ; 
    else
        smooth_2d_image = false ;
    end 
else
    background_1d_vector = false ;
    background_plot = true ;
    background_2d = false ;
    new_figure = true ;
    calc_bidirection = true ;
    smooth_2d_image = false ;
end

smooth_2d_image 

% background_2d = false;
% calc_bidirection = false ;

s = size( Data2d_chan_to_chan );
N = s(1) ;
Data2d = Plot8x8Data_convert( 1:N   );
Nside = 8 ;
Data2d2 = Data2d ;



Vector_field_x = zeros( Nside , Nside ) ;
Vector_field_y = zeros( Nside , Nside ) ;
Vector_field_strengths = zeros( 1 , Nside ) ;

for i = 1 : N
    
    [ row , col ] =find( Data2d == i );
     
    data_x = 0 ;
    data_y = 0 ;
    max_strength = 0 ;
    
    num_delays = 0 ;
    for row_i = -DR:1:DR
       for col_i = -DR:1:DR
          if col_i  == 0  && row_i  == 0   
          else
%           if col_i == 0 || row_i  == 0 
          if    col_i + row_i ~= 0
             newrow = row + row_i ;
             newcol = col + col_i ;
             if newrow >0 && newcol >0 && newcol <= Nside && newrow <= Nside
                 newrow ;
                 newcol ;
                 new_index = Data2d( newrow , newcol )  ; 
                 Data2d2( newrow , newcol )  = 0 ; 
                 if new_index > 0 
                     max_delay  = Data2d_chan_to_chan( i, new_index ); 
                     if background_2d
                         newStr = background_2d_data( i, new_index ); 
                     else
                         newStr = Data2d_chan_to_chan( i, new_index ); 
                     end
                     if isnan( newStr )
                          newStr = 0 ;
                     end
                     
                     result_delay = max_delay ;
                     
                     if calc_bidirection
                         back_max_delay = Data2d_chan_to_chan( new_index , i ); 
                         if background_2d
                            newStr2 =  background_2d_data( new_index , i ); 
                         else
                            newStr2 = Data2d_chan_to_chan( new_index , i ); 
                         end
                         if isnan( newStr2 )
                            newStr2 = 0 ;
                         end
                         
                         if max_delay > back_max_delay
                            result_delay =  max_delay   ; 
                         else
                            result_delay =  back_max_delay   ; 
                            newStr = newStr2 ;
                         end
                     end
                     
                     max_strength = max_strength + newStr ;
                     
                     if row == 5 && col == 3
                         max_strength ;
                     end
                     data_x = data_x + sign(col_i) *  result_delay / sqrt( col_i*col_i + row_i*row_i ); 
                     data_y = data_y + sign(row_i) * result_delay / sqrt( col_i*col_i + row_i*row_i );
                      
                     
                     num_delays=num_delays+1   ;
                 end
             end
          end
          end
       end
    end
        
    vector_length = sqrt( data_x*data_x + data_y*data_y ) ;
    if vector_length == 0 
        vector_length =1 ;
    end
    
    if Normalize_vectors 
        data_x = 0.2 * data_x  / vector_length; 
        data_y = 0.2 * data_y / vector_length ; 
    end
    
    Vector_field_x( row , col ) =  data_x  ;    
    Vector_field_y( row , col ) = data_y  ; 
    Vector_field_strengths( i ) =  max_strength / num_delays  ;
%     Vector_field_strengths( i ) = vector_length ;
    
end

Result_struct.Vector_field_x = Vector_field_x ;
Result_struct.Vector_field_y = Vector_field_y ;


[X,Y]=meshgrid(1:Nside,1:Nside);

%  figure
 
%  Plot8x8Data( var.Total_Spike_Rates , true );
if background_plot
    if background_1d_vector 
          Plot8x8Data( var.background_1d_vector_data , new_figure   );         
%           Plot8x8Data( var.background_1d_vector_data , new_figure ,  smooth_2d_image );      
    else
     Plot8x8Data( Vector_field_strengths , new_figure );  
%      Plot8x8Data( Vector_field_strengths , new_figure ,  smooth_2d_image ); 
    end
end
 hold on
 scale = 0.3 ;
% quiver(X,Y,Vector_field_x,Vector_field_y ,scale ,  '-k',...
%                 'LineWidth',2 )
%      
%       figure    
if max( max( abs(Vector_field_x) )) + max( max( abs(Vector_field_y) )) > 0  
% cquiver(Vector_field_x ,Vector_field_y , 0.1*max(max( Vector_field_strengths )) )     
 if Normalize_vectors 
    field_x = zeros( Nside , Nside ) ;
    field_y = zeros( Nside , Nside ) ;
    DXY=0.5 ;
    for i=1:Nside
        for j=1:Nside
           field_x( i , j ) = i   - 1.8*Vector_field_x( i , j )  ;
           field_y( i , j ) = j    - 1.8*Vector_field_y( i , j )  ; 
        end
    end 

    quiver(field_x , field_y , Vector_field_x , Vector_field_y , 0.6 ,'Color' , 'k', 'Linewidth' , 2  )
          colorbar    
 else
     quiver( Vector_field_x , Vector_field_y , 0.65,'Color' , 'k', 'Linewidth' , 2  )
          colorbar     
 end
 
end
 hold off
% axis square            
% set(gca,'Visible','off')
% set(gcf,'color','w')










