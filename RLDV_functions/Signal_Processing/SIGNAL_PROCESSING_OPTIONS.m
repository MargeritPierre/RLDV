function varargout = SIGNAL_PROCESSING_OPTIONS(varargin)
% SIGNAL_PROCESSING_OPTIONS MATLAB code for SIGNAL_PROCESSING_OPTIONS.fig
%      SIGNAL_PROCESSING_OPTIONS, by itself, creates a new SIGNAL_PROCESSING_OPTIONS or raises the existing
%      singleton*.
%
%      H = SIGNAL_PROCESSING_OPTIONS returns the handle to a new SIGNAL_PROCESSING_OPTIONS or the handle to
%      the existing singleton*.
%
%      SIGNAL_PROCESSING_OPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNAL_PROCESSING_OPTIONS.M with the given input arguments.
%
%      SIGNAL_PROCESSING_OPTIONS('Property','Value',...) creates a new SIGNAL_PROCESSING_OPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SIGNAL_PROCESSING_OPTIONS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SIGNAL_PROCESSING_OPTIONS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SIGNAL_PROCESSING_OPTIONS

% Last Modified by GUIDE v2.5 24-Mar-2017 16:04:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SIGNAL_PROCESSING_OPTIONS_OpeningFcn, ...
                   'gui_OutputFcn',  @SIGNAL_PROCESSING_OPTIONS_OutputFcn, ...
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


% --- Executes just before SIGNAL_PROCESSING_OPTIONS is made visible.
function SIGNAL_PROCESSING_OPTIONS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SIGNAL_PROCESSING_OPTIONS (see VARARGIN)

% Choose default command line output for SIGNAL_PROCESSING_OPTIONS
handles.output = varargin;

% CHECKBOXES INITIALISATION
    inputProcess = varargin{1}' ;
    % Get CheckBox Names
        warning off
        componentsHandles = findobj([handles.panelCOMPONENTS],'style','checkbox') ;
        checkboxesHandles = findobj([handles.panelTIME,handles.panelFREQUENCY],'style','checkbox') ;
        checkboxVar = handles.checkboxVar;
        warning on
    % Set checkboxesComp value
        for chkbx = componentsHandles'
            chkbxTag = strrep(get(chkbx,'tag'),'checkbox','') ;
            isTag = regexp(inputProcess,chkbxTag) ;
            if ~isempty([isTag{:}])
                chkbx.Value = 1 ;
            end
        end
    % Set checkboxesProcess value
        for chkbx = checkboxesHandles'
            chkbxTag = strrep(get(chkbx,'tag'),'checkbox','') ;
            if sum(strcmp([chkbxTag,'dX'],inputProcess)) || ...
                    sum(strcmp([chkbxTag,'dY'],inputProcess)) || ...
                    sum(strcmp([chkbxTag,'dZ'],inputProcess)) || ...
                    sum(strcmp([chkbxTag,'Ref'],inputProcess))
                chkbx.Value = 1 ;
            end
        end
    % Variance ?
        isTag = regexp(inputProcess,'Var') ;
        if ~isempty([isTag{:}])
            checkboxVar.Value = 1 ;
        end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SIGNAL_PROCESSING_OPTIONS wait for user response (see UIRESUME)
uiwait(handles.Interface);


% --- Outputs from this function are returned to the command line.
function varargout = SIGNAL_PROCESSING_OPTIONS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout = handles.output;

warning off
compCheck = strrep(get(findobj(handles.panelCOMPONENTS,'Value',1),'tag'),'checkbox','') ;
processCheck = strrep(get(findobj([handles.panelTIME,handles.panelFREQUENCY],'Value',1),'tag'),'checkbox','') ;
varCheck = handles.checkboxVar.Value ;
warning on

if ~isempty(compCheck) && ~isempty(processCheck)
    selectedProcess = {} ;
    if ~iscell(processCheck) ; processCheck = {processCheck} ; end ;
    if ~iscell(compCheck) ; compCheck = {compCheck} ; end ;
    for process = processCheck'
        for comp = compCheck'
            selectedProcess{end+1} = [process{1},comp{1}] ;
            if varCheck % Compute the variance
                selectedProcess{end+1} = [regexprep(process{1},'Avg','Var'),comp{1}] ;
            end
        end
    end
    varargout = {} ;
    varargout{1} = selectedProcess ;
end

% Hint: delete(hObject) closes the figure
delete(handles.Interface);


% --- Executes when user attempts to close Interface.
function Interface_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Interface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Update handles structure
    guidata(hObject, handles) ;

% Call OutputFunction
    uiresume
