function InitFileData(handles)
    global FileData
    if ~isempty(FileData.Points)
        % Infos
            nPt = length(FileData.X) ;
            nOr = size(FileData.Targets,3) ;
        % No Point Has Been Measured
            FileData.IsPointMeasured = false(nPt,nOr) ;
        if ~isempty(handles.SignalInfos) && ~isempty(FileData.Points)
            % Infos
                nT = handles.SignalInfos.RealisationSamples ;
                nTotal = handles.SignalInfos.TotalNumberOfSamples ;
                nAvg = handles.SignalInfos.Averages ;
                nUsed = handles.SignalInfos.MeasuredSamples ;
                nCorr = 2*nT-1 ;
                nPt = length(FileData.X) ;
                nOr = size(FileData.Targets,3) ;
            % Measurements Matrix
                if FileData.SaveMeasurements
                    FileData.Measurements = zeros(nTotal,2,nPt,nOr) ;
                else
                    FileData.Measurements = [] ;
                end
                FileData.ThisPointMeasurements = zeros(nTotal,2,nOr) ;
            % Compute Window
                FileData.Window = eval([FileData.WindowName,'(nT)']).' ;
            % Time Vectors
                FileData.TotalTime = handles.SignalInfos.TotalTime ;
                FileData.Time = handles.SignalInfos.RealisationTime ;
                FileData.corrTime = [-flip(FileData.Time(1,2:nT)),FileData.Time] ;
            % Frequency vectors
                FileData.Freq = (0:nT-1)/nT*handles.SignalInfos.Fe ;
                FileData.corrFreq = (0:nCorr-1)/nCorr*handles.SignalInfos.Fe ;
            % SIGNAL PROCESSING FIELDS
                InitSignalProcessing(handles) ;
        end
    end