function handles = displayInfosInList(handlesIN) 
    handles = handlesIN ;
    if (~isempty(handles.Session))
        [~,strInfos,~] = struct2str(handles.Session) ;
        handles.listInfos.String = strtrim(strInfos) ;
    end