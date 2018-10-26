function handles = plotCursor(handles,varargin)
% varargin: indice for the cursor
    global FileData
    % Get the data plot
        dataLine = findobj(handles.axes4,'tag','AvgDATA') ;
        XData = dataLine.XData ;
        nX = length(XData) ;
    % Coordinates of the cursor line
        if isempty(varargin)
            indCursor = FileData.ActualSample ;
        else
            indCursor = varargin{1} ;
        end
        xC = XData(max(min(nX,indCursor),1))*[1 1] ;
        yC = handles.axes4.YLim ;
    % Detect a previous cursor line
        cursorLine = findobj(handles.axes4,'tag','cursor') ;
    % Create or modify the cursor line
        if isempty(cursorLine)
            cursorLine = plot(handles.axes4,...
                                xC,...
                                yC,...
                                '-.r','tag','cursor','linewidth',1) ;
        else 
            cursorLine.XData = xC ;
            cursorLine.YData = yC ;
        end
    % Text for the cursor label
        switch handles.popupDomain.Value
            case 1 % TIME
                cursorStr = [' ',num2str(cursorLine.XData(1)*1000,'%.1f'),' ms '] ;
            case 2 % FREQ.
                cursorStr = [' ',num2str(cursorLine.XData(1),'%.1f'),' Hz '] ;
        end
        if cursorLine.XData(1)<(max(XData)-min(XData))/2
            horizalign = 'left' ;
        else
            horizalign = 'right' ;
        end
    % Create or modify the cursor label
        cursorTxt = findobj(handles.axes4,'tag','cursorTxt') ;
        if isempty(cursorTxt)
            cursorTxt = text(cursorLine.XData(1),cursorLine.YData(end),...
                            cursorStr,...
                            'tag','cursorTxt',...
                            'verticalalignment','top',...
                            'horizontalalignment',horizalign,...
                            'color','r',...
                            'fontsize',15,...
                            'Interpreter','none') ;
        else
            cursorTxt.Position = [xC(1) yC(end) 0] ;
            cursorTxt.String = cursorStr ;
            cursorTxt.HorizontalAlignment = horizalign ;
        end