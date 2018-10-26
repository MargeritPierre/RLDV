function handles = checkMeasurements(handles)
    global FileData
    % TYPES OF CHECKING AVAILABLE
        checks = {} ;
        % -------- Variance ---------
            isVar = regexp(FileData.KeepProcessing,'Var') ;
            if sum([isVar{:}])>0 ; checks{end+1} = 'Variance' ; end
        % -------- Coherence --------
            isCoh = regexp(FileData.KeepProcessing,'Coh') ;
            if sum([isCoh{:}])>0 ; checks{end+1} = 'Coherence' ; end
        % ---------------------------
        % If no checking is available, return
            if isempty(checks)
                errordlg('No checking can be performed yet.','Error') ;
                return ;
            end
    % START THE PROCEDURE ?
        answer = questdlg({'Do you want to check the measurements ?',...
                            'This will cancel any checking performed before.'},...
                            'Measurement Check',...
                            'Yes','No','No') ;
        if ~strcmp(answer,'Yes'); return ; end
    % INITIALIZE
        % Initialize the checkings
            validPts = true(size(FileData.Points,1),1) ;
        % Delete the previous checking plot
            checkPlot = findobj(handles.axesMesh,'tag','checkPlot') ;
            delete(checkPlot) ;
        % Initialize the plot
            checkPlot = plot3(handles.axesMesh...
                                ,FileData.X(1)...
                                ,FileData.Y(1)...
                                ,FileData.Z(1)...
                                ,'or','tag','checkPlot'...
                                ) ;
            checkPlot.XData = [] ; checkPlot.YData = [] ; checkPlot.ZData = [] ;
    % WHICH CHECKING TO PERFORM ?
        [choices,valid] = listdlg('PromptString','Select Checkings',...
                                   'SelectionMode','multiple',...
                                   'ListString',checks) ;
        if ~valid ; return ;  end
        checks = checks(choices) ;
    % PERFORM CHECKINGS
        for c = 1:length(checks)
            % Perform the type of checking
                switch checks{c}
                    case 'Variance'
                        overThrs = checkVariance(validPts,isVar,checkPlot) ;
                    case 'Coherence'
                        overThrs = checkCoherence(validPts,checkPlot) ;
                end
            % Update the list of valid points
                validPts = validPts(:) & ~overThrs(:) ;
        end
    % AT THE END
        % Are there any points to delete ?
            if ~any(~validPts) ; return ; end
        % User Confirmation to delete the points
            answer = questdlg({'Do you want to delete the data at these points ?',...
                                ['The data will be deleted at ',num2str(sum(~validPts(:))),' points.']},...
                                'DELETE POINT DATA',...
                                'Yes','No','No') ;
            if ~strcmp(answer,'Yes'); return ; end
        % Delete the data at the points
            FileData.IsPointMeasured(~validPts,:) = false ;
            for i = 1:length(FileData.KeepProcessing)
                field = FileData.KeepProcessing{i} ;
                FileData.(field)(~validPts,:) = NaN ;
            end
        % Update the figure
            handles = plotMeasurements(handles) ;

            
            
            
% =========================================================================
% CHILD FUNCTIONS
% =========================================================================


% ----------------------------------------------------
% Checking Procedures
% ----------------------------------------------------

% VARIANCE CHECK
    function overVarThrs = checkVariance(validPts,isVar,checkPlot)
        global FileData
        % Get the first field on which to check the variance
            %(all processing fields conserve the mean variance)
            for i=1:length(isVar)
                fieldVar = [] ;
                if ~isempty(isVar{i})
                    fieldVar = FileData.KeepProcessing{i} ;
                    break ;
                end
            end
            if isempty(fieldVar) ; return ; end
        % Mean Power over time
            field = getfield(FileData,regexprep(fieldVar,'Var','Avg')) ;
            mPow = mean(field.^2,2) ;
        % Mean variance over time
            mVar = mean(getfield(FileData,fieldVar),2) ;
        % Compute the mean NSR over time
            mSNR = mVar./mPow ;   
        % First Variance threshold
            thrs0 = .1 ;
        % Create the interface
            H = sliderBox() ;
            H.fig.Name = 'Adjust the NSR threshold (%)' ;
            % Modify the UIControls
                H.slider.Min = -4 ;
                H.slider.Max = 0 ;
                H.slider.Value = log10(thrs0) ;
        % Loop until user validation
            while isvalid(H.fig)
                % Update the threshold
                    thrs = 10^H.slider.Value ;
                % Get the points for which the variance is more than the threshold
                    overVarThrs = mSNR>thrs ;
                % Update the uicontrols
                    H.editBoxThrs.String = [num2str(100*thrs) ' %'] ;
                    H.editBoxPts.String = [num2str(sum(overVarThrs(:))) ' pts'] ;
                % Plot
                    notValid = ~validPts(:) | overVarThrs(:)  ; % points not valid in the current configuration
                    checkPlot.XData = FileData.X(notValid) ;
                    checkPlot.YData = FileData.Y(notValid) ;
                    checkPlot.ZData = FileData.Z(notValid) ;
                % Update the graphics
                    drawnow ;
            end

% COHERENCE CHECK
    function overCohThrs = checkCoherence(validPts,checkPlot)
        global FileData
        % Get the global coherence data (product in all directions)
            Coh = ones(size(FileData.Points,1),length(FileData.corrFreq)) ;
            for f = {'dX','dY','dZ'}
                if isfield(FileData,['Coh' f{1}])
                    Coh = Coh.*abs(FileData.(['Coh' f{1}])) ;
                end
            end
        % Mean Coherence over frequency
            mTCoh = mean(Coh,2) ;
        % First Coherence threshold
            thrs0 = mean(Coh(:)) ;
        % Create the interface
            H = sliderBox() ;
            H.fig.Name = 'Adjust the Coherence threshold (%)' ;
            % Modify the UIControls
                H.slider.Min = 0 ;
                H.slider.Max = 1 ;
                H.slider.Value = thrs0 ;
        % Loop until user validation
            while isvalid(H.fig)
                % Update the threshold
                    thrs = H.slider.Value ;
                % Get the points for which the variance is more than the threshold
                    overCohThrs = mTCoh<thrs ;
                % Update the uicontrols
                    H.editBoxThrs.String = [num2str(100*thrs) ' %'] ;
                    H.editBoxPts.String = [num2str(sum(overCohThrs(:))) ' pts'] ;
                % Plot
                    notValid = ~validPts(:) | overCohThrs(:)  ; % points not valid in the current configuration
                    checkPlot.XData = FileData.X(notValid) ;
                    checkPlot.YData = FileData.Y(notValid) ;
                    checkPlot.ZData = FileData.Z(notValid) ;
                % Update the graphics
                    drawnow ;
            end


% ----------------------------------------------------
% Interface
% ----------------------------------------------------

function figHandles = sliderBox()
    % Create the figure
        fig = dialog() ;
    % Adjust the size
        figSize = [600 40] ;
        fig.Position(1:2) = fig.Position(1:2)+fig.Position(3:4)/2-figSize/2 ;
        fig.Position(3:4) = figSize ;
    % Add the UIControls
        slider = uicontrol(fig,'style','slider'...
                            ,'units','normalized'...
                            ,'position',[0.01 0.2 .5 .6]...
                            ) ;
        editBoxThrs = uicontrol(fig,'style','edit'...
                            ,'units','normalized'...
                            ,'position',[0.52 0.2 .2 .6]...
                            ) ;
        editBoxPts = uicontrol(fig,'style','edit'...
                            ,'units','normalized'...
                            ,'position',[0.74 0.2 .096 .6]...
                            ) ;
        buttonOK = uicontrol(fig,'style','pushbutton'...
                            ,'string','OK'...
                            ,'callback',fig.CloseRequestFcn...
                            ,'units','normalized'...
                            ,'position',[0.85 0.2 .1 .6]...
                            ) ;
    % Return the handles
        figHandles.fig  = fig ;
        figHandles.slider = slider ;
        figHandles.editBoxThrs = editBoxThrs ;
        figHandles.editBoxPts = editBoxPts ;
        figHandles.buttonOK = buttonOK ;
        
                        













            
    
    