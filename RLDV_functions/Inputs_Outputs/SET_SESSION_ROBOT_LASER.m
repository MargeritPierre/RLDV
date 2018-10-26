function varargout = SET_SESSION_ROBOT_LASER(varargin)
% SET_SESSION_ROBOT_LASER MATLAB code for SET_SESSION_ROBOT_LASER.fig
%      SET_SESSION_ROBOT_LASER, by itself, creates a new SET_SESSION_ROBOT_LASER or raises the existing
%      singleton*.
%
%      H = SET_SESSION_ROBOT_LASER returns the handle to a new SET_SESSION_ROBOT_LASER or the handle to
%      the existing singleton*.
%
%      SET_SESSION_ROBOT_LASER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SET_SESSION_ROBOT_LASER.M with the given input arguments.
%
%      SET_SESSION_ROBOT_LASER('Property','Value',...) creates a new SET_SESSION_ROBOT_LASER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SET_SESSION_ROBOT_LASER_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SET_SESSION_ROBOT_LASER_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SET_SESSION_ROBOT_LASER

% Last Modified by GUIDE v2.5 17-Feb-2017 14:16:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1 ;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SET_SESSION_ROBOT_LASER_OpeningFcn, ...
                   'gui_OutputFcn',  @SET_SESSION_ROBOT_LASER_OutputFcn, ...
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


% --- Executes just before SET_SESSION_ROBOT_LASER is made visible.
function SET_SESSION_ROBOT_LASER_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SET_SESSION_ROBOT_LASER (see VARARGIN)
clc

% Backup Session in case of Quit
if (~isempty(varargin)) 
    if (isempty(varargin{1}))
    % INSession was empty
        handles.OLDSession = {} ;
    else
        handles.OLDSession = varargin{1} ;
    end
end
    
% We need to create a session and initialize the lists
    handles = resetSession(handles) ;

% Choose default command line output for SET_SESSION_ROBOT_LASER
    handles.output = 'Has Bugged' ;
    
% Update handles structure
    guidata(hObject, handles) ;

% UIWAIT makes SET_SESSION_ROBOT_LASER wait for user response (see UIRESUME)
    uiwait(handles.Figure) ;


% --- Outputs from this function are returned to the command line.
function varargout = SET_SESSION_ROBOT_LASER_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.OUTSession ;

% Hint: delete(hObject) closes the figure
delete(handles.Figure);


% --- Executes when user attempts to close Figure.
function Figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (strcmp(hObject.Tag,handles.Figure.Tag) || isempty(handles.OUTSession))
    handles.OUTSession = handles.OLDSession ;
else
    % Remove Old Channels
        % handles.OUTSession.Channels
        for i = 1:length(handles.OUTSession.Channels)
            removeChannel(handles.OUTSession,1) ;
        end
        
    % Generator Channel
        GENE = addAnalogOutputChannel(handles.OUTSession,...
                    handles.GeneDevice.String{handles.GeneDevice.Value},...
                    handles.GeneChannel.String{handles.GeneChannel.Value},...
                    handles.GeneType.String{handles.GeneType.Value}) ;
        GENE.Name = handles.GeneName.String ;
        GENE.TerminalConfig = handles.GeneConfig.String ;
    % Ref Channel
        REF = addAnalogInputChannel(handles.OUTSession,...
                    handles.RefDevice.String{handles.RefDevice.Value},...
                    handles.RefChannel.String{handles.RefChannel.Value},...
                    handles.RefType.String{handles.RefType.Value}) ;
        REF.Name = handles.RefName.String ;
        REF.TerminalConfig = handles.RefConfig.String{handles.RefConfig.Value} ;
    % Vibrometer Channel
        VIB = addAnalogInputChannel(handles.OUTSession,...
                    handles.VibDevice.String{handles.VibDevice.Value},...
                    handles.VibChannel.String{handles.VibChannel.Value},...
                    handles.VibType.String{handles.VibType.Value}) ;
        VIB.Name = handles.VibName.String ;
        VIB.TerminalConfig = handles.VibConfig.String{handles.VibConfig.Value} ;
        % Set the range of the vibrometer Channel
            VIB.Range = daq.Range(-5,5,'Volts') ;
end

% Update handles structure
    guidata(hObject, handles) ;

% Call OutputFunction
    uiresume

    
function handles = resetSession(handlesIN)
    handles = handlesIN ;
    handles.OLDSession = {} ;
    handles.OUTSession = {} ;
    daq.reset ;
    handles = getDevices(handles) ;
    if (isempty(handles.devices)) % No device
        errordlg({'No Devices Found !' , 'Plug a Device and Reset or Quit'}) ;
        set(findobj(handles.Figure,'-property','enable'),'enable','off') ;
        set(handles.Reset,'enable','on') ;
        return
    else % Devices are present
        set(findobj(handles.Figure,'-property','enable'),'enable','on') ;
        handles.OUTSession = daq.createSession('ni') ;
        warndlg('New Session Started.')
        set(findobj(handles.Figure,'style','popupmenu'),'string','--') ;
        handles = updatePopups(handles) ;
        if (~isempty(handles.devices))
            % OUTPUTS
                handles.GeneDevice.Value = 1 ;
                handles.GeneSubsystem.Value = 1 ;
                handles.GeneChannel.Value = 1 ;
                handles.GeneType.Value = 1 ;
                handles.GeneConfig.Value = 1 ;
            % INPUTS
                % REF CHANNEL
                    handles.RefDevice.Value = 1 ;
                    handles.RefSubsystem.Value = 1 ;
                    handles.RefChannel.Value = 1 ;
                    handles.RefType.Value = 1 ;
                    handles.RefConfig.Value = 1 ;
                % VIBROMETER CHANNEL
                    handles.VibDevice.Value = 1 ;
                    handles.VibSubsystem.Value = 1 ;
                    handles.VibChannel.Value = 1 ;
                    handles.VibType.Value = 1 ;
                    handles.VibConfig.Value = 1 ;
        end
    end
    
function handles = getDevices(handlesIN)  
    handles = handlesIN ;  
    handles.devices = daq.getDevices ;
    
function handles = updatePopups(handlesIN)
    handles = handlesIN ;
        if (~isempty(handles.devices))
            % OUTPUTS
                handles.GeneDevice.String = {handles.devices(:).ID} ;
                handles.GeneSubsystem.String = {handles.devices(handles.GeneDevice.Value).Subsystems(:).SubsystemType} ;
                handles.GeneChannel.String = handles.devices(handles.GeneDevice.Value).Subsystems(handles.GeneSubsystem.Value).ChannelNames ;
                handles.GeneType.String = handles.devices(handles.GeneDevice.Value).Subsystems(handles.GeneSubsystem.Value).MeasurementTypesAvailable ;
                handles.GeneConfig.String = handles.devices(handles.GeneDevice.Value).Subsystems(handles.GeneSubsystem.Value).TerminalConfigsAvailable ;
            % INPUTS
                % REF CHANNEL
                handles.RefDevice.String = {handles.devices(:).ID} ;
                handles.RefSubsystem.String = {handles.devices(handles.RefDevice.Value).Subsystems(:).SubsystemType} ;
                handles.RefChannel.String = handles.devices(handles.RefDevice.Value).Subsystems(handles.RefSubsystem.Value).ChannelNames ;
                handles.RefType.String = handles.devices(handles.RefDevice.Value).Subsystems(handles.RefSubsystem.Value).MeasurementTypesAvailable ;
                handles.RefConfig.String = handles.devices(handles.RefDevice.Value).Subsystems(handles.RefSubsystem.Value).TerminalConfigsAvailable ;
                % VIBROMETER CHANNEL
                handles.VibDevice.String = {handles.devices(:).ID} ;
                handles.VibSubsystem.String = {handles.devices(handles.VibDevice.Value).Subsystems(:).SubsystemType} ;
                handles.VibChannel.String = handles.devices(handles.VibDevice.Value).Subsystems(handles.VibSubsystem.Value).ChannelNames ;
                handles.VibType.String = handles.devices(handles.VibDevice.Value).Subsystems(handles.VibSubsystem.Value).MeasurementTypesAvailable ;
                handles.VibConfig.String = handles.devices(handles.VibDevice.Value).Subsystems(handles.VibSubsystem.Value).TerminalConfigsAvailable ;
        end


% --- GENERAL CALLBACK
% @(hObject,eventdata)SET_SESSION_ROBOT_LASER('General_Callback',hObject,eventdata,guidata(hObject))
function General_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA
hObject.Tag

switch (hObject.Tag)
    case 'OK'
        Figure_CloseRequestFcn(hObject, eventdata, handles) ;
        return
    case 'Reset'
%         options.FontSize = 15 ;
%         options.Default = 'Abort' ;
%         options.Interpreter = 'tex' ;
        answer = questdlg({'Resetting session will erase all parameters previously setted.'},...
                    'Warning : Session Reset',...
                    'Continue','Abort',...
                    'Abort') ;
        if (strcmp(answer,'Continue'))
            handles = resetSession(handles) ;
        else 
            return
        end
    case 'default'
end

%handles = getDevices(handles) ;
handles = updatePopups(handles) ;

% Update handles structure
    guidata(hObject, handles) ;
