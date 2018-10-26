function handles = GoTo(Point,Orientation,handlesIN,execMode)
    global FileData 
    handles = handlesIN ;
    % Actualize Position
        FileData.ActualOrientation = Orientation ;
        Point = max(min(FileData.MeshSize-1,Point),0) ;
        FileData.ActualPoint = Point ;
    % Actualise SensorPosition
        FileData.SensorPosition = [Point-1,Orientation] ;
    % On Normals ?
        if (strcmp(handles.toolOnNormals.State,'on'))
            Orientation = 0 ;
        end
    % Display Order
        display(['Order  : ',num2str(Point),',',num2str(Orientation)])
    % Send String
        fopen(handles.UDP) ;
        fwrite(handles.UDP,[num2str(Point),',',num2str(Orientation)]) ;
        fclose(handles.UDP) ;
    % Block execution if needed
    if (nargin>3)
        display('Execution mode') ;
        if (execMode == 'blocking')
            display('Waiting for end of move...');
            fopen(handles.UDP) ;
            ReceivedDate = fscanf(handles.UDP) ;
            fclose(handles.UDP) ;
            if isempty(ReceivedDate)
                display('WARNING : TIMEOUT REACHED !') ;
            end
        end
    end