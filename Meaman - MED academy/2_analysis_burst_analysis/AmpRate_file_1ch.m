
%  AmpRate_file_1ch
function  AmpRate = AmpRate_file_1ch(filename, pathname , CHANNEL , TimeBin )

if  filename ~= 0 
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
N = 64 ;
AmpRate = zeros(1,Nt) ;
asdr_i = 1 ;

whos index_r

t = 0 ;
     T1 =  t * dT ;
    T2 = T1 + dT ;
for t = 1 : Nt
    
    AmpRate( t ) = 0 ;   
        channel_index =  index_r( : , 2 ) ==  CHANNEL   ;
        spike_index =  index_r( channel_index , 1 ) >=  T1 & index_r( channel_index , 1 ) <  T2  ;       
        ss = length( find ( index_r( channel_index , 1 ) >=  T1 & index_r( channel_index , 1 ) <  T2 ) ) ;
        if ss > 0
             avg_amp = sum( index_r( spike_index , 3 ) ) /ss ;
           AmpRate( t ) =   AmpRate( asdr_i ) + avg_amp ;  
        end
 
    asdr_i = asdr_i + 1 ;
     T1 =  t * dT ;
    T2 = T1 + dT ;
end

x = [ 1 : (Nt )  ] ;
x = x *dT / 1000  ;
y = AmpRate ;


figure
% set(gcf,'position');
plot( x ,  y  ,'MarkerEdgeColor',[.04 .52 .78]) , grid on
xlabel('Time, s')
ylabel(['Average Amplitude, mV per bin']) 
% set(p,'Color',[.04 .52 .78])

if SAVE_PLOT_TO_FILE == 'y' 
figname = [ name '_AmpRate_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gcf,  figname ,'fig');
end

 


cd( Init_dir ) ;
%Fireratefile =[char(file) '_FireRate.txt'  ] ;
%eval(['save ' char(Fireratefile) ' Rate -ascii']);  
end 

