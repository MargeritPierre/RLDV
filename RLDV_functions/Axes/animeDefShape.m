function animeDefShape(handles,time)
    axesMesh = handles.axesMesh ;
    defShape = findobj(axesMesh,'tag','defShape') ;
    if isempty(defShape)
        return ;
    else
        switch axesMesh.UserData.Domain
            case 'frequency'
                expi = exp(2i*pi*time/4) ;
                dX = real(axesMesh.UserData.dX*expi) ;
                dY = real(axesMesh.UserData.dY*expi) ;
                dZ = real(axesMesh.UserData.dZ*expi) ;
            case 'time'
                ind = axesMesh.UserData.animationIndice ;
                plotCursor(handles,ind) ;
                % Data to plot
                    dX = reshape(squeeze(axesMesh.UserData.dX(ind,:,:)),size(axesMesh.UserData.X0)) ;
                    dY = reshape(squeeze(axesMesh.UserData.dY(ind,:,:)),size(axesMesh.UserData.X0)) ;
                    dZ = reshape(squeeze(axesMesh.UserData.dZ(ind,:,:)),size(axesMesh.UserData.X0)) ;
                % Time indice Actualisation
                    axesMesh.UserData.animationIndice = axesMesh.UserData.animationIndice + 1 ;
                    if ind>size(axesMesh.UserData.dX,1)
                        axesMesh.UserData.animationIndice = 1 ;
                    end
        end
            X = axesMesh.UserData.X0 + dX ;
            Y = axesMesh.UserData.Y0 + dY ;
            Z = axesMesh.UserData.Z0 + dZ ;
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
        drawnow ;
    end