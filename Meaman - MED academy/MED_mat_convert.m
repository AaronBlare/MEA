%  MED_mat_convert
%converting txt files with voltage activity in mat-files for clustering
clear

datafile = 'Full_01-001.txt';
savefile = 'D:\X_01.mat' ;

a = load('-ascii', datafile )
data =  a( : , 3 )' 
save ( savefile , 'data' , '-mat' )

x =  a( : , 3 );
y =  a( : , 4 );
C = xcorr( x , y , 100 ) ;
stem(  1: length(C) ,C)
