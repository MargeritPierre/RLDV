function handles = plotDeformedShape(handles)
    global FileData 
    ScaleFactor = .05 ; % !!!!!!!!!
    plotType = 'trisurf' ; % 'points' or 'surface' or 'trisurf' ;
    % Initial Position
        X0 = FileData.X ;
        Y0 = FileData.Y ;
        Z0 = FileData.Z ;
        Lx = max(X0(:))-min(X0(:)) ;
        Ly = max(Y0(:))-min(Y0(:)) ;
        Lz = max(Z0(:))-min(Z0(:)) ;
        NORM = norm([Lx Ly Lz]) ;
        ScaleFactor = ScaleFactor*NORM ;
    % Deviations Retrieval
        plotData = handles.axes4.UserData.currentData ;
        TData = get(findobj(handles.axes4,'tag','AvgDATA'),'XData') ;
        nT = length(TData) ;
        nPt = length(X0) ;
        dataIndices = handles.axes4.UserData.dataIndices ;
        % If it has been measured !
            if isfield(FileData,[plotData,'dX'])
                dX = eval(['FileData.',plotData,'dX(:,dataIndices)']).' ;
            else
                dX = zeros(length(X0),length(dataIndices)).' ;
            end
            if isfield(FileData,[plotData,'dY'])
                dY = eval(['FileData.',plotData,'dY(:,dataIndices)']).' ;
            else
                dY = zeros(length(X0),length(dataIndices)).' ;
            end
            if isfield(FileData,[plotData,'dZ'])
                dZ = eval(['FileData.',plotData,'dZ(:,dataIndices)']).' ;
            else
                dZ = zeros(length(X0),length(dataIndices)).' ;
            end
    % Reset ActualSample if needed
        FileData.ActualSample = max(1,min(nT,FileData.ActualSample)) ;
    % DATA FORMING
        % Plot Type
            switch plotType
                case 'surface'
                    % mesh spec. retrieval
                        dy = abs(Y0(2)-Y0(1)) ;
                        Ly = max(Y0(:))-min(Y0(:)) ;
                        nY = round(Ly/dy + 1) ;
                        nX = nPt/nY ; 
                case 'points'
                    nX = nPt ;
                    nY = 1 ;
                case 'trisurf'
                    nX = nPt ;
                    nY = 1 ;
            end
        % Conversion Points->meshgrid
            X0 = reshape(X0,[nY nX]) ;
            Y0 = reshape(Y0,[nY nX]) ;
            Z0 = reshape(Z0,[nY nX]) ;
            dX = reshape(dX,[nT nY nX]) ;
            dY = reshape(dY,[nT nY nX]) ;
            dZ = reshape(dZ,[nT nY nX]) ;
        % Data
            switch handles.popupDomain.Value
                case 1 % TIME DOMAIN
                    handles.axesMesh.UserData.Domain = 'time' ;
                    % Normalisation
                        dS = sqrt(abs(dX(:)).^2 + abs(dY(:)).^2 + abs(dZ(:)).^2) ;
                        Amp = max(max(abs(dS(:))),eps) ;
                        dX = dX/Amp*ScaleFactor ;
                        dY = dY/Amp*ScaleFactor ;
                        dZ = dZ/Amp*ScaleFactor ;
                    % SAVE ALL DATA FOR ANIMATION
                        handles.axesMesh.UserData.X0 = X0 ;
                        handles.axesMesh.UserData.Y0 = Y0 ;
                        handles.axesMesh.UserData.Z0 = Z0 ;
                        handles.axesMesh.UserData.dX = dX ;
                        handles.axesMesh.UserData.dY = dY ;
                        handles.axesMesh.UserData.dZ = dZ ;
                    % SET THE LIMITS ON ALL DATA
                        XLIM = [min(X0(:))-max(abs(dX(:))) max(X0(:))+max(abs(dX(:)))] ;
                        YLIM = [min(Y0(:))-max(abs(dY(:))) max(Y0(:))+max(abs(dY(:)))] ;
                        ZLIM = [min(Z0(:))-max(abs(dZ(:))) max(Z0(:))+max(abs(dZ(:)))] ;
                        if XLIM(1)<XLIM(2)
                            handles.axesMesh.XLim = XLIM ;
                        end
                        if YLIM(1)<YLIM(2)
                            handles.axesMesh.YLim = YLIM ;
                        end
                        if ZLIM(1)<ZLIM(2)
                            handles.axesMesh.ZLim = ZLIM ;
                        end
                    % SELECT SAMPLE DATA
                        dX = reshape(squeeze(dX(FileData.ActualSample,:,:)),[nY nX]) ;
                        dY = reshape(squeeze(dY(FileData.ActualSample,:,:)),[nY nX]) ;
                        dZ = reshape(squeeze(dZ(FileData.ActualSample,:,:)),[nY nX]) ;
                case 2 % FREQUENCY DOMAIN
                    handles.axesMesh.UserData.Domain = 'frequency' ;
                    % SELECT SAMPLE DATA
                        dX = reshape(squeeze(dX(FileData.ActualSample,:,:)),[nY nX]) ;
                        dY = reshape(squeeze(dY(FileData.ActualSample,:,:)),[nY nX]) ;
                        dZ = reshape(squeeze(dZ(FileData.ActualSample,:,:)),[nY nX]) ;
                    % Normalisation
                        dS = sqrt(abs(dX(:)).^2 + abs(dY(:)).^2 + abs(dZ(:)).^2) ;
                        Amp = max(abs(dS(:))) ;
                        dX = dX/Amp*ScaleFactor ;
                        dY = dY/Amp*ScaleFactor ;
                        dZ = dZ/Amp*ScaleFactor ;
                    % SAVE FOR ANIMATION
                        handles.axesMesh.UserData.X0 = X0 ;
                        handles.axesMesh.UserData.Y0 = Y0 ;
                        handles.axesMesh.UserData.Z0 = Z0 ;
                        handles.axesMesh.UserData.dX = dX ;
                        handles.axesMesh.UserData.dY = dY ;
                        handles.axesMesh.UserData.dZ = dZ ;
                    % SET THE LIMITS
                        XLIM = [min(X0(:))-max(abs(dX(:))) max(X0(:))+max(abs(dX(:)))] ;
                        YLIM = [min(Y0(:))-max(abs(dY(:))) max(Y0(:))+max(abs(dY(:)))] ;
                        ZLIM = [min(Z0(:))-max(abs(dZ(:))) max(Z0(:))+max(abs(dZ(:)))] ;
                        if XLIM(1)<XLIM(2)
                            handles.axesMesh.XLim = XLIM ;
                        end
                        if YLIM(1)<YLIM(2)
                            handles.axesMesh.YLim = YLIM ;
                        end
                        if ZLIM(1)<ZLIM(2)
                            handles.axesMesh.ZLim = ZLIM ;
                        end
            end
    % Position
        X = X0+dX ;
        Y = Y0+dY ;
        Z = Z0+dZ ;
    % Plotting DefShape
        axes(handles.axesMesh) ;
        % Try to find any previous defshape
            defShape = findobj(handles.axesMesh,'tag','defShape') ;
            isempty(defShape)
        if isempty(defShape) % no defShape found, then create it
            axis 'equal' ;
            switch plotType
                case 'points'
                    defShape = plot3(real(X),real(Y),real(Z)) ;
                case 'surface'
                    defShape = surf(real(X),real(Y),real(Z)) ;
                    defShape.CData = sqrt(real(dX).^2 + real(dY).^2 + real(dZ).^2) ;
                    shading 'interp'
                    defShape.EdgeColor = 'k' ;
                case 'trisurf'
                    dx = mean(diff(X0(:))) ;
                    dy = mean(diff(Y0(:))) ;
                    dz = mean(diff(Z0(:))) ;
                    if dx~=0 && dy~=0
                        tri = delaunay(X0,Y0) ;
                    elseif dx~=0 && dz~=0
                        tri = delaunay(X0,Z0) ;
                    elseif dy~=0 && dz~=0
                        tri = delaunay(Y0,Z0) ;
                    else
                        tri = [] ;
                    end
                    if ~isempty(tri)
                        defShape = trisurf(tri,real(X),real(Y),real(Z)) ;
                        defShape.FaceVertexCData = sqrt(real(dX(:)).^2 + real(dY(:)).^2 + real(dZ(:)).^2) ;
                        shading 'interp'
                        defShape.EdgeColor = 'k' ;
                    else
                        defShape = plot3(real(X),real(Y),real(Z)) ;
                    end
            end
            % DefShape common properties
                defShape.Tag = 'defShape' ;
                defShape.HitTest = 'off' ;
                if strcmp(defShape.Type,'line')
                    defShape.Marker = '.' ;
                    defShape.Color = 'b' ;
                    defShape.MarkerSize = 15 ;
                end
        else
            switch defShape.Type
                case 'line'
                    defShape.XData = real(X) ;
                    defShape.YData = real(Y) ;
                    defShape.ZData = real(Z) ;
                case 'surface'
                    defShape.XData = real(X) ;
                    defShape.YData = real(Y) ;
                    defShape.ZData = real(Z) ;
                    defShape.CData = sqrt(real(dX).^2 + real(dY).^2 + real(dZ).^2) ;
                case 'patch'
                    defShape.Vertices = [real(X(:)) real(Y(:)) real(Z(:))] ;
                    defShape.FaceVertexCData = sqrt(real(dX(:)).^2 + real(dY(:)).^2 + real(dZ(:)).^2) ;
            end
        end
    % ENABLE ANIMATION MENU
        handles.contextAxesMesh_Anime.Enable = 'on' ;