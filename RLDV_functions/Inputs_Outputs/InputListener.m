function InputListener(src,event,handles)
    display('In Input Listener')
    global InstantData
    if (strcmp(handles.toolListen.State,'on'))
        nScans = length(event.TimeStamps) ;
        % Local Copy of FileData
            data = event.Data ;
            time = event.TimeStamps ;
        % CORRECT DELAY BETWEEN CHANNELS
            data(:,1) = data([2:end,1],1) ;
        % SAVE DATA
            InstantData.LastScan_Data = [InstantData.LastScan_Data ; data] ;
            InstantData.LastScan_Time = [InstantData.LastScan_Time ; time] ;
            InstantData.LastScan.f = (0:nScans-1)/nScans*handles.Session.Rate ;
    %     display(['Samples Available : ',num2str(length(event.TimeStamps))]) ;
    %     display(['Size of LastScan : ',num2str(size(InstantData.LastScan_Data,1))]) ;
        if (InstantData.ToPlot.HasPlottedLastTime)
            InstantData.ToPlot.f = [] ;
            InstantData.ToPlot.Time = [] ;
            InstantData.ToPlot.Data = [] ;
        end
        InstantData.ToPlot.Time = [InstantData.ToPlot.Time ; time] ;
        InstantData.ToPlot.Data = [InstantData.ToPlot.Data ; data] ;
        InstantData.ToPlot.HasPlottedLastTime = 0 ;
        if (toc(InstantData.ToPlot.LastTime)>1/handles.MaxRefreshRate)
            plotData(InstantData.ToPlot,handles) ;
            InstantData.ToPlot.LastTime = tic ;
            InstantData.ToPlot.HasPlottedLastTime = 1 ;
        end
    end