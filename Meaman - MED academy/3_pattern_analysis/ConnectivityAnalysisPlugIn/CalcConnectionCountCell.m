function [ neurons ] = CalcConnectionCountCell( ConMatrix )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
  neurons.out=zeros(size(ConMatrix,2),1);
  neurons.in=zeros(size(ConMatrix,2),1);
  %{
  for j=1:1:size(ConMatrix,2)
    neurons.out(j)=nnz(ConMatrix(:,j));
    neurons.in(j)=nnz(ConMatrix(j,:));
  end
  %}
  for j=1:size(ConMatrix,2)
    for i=1:size(ConMatrix,2)
      if ConMatrix{i,j}        
        for x=1:length(ConMatrix{i,j})
          neurons.out(j)=neurons.out(j)+1;
          neurons.in(i)=neurons.in(i)+1;
        end
      end
    end
  end
end

