function raster_6wells(start_folder,som,valindex,end_folder1,subfolder_A)

[fs, starttime, endtime, startend, cancelFlag]=uigetRASTERinfo;

if cancelFlag
    errordlg('Selection Failed - End of Session', 'Error');
else
    [exp_num]=find_expnum(start_folder, '_6Wells');
    endname=strcat('RasterPlotMAT_', startend);
end
% --------- FOLDER MANAGEMENT
cd (start_folder);
cd ..
cd(end_folder1);
upfolder=pwd;
[end_folder]=createresultfolder(upfolder, exp_num, endname);

filetype=1;
lookuptable=[43; 42; 51; 44; 52; 53; 31; 41; 54; 32; ... % CLUSTER A
    63; 82; 83; 71; 73; 64; 62; 72; 74; 61; ... % CLUSTER B
    65; 76; 77; 75; 87; 66; 85; 86; 78; 84; ... % CLUSTER C
    56; 57; 48; 55; 47; 46; 68; 58; 45; 67; ... % CLUSTER D
    36; 17; 16; 28; 26; 35; 37; 27; 25; 38; ... % CLUSTER E
    34; 23; 22; 24; 12; 33; 14; 13; 21; 15];    % CLUSTER F
IMT_array= [1:10, 1:10, 1:10, 1:10, 1:10, 1:10]'; % Indexes of the IMT electrodes, ordered as cluster A-B-C-D
cluster_code=[ones(1,10)'; (ones(1,10)'*2); (ones(1,10)'*3); (ones(1,10)'*4); ones(1,10)'*5; ones(1,10)'*6];
lookuptable=[(1:60)', cluster_code, IMT_array, lookuptable];

cd (subfolder_A);
[p]=searchFolderMF(pwd,'Peak');
str=strcat(exp_num,'a','_');
a=strfind(p{1,1},str);
last=p{1,1}(a+4:end);

cd ..
first=3;
dispwarn=0;
cd (start_folder);

if som>=1
    s1=[];
    s2=[];
    s3=[];
    s4=[];
    s5=[];
    s6=[];

    for k=1:som

        if valindex(k)==1
            s1=['a'];
        elseif valindex(k)==2
            s2=['b'];
        elseif valindex(k)==3
            s3=['c'];
        elseif valindex(k)==4
            s4=['d'];
        elseif valindex(k)==5
            s5=['e'];
        elseif valindex(k)==6
            s6=['f'];
        end
        s=[s1 s2 s3 s4 s5 s6];
    end

    folder_s=strcat('PeakDetectionMAT_',s);
    cd (start_folder);
    mkdir(folder_s);
    handles.peakfolder_s=strcat(start_folder,'\PeakDetectionMAT_',s);
    cd(end_folder);
    end_fol=strcat('Raster_Plot_',s);
    mkdir(end_fol);
    handles.end_folder_s=strcat(end_folder,'\','Raster_Plot_',s);
    if som==1
        handles.endsubfolder1=strcat(end_folder1,'\',exp_num,s(1),'\',exp_num,s(1),last);
        cd(handles.endsubfolder1);
        copyfile(pwd,handles.peakfolder_s);
    elseif som==2
        handles.endsubfolder1=strcat(end_folder1,'\',exp_num,s(1),'\',exp_num,s(1),last);
        cd(handles.endsubfolder1);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder2=strcat(end_folder1,'\',exp_num,s(2),'\',exp_num,s(2),last);
        cd(handles.endsubfolder2);
        copyfile(pwd,handles.peakfolder_s);
    elseif som==3
        handles.endsubfolder1=strcat(end_folder1,'\',exp_num,s(1),'\',exp_num,s(1),last);
        cd(handles.endsubfolder1);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder2=strcat(end_folder1,'\',exp_num,s(2),'\',exp_num,s(2),last);
        cd(handles.endsubfolder2);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder3=strcat(end_folder1,'\',exp_num,s(3),'\',exp_num,s(3),last);
        cd(handles.endsubfolder3);
        copyfile(pwd,handles.peakfolder_s);
    elseif som==4
        handles.endsubfolder1=strcat(end_folder1,'\',exp_num,s(1),'\',exp_num,s(1),last);
        cd(handles.endsubfolder1);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder2=strcat(end_folder1,'\',exp_num,s(2),'\',exp_num,s(2),last);
        cd(handles.endsubfolder2);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder3=strcat(end_folder1,'\',exp_num,s(3),'\',exp_num,s(3),last);
        cd(handles.endsubfolder3);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder4=strcat(end_folder1,'\',exp_num,s(4),'\',exp_num,s(4),last);
        cd(handles.endsubfolder4);
        copyfile(pwd,handles.peakfolder_s);
    elseif som==5
        handles.endsubfolder1=strcat(end_folder1,'\',exp_num,s(1),'\',exp_num,s(1),last);
        cd(handles.endsubfolder1);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder2=strcat(end_folder1,'\',exp_num,s(2),'\',exp_num,s(2),last);
        cd(handles.endsubfolder2);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder3=strcat(end_folder1,'\',exp_num,s(3),'\',exp_num,s(3),last);
        cd(handles.endsubfolder3);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder4=strcat(end_folder1,'\',exp_num,s(4),'\',exp_num,s(4),last);
        cd(handles.endsubfolder4);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder5=strcat(end_folder1,'\',exp_num,s(5),'\',exp_num,s(5),last);
        cd(handles.endsubfolder5);
        copyfile(pwd,handles.peakfolder_s);
    elseif som==6
        handles.endsubfolder1=strcat(end_folder1,'\',exp_num,s(1),'\',exp_num,s(1),last);
        cd(handles.endsubfolder1);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder2=strcat(end_folder1,'\',exp_num,s(2),'\',exp_num,s(2),last);
        cd(handles.endsubfolder2);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder3=strcat(end_folder1,'\',exp_num,s(3),'\',exp_num,s(3),last);
        cd(handles.endsubfolder3);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder4=strcat(end_folder1,'\',exp_num,s(4),'\',exp_num,s(4),last);
        cd(handles.endsubfolder4);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder5=strcat(end_folder1,'\',exp_num,s(5),'\',exp_num,s(5),last);
        cd(handles.endsubfolder5);
        copyfile(pwd,handles.peakfolder_s);
        handles.endsubfolder6=strcat(end_folder1,'\',exp_num,s(6),'\',exp_num,s(6),last);
        cd(handles.endsubfolder6);
        copyfile(pwd,handles.peakfolder_s);
    end
    start_folder=handles.peakfolder_s;
   
end

cd (start_folder);
peakfolderdir= dir;                   % Struct containing the peak-det folders
NumPeakFolder= length(peakfolderdir); % Number of experimental phases

for f= first:NumPeakFolder            % FOR cycle on the phase directories

    scrsz = get(0,'ScreenSize');
    figure('Position',[1+100 scrsz(1)+100 scrsz(3)-200 scrsz(4)-200]);
    set(gcf,'Color','w');

    phasedir=peakfolderdir(f).name;
    if (filetype==1)
        phasename=phasedir(8:end);  % Necessary for saving the final filename - no 'ptrain'
    else
        phasename=phasedir;
    end
    cd(phasedir);
    phasedir=pwd;
    phasefiles= dir;
    numphasefiles= length(phasefiles);

    for i=first:numphasefiles
        filename=phasefiles(i).name;
        load (filename);     % peak_train and artifact are loaded
        electrode=filename(end-5:end-4);

        if (filetype==1)     % PeakDetection MAT file
            endtimePhase=endtime;
            if (length(peak_train)<endtime)&& (length(peak_train)>0)
                endtimePhase=length(peak_train);
                dispwarn=1;
            end
            realspiketimes= find(peak_train(starttime+1:endtimePhase));
            realspiketimes= (realspiketimes+starttime)/fs; % correct X-scale [sec]
        else                 % PeakDetection TXT file
            fid = fopen(filename);               % open the current file
            data = fscanf(fid,'%g %g',[2 inf]);  % read data as ASCII
            fclose(fid);                         % close the file
            data=  data';                        % data(:,1)= timestamp, data(:,2)= peak values
            realspiketimes= [];
            if ~isempty (data)
                data= data(:,1)*fs;
                if (data(end)<endtimePhase)
                    endtimePhase=data(end);
                    dispwarn=1;
                end
                realspiketimes= data(find((starttime<=data)&(data<=endtimePhase)))/fs; % correct X-scale [sec]
            end
        end
        spiketimes= [realspiketimes; endtimePhase/fs+10; endtimePhase/fs+11]; % To avoid 0 or 1 spikes - at least two
        % that will not be displayed
        % RASTER PLOT PROCESSING

        el=str2num(electrode);

        IMT_index=find(lookuptable(:,4)==el);
        graph_pos=lookuptable(IMT_index, 1);
        NFiles= numphasefiles-first+1;
        if som==1
            if (graph_pos>=11) && (graph_pos<=20)
                graph_pos=graph_pos-10;
            elseif (graph_pos>=21) && (graph_pos<=30)
                graph_pos=graph_pos-20;
            elseif (graph_pos>=31) && (graph_pos<=40)
                graph_pos=graph_pos-30;
            elseif (graph_pos>=41) && (graph_pos<=50)
                graph_pos=graph_pos-40;
            elseif (graph_pos>=51) && (graph_pos<=60)
                graph_pos=graph_pos-50;
            end
        elseif som==2
            if (valindex(1)==1)
                if (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-30;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-40;
                end
            elseif (valindex(1)==2)
                if (graph_pos>=11) && (graph_pos<=20)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-30;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-40;
                end
            elseif (valindex(1)==3)
                if (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-30;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-40;
                end
            elseif (valindex(1)==4)
                if (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-30;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-30;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-40;
                end
            elseif (valindex(1)==5)
                if (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-40;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-40;
                end
            end
        elseif som==3
            if (valindex(1)==1) && (valindex(2)==2)
                if (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-30;
                end
            elseif (valindex(1)==1) && (valindex(2)==3)
                if (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-30;
                end
            elseif (valindex(1)==1) && (valindex(2)==4)
                if (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-30;
                end
            elseif (valindex(1)==1) && (valindex(2)==5)
                if (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-30;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-30;
                end
            elseif (valindex(1)==2) && (valindex(2)==3)
                if (graph_pos>=11) && (graph_pos<=20)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-30;
                end
            elseif (valindex(1)==2) && (valindex(2)==4)
                if (graph_pos>=11) && (graph_pos<=20)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-30;
                end
            elseif (valindex(1)==2) && (valindex(2)==5)
                if (graph_pos>=11) && (graph_pos<=20)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-30;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-30;
                end
            elseif (valindex(1)==3) && (valindex(2)==4)
                if (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-30;
                end
            elseif (valindex(1)==3) && (valindex(2)==5)
                if (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-30;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-30;
                end
            elseif (valindex(1)==4) && (valindex(2)==5)
                if (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-30;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-30;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-30;
                end
            end
        elseif som==4
            if (valindex(1)==1) && (valindex(2)==2) && (valindex(3)==3)
                if (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-20;
                end
            elseif (valindex(1)==1) && (valindex(2)==2) && (valindex(3)==4)
                if (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-20;
                end
            elseif (valindex(1)==1) && (valindex(2)==2) && (valindex(3)==5)
                if (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-20;
                end
            elseif (valindex(1)==1) && (valindex(2)==3) && (valindex(3)==4)
                if (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-10
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-20;
                end
            elseif (valindex(1)==1) && (valindex(2)==3) && (valindex(3)==5)
                if (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-20;
                end
            elseif (valindex(1)==1) && (valindex(2)==4) && (valindex(3)==5)
                if (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-20;
                end
            elseif (valindex(1)==2) && (valindex(2)==3) && (valindex(3)==4)
                if (graph_pos>=11) && (graph_pos<=20)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-20;
                end
            elseif (valindex(1)==2) && (valindex(2)==3) && (valindex(3)==5)
                if (graph_pos>=11) && (graph_pos<=20)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-20;
                end
            elseif (valindex(1)==2) && (valindex(2)==4) && (valindex(3)==5)
                if (graph_pos>=11) && (graph_pos<=20)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-20;
                end
            elseif (valindex(1)==3) && (valindex(2)==4) && (valindex(3)==5)
                if (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-20;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-20;
                end
            end
        elseif som==5
            if (valindex(1)==1) && (valindex(2)==2) && (valindex(3)==3) && (valindex(4)==4)
                if (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-10;
                end
            elseif (valindex(1)==1) && (valindex(2)==2) && (valindex(3)==3) && (valindex(4)==5)
                if (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-10;
                end
            elseif (valindex(1)==1) && (valindex(2)==2) && (valindex(3)==4) && (valindex(4)==5)
                if (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-10;
                end
            elseif (valindex(1)==1) && (valindex(2)==3) && (valindex(3)==4) && (valindex(4)==5)
                if (graph_pos>=21) && (graph_pos<=30)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=31) && (graph_pos<=40)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=41) && (graph_pos<=50)
                    graph_pos=graph_pos-10;
                elseif (graph_pos>=51) && (graph_pos<=60)
                    graph_pos=graph_pos-10;
                end
            end
        end

        subplot(NFiles, 1, graph_pos,'align')

        if (graph_pos>=1) && (graph_pos<=10)
            raster=bar(spiketimes, sign(spiketimes),0.001,'m'); % Raster Plot
            set(raster,'EdgeColor','m');                        % Lines are blue
            axis([starttime/fs endtimePhase/fs 0 0.5]); % Olny the time frame selected

        elseif (graph_pos>=11) && (graph_pos<=20)
            raster=bar(spiketimes, sign(spiketimes),0.001,'b'); % Raster Plot
            set(raster,'EdgeColor','b');                        % Lines are blue
            axis([starttime/fs endtimePhase/fs 0 0.5]); % Olny the time frame selected

        elseif (graph_pos>=21) && (graph_pos<=30)
            raster=bar(spiketimes, sign(spiketimes),0.001,'g'); % Raster Plot
            set(raster,'EdgeColor','g');                        % Lines are blue
            axis([starttime/fs endtimePhase/fs 0 0.5]); % Olny the time frame selected

        elseif (graph_pos>=31) && (graph_pos<=40)
            raster=bar(spiketimes, sign(spiketimes),0.001,'k'); % Raster Plot
            set(raster,'EdgeColor','k');                        % Lines are blue
            axis([starttime/fs endtimePhase/fs 0 0.5]); % Olny the time frame selected

        elseif (graph_pos>=41) && (graph_pos<=50)
            raster=bar(spiketimes, sign(spiketimes),0.001,'r'); % Raster Plot
            set(raster,'EdgeColor','r');                        % Lines are blue
            axis([starttime/fs endtimePhase/fs 0 0.5]); % Olny the time frame selected

        else (graph_pos>=51) && (graph_pos<=60)
            raster=bar(spiketimes, sign(spiketimes),0.001,'c'); % Raster Plot
            set(raster,'EdgeColor','c');                        % Lines are blue
            axis([starttime/fs endtimePhase/fs 0 0.5]); % Olny the time frame selected
        end
        if (graph_pos==60)
            set(gca,'Ycolor', 'w');
            set(gca,'ytick',[]);
            set(get(gca,'XLabel'),'String','Time [sec]')

        else
            axis off; % Decide if you want to visualize the rows among each electrode
        end
        space=round((endtimePhase/fs-starttime/fs)/25); % I verified that it is ok this space
        text((starttime/fs-space), 0.25, electrode, 'FontSize', 5, 'FontWeight', 'bold');
        cd(phasedir)
    end
    cd(handles.end_folder_s);

    if ishandle(raster) % Only if the raster exists
        name_figure=strcat('Raster_', startend, '_', phasename);
        % saveas(raster, name_figure,'tif'); % TIF format
        % saveas(raster, name_figure,'fig'); % Matlab Figure file
        saveas(raster, name_figure,'jpg');   % JPEG format
    end
    close;
    
    cd (start_folder);
end
