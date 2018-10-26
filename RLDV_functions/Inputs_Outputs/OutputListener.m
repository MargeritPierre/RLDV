function OutputListener(src,event,handles)
    display('In Output Listener')
    % Listen mode only (without outputed signal)
%         if (strcmp(handles.toolListen.State,'on') && strcmp(handles.toolOutput.State,'off'))
        % Signal to output
            outputSignal = handles.SignalToOutput ;
            maxSignal = max(abs(outputSignal(:))) ;
            if maxSignal>0 && ~isnan(maxSignal)
                outputSignal = outputSignal./max(abs(outputSignal(:))) ;
            end
            outputSignal = (outputSignal*handles.OutputLevel) ;
        if (strcmp(handles.toolOutput.State,'off'))
            display(['ScansQueued : ',num2str(handles.Session.ScansQueued)])
            %handles.Session.queueOutputData(handles.SignalToOutput*handles.OutputLevel) ;
            handles.Session.queueOutputData(outputSignal) ;
            display(['ScansQueued : ',num2str(handles.Session.ScansQueued)])
            return
        else
            display(['ScansQueued : ',num2str(handles.Session.ScansQueued)])
            %handles.Session.queueOutputData(handles.SignalToOutput*handles.OutputLevel) ;
            handles.Session.queueOutputData(outputSignal) ;
            display(['ScansQueued : ',num2str(handles.Session.ScansQueued)])
            return
        end
    % Update handles structure
%         guidata(handles.Interface, handles);