function handles = plotMeasurements(handles)
    global FileData
    % Actual position
        actPt = FileData.SensorPosition(1,1)+1 ;
        actOr = FileData.SensorPosition(1,2) ;
    % Initialisation of axes4
        XData = [] ;
        YData = [] ;
        axes(handles.axes4) ;
        cla ;
    % In The case where no data would be there
        text(.5,.5,'NO DATA','units','normalized','verticalalignment','middle','horizontalalignment','center')
    % Is there Processed Measurements to Plot ?
        if sum(FileData.IsPointMeasured(actPt,:))<1 ; return ; end
    % Let's Go
        % Extract components from interface
            component = handles.popupComponent.String{handles.popupComponent.Value} ;
        switch handles.popupDomain.Value
            case 1 % Time
                % Axes are linear
                    handles.axes4.XScale = 'lin' ;
                    handles.axes4.YScale = 'lin' ;
                % Domain
                    domain = 'Time' ;
                % XData indices
                    xindices = '1:end' ;
                % Data Indices for deformed shape
                    dataindices = ' 1:length(XData)' ;
                switch handles.popupTimeSignals.Value
                    case 1 % Tot. Vib
                        xfield = 'Total' ;
                        yfield = 'Total' ;
                        plotfield = 'Total' ;
                    case 2 % Tot. Ref
                        xfield = 'Total' ;
                        yfield = 'Total' ;
                        plotfield = 'Total' ;
                        component = 'Ref' ;
                    case 3 % Avg. Vib
                        xfield = '' ;
                        yfield = '' ;
                        plotfield = '' ;
                    case 4 % Avg. Ref
                        xfield = '' ;
                        yfield = '' ;
                        plotfield = '' ;
                        component = 'Ref' ;
                    case 5 % AC. Vib
                        xfield = 'corr' ;
                        yfield = 'AC' ;
                        plotfield = 'AC' ;
                    case 6 % AC. Ref
                        xfield = 'corr' ;
                        yfield = 'AC' ;
                        plotfield = 'AC' ;
                        component = 'Ref' ;
                    case 7 % CC. Vib. Ref.
                        xfield = 'corr' ;
                        yfield = 'CC' ;
                        plotfield = 'CC' ;
                end
            case 2 % Frequency
                % Axes are Log Scaled
                    handles.axes4.XScale = 'log' ;
                    handles.axes4.YScale = 'log' ;
                % Domain
                    domain = 'Freq' ;
                % XData indices
                    xindices = '2:floor(end/2)' ;
                % Data Indices for deformed shape
                    dataindices = '(1:length(XData))+1' ;
                switch handles.popupFFTSignals.Value
                    case 1 % Tot.FFT.Vib
                        plotfield = 'FFT' ;
                    case 2 % Tot.FFT.Ref
                        plotfield = 'FFT' ;
                        component = 'Ref' ;
                    case 3 % Avg.FFT.Vib
                        xfield = '' ;
                        yfield = 'FFT' ;
                        plotfield = 'FFT' ;
                    case 4 % Avg.FFT.Ref
                        xfield = '' ;
                        yfield = 'Total' ;
                        plotfield = 'Total' ;
                        component = 'Ref' ;
                    case 5 % AS.Vib
                        xfield = 'corr' ;
                        yfield = 'AS' ;
                        plotfield = 'AS' ;
                    case 6 % AS.Ref
                        xfield = 'corr' ;
                        yfield = 'AS' ;
                        plotfield = 'AS' ;
                        component = 'Ref' ;
                    case 7 % CS.Vib*Ref
                        xfield = 'corr' ;
                        yfield = 'CS' ;
                        plotfield = 'CS' ;
                    case 8 % H1.Vib/Ref
                        xfield = 'corr' ;
                        yfield = 'H1' ;
                        plotfield = 'H1' ;
                    case 9 % H2.Vib/Ref
                        xfield = 'corr' ;
                        yfield = 'H2' ;
                        plotfield = 'H2' ;
                    case 10 % Coherence
                        xfield = 'corr' ;
                        yfield = 'Coh' ;
                        plotfield = 'Coh' ;
                end
        end
    % DATA EXTRACTION
        if exist('xfield')
            XData = eval(['FileData.',xfield,domain,'(',xindices,')']) ;
            % Mesh averages made on the actually measured points
                pointsFullMeasured = ~any(FileData.IsPointMeasured==0,2) ;
            % Averaged Data (on realisations)
                if isfield(FileData,['Avg',yfield,component])
                    if handles.popupLocation.Value==1 % Single Point
                        YData = eval(['FileData.','Avg',yfield,component,'(actPt,',xindices,')']) ;
                    else % Average on Mesh
                        YData = mean(abs(eval(['FileData.','Avg',yfield,component,'(pointsFullMeasured,',xindices,')'])),1) ;
                    end
                    if ~isreal(YData)
                        YData = abs(YData) ;
                    end
                end
            % Data Variance
                if isfield(FileData,['Var',yfield,component])
                    if handles.popupLocation.Value==1 % Single Point
                        VarYData = eval(['FileData.','Var',yfield,component,'(actPt,',xindices,')']) ;
                    else % Average on Mesh
                        VarYData = mean(abs(eval(['FileData.','Var',yfield,component,'(pointsFullMeasured,',xindices,')'])),1) ;
                    end
                end
            % If Coherence (no Multi Data)
                if strcmp(yfield,'Coh') && isfield(FileData,['Coh',component])
                    if handles.popupLocation.Value==1 % Single Point
                        YData = abs(eval(['FileData.',yfield,component,'(actPt,',xindices,')'])) ;
                    else % Average on Mesh
                        YData = mean(abs(eval(['FileData.',yfield,component,'(pointsFullMeasured,',xindices,')'])),1) ;
                    end
                end
            % If Total Time (no Multi Data)
                if strcmp(yfield,'Total') && isfield(FileData,['Total',component])
                    if handles.popupLocation.Value==1 % Single Point
                        YData = eval(['FileData.',yfield,component,'(actPt,',xindices,')']) ;
                    else % Average on Mesh
                        YData = mean(abs(eval(['FileData.',yfield,component,'(pointsFullMeasured,',xindices,')'])),1) ;
                    end
                end
            % Realisation Datas
                if isfield(FileData,[yfield,component]) && strcmp(yfield,'Total')==0 && strcmp(yfield,'Coh')==0
                    if handles.popupLocation.Value==1 % Single Point
                        MultiYData = eval(['FileData.',yfield,component,'(actPt,:,',xindices,')']) ;
                    else % Average on Mesh
                        MultiYData = mean(abs(eval(['FileData.',yfield,component,'(pointsFullMeasured,:,',xindices,')'])),1) ;
                    end
                    if ~isreal(MultiYData)
                        MultiYData = abs(MultiYData) ;
                    end
                end
            % Plot indicator for the deformed shape
                if strcmp(yfield,'Total')==0 && strcmp(yfield,'Coh')==0
                    handles.axes4.UserData.currentData = ['Avg',plotfield] ;
                else
                    handles.axes4.UserData.currentData = plotfield ;
                end
            % Indices for deformed shape
                handles.axes4.UserData.dataIndices = eval(dataindices) ;
        end
    % Finally, Plot
        if ~isempty(XData) && (exist('MultiYData') || ~isempty(YData))
            % Init Axes
                cla(handles.axes4) ;
            % Realisations
                if exist('MultiYData')
                    plRlz = plot(handles.axes4,XData,squeeze(MultiYData),'hittest','off','tag','MultiDATA') ;
                    set(plRlz,'LineWidth',1) ;
                end
            % Variance
                if exist('VarYData')
                    plVar(1) = plot(handles.axes4,XData,squeeze(YData+sqrt(VarYData)),'tag','VarDATA+') ;
                    plVar(2) = plot(handles.axes4,XData,squeeze(YData-sqrt(VarYData)),'tag','VarDATA-') ;
                    set(plVar,'HitTest','off','color',[1 1 1]*0,'linewidth',1,'linestyle','-.') ;
                end
            % Average
                plAvg = plot(handles.axes4,XData,squeeze(YData),'k','hittest','off','tag','AvgDATA') ;
                set(plAvg,'linewidth',1.5)
            % Axes Formatting
                handles.axes4.YLimMode =  'auto' ;
                handles.axes4.XLim = XData([1,end]) ;
                if handles.popupFFTSignals.Value==10 && handles.popupDomain.Value==2 % coherence
                    handles.axes4.YLim = [0 1] ;
                    handles.axes4.YScale = 'lin' ;
                end
            % Cursor
                handles = plotCursor(handles) ;
            % SNR indicator
                if exist('VarYData')
                    power = norm(YData)^2/length(XData) ;
                    NoiseRatio = (mean(VarYData)/power) ;
                    NSRpercent = NoiseRatio*100 ;
                    NSRdB = 10*log10(NoiseRatio) ;
                    snrStr = {['NSR: ',num2str(NSRpercent,2),' %'],...
                                ['SNR: ',num2str(-NSRdB,2),' dB']} ;
                    text(1,1,...
                        snrStr,...
                        'units','normalized',...
                        'tag','snrTxt',...
                        'verticalalignment','top',...
                        'horizontalalignment','right',...
                        'color','b',...
                        'fontsize',15,...
                        'Interpreter','none') ;
                end
            % Plot Deformed Shape
                handles.axes4.UserData.dataLength = length(XData) ;
                if sum(FileData.IsPointMeasured(:))>0 && ~isempty(YData)
                    handles = plotDeformedShape(handles) ;
                end
        end