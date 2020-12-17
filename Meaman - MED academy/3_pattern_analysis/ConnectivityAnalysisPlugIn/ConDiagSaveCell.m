function [ ] = ConDiagSaveCell( result_dir, SigIJ )
  neurons=CalcConnectionCountCell(SigIJ);
  h = figure
  bar((1:1:size(SigIJ,2))',[neurons.out neurons.in]);
  grid on;
  legend('number of out connections','--- in connections');
  if result_dir==''
    saveas(h,result_dir)
    close(h)
  end
end

