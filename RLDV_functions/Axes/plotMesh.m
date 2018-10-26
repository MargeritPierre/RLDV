function handles = plotMesh(handlesIN)
    handles = handlesIN ;
    global FileData
    axes(handles.axesMesh) ;
    cla
    axis equal
    xlabel '\bf X'
    ylabel '\bf Y'
    zlabel '\bf Z'
    actPt = FileData.ActualPoint+1 ;
    actOr = FileData.ActualOrientation ;
    % POINTS
        if strcmp(handles.contextAxesMesh_Plot_Points.Checked,'on')
            markers = plot3(FileData.X,FileData.Y,FileData.Z,'.k','markersize',5,'tag','Points') ;
            markers.ButtonDownFcn = @(src,evt)display(evt) ;
        end
    % NORMALS
        if strcmp(handles.contextAxesMesh_Plot_Normals.Checked,'on')
            Length = 30 ;
            startPt = FileData.Points ;
            endPt = startPt + Length*FileData.Normals ;
            plot3([startPt(:,1) endPt(:,1)]',[startPt(:,2) endPt(:,2)]',[startPt(:,3) endPt(:,3)]','k','linewidth',1,'tag','Normals')
        end
    % TARGETS
        if strcmp(handles.contextAxesMesh_Plot_Vectors.Checked,'on')
            Length = 20 ;
            for i = 1:size(FileData.Targets,3)
                startPt = FileData.Points ;
                endPt = startPt + Length*squeeze(FileData.Targets(:,:,i)) ;
                plot3([startPt(:,1) endPt(:,1)]',[startPt(:,2) endPt(:,2)]',[startPt(:,3) endPt(:,3)]','b','linewidth',1,'tag','Targets')
            end
        end
    % ACTUAL POSITION + ORIENTATION
        plot3(FileData.X(actPt,1),FileData.Y(actPt,1),FileData.Z(actPt,1),'.r','markersize',25,'tag','ActualPoint')
        Length = 30 ;
        startPt = FileData.Points(actPt,:) ;
        if (strcmp(handles.toolOnNormals.State,'on') || actOr==0)
            endPt = startPt + Length*FileData.Normals(actPt,:) ;
        else
            endPt = startPt + Length*squeeze(FileData.Targets(actPt,:,actOr)) ;
        end
        plot3([startPt(1) endPt(1)]',[startPt(2) endPt(2)]',[startPt(3) endPt(3)]','r','linewidth',2,'Tag','ActualOrientation')
