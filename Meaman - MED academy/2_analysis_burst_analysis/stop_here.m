function stop_here()
  s.name='stopHere';
  s.file=[pwd '\stopHere.m'];
  s.line = 13;
  s.anonymous = 0;
  s.expression={''};
  s.cond= '';
  s.identifier= {};
  %timerStepout = timer('TimerFcn','dbstep(''out'');','StartDelay',.1,'TasksToExecute',1);
  %start(timerStepout);
  dbstop(s)
  %delete(timerStepout);
end