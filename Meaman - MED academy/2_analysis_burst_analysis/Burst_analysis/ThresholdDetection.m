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

 