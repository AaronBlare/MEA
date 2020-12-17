
%  AWSR_file_1ch
function  AWSR = AWSR_file_1ch(filename, pathname , CHANNEL , TimeBin )

if  filename ~= 0 
dT  = TimeBin ; % bin  in ms 

dT  = TimeBin ; % bin  in ms 

SAVE_PLOT_TO_FILE = 'y' ;
if pathname == '-'
    SAVE_PLOT_TO_FILE = 'n' ;
end    

[pathstr,name,ext,versn] = fileparts( filename ) ;
Init_dir = cd ;
if SAVE_PLOT_TO_FILE == 'y' 
    cd( pathname ) ; 
end

DATA_TYPE = ext ;
index_r = load(  char( filename )  ) ;


Tdim = 0 ; % ms
Tmax =  max(index_r(:,1) )   ; % ms
Nt = Tmax / dT ;

ASDR = zeros(1,Nt) ;
asdr_i = 1 ;

whos index_r

t = 0 ;
     T1 =  t * dT ;
    T2 = T1 + dT ;
for t = 1 : Nt
    
    ASDR( t ) = 0 ;
             
        channel_index = find ( index_r( : , 2 ) ==  CHANNEL  ) ;
        ss = length( find ( index_r( channel_index , 1 ) >=  T1 & index_r( channel_index , 1 ) <  T2 ) ) ;
        if ss > 0
           ASDR( t ) =   ASDR( asdr_i ) + ss ;  
        end
   
    asdr_i = asdr_i + 1 ;
     T1 =  t * dT ;
    T2 = T1 + dT ;
end

x = [ 1 : (Nt )  ] ;
x = x *dT / 1000  ;
y = ASDR ;


figure
% set(gcf,'position');
plot( x ,  y  ) , grid on
xlabel('Time, s')
ylabel(['AWSR (electrode ' int2str(CHANNEL) '), spikes per bin']) 

if SAVE_PLOT_TO_FILE == 'y' 
figname = [ name '_AWSR_electrode' int2str(CHANNEL)  '_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gcf,  figname ,'fig');
end


AWSR = ASDR ;

cd( Init_dir ) ;

end
%Fireratefile =[char(file) '_FireRate.txt'  ] ;
%eval(['save ' char(Fireratefile) ' Rate -ascii']);  
 