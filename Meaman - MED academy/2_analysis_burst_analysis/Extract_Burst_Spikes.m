
%  AWSR_file
function  AWSR = AWSR_file(filename, TimeBin )

SAVE_PLOT_TO_FILE = 'y' ;

[pathstr,name,ext,versn] = fileparts( filename ) ;
index_r = load(  char( filename )  ) ;

Tdim = 0 ; % ms
Tmax =  max(index_r(:,1) )   ; % ms
Nt = Tmax / dT ;
N = 64 ;

whos index_r

burst_start , burst_max , burst_end
Burst_num = length( burst_max ) ;

Bursts( 

for bi = 1:Burst_num
    for ch = 1: N         
        channel_index = find ( index_r( : , 2 ) ==  ch  ) ;
        ss = length( find ( index_r( channel_index , 1 ) >=  T1 & index_r( channel_index , 1 ) <  T2 ) ) ;
        if ss > 0
           ASDR( t ) =   ASDR( asdr_i ) + ss ;  
        end
    end
    asdr_i = asdr_i + 1 ;
     T1 =  t * dT ;
    T2 = T1 + dT ;
end

x = [ 1 : (Nt )  ] ;
x = x *dT / 1000  ;
y = ASDR ;


figure
set(gcf,'position');
plot( x ,  y  ) , grid on
xlabel('Time, s')
ylabel(['AWSR , spikes per bin']) 

if SAVE_PLOT_TO_FILE == 'y' 
figname = [ name '_AWSR_' int2str(TimeBin) 'ms_TimeBin .fig' ] ;
saveas(gcf,  figname ,'fig');
end


%Fireratefile =[char(file) '_FireRate.txt'  ] ;
%eval(['save ' char(Fireratefile) ' Rate -ascii']);  
 