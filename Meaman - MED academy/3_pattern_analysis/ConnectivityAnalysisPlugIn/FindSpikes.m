function [ Spks ] = FindSpikes( RASTR )

  n=size(RASTR,2);
  Spks=cell(n,1);

  for i=1:n
    Spks{i}=find(RASTR(:,i));
  end

end

