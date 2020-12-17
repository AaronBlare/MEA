function [ Sstarts, Sends, bursts_per_super_bursts] = SuperBurst( SummaryActivityVector, Tsuper, T , TimeBin , params )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Tsuper - Superbursts eefective length (half gauss) , in points
% Tsuper - bursts  eefective length (half gauss) , in points
% Sstarts , Sends - ms

if nargin == 4
   params.show_figures  = true ;
end

%   thr=0.2 * sqrt(sum(SummaryActivityVector.^2)./(length(SummaryActivityVector)-1));

  %--- erase zero time bins in the begining
  [ non_zero_val , non_zero_val_i ] = find(  SummaryActivityVector > 0 );
  SummaryActivityVector_filtered = SummaryActivityVector ;
  SummaryActivityVector_filtered( 1 : non_zero_val_i(1) ) = [];

  thr= params.Search_Params.Superburst_threshold_coeff * std( SummaryActivityVector_filtered )   ;  

  thr
  
  %smoothing windows set up
  mf=3.5;
  wnd_super=normpdf([-mf*Tsuper:mf*Tsuper],0,Tsuper);
  wnd=normpdf([-mf*Tsuper:mf*Tsuper],0,T);
  %smoothoing
  VectorS=conv(SummaryActivityVector,wnd_super);
  hsl=fix(length(wnd_super)/2);
  VectorS=VectorS(hsl:end-hsl);
  
  if params.show_figures
      % Plot input activity and smooth on one figure , use seconds as time bin
      figure 
      hold on
      x = [ 1 : length( VectorS )  ] ;
      x2 = [ 1 : length( SummaryActivityVector )  ] ;
    x = x *TimeBin / 1000  ;
    x2 = x2 *TimeBin / 1000  ;
    y = VectorS ;  
    plot( x2 ,  SummaryActivityVector    )  
    plot( x ,  y  , 'Color' , 'r' , 'LineWidth',2  ) , grid on
     plot( [ x(1) x(end) ] , [ thr thr ]  , 'Color' , 'g' , 'LineWidth',1  ) 
    xlabel('Time, s')
    ylabel(['TSR, spikes per bin']) 
    legend( 'Spikes per bin' ,  'Superburst indicator' ,'Threshold' );
    title( 'Superburst detection')
     hold off
  end
  
  %smoothoing
  Vector=conv(SummaryActivityVector,wnd);
  hl=fix(length(wnd)/2);
  Vector=Vector(hl:end-hl);  
  %detection
  [ parts, Sstarts, Sends ] = ThresholdDetection(VectorS, thr);
  STARTS = Sstarts * TimeBin / 1000 ;
  STARTS
  ENDS = Sends * TimeBin / 1000 ;
  ENDS
  [ parts, starts, ends ] = ThresholdDetection(Vector, thr);
  %calculate busts per super
  bursts_per_super_bursts=zeros(1,length(Sstarts));
  for z=1:length(Sstarts)
    bursts_per_super_bursts(z)=nnz(Sstarts(z) < starts & ends < Sends(z));
  end
  
  Sstarts= Sstarts * TimeBin  ;
  Sends = Sends * TimeBin  ;
  
  function [ parts, starts, ends ] = ThresholdDetection( Vector, threshold )
  %ThresholdDetection( Vector, threshold ) Takes Vector parts above threshold
  %   [ parts, starts, ends ] = ThresholdDetection( Vector, threshold )
    % find start and end points
    a=Vector>=threshold;
    a=a(:);
    a=[0;a;0];
    a=diff(a);
    starts=find(a==1);
    ends=find(a==-1)-1;
    % cutting
    parts=cell(length(ends),1);
    for i=1:length(ends)
      parts{i}=Vector(starts(i):ends(i));
    end
  end

end

