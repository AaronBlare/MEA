% Color_gradient_many_plot

Nvals  = 1000 ;

a = 1: Nvals ; 
b = sin(a/10) ;
x = a ;  
cmap = colormap; 


t = 0:0.1:2*pi ;
     lt = length( t );         

 ColorMax = 1 ;
 
 % RGB gradient
        MaxT = 2*pi ;
        MinT = 0 ; 
        T_bin = (MaxT - MinT )/   Nvals ;
%         t = 0:0.1:2*pi ; 
        t = MinT:T_bin : MaxT  ;
        lt = length( t ); 
        
            redc =  ( 1 * (1+cos(  t  ))) / 2 ;
            redc( floor( lt/2) : end ) = 0  ; 
            
            greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 

            bluec = ( 1 * (1+cos(  t ))) / 2 ;
            bluec(1 : floor( lt/2)   ) = 0  ; 
            
%             
% % % R -> B    
%         MaxT = pi ;
%         MinT = 0 ; 
%         T_bin = (MaxT - MinT )/   Nvals ;
% %         t = 0:0.1: pi ; 
%         t = MinT:T_bin : MaxT  ;
%         lt = length( t ); 
%         
%             redc =  ( 1 * (1 +cos(  t * 1.0 ))) / 2 ; 
%             redc = redc * 0.99 + 0.0  ;
%             
%             greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 
%             greenc(:) = 0.0 ;
% 
%             bluec = ( 1 + sin(  t - pi/2 ) )/ 2 ;  
%             bluec = bluec * 0.99 + 0.0  ;
%  
% % % B-> R    
%         MaxT = pi ;
%         MinT = 0 ; 
%         T_bin = (MaxT - MinT )/   Nvals ;
% %         t = 0:0.1: pi ; 
%         t = MinT:T_bin : MaxT  ;
%         lt = length( t ); 
%           
% %             redc = ( 1 + sin(  t - pi/2 ) )/ 2 ;  
%               redc = ( 0 + (  t  ) )/ MaxT ; 
%             redc = redc * 1.0 + 0.0  ;
%             
%             
% %             bluec =  ( 1 * (1 +cos(  t * 1.0 ))) / 2 ; 
%             bluec =  ( 1 * ( ( MaxT - t * 1.0 ))) / MaxT   ; 
%             bluec(:) = 0.0 ;
%             
%             greenc =  ( 1 * (1 +cos(  t * 1.0 ))) / 2 ; 
%             greenc(:) = 0.0 ;
%           
%             
%     % % R -> G    
%         MaxT = pi ;
%         MinT = 0 ; 
%         T_bin = (MaxT - MinT )/   Nvals ;
% %         t = 0:0.1: pi ; 
%         t = MinT:T_bin : MaxT  ;
%         lt = length( t ); 
%         
% %             redc =  ( 1 * (1 +cos(  t * 1.0 ))) / 2 ; 
%             redc =  ( 1 * ( ( MaxT - t * 1.0 ))) / MaxT   ; 
%             redc = redc * 1.0 + 0.0  ;
%             
% %             greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 
%             greenc =  ( 0 + (  t  ) )/ MaxT ; 
%             greenc = greenc * 0.99 + 0.0  ;   
% 
%             bluec = ( 1 + sin(  t - pi/2 ) )/ 2 ;  
%             
%             bluec(:) = 0.0 ;
%             
%             
%     % % R -> B    
        MaxT = pi ;
        MinT = 0 ; 
        T_bin = (MaxT - MinT )/   Nvals ;
%         t = 0:0.1: pi ; 
        t = MinT:T_bin : MaxT  ;
        lt = length( t ); 
        
%             redc =  ( 1 * (1 +cos(  t * 1.0 ))) / 2 ; 
            redc =  ( 1 * ( ( MaxT - t * 1.0 ))) / MaxT   ; 
            redc = redc * 1.0 + 0.0  ;
            
%             greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 
            greenc =  ( 0 + (  t  ) )/ MaxT ; 
             greenc(:) = 0.0  ;

            bluec =  ( 0 + (  t  ) )/ MaxT ;  
            
            bluec  = bluec * 1.0 + 0.0  ;            
%             

figure
hold on
plot( t , redc , '-r' )
plot( t , greenc , '-g' )
plot( t , bluec , '-b' )


            
    figure      
hold on
for i=1 : Nvals 
     color_i = [ redc( i ) greenc( i ) bluec( i ) ] ;
    plot(   x   ,  b + i*3     , 'Color' , color_i   )
end
  


 



