function [ res ] = res_produce_sigma( results )
  res.t = results{1}{1};
  res.s = results{1}{2};
  for i = 2:1:length(results)
    res.t = [res.t; results{i}{1}];
    res.s = [res.s; results{i}{2}];
  end
end

