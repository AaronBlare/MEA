%--------------------------------------------------------------------------
function ts = ConvertTimeStamps(timestamps, units)
%--------------------------------------------------------------------------
% Convert to base time units, cast to int32
% Note MATLAB does rounding

ts = int32(timestamps*(1/units));
return
end
%--------------------------------------------------------------------------