function varargout = SET_EXCITATION_ROBOT_LASER(varargin)
% SET_EXCITATION_ROBOT_LASER MATLAB code for SET_EXCITATION_ROBOT_LASER.fig
%      SET_EXCITATION_ROBOT_LASER, by itself, creates a new SET_EXCITATION_ROBOT_LASER or raises the existing
%      singleton*.
%
%      H = SET_EXCITATION_ROBOT_LASER returns the handle to a new SET_EXCITATION_ROBOT_LASER or the handle to
%      the existing singleton*.
%
%      SET_EXCITATION_ROBOT_LASER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SET_EXCITATION_ROBOT_LASER.M with the given input arguments.
%
%      SET_EXCITATION_ROBOT_LASER('Property','Value',...) creates a new SET_EXCITATION_ROBOT_LASER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SET_EXCITATION_ROBOT_LASER_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SET_EXCITATION_ROBOT_LASER_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SET_EXCITATION_ROBOT_LASER

% Last Modified by GUIDE v2.5 11-Oct-2016 10:54:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SET_EXCITATION_ROBOT_LASER_OpeningFcn, ...
                   'gui_OutputFcn',  @SET_EXCITATION_ROBOT_LASER_OutputFcn, ...
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


% --- Executes just before SET_EXCITATION_ROBOT_LASER is made visible.
function SET_EXCITATION_ROBOT_LASER_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SET_EXCITATION_ROBOT_LASER (see VARARGIN)

% Choose default command line output for SET_EXCITATION_ROBOT_LASER
    handles.output = hObject;
    

% INITIALISE DATA
    handles.Session = varargin{1} ;
    handles.SignalInfos = varargin{2} ;
    handles.plotTime = plot(handles.axesTime,1:10,1:10,'k') ;
    handles.plotFFT = plot(handles.axesFFT,1:10,1:10,'k') ;
    
% BACKUP CONFIG
    handles.OldSession = handles.Session ;
    handles.OldSignalInfos = handles.SignalInfos ;
    
% INITIALISE INTERFACE
    if (~isempty(handles.SignalInfos))
        % Import Values from Interface
            SignalInfos = handles.SignalInfos
            handles.editSamplingRate.String = num2str(SignalInfos.Fe) ;
            handles.popupSignalType.Value = find(strcmp(SignalInfos.Type,strtrim(handles.popupSignalType.String))) ;
            handles.editDuration.String = SignalInfos.Duration ;
            handles.editDelay.String = num2str(SignalInfos.Delay) ;
            handles.editFrequency.String = num2str(SignalInfos.F0) ;
            handles.editPeriods.String = num2str(SignalInfos.Periods) ;
            handles.editFmin.String = num2str(SignalInfos.Fmin) ;
            handles.editFmax.String = num2str(SignalInfos.Fmax) ;
            handles.popupAmp.Value = find(strcmp(strtrim(handles.popupAmp.String),SignalInfos.Window)) ;
            handles.editAverages.String = num2str(SignalInfos.Averages) ;
            handles.checkboxRejection.Value = SignalInfos.Rejection ;
            handles.checkboxRejectionSaturation.Value = SignalInfos.RejectionOnSaturation ;
            handles.checkboxRejectionCoherence.Value = SignalInfos.RejectionOnCoherence ;
            handles.editRejectionSaturationThreshold.String = num2str(SignalInfos.RejectionSaturationThreshold) ;
            handles.editRejectionCoherenceThreshold.String = num2str(SignalInfos.RejectionCoherenceThreshold) ;
            handles.editOverlap.String = num2str(SignalInfos.Overlap) ;
            handles.editWaitSteady.String = num2str(SignalInfos.WaitSteady) ;
    end
    % Process Data
        General_Callback(handles.popupSignalType, {}, handles)
        %handles = updateInterface(handles) ;

% Update handles structure
    guidata(hObject, handles);
    
    
% UIWAIT makes SET_SESSION_ROBOT_LASER wait for user response (see UIRESUME)
    uiwait(handles.Interface) ;

% UIWAIT makes SET_EXCITATION_ROBOT_LASER wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SET_EXCITATION_ROBOT_LASER_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.Session ;
    varargout{2} = handles.SignalInfos ;

% Hint: delete(hObject) closes the figure
    delete(handles.Interface);
    
    
function Interface_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Was the close button ? will reset original settings
if (strcmp(hObject.Tag,handles.Interface.Tag))
    answer = questdlg({'Closing this window will undo all changes made on the signal.'},...
                'Warning : Session Reset',...
                'Quit','Cancel',...
                'Cancel') ;
    if (strcmp(answer,'Quit'))
        handles.Session = handles.OldSession ;
        handles.SignalInfos = handles.OldSignalInfos ;
        close(hObject) ;
    else 
        return
    end
end

% Update handles structure
    guidata(hObject, handles) ;

% Call OutputFunction
    uiresume
    
    
function handles = updateSignalInfos(handlesIN)
    handles = handlesIN ;
    % Import Values from Interface
        SignalInfos.Fe = handles.Session.Rate ;
        SignalInfos.Type = strtrim(handles.popupSignalType.String{handles.popupSignalType.Value}) ;
        SignalInfos.Duration = str2double(handles.editDuration.String) ;
        SignalInfos.Delay = str2double(handles.editDelay.String) ;
        SignalInfos.F0 = str2double(handles.editFrequency.String) ;
        SignalInfos.Periods = str2double(handles.editPeriods.String) ;
        SignalInfos.Fmin = str2double(handles.editFmin.String) ;
        SignalInfos.Fmax = str2double(handles.editFmax.String) ;
        SignalInfos.Window = strtrim(handles.popupAmp.String{handles.popupAmp.Value}) ;
        SignalInfos.Averages = str2double(handles.editAverages.String) ;
        SignalInfos.Rejection = handles.checkboxRejection.Value ;
        SignalInfos.RejectionOnSaturation = handles.checkboxRejectionSaturation.Value ;
        SignalInfos.RejectionOnCoherence = handles.checkboxRejectionCoherence.Value ;
        SignalInfos.RejectionSaturationThreshold = str2double(handles.editRejectionSaturationThreshold.String) ;
        SignalInfos.RejectionCoherenceThreshold = str2double(handles.editRejectionCoherenceThreshold.String) ;
        SignalInfos.Overlap = str2double(handles.editOverlap.String) ;
        SignalInfos.WaitSteady = str2double(handles.editWaitSteady.String) ;
    % Ajust some infos that are bounded
        SignalInfos.Fmax = min(SignalInfos.Fmax,SignalInfos.Fe/2.01) ;
        handles.editFmax.String = num2str(SignalInfos.Fmax) ;
        SignalInfos.Fmin = min(SignalInfos.Fmax-eps,max(SignalInfos.Fmin,1/SignalInfos.Duration)) ;
        handles.editFmin.String = num2str(SignalInfos.Fmin) ;
    % Compute Auxiliary Informations 
        % IF NEEDED, OVERWRITE (Waveform-dependent)
            switch (SignalInfos.Type)
                case 'White Noise'
                    SignalInfos.CanBeContinuous = 'true' ;
                case 'White Noise Filtered'
                    SignalInfos.CanBeContinuous = 'true' ;
                case 'Blue Noise Filtered'
                    SignalInfos.CanBeContinuous = 'true' ;
                case 'Tone'
                    SignalInfos.Duration = SignalInfos.Periods/SignalInfos.F0 ;
                    handles.editDuration.String = num2str(SignalInfos.Duration) ;
                    SignalInfos.CanBeContinuous = 'true' ;
                case 'Burst'
                    SignalInfos.WaitSteady = 0 ;
                    SignalInfos.Overlap = 0 ;
                    SignalInfos.CanBeContinuous = 'false' ;
                case 'Sweep'
                    SignalInfos.WaitSteady = 0 ;
                    SignalInfos.Overlap = 0 ;
                    SignalInfos.CanBeContinuous = 'false' ;
                case 'Sweep (Log)'
                    SignalInfos.WaitSteady = 0 ;
                    SignalInfos.Overlap = 0 ;
                    SignalInfos.CanBeContinuous = 'false' ;
                case 'Impulse'
                    SignalInfos.WaitSteady = 0 ;
                    SignalInfos.Overlap = 0 ;
                    SignalInfos.CanBeContinuous = 'false' ;
                case 'User'
            end
    % THEN
        % Different lengths
            SignalInfos.WaitSteadySamples = round(SignalInfos.WaitSteady*SignalInfos.Fe) ;
            SignalInfos.RealisationSamples = round(SignalInfos.Duration*SignalInfos.Fe) ;
            SignalInfos.OverlapSamples = round(SignalInfos.Duration*SignalInfos.Fe*SignalInfos.Overlap) ;
            SignalInfos.MeasuredSamples = SignalInfos.RealisationSamples*SignalInfos.Averages...
                                        - (SignalInfos.Averages-1)*SignalInfos.OverlapSamples ;
            SignalInfos.TotalNumberOfSamples = SignalInfos.WaitSteadySamples + SignalInfos.MeasuredSamples ;
        % Different Times
            SignalInfos.RealisationTime = (0:SignalInfos.RealisationSamples-1)/SignalInfos.Fe ;
            SignalInfos.TotalTime = ((0:SignalInfos.TotalNumberOfSamples-1)-SignalInfos.WaitSteadySamples)/SignalInfos.Fe ; ... time is zero at the beginning of the measure, negative before
        % Frequency vector
            SignalInfos.f = (0:SignalInfos.RealisationSamples-1)/SignalInfos.RealisationSamples*SignalInfos.Fe ;
        % Different Signals vectors Initialisation
            SignalInfos.TotalSignal = zeros(1,SignalInfos.TotalNumberOfSamples) ;
            SignalInfos.ContinuousSignal = zeros(1,SignalInfos.MeasuredSamples) ;
            SignalInfos.Signal = zeros(1,SignalInfos.RealisationSamples) ;
    % COMPUTE TOTAL SIGNAL 
        switch (SignalInfos.Type)
            case 'White Noise'
                SignalInfos.TotalSignal = 1-2*rand(1,SignalInfos.TotalNumberOfSamples) ;
            case 'White Noise Filtered'
                Order = 1000 ;
                SignalInfos.TotalSignal = 1-2*rand(1,SignalInfos.TotalNumberOfSamples) ;
                Filter = fir1(Order,[SignalInfos.Fmin SignalInfos.Fmax]/SignalInfos.Fe*2,'bandpass') ;
                SignalInfos.TotalSignal = conv(SignalInfos.TotalSignal,Filter,'same') ;
            case 'Blue Noise Filtered'
                Order = 1000 ;
                SignalInfos.TotalSignal = 1-2*rand(1,SignalInfos.TotalNumberOfSamples) ;
                % Blue noise
                    L = length(SignalInfos.TotalSignal) ;
                    N = round(L/2) ;
                    fftBlue = fft(SignalInfos.TotalSignal).*([0:N-1,(L-N-1):-1:0]+L/100) ;%
                    SignalInfos.TotalSignal = real(ifft(fftBlue)) ;
                Filter = fir1(Order,[SignalInfos.Fmin SignalInfos.Fmax]/SignalInfos.Fe*2,'bandpass') ;
                SignalInfos.TotalSignal = conv(SignalInfos.TotalSignal,Filter,'same') ;
                % Normalisation
                    SignalInfos.TotalSignal = SignalInfos.TotalSignal./max(abs(SignalInfos.TotalSignal(:))) ;
            case 'Tone'
                SignalInfos.TotalSignal = sin(2*pi*SignalInfos.F0*SignalInfos.TotalTime) ;
            case 'Sweep'
                instantF = linspace(SignalInfos.Fmin,SignalInfos.Fmax,SignalInfos.RealisationSamples) ;
                SINVAR = sin(2*pi*instantF.*SignalInfos.RealisationTime) ;
                SignalInfos.TotalSignal = repmat(SINVAR,[1 SignalInfos.Averages]) ;
            case 'Sweep (Log)'
                instantF = logspace(log10(SignalInfos.Fmin),log10(SignalInfos.Fmax),SignalInfos.RealisationSamples) ;
                SINVAR = sin(2*pi*instantF.*SignalInfos.RealisationTime) ;
                SignalInfos.TotalSignal = repmat(SINVAR,[1 SignalInfos.Averages]) ;
            case 'Burst'
                delay = SignalInfos.Delay/100*SignalInfos.Duration ;
                winSize = SignalInfos.Periods/SignalInfos.F0 ;
                win = double((SignalInfos.RealisationTime>delay) & (SignalInfos.RealisationTime<delay+winSize)) ;
                switch (SignalInfos.Window)
                    case 'Rectangle'
                    case 'Sinus'
                        win = win.*sin(pi/winSize*(SignalInfos.RealisationTime-delay)) ;
                end
                BURST = win.*sin(2*pi*SignalInfos.F0*(SignalInfos.RealisationTime-delay)) ;
                SignalInfos.TotalSignal = repmat(BURST,[1 SignalInfos.Averages]) ;
            case 'Impulse'
                delay = SignalInfos.Delay/100*SignalInfos.Duration ;
                winSize = SignalInfos.Periods/SignalInfos.F0 ;
                IMPULSE = double((SignalInfos.RealisationTime>delay) & (SignalInfos.RealisationTime<delay+winSize)) ;
                switch (SignalInfos.Window)
                    case 'Rectangle'
                    case 'Sinus'
                        IMPULSE = IMPULSE.*sin(pi/winSize*(SignalInfos.RealisationTime-delay)).^2 ;
                end
                SignalInfos.TotalSignal = repmat(IMPULSE,[1 SignalInfos.Averages]) ;
            case 'User'
        end
        % Fade In for the beginning of stationnary signals
        if (strcmp(SignalInfos.CanBeContinuous,'true') && (SignalInfos.WaitSteadySamples>0))
            FadeIn = ones(size(SignalInfos.TotalTime)) ;
            nFadeIn = floor(SignalInfos.WaitSteadySamples/2) ;
            FadeIn(1:nFadeIn) = FadeIn(1:nFadeIn).*linspace(0,1,nFadeIn) ;
            SignalInfos.TotalSignal = SignalInfos.TotalSignal.*FadeIn ;
        end
        % COMPUTE PARTIAL SIGNALS
            SignalInfos.ContinuousSignal = SignalInfos.TotalSignal(end-SignalInfos.MeasuredSamples+1:end) ;
            SignalInfos.Signal = SignalInfos.TotalSignal(end-SignalInfos.RealisationSamples+1:end) ;
        % TIME TO USE 
            SignalInfos.Time = SignalInfos.RealisationTime ;
        % DISPLAY INFOS
            SignalInfos
    % Backup Signal Infos
        handles.SignalInfos = SignalInfos ;
    
    
function handles = updateInterface(handlesIN)
    handles = handlesIN ;
    if (isempty(handles.SignalInfos)) % No Signal Infos
        handles = defaultInterface(handles) ;
    else % A change has to be made
        %display('has to be changed')
    end
    handles = updateSignalInfos(handles) ;
    handles.plotTime.XData = handles.SignalInfos.RealisationTime ;
    handles.plotTime.YData = handles.SignalInfos.Signal ;
    handles.plotFFT.XData = handles.SignalInfos.f ;
    handles.plotFFT.YData = abs(fft(handles.SignalInfos.Signal)) ;
    
    
    
function handles = defaultInterface(handlesIN)
    handles = handlesIN ;
    handles.editSamplingRate.String = '51200' ;
    handles.popupSignalType.Value = 1 ;
    handles.editDuration.String = '1' ;
    handles.editDelay.Enable = 'off' ;
    handles.editFrequency.Enable = 'off' ;
    handles.editPeriods.Enable = 'off' ;
    handles.editFmin.Enable = 'off' ;
    handles.editFmax.Enable = 'off' ;
    handles.popupAmp.Enable = 'off' ;
    handles.editAverages.String = '10' ;
    handles.checkboxRejection.Value = 1 ;
    handles.checkboxRejectionSaturation.Value = 1 ;
    handles.checkboxRejectionSaturationThreshold.String = '95' ;
    handles.checkboxRejectionCoherence.Value = 1 ;
    handles.checkboxRejectionCoherenceThreshold.String = '95' ;
    
    
%--- GENERAL CALLBACK
% @(hObject,eventdata)SET_EXCITATION_ROBOT_LASER('General_Callback',hObject,eventdata,guidata(hObject))
function General_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA
clc
hObject.Tag

switch (hObject.Tag)
    case 'buttonOK'
        Interface_CloseRequestFcn(hObject, eventdata, handles) ;
        return
    case 'editSamplingRate'
        % The Rate is corrected to be compatible with the hardware
        handles.Session.Rate = str2double(handles.editSamplingRate.String) ; % Could display a warning message
        handles.editSamplingRate.String = num2str(handles.Session.Rate) ;
    case 'popupSignalType'
        switch (strtrim(handles.popupSignalType.String{handles.popupSignalType.Value}))
            case 'White Noise'
                handles.editDuration.Enable = 'on' ;
                handles.editDelay.Enable = 'off' ;
                handles.editFrequency.Enable = 'off' ;
                handles.editPeriods.Enable = 'off' ;
                handles.editFmin.Enable = 'off' ;
                handles.editFmax.Enable = 'off' ;
                handles.popupAmp.Enable = 'off' ;
            case 'White Noise Filtered'
                handles.editDuration.Enable = 'on' ;
                handles.editDelay.Enable = 'off' ;
                handles.editFrequency.Enable = 'off' ;
                handles.editPeriods.Enable = 'off' ;
                handles.editFmin.Enable = 'on' ;
                handles.editFmax.Enable = 'on' ;
                handles.popupAmp.Enable = 'off' ;
            case 'Blue Noise Filtered'
                handles.editDuration.Enable = 'on' ;
                handles.editDelay.Enable = 'off' ;
                handles.editFrequency.Enable = 'off' ;
                handles.editPeriods.Enable = 'off' ;
                handles.editFmin.Enable = 'on' ;
                handles.editFmax.Enable = 'on' ;
                handles.popupAmp.Enable = 'off' ;
            case 'Tone'
                handles.editDuration.Enable = 'off' ;
                handles.editDelay.Enable = 'off' ;
                handles.editFrequency.Enable = 'on' ;
                handles.editPeriods.Enable = 'on' ;
                handles.editFmin.Enable = 'off' ;
                handles.editFmax.Enable = 'off' ;
                handles.popupAmp.Enable = 'off' ;
            case 'Sweep'
                handles.editDuration.Enable = 'on' ;
                handles.editDelay.Enable = 'off' ;
                handles.editFrequency.Enable = 'off' ;
                handles.editPeriods.Enable = 'off' ;
                handles.editFmin.Enable = 'on' ;
                handles.editFmax.Enable = 'on' ;
                handles.popupAmp.Enable = 'off' ;
            case 'Sweep (Log)'
                handles.editDuration.Enable = 'on' ;
                handles.editDelay.Enable = 'off' ;
                handles.editFrequency.Enable = 'off' ;
                handles.editPeriods.Enable = 'off' ;
                handles.editFmin.Enable = 'on' ;
                handles.editFmax.Enable = 'on' ;
                handles.popupAmp.Enable = 'off' ;
            case 'Burst'
                handles.editDuration.Enable = 'on' ;
                handles.editDelay.Enable = 'on' ;
                handles.editFrequency.Enable = 'on' ;
                handles.editPeriods.Enable = 'on' ;
                handles.editFmin.Enable = 'off' ;
                handles.editFmax.Enable = 'off' ;
                handles.popupAmp.Enable = 'on' ;
            case 'Impulse'
                handles.editDuration.Enable = 'on' ;
                handles.editDelay.Enable = 'on' ;
                handles.editFrequency.Enable = 'on' ;
                handles.editPeriods.Enable = 'off' ;
                handles.editFmin.Enable = 'off' ;
                handles.editFmax.Enable = 'off' ;
                handles.popupAmp.Enable = 'on' ;
            case 'User'
                handles.editDuration.Enable = 'off' ;
                handles.editDelay.Enable = 'off' ;
                handles.editFrequency.Enable = 'off' ;
                handles.editPeriods.Enable = 'off' ;
                handles.editFmin.Enable = 'off' ;
                handles.editFmax.Enable = 'off' ;
                handles.popupAmp.Enable = 'off' ;
        end
end

handles = updateInterface(handles) ;

% Update handles structure
    guidata(hObject, handles) ;

    
    
    
    
    