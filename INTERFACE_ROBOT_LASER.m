function varargout = INTERFACE_ROBOT_LASER(varargin)
% INTERFACE_ROBOT_LASER MATLAB code for INTERFACE_ROBOT_LASER.fig
%      INTERFACE_ROBOT_LASER, by itself, creates a new INTERFACE_ROBOT_LASER or raises the existing
%      singleton*.
%
%      H = INTERFACE_ROBOT_LASER returns the handle to a new INTERFACE_ROBOT_LASER or the handle to
%      the existing singleton*.
%
%      INTERFACE_ROBOT_LASER('CALLBACK',hObject,eventFileData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_ROBOT_LASER.M with the given input arguments.
%
%      INTERFACE_ROBOT_LASER('Property','Value',...) creates a new INTERFACE_ROBOT_LASER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before INTERFACE_ROBOT_LASER_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to INTERFACE_ROBOT_LASER_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help INTERFACE_ROBOT_LASER

% Last Modified by GUIDE v2.5 10-Oct-2016 18:37:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @INTERFACE_ROBOT_LASER_OpeningFcn, ...
                   'gui_OutputFcn',  @INTERFACE_ROBOT_LASER_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before INTERFACE_ROBOT_LASER is made visible.
function INTERFACE_ROBOT_LASER_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to INTERFACE_ROBOT_LASER (see VARARGIN)
% Choose default command line output for INTERFACE_ROBOT_LASER
handles.output = hObject;

% INITIALISATION
    handles.Session = {} ;
    handles.SignalInfos = {} ;
    handles.OutputListener = {} ;
    handles.InputListener = {} ;
    handles.SignalToOutput = {} ;
    handles.MaxRefreshRate = str2double(handles.editRefreshRate.String) ;
    
% UDP OBJECT
    handles.UDP = udp() ;
    handles.UDP.Timeout = 30 ; % max waiting time (s)
    handles.UDP.InputDatagramPacketSize = 65535 ;
    handles.UDP.OutputDatagramPacketSize = 65535 ;
    handles.UDP.InputBufferSize = 1e5 ;
    handles.UDP.RemotePort = str2double(handles.editUDPOut.String) ;
    handles.UDP.LocalPort = str2double(handles.editUDPIn.String) ;
    
% GLOBAL DATA STRUCTURE (for access by listeners and exterior function)  
        global FileData
        if 1==1
            % NOT-A-FILE SOLUTION (WARNING : OUT OF MEMORY)
                FileData = {} ; % Global link trough All FileData
        else
            % FILE SOLUTION
                % SAVE THE NAME OF THE FILE
                    handles.FileDataPath = 'FileData.mat' ;
                % DELETE PREVIOUS DATAFILE
                    delete(handles.FileDataPath) ;
                % FILE CREATION
                    FileData = matfile(handles.FileDataPath,'Writable',true) ;
        end
        % Infos About Mesh (1D)
            FileData.MeshSize = 0 ;
            FileData.Points = [] ;
            FileData.Normals = [] ;
            FileData.Targets = [] ; % Format : [Point , [VX VY VZ] , Target]
            FileData.X = [] ;
            FileData.Y = [] ;
            FileData.Z = [] ;
        % Robot Position
            FileData.ActualPoint = 0 ;
            FileData.ActualOrientation = 0 ;
            FileData.SensorPosition = [0,0] ;
            FileData.ActualSample = 1 ;
        % Measurements
            FileData.SaveMeasurements = false ;
            FileData.WindowName = 'rectwin' ;
            FileData.KeepProcessing = {...'dX' 'dY' 'dZ' 'Ref' ...
                                        ...'FFTdX' 'FFTdY' 'FFTdZ' 'FFTRef' ...
                                        ...'WinFFTdX' 'WinFFTdY' 'WinFFTdZ' 'WinFFTRef' ...
                                        'AvgdX' 'AvgdY' 'AvgdZ'... 'AvgRef' ...
                                        'AvgFFTdX' 'AvgFFTdY' 'AvgFFTdZ' 'AvgFFTRef' ...
                                        ...'AvgWinFFTdX' 'AvgWinFFTdY' 'AvgWinFFTdZ' 'AvgWinFFTRef' ...
                                        ...'ACdX' 'ACdY' 'ACdZ' 'ACRef' ...
                                        ...'CCdX' 'CCdY' 'CCdZ' ...
                                        ...'ASdX' 'ASdY' 'ASdZ' 'ASRef' ...
                                        ...'CSdX' 'CSdY' 'CSdZ' ...
                                        ...'H1dX' 'H1dY' 'H1dZ' ...
                                        ...'H2dX' 'H2dY' 'H2dZ' ...
                                        ...'AvgACdX' 'AvgACdY' 'AvgACdZ' 'AvgACRef' ...
                                        ...'AvgCCdX' 'AvgCCdY' 'AvgCCdZ' ...
                                        ...'CohdX' 'CohdY' 'CohdZ' ...
                                        ...'AvgASdX' 'AvgASdY' 'AvgASdZ' 'AvgASRef'  ...
                                        ...'AvgCSdX' 'AvgCSdY' 'AvgCSdZ' ...
                                        ...'AvgH1dX' 'AvgH1dY' 'AvgH1dZ' ...
                                        ...'AvgH2dX' 'AvgH2dY' 'AvgH2dZ' ...
                                        } ;
            InitFileData(handles) ;
        % Oupout level
            FileData.OutputLevel = 8 ; % VOLTS
        
% GLOBAL HANDLES TO AXES (for access by listeners)
    global Axes1 Axes2
    Axes1 = handles.axes1 ;
    Axes2 = handles.axes2 ;
    
% INITIALISE DEFAULT AXES CONFIG
    % MONITORING AXES DEFAULT CONFIG
        plot(Axes1,0,0,'Tag','Vibrometer')
        Axes1.UserData.lgd = legend(Axes1,'Vibrometer') ;
        Axes1.UserData.lgd.FontSize = 9 ;
        plot(Axes2,0,0,'Tag','Reference')
        Axes2.UserData.lgd = legend(Axes2,'Reference') ;
        Axes2.UserData.lgd.FontSize = 9 ;
    % ALL AXES DEFAULT CONFIG
        axH = findobj(handles.Interface,'type','axes') ;
        for a = axH(:)'
            a.Units = 'normalized' ;
            a.OuterPosition = a.Position ;
            a.FontSize = 12 ;
            a.Box = 'on' ;
            grid(a,'on')
        end
    % AxesMesh Config
        grid(handles.axesMesh,'off') ;
% TIMER OBJECT FOR ANIMATION
    handles.Timer = timer ;
    
% Outputlevel in handles
    handles.OutputLevel = FileData.OutputLevel ;
    
% Update handles structure
    guidata(hObject, handles);

% UIWAIT makes INTERFACE_ROBOT_LASER wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = INTERFACE_ROBOT_LASER_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% STOP SESSION
    if (~isempty(handles.Session))
        handles.Session.stop
    end
    
% DELETE UDP OBJECT
    fclose(handles.UDP) ;

% Get default command line output from handles structure
varargout{1} = handles.output ;




% CONTEXT MENUS :
%   INTERFACE_ROBOT_LASER('General_Callback',hObject,eventdata,guidata(hObject))
% UI Objects :
%   @(hObject,eventdata)INTERFACE_ROBOT_LASER('General_Callback',hObject,eventdata,guidata(hObject))
% --------------------------------------------------------------------
function General_Callback(hObject, eventdata, handles)
% hObject    handle to contextAxesMeshPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hObject.Tag
%get(hObject.Parent.Parent)
global FileData InstantData

switch (hObject.Tag)        
        
    case 'toolChannels' % BUTTON FOR SETTING CHANNELS CONFIG
        % Disable all buttons
            eh = findobj(handles.Interface,'enable','on') ;
            set(eh,'enable','off') ;
        if (~isempty(handles.Session))
            % Shut down the signal Listening
                handles.toolListen.State = 'off' ;
                General_Callback(handles.toolListen,{},handles) ;
            % Shut down the signal Generation
                handles.toolOutput.State = 'off' ;
                General_Callback(handles.toolOutput,{},handles) ;
            % Stop Running Session if needed
                    handles.Session.stop ;                
                    handles.Session.IsContinuous = 0 ;
        end
        % Start Session Setting Interface and wait for it to return
            handles.Session = SET_SESSION_ROBOT_LASER(handles.Session) ;
            display(handles.Session.Channels)
        % Configure session listeners
            handles.OutputListener = addlistener(handles.Session,'DataRequired', ...
                    @(src,event) OutputListener(src,event,handles));
            handles.InputListener = addlistener(handles.Session,'DataAvailable', ...
                    @(src,event) InputListener(src,event,handles));                
            handles.Session.IsContinuous = 1 ;
        % Enable disabled buttons
            set(eh,'enable','on') ;
            handles.toolChannels.State = 'off' ;
        % Enable Generator Signal Configuration Interface and Listening Button
            if (~isempty(handles.Session))
                handles.toolSignal.Enable = 'on' ;
                handles.toolListen.Enable = 'on' ;
            end
        
    case 'toolSignal' % BUTTON FOR SETTING SIGNAL CONFIG
        % Disable all buttons
            eh = findobj(handles.Interface,'enable','on') ;
            %set(eh,'enable','off') ;
        if (~isempty(handles.Session))
            % Shut down the signal Listening
                handles.toolListen.State = 'off' ;
                General_Callback(handles.toolListen,{},handles) ;
            % Shut down the signal Generation
                handles.toolOutput.State = 'off' ;
                General_Callback(handles.toolOutput,{},handles) ;
            % Stop Running Session if needed
                    handles.Session.stop ;                
                    handles.Session.IsContinuous = 0 ;
        end
        % Start Session Setting Interface and wait for it to return
            [handles.Session, handles.SignalInfos] = SET_EXCITATION_ROBOT_LASER(handles.Session,handles.SignalInfos) ;
            display('SIGNAL INFOS :')
            display(handles.SignalInfos) ;
            handles.Session.IsContinuous = 1 ;
            display('SESSION INFOS :')
            display(get(handles.Session)) ;
        % RE-INITIALIZE MEASUREMENTS
            InitFileData(handles) ;
        % Enable disabled buttons
            set(eh,'enable','on') ;
            handles.toolChannels.State = 'off' ;
            handles.toolSignal.State = 'off' ;
        % Enable Output Button
            if (~isempty(handles.SignalInfos))
                handles.toolOutput.Enable = 'on' ;
                handles.toolPointMeasure.Enable = 'on' ;
                handles.toolPoint3DMeasure.Enable = 'on' ;
                handles.toolMeshMeasure.Enable = 'on' ;
            else
                handles.toolOutput.Enable = 'off' ;
                handles.toolPointMeasure.Enable = 'off' ;
                handles.toolMeshMeasure.Enable = 'off' ;
            end             
        
    case 'toolListen' % BUTTON FOR LAUNCHING CONTINUOUS ACQUISITION
        if (strcmp(handles.toolListen.State,'on'))
            display('Listening Started')
                % Zeros are Outputed
                    handles.SignalToOutput = zeros(handles.Session.NotifyWhenScansQueuedBelow*2,1) ;
                % Empty the InstantData
                    InstantData.LastScan_Data = [] ;
                    InstantData.LastScan_Time = [] ;
                    InstantData.ToPlot.Data = [] ;
                    InstantData.ToPlot.Time = [] ;
            if (~handles.Session.IsRunning) % The session has to be started
                OutputListener({},{},handles) ; % Queue data before Start
                startBackground(handles.Session) ;
                display('Started Background')
            end
        else
            display('Listening Stopped')
            if (strcmp(handles.toolOutput.State,'off')) % The session has to be stopped
                handles.Session.stop ;
            end
        end
        
    case 'toolOutput' % BUTTON FOR LAUNCHING CONTINOUS GENERATION
        if (strcmp(handles.toolOutput.State,'on'))
            display('Output Started')
            % Set SignalToOutput with SignalInfos
                handles.SignalToOutput = handles.SignalInfos.Signal.' ;
            if (~handles.Session.IsRunning) % The session has to be started
                OutputListener({},{},handles) ; % Queue data before Start
                startBackground(handles.Session) ;
            end
        else
            display('Output Stopped')
            % Output Zeros, update Listeners
                handles.SignalToOutput = zeros(handles.Session.NotifyWhenScansQueuedBelow*2,1) ;
            if (strcmp(handles.toolListen.State,'off')) % The session has to be stopped
                handles.Session.stop ;
            end
        end
        
    case 'toolRotate'
        rotate3d(handles.axesMesh,hObject.State) ;
        
    case 'toolZoom'
        zoom(handles.Interface,hObject.State) ;
        
    case 'toolPan'
        pan(handles.Interface,hObject.State) ;
    
    case 'sliderOutLevel' % SLIDER TO ADJUST OUTPUT LEVEL
        outputRange = 10 ; % HARD-CODED, BOF bOF BOF !
        FileData.OutputLevel = outputRange*handles.sliderOutLevel.Value ;
        handles.OutputLevel = FileData.OutputLevel  ;
        
        
    case 'toolPointMeasure' % BUTTON FOR A PONCTUAL MEASURE
        display('Point Measurement')
        if (~isempty(handles.Session))
                startTime = tic ;
            % Disable all buttons
                eh = findobj(handles.Interface,'enable','on') ;
                set(eh,'enable','off') ;
                handles.toolDebug.Enable = 'on' ;
            % Shut down the signal Listening
                handles.toolListen.State = 'off' ;
                General_Callback(handles.toolListen,{},handles) ;
            % Shut down the signal Generation
                handles.toolOutput.State = 'off' ;
                General_Callback(handles.toolOutput,{},handles) ;
            % Stop Running Session
                handles.Session.stop ;                
                handles.Session.IsContinuous = 0 ;
            % Erase Listeners (they will be re-setted in the lines below)
                handles.OutputListener.Callback = @(src,event) {} ;
                handles.InputListener.Callback = @(src,event) {} ;
            % MEASUREMENT
                % Clear Signal Axes
                    for ax = [handles.axes1 handles.axes2]
                        for child = ax.Children.'
                            child.XData = [] ;
                            child.YData = [] ;
                        end
                    end
                % Signal to output
                    outputSignal = handles.SignalInfos.TotalSignal.' ;
                    outputSignal = outputSignal./max(abs(outputSignal(:))) ;
                    outputSignal = outputSignal*handles.OutputLevel ;
                % Add Zeros before and after
                    zerosBefore = 1 ;
                    zerosAfter = 1 ;
                    outputSignal = [zeros(zerosBefore,1) ; outputSignal ; zeros(zerosAfter,1)] ;
                % Queue Generator Signal
                    queueOutputData(handles.Session,outputSignal) ; 
                % Acquire Data
                    [data,time] = handles.Session.startForeground ;
                % Delete added zeros
                    data = data(zerosBefore+1:end-zerosAfter,:) ;
                % CORRECT DELAY BETWEEN CHANNELS
                    data(:,1) = data([2:end,1],1) ;
                % PROCESS DATA
                    if (~isempty(FileData.Targets) && ~isempty(handles.SignalInfos) && FileData.ActualOrientation~=0)
                        FileData.SensorPosition = [FileData.ActualPoint,FileData.ActualOrientation] ;  % Position for plotting on axes4
                        % Saving measurement
                            % Total
                                if FileData.SaveMeasurements
                                    if size(FileData.Measurements,4)>1
                                        FileData.Measurements(:,:,FileData.ActualPoint+1,FileData.ActualOrientation) = data ;
                                    else
                                        FileData.Measurements(:,:,FileData.ActualPoint+1) = data ;
                                    end
                                end
                            % At this point
                                if size(FileData.ThisPointMeasurements,3)>1
                                    FileData.ThisPointMeasurements(:,:,FileData.ActualOrientation) = data ;
                                else
                                    FileData.ThisPointMeasurements = data ;
                                end
                        % Convert in cartesian basis
                            %handles = PointMeasure2dXdYdZ(handles) ;
                        % Turn on Boolean IsPointMeasured
                            FileData.IsPointMeasured(FileData.ActualPoint+1,FileData.ActualOrientation) = 1 ;
                        % Process measurement
                            SignalProcessing(handles) ;
                        % Plot Instantaneous measurement
                            toplot.Time = time(zerosBefore+1:end-zerosAfter) ;
                            toplot.Data = data ;
                            handles = plotData(toplot,handles) ;
                        % Plot processed Data
                            handles = plotMesh(handles) ;
                            handles = plotMeasurements(handles) ;
                    end
            % Enable disabled buttons
                set(eh,'enable','on') ;
            % Set Session Continuous  
                handles.Session.IsContinuous = 1 ;
            % Enable Animation
                handles.toolAnime.Enable = 'on' ;
            display(['POINT MEASURE : ',num2str(toc(startTime),2),' sec']) ;
        end
        % Uncheck Point Measure Button (toggle)
            handles.toolPointMeasure.State = 'off' ;
            
    case 'toolPoint3DMeasure'
        % Disable all buttons
            eh = findobj(handles.Interface,'enable','on') ;
            set(eh,'enable','off') ;
            handles.toolDebug.Enable = 'on' ;
            drawnow ;
        % Measure 
            startTime = tic ;
            WaitTime = 1 ; % Seconds
            nOr = size(FileData.Targets,3) ;
            FileData.ThisPointMeasurements = zeros(handles.SignalInfos.TotalNumberOfSamples,2,nOr) ;
            for Or = 1:nOr
                handles = GoTo(FileData.ActualPoint,Or,handles,'blocking') ;
                pause(WaitTime) ;
                General_Callback(handles.toolPointMeasure, eventdata, handles) ;
                handles.toolPoint3DMeasure.State = 'off' ;
                drawnow ;
            end
            display(['3D POINT MEASURE : ',num2str(toc(startTime),2),' sec']) ;
        % Re-Enable Points
            set(eh,'enable','on') ;
            
    case 'toolMeshMeasure'
        % Disable all buttons
            eh = findobj(handles.Interface,'enable','on') ;
            set(eh,'enable','off') ;
            handles.toolDebug.Enable = 'on' ;
            drawnow ;
        % INITIALISATION
            nPt = size(FileData.Targets,1) ;
            nOr = size(FileData.Targets,3) ;
            ptsNotCompletlyMeasured = find(sum(FileData.IsPointMeasured,2)<nOr)' ;
            fclose(handles.UDP) ;
        % MEASUREMENTS
            wtbr = waitbar(0,'MESURE EN COURS') ;
            WaitTime = 1 ; % Seconds
            nPtsToMeasure = length(ptsNotCompletlyMeasured) ;
            nPtsMeasured = 0 ;
            display(['Nombre de points à mesurer : ',num2str(length(ptsNotCompletlyMeasured))]);
            StartMeshMeasurementTime = tic ;
            for Pt = ptsNotCompletlyMeasured
                handles = GoTo(Pt-1,1,handles,'blocking') ;
                if nOr>1
                    pause(WaitTime) ;
                    General_Callback(handles.toolPoint3DMeasure, eventdata, handles) ;
                else
                    pause(WaitTime) ;
                    General_Callback(handles.toolPointMeasure, eventdata, handles) ;
                end
                nPtsMeasured = nPtsMeasured + 1 ;
                % WAITBAR
                    time = round(toc(StartMeshMeasurementTime)/nPtsMeasured*(nPtsToMeasure-nPtsMeasured)) ;
                    hours = floor(time/3600) ;
                    mins = floor((time-3600*hours)/60) ;
                    secs = round(time-3600*hours-60*mins) ;
                    wtbr = waitbar(nPtsMeasured/nPtsToMeasure,wtbr,['MESURE EN COURS, TEMPS RESTANT : ',num2str(hours),'h',num2str(mins),'m',num2str(secs),'s']) ;
            end
            delete(wtbr) ;
            display(['TOTAL MEASUREMENT TIME : ',num2str(toc(StartMeshMeasurementTime))]);
        % SAVE BACKUP
            display('SAVING BACKUP ... (LastFileData)') ;
            save('LastFileData.mat','FileData','-v7.3') ;
            display('BACKUP OK') ;
        % Reset Original Interface State
            set(eh,'enable','on') ;
            handles.toolMeshMeasure.State = 'off' ;
        
        
    case 'listInfos' % EVENT IN THE LIST OF INFOS
        handles.listInfos.Value
        
    case 'editRefreshRate' % EDIT FOR THE REFRESH RATE
        handles.MaxRefreshRate = str2double(handles.editRefreshRate.String) ; 
        
    case 'toolMesh' % BUTTON FOR LOADING A MESH FROM UDP AND GRASSHOPPER
%         % Disable all buttons
%             eh = findobj(handles.Interface,'enable','on') ;
%             set(eh,'enable','off') ;
        % Read Port (wait for data to come)
            fopen(handles.UDP) ;
            ReceivedData = fscanf(handles.UDP) ;
            fclose(handles.UDP) ;
            %ReceivedData = str2num(ReceivedData) ;
            % Now on a file
                fileID = fopen('Mesh.txt') ;
                ReceivedData = str2num(fscanf(fileID,'%s')) ;
                fclose(fileID);
                size(ReceivedData)
            if (~isempty(ReceivedData))
                % IMPORT
                    FileData.X = ReceivedData(:,1) ;
                    FileData.Y = ReceivedData(:,2) ;
                    FileData.Z = ReceivedData(:,3) ;
                    FileData.Points = [FileData.X,FileData.Y,FileData.Z] ;
                    FileData.MeshSize = length(FileData.X) ;
                    FileData.Normals = ReceivedData(:,4:6) ;
                    FileData.Targets = reshape(ReceivedData(:,7:end),FileData.MeshSize,3,[]) ;
                    size(FileData.Targets)
                % INITIALIZE MEASUREMENTS
                    InitFileData(handles) ;
                % INITIALISATION OF POSITION
                    FileData.ActualPoint = 0 ;
                    handles = GoTo(0,FileData.ActualOrientation,handles) ;
                % MESH PLOT
                    handles = plotMesh(handles) ;
                % ENABLE CONTROL TOOLS
                    handles.toolNextPoint.Enable = 'on' ;
                    handles.toolPreviousPoint.Enable = 'on' ;
                    handles.toolOnNormals.Enable = 'on' ;
                    handles.toolPreviousOrientation.Enable = 'on' ;
                    handles.toolNextOrientation.Enable = 'on' ;
                    handles.toolChoosePoint.Enable = 'on' ;
                    handles.contextAxesMesh_Plot.Enable = 'on' ;
            end
%         % Enable disabled buttons
%             set(eh,'enable','on') ;

    case 'toolNextPoint' % BUTTON TO GO TO NEXT POINT
        handles = GoTo(FileData.ActualPoint+1,FileData.ActualOrientation,handles) ;
        % MESH PLOT
            handles = plotMesh(handles) ;
        
    case 'toolPreviousPoint' % BUTTON TO GO TO PREVIOUS POINT
        handles = GoTo(FileData.ActualPoint-1,FileData.ActualOrientation,handles) ;
        % MESH PLOT
            handles = plotMesh(handles) ;
        
    case 'toolOnNormals' % BUTTON TO ORIENT THE LASER ON NORMALS
        handles = GoTo(FileData.ActualPoint,FileData.ActualOrientation,handles) ;
        % MESH PLOT
            handles = plotMesh(handles) ;
        
    case 'toolNextOrientation' % BUTTON TO ORIENT THE LASER ON THE NEXT ORIENTATION
        handles.toolOnNormals.State = 'off' ;
        Orientation = FileData.ActualOrientation + 1 ;
        if (Orientation>size(FileData.Targets,3))
            Orientation = 1 ;
        end
        handles = GoTo(FileData.ActualPoint,Orientation,handles) ;
        % MESH PLOT
            handles = plotMesh(handles) ;
        FileData.ActualOrientation = Orientation ;
        
    case 'toolPreviousOrientation' % BUTTON TO ORIENT THE LASER ON THE PREVIOUS ORIENTATION
        handles.toolOnNormals.State = 'off' ;
        Orientation = FileData.ActualOrientation - 1 ;
        if (Orientation<1)
            Orientation = size(FileData.Targets,3) ;
        end
        handles = GoTo(FileData.ActualPoint,Orientation,handles) ;
        % MESH PLOT
            handles = plotMesh(handles) ;
        FileData.ActualOrientation = Orientation ;
        
    case 'toolChoosePoint' % BUTTON TO ALLOW THE USER TO PICK A POINT ON THE MESH
        handles = plotMesh(handles) ;
        handles.axesMesh.ButtonDownFcn = '' ;
        pts = findobj(handles.axesMesh,'Tag','Points') ;
        pts.UserData.evt = [] ;
        pts.ButtonDownFcn = @(src,evt)eval('src.UserData.evt = evt ;') ;
        pts.HitTest = 'on' ;
        while (isempty(pts.UserData.evt))
            drawnow ;
        end
        pts.ButtonDownFcn = '' ;
        HitPt = pts.UserData.evt.IntersectionPoint ;
        distance = sqrt((HitPt(1)-pts.XData).^2+(HitPt(2)-pts.YData).^2+(HitPt(3)-pts.ZData).^2)' ;
        [~,IndPt] = min(distance) ;
        handles = GoTo(IndPt-1,FileData.ActualOrientation,handles) ;
        % MESH PLOT
            handles = plotMesh(handles) ;
        handles.toolChoosePoint.State = 'off' ;
        FileData.SensorPosition = [FileData.ActualPoint,FileData.ActualOrientation];
        handles = plotMeasurements(handles) ;
        
    case 'toolDebug' % BUTTON FOR DEBUGGING
        handles.toolDebug.State = 'off' ;
        eh = findobj(handles.Interface,'enable','off') ; % acts like a pushbutton
        % REACTIVATE ALL BUTTONS
            set(eh,'enable','on') ; % To Get out of errors !
        % DEBUGGING
            %handles = checkMeasurements(handles) ;
            %out = SignalProcessing(handles) ;
            %handles = plotMeasurements(handles) ;
        
    
    case 'contextAxesSignal' % MENU FOR THE SIGNAL AXES
        [~,handles.axesClicked,~] = MouseInAxes(handles.Interface) ;
        display(['Clicked on : ',handles.axesClicked.Tag]) ;
        handles = setContextState(handles) ;
        
    case 'contextAxesMesh' % MENU FOR THE MESH AXES
        [~,handles.axesClicked,~] = MouseInAxes(handles.Interface) ;
        display(['Clicked on : ',handles.axesClicked.Tag]) ;
        handles = setContextState(handles) ;
    
    case 'axes4' % ON CLICK ON THE AXES OF CURRENT MEASUREMENT
        if ~isempty(handles.axes4.Children)
            % Data plotted
                dataPlot = findobj(handles.axes4,'tag','AvgDATA') ;
            % If is data on axes4
                if ~isempty(dataPlot)
                    % Update the selected timeline point
                        FileData.ActualSample = closest(dataPlot.XData,handles.axes4.CurrentPoint(1,1)) ;
                    % Update the animation
                        handles.axesMesh.UserData.animationIndice = FileData.ActualSample ;
                    % Update Graphics
                        handles = plotCursor(handles) ;
                        handles = plotDeformedShape(handles) ; % handles = plotMeasurements(handles) ;
                        display(['Actual Sample : ',num2str(FileData.ActualSample)]) ;
                end
        end
        
    case 'popupDomain' % POPUP FOR CHOOSING TIME OR FREQUENCY DOMAIN
        switch handles.popupDomain.Value
            case 1 % Time
                handles.popupTimeSignals.Enable = 'on' ;
                handles.popupFFTSignals.Enable = 'off' ;
            case 2 % Freq
                handles.popupTimeSignals.Enable = 'off' ;
                handles.popupFFTSignals.Enable = 'on' ;
        end
        handles = plotMeasurements(handles) ;
        
    case 'popupLocation' % POPUP FOR CHOOSING SINGLE POINT OR AVERAGE ON MESH
        handles = plotMeasurements(handles) ;
        
    case 'popupTimeSignals' % POPUP FOR CHOOSING TIME SIGNALS TO PLOT
        handles = plotMeasurements(handles) ;
        
    case 'popupFFTSignals' % POPUP FOR CHOOSING FREQUENCY SIGNALS TO PLOT
        handles = plotMeasurements(handles) ;
        
    case 'popupComponent' % POPUP FOR CHOOSING DISPLACEMENT COMPONENT TO PLOT
        handles = plotMeasurements(handles) ;
        
    case 'popupWindow' % POPUP FOR CHOOSING DISPLACEMENT COMPONENT TO PLOT
        FileData.WindowName = handles.popupWindow.String{handles.popupWindow.Value} ;
        % Compute Window
            FileData.Window = eval([FileData.WindowName,'(handles.SignalInfos.RealisationSamples)']).' ;
        % RE-COMPUTE SIGNAL PROCESSING
        nPt = size(FileData.Targets,1) ;
        wtbr = waitbar(0,'Application du Signal processing...') ;
        for Pt = 1:nPt
            if sum(FileData.IsPointMeasured(Pt,:))>=1
                SignalProcessing(handles) ;
                wtbr = waitbar(Pt/nPt,wtbr) ;
            end
        end
        delete(wtbr) ;
        handles = plotMeasurements(handles) ;
        
    case 'toolSave' % SAVE THE GLOBAL VARIABLE DATA TO A FILE
        % Save All FileData or Plotted ?
            answer = questdlg({'Which Data Do You Want To Save ?'},...
                'Choose Data To Save',...
                'All','Current Plot','Cancel',...
                'All') ;
        % Save or cancel if needed
            if strcmp(answer,'Cancel') ; return ; end
            [FILENAME, PATHNAME, FILTERINDEX] = uiputfile('*.mat') ;
            if ~FILTERINDEX ; return ; end
            switch answer
                case 'All'
                    % SAVE AL DATA AND SIGNAL INFOS
                        SignalInfos = handles.SignalInfos ;
                        save([PATHNAME,FILENAME],'FileData','SignalInfos','-v7.3') ;
                case 'Current Plot'
                    % VERIFY PRESENCE OF DATA
                        if ~isfield(handles.axes4.UserData,'currentData') 
                            errordlg('No FileData Plotted To Save') ; 
                            return
                        end
                    % SAVE CURRENT PLOTTED DATA ONLY
                        plotdata = handles.axes4.UserData.currentData ;
                    % DATA RETRIEVAL
                        % Initial Position
                            X0 = FileData.X ;
                            Y0 = FileData.Y ;
                            Z0 = FileData.Z ;
                        % XData
                            switch plotdata 
                                case 'Total' 
                                    XData = 'TotalTime' ;
                                case 'Avg'  
                                    XData = 'Time' ;
                                case 'AvgAC' 
                                    XData = 'corrTime' ;
                                case 'AvgCC' 
                                    XData = 'corrTime' ;
                                case 'FFT' 
                                    XData = 'Freq' ;
                                case 'AvgAS' 
                                    XData = 'corrFreq' ;
                                case 'AvgCS' 
                                    XData = 'corrFreq' ;
                                case 'AvgH1' 
                                    XData = 'corrFreq' ;
                                case 'AvgH2'
                                    XData = 'corrFreq' ;
                                case 'Coh'
                                    XData = 'corrFreq' ;
                            end
                        % Extract XData
                            eval([XData,' = FileData.',XData,' ;']) ;
                        % Deviations Retrieval
                            nT = eval(['length(',XData,')']) ;
                            nPt = length(X0) ;
                            dX = zeros(nT,nPt) ;
                            dY = zeros(nT,nPt) ;
                            dZ = zeros(nT,nPt) ;
                            % Default saved fields 
                                fieldsToSave = {'IsPointMeasured'} ;
                            % User-Chosen Fields
                                for subField = {'dX','dY','dZ'}
                                    % Data Averaged
                                        if isfield(FileData,[plotdata,subField{1}])
                                            fieldsToSave{end+1} = [plotdata,subField{1}] ;
                                        end
                                    % Data Variance
                                        plotdataVar = regexprep(plotdata,'Avg','Var') ;
                                        if ~strcmp(plotdataVar,plotdata) && isfield(FileData,[plotdataVar,subField{1}])
                                            fieldsToSave{end+1} = [plotdataVar,subField{1}] ;
                                        end
                                    % Data without average
                                        plotdataNoAvg = regexprep(plotdata,'Avg','') ;
                                        if ~strcmp(plotdataNoAvg,plotdata) && isfield(FileData,[plotdataNoAvg,subField{1}])
                                            fieldsToSave{end+1} = [plotdataNoAvg,subField{1}] ;
                                        end
                                end
                            % Declare fields
                                for fi = 1:length(fieldsToSave)
                                    if 0 %Previous version
                                        for i = 1:length(X0)
                                            if FileData.IsPointMeasured(i,1)
                                                eval([plotdata,subField{1},'(:,i) = FileData.',plotdata,subField{1},'(i,:) ;']) ;
                                            end
                                        end
                                    end
                                    eval([fieldsToSave{fi},' = FileData.',fieldsToSave{fi},' ;']) ;
                                end
                    % TO FILE
                        % Add SignalInfos
                            SignalInfos = handles.SignalInfos ;
                        % Save
%                             save([PATHNAME,plotdata,'_',FILENAME],'X0','Y0','Z0','dX','dY','dZ',XData,'SignalInfos','-v7.3') ;
                            save([PATHNAME,plotdata,'_',FILENAME],'X0','Y0','Z0',fieldsToSave{:},XData,'SignalInfos','-v7.3') ;
                            display(['DATA SAVED : ',plotdata]) ;
            end
        
    case 'toolOpen' % LOAD THE GLOBAL VARIABLE DATA FROM A FILE
        % Prevent loose of Measurements !
            answer = questdlg({'Loading a file will erase all current data.','Save current Data File before ?'},...
                'Warning : Load Data File',...
                'Save','Do not Save','Cancel',...
                'Cancel') ;
        % Save or cancel if needed
            switch answer
                case 'Cancel'
                    return
                case 'Save'
                    General_Callback(handles.buttonSaveFileData, eventdata, handles) ;
                case 'Do not Save'
            end
        [FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.mat') ;
        if FILTERINDEX
            LoadFileData = load([PATHNAME,FILENAME]) ;
            handles.SignalInfos = LoadFileData.SignalInfos ;
            FileData = LoadFileData.FileData ;
        end
        handles = plotMeasurements(handles) ;
        
    case 'toolAnime' % ANIME THE DEFORMED SHAPE   
        if strcmp(handles.Timer.Running,'on')
            hObject.State = 'off' ;
            stop(handles.Timer) ;
            display(['TIMER STOPPED : now it''s ',handles.Timer.Running])
        else
            % Set Time indice for animation
                handles.axesMesh.UserData.animationIndice = FileData.ActualSample ;
            % Set Timer Properties
                handles.Timer.Period = 0.03 ;
                handles.Timer.ExecutionMode = 'fixedDelay' ;
                handles.Timer.TimerFcn = @(src,evt)animeDefShape(handles,evt.Data.time(end)) ;
                hObject.State = 'on' ;
                start(handles.Timer) ;
                display(['TIMER STARTED : now it''s ',handles.Timer.Running])
        end
    
    case 'toolCheckMeasurements'
         handles = checkMeasurements(handles) ;
        
    case 'toolSignalProcessing'
        FileData.KeepProcessing = SIGNAL_PROCESSING_OPTIONS(FileData.KeepProcessing) ;
        display('SIGNAL PROCESSING WILL SAVE DATA FIELDS :')
        display(FileData.KeepProcessing')
        InitSignalProcessing(handles) ;
        
        
    otherwise  % IF NONE OF THE PREVIOUS OPTIONS HAS BEEN CHOSEN
        % Signal Axes Context Menus
            % Signal Representation Choice
                if (~isempty(strfind(hObject.Tag,'contextAxesSignal_Signal_')))
                    strMenu = strrep(hObject.Tag,'contextAxesSignal_Signal_','') ;
                    display(['Context Menu : ',strMenu])
                    display(['Checked : ',hObject.Checked])
                    if (strcmp(hObject.Checked,'off'))
                        plot(handles.axesClicked,0,0,'Tag',strMenu) ;
                    else
                        delete(findobj(handles.axesClicked,'Tag',strMenu)) ;
                    end
                    handles = plotData(InstantData.ToPlot,handles) ;
                    handles = updateLegends(handles) ;
                end
            % Lims Choice
                if (~isempty(strfind(hObject.Tag,'contextAxesSignal_Lims_')))
                    strMenu = strrep(hObject.Tag,'contextAxesSignal_Lims_','') ;
                    display(['Context Menu : ',strMenu])
                    display(['Checked : ',hObject.Checked])
                    if (strcmp(handles.contextAxesSignal_Signal_FFT.Checked,'on'))
                        ax = handles.axesClicked ;
                        if (~isempty(handles.Session))
                            switch (strMenu)
                                case 'Whole_Bandwidth'
                                    ax.XLim = [0 handles.Session.Rate] ;
                                case 'Shannon_Bandwidth'
                                    ax.XLim = [0 handles.Session.Rate/2] ;
                                case 'Excitation_Bandwidth'
                                    if (~isempty(handles.SignalInfos))
                                        ax.XLim = [handles.SignalInfos.Fmin handles.SignalInfos.Fmax] ;
                                    end
                            end
                        end
                    end
                end
            % Lims Choice
                if (~isempty(strfind(hObject.Tag,'contextAxesSignal_Scale_')))
                    strMenu = strrep(hObject.Tag,'contextAxesSignal_Scale_','') ;
                    display(['Context Menu : ',strMenu])
                    display(['Checked : ',hObject.Checked])
                    if (strcmp(handles.contextAxesSignal_Signal_FFT.Checked,'on'))
                        ax = handles.axesClicked ;
                        if (~isempty(handles.Session))
                            switch (strMenu)
                                case 'X_Log'
                                    ax.XScale = 'log' ;
                                case 'X_Lin'
                                    ax.XScale = 'linear' ;
                                case 'Y_Log'
                                    ax.YScale = 'log' ;
                                case 'Y_Lin'
                                    ax.YScale = 'linear' ;
                            end
                        end
                    end
                end
        % Mesh Axes Context Menus
            % Plot Menu
                if (~isempty(strfind(hObject.Tag,'contextAxesMesh_Plot_')))
                    strMenu = strrep(hObject.Tag,'contextAxesMesh_Plot_','') ;
                    display(['Context Menu : ',strMenu])
                    display(['Checked : ',hObject.Checked])
                    if strcmp(hObject.Checked,'on')
                        hObject.Checked = 'off' ;
                    else
                        hObject.Checked = 'on' ;
                    end
                    handles = plotMesh(handles) ;
                end
end


% FOLLOWING LINES ARE EXECUTED EVERY TIME

% Actualise Listeners if needed
    if (~isempty(handles.Session))
        handles.OutputListener.Callback = @(src,event) OutputListener(src,event,handles) ;
        handles.InputListener.Callback = @(src,event) InputListener(src,event,handles) ;
    end
    
% Actualise Infos
    handles = displayInfosInList(handles) ;

% Update handles structure
    guidata(hObject, handles);
    
    
    


