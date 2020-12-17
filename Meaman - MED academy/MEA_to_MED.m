clear

[ filename , pathname ] = uigetfile( '*.*' , 'Select file' ) ;
[ ~ , name , ~ ] = fileparts( filename ) ;
cd( pathname ) ;

disp( ' ' )
disp( [ 'Data formatting started at:  ' datestr(now) ] )
T1 = tic ;

Tmin = 63 ;            % start  recording - in sec
Tmax = 65 ;            % finish recording - in sec (Inf, 60, 100, ...)

if Tmin <= 0
    Tmin = 0 ;
end
Tmin1 = Tmin * 20000 ;
Tmax1 = Tmax * 20000 + 1 ;

if isinf( Tmax )
    if Tmin == 0
        foutname = [ name '_complete.txt' ] ;
    else foutname = [ name '_' num2str(Tmin) '-end_s.txt' ] ;
    end
else foutname = [ name '_' num2str(Tmin) '-' num2str(Tmax) 's.txt' ] ;
end

f1id = fopen( filename , 'r' ) ;
for i = 1 : 3
    line = fgetl( f1id ) ;
end
N = numel( line ) + 2 ;

% fseek( f1id , N * ( Tmin1 + 1 ) , 'cof' ) ;
% N = ( numel( line ) + 1 ) / 13 ;
% a = fscanf( f1id , repmat( ' %f' , 1 , N ) , [ N Tmax1-Tmin1 ] ) ;
% toc( T1 )
% a = permute( a , [ 2 1 ] ) ;
% if N > 10
%     a = [ a zeros(size(a,1),64-N+1) ] ;
% end
% dlmwrite( foutname , a , 'precision' , '%6.2f' , 'delimiter' , ' ' ) ;

f2id = fopen( foutname , 'w' ) ;
fseek( f1id , N * ( Tmin1 + 1 ) , 'cof' ) ;
j = 1 ;
line = fgetl( f1id ) ;
while numel( line ) > 2 && j <= Tmax1 - Tmin1
%     k = strfind( line , '0 ' ) ;
%     line( [ k k+1 ] ) = [] ;
    if floor( j / 1200000 ) == j / 1200000
        fprintf( '%d-min data has been formatted at: %s\n' , j/1200000 , datestr(now) )
        toc( T1 )
    end
%     line( strfind( line , ' ' ) ) = [] ;
    fprintf( f2id , '%s\t0\t0\t0\t0\n' , line ) ;
    line = fgetl( f1id ) ;
    j = j + 1 ;
end
fclose( f2id ) ;

fclose( f1id ) ;

disp( [ 'Data formatting finished at:  ' datestr(now) ] )
toc( T1 )