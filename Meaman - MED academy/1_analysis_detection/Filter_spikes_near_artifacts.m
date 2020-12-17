

% Filter_spikes_near_artifacts


    SSDD = [] ;

    for i=1:  length( artefacts   )
        ssdd = [] ;
      ssdd = find( index(:) > artefacts(i)-Dat  & index(:) < artefacts(i) + Dat );
    %    whos SSDD
    %    whos ssdd
      if ~isempty( ssdd )
      SSDD = [ SSDD ; ssdd ] ;
      end
    end    
    if ~isempty( SSDD )

    index(SSDD)=[];
    amps(SSDD)=[];  
    end 

    if SIMPLE_RASTER ~= 'y' 
        spikes(SSDD,:)=[];

        switch handles.par.interpolation
            case 'n'
                spikes(:,end-1:end)=[];       %eliminates borders that were introduced for interpolation 
                spikes(:,1:2)=[];
            case 'y'
                %Does interpolation
                spikes = int_spikes(spikes,handles);   
        end
    end
 
 
    