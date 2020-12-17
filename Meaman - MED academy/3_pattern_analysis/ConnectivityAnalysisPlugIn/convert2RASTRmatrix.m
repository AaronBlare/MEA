function [ RASTR ] = convert2RASTRmatrix( neu_count, filename, h  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  fid = fopen(filename, 'rt');
  fseek(fid, 0, -1);
  C = textscan(fid, '%f %d %f',-1);
  fclose(fid);
  % C{2} - neurons numebers
  % C{1} - timings
  cmin=min(C{1});
  cmax=max(C{1});
  tmax = floor((1+cmax-cmin)./h);
  RASTR = zeros(tmax, neu_count);
  for i=1:1:length(C{1})
    RASTR(floor((1+C{1}(i)-cmin)./h), C{2}(i)) = 1;
  end
end

