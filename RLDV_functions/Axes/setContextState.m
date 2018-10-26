function handles = setContextState(handlesIN)
    handles = handlesIN ;
    ax = handles.axesClicked ;
    if (strcmp(ax.Tag,'axesMesh'))
    else
        lineH = ax.Children ;
        set(findobj(handles.contextAxesSignal,'-property','Checked'),'checked','off')
        % Signal representation
            for line = lineH.'
                line.Tag
                eval(['handles.contextAxesSignal_Signal_',line.Tag,'.Checked = ''on'' ; ']) ;
                eval(['handles.contextAxesSignal_Signal_',line.Tag,'.Parent.Checked = ''on'' ; ']) ;
            end
        handles.contextAxesSignal_Lims.Enable = 'off' ;
        handles.contextAxesSignal_Scale.Enable = 'off' ;
        if (strcmp(handles.contextAxesSignal_Signal_FFT.Checked,'on'))
        % Lims
            handles.contextAxesSignal_Lims.Enable = 'on' ;
            if (~isempty(handles.Session))
                if ((ax.XLim(1) == 0) && (ax.XLim(2) == handles.Session.Rate))
                    handles.contextAxesSignal_Lims_Whole_Bandwidth.Checked = 'on' ;
                end
                if ((ax.XLim(1) == 0) && (ax.XLim(2) == handles.Session.Rate/2))
                    handles.contextAxesSignal_Lims_Shannon_Bandwidth.Checked = 'on' ;
                end
                if (~isempty(handles.SignalInfos))
                    if ((ax.XLim(1) == handles.SignalInfos.Fmin) && (ax.XLim(2) == handles.SignalInfos.Fmax))
                        handles.contextAxesSignal_Lims_Excitation_Bandwidth.Checked = 'on' ;
                    end
                end
            end   
        % Scale
            handles.contextAxesSignal_Scale.Enable = 'on' ;
            if (~isempty(handles.Session))
                if (strcmp(ax.XScale,'linear'))
                    handles.contextAxesSignal_Scale_X_Lin.Checked = 'on' ;
                end
                if (strcmp(ax.XScale,'log'))
                    handles.contextAxesSignal_Scale_X_Log.Checked = 'on' ;
                end
                if (strcmp(ax.YScale,'linear'))
                    handles.contextAxesSignal_Scale_Y_Lin.Checked = 'on' ;
                end
                if (strcmp(ax.YScale,'log'))
                    handles.contextAxesSignal_Scale_Y_Log.Checked = 'on' ;
                end
            end
        end
    end