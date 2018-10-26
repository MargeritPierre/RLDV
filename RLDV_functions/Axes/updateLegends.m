function handles = updateLegends(handlesIN)
    handles = handlesIN ;
    if (~isempty(handles.axesClicked.Children))
        strLegend = flip(strrep({handles.axesClicked.Children(:).Tag},'_',' ')) ;
        nChildren = length(handles.axesClicked.Children) ;
        for child = 1:nChildren
             handles.axesClicked.Children(child).Color = handles.axesClicked.ColorOrder(nChildren-child+1,:) ;
        end
        handles.axesClicked.UserData.lgd = legend(strLegend) ;
        handles.axesClicked.UserData.lgd.FontSize = 9 ;
    else
        delete(handles.axesClicked.UserData.lgd)
    end