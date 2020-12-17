


function Learn_curve( artefacts )  

 % LEARNING CURVE----------------------------
 StartAt=artefacts(1);
  EndAt=artefacts(1);
  LearningCurve = []; %each element is cycle
     for i=1:  length( artefacts   )-1 
       if artefacts(i+1)-artefacts(i) > 50000 
           EndAt=artefacts(i);
           AdaptTime = (EndAt - StartAt )/1000;
           StartAt=artefacts(i+1);
           LearningCurve=[LearningCurve AdaptTime];
       end
     end
    EndAt=artefacts(end);
   AdaptTime = (EndAt - StartAt )/1000;
    LearningCurve=[LearningCurve AdaptTime];
 figure 
 plot(LearningCurve,'-s','MarkerEdgeColor','k')
 title( 'Learning curve, y-time to reach criteria,x-cycle' )
 LearningCurve=LearningCurve';
 LearningCurve
 