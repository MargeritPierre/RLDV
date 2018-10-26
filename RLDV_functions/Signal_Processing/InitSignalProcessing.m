function InitSignalProcessing(handles)
    global FileData
    if ~isempty(FileData.Points)
        % Infos
            nPt = length(FileData.X) ;
        if ~isempty(handles.SignalInfos) && ~isempty(FileData.Points)
            % Infos
                nT = handles.SignalInfos.RealisationSamples ;
                nTotal = handles.SignalInfos.TotalNumberOfSamples ;
                nAvg = handles.SignalInfos.Averages ;
                nUsed = handles.SignalInfos.MeasuredSamples ;
                nCorr = 2*nT-1 ;
                nPt = length(FileData.X) ;
                nOr = size(FileData.Targets,3) ;
            % Fields Initialisation    
                nFields = length(FileData.KeepProcessing) ;
                wtbr = waitbar(0,'INITIALISATION OF SIGNAL PROCESSING DATA') ;
                tic
                field = 0 ;
                % TOTAL TIME IS SAVED EVERYTIME
                    for name = {'TotaldX' 'TotaldY' 'TotaldZ' 'TotalRef'}
                        if sum(strcmp(FileData.KeepProcessing,name{1}))>0
                            FileData = setfield(FileData,name{1},zeros(nPt,nTotal)) ;
                            wtbr = waitbar(field/nFields,wtbr,['INITIALISATION OF SIGNAL PROCESSING DATA : ',name{1}]) ; 
                            field = field+1 ;
                        else
                            if isfield(FileData,name{1})
                                FileData = rmfield(FileData,name{1}) ;
                            end
                        end
                    end
                % OPTIONAL DATA
                    for name = {'UseddX' 'UseddY' 'UseddZ' 'UsedRef'}
                        if sum(strcmp(FileData.KeepProcessing,name{1}))>0
                            FileData = setfield(FileData,name{1},zeros(nPt,nUsed)) ;
                            wtbr = waitbar(field/nFields,wtbr,['INITIALISATION OF SIGNAL PROCESSING DATA : ',name{1}]) ; 
                            field = field+1 ;
                        else
                            if isfield(FileData,name{1})
                                FileData = rmfield(FileData,name{1}) ;
                            end
                        end
                    end
                    for name = {'dX' 'dY' 'dZ' 'Ref' }
                        if sum(strcmp(FileData.KeepProcessing,name{1}))>0
                            FileData = setfield(FileData,name{1},zeros(nPt,nAvg,nT)) ;
                            wtbr = waitbar(field/nFields,wtbr,['INITIALISATION OF SIGNAL PROCESSING DATA : ',name{1}]) ; 
                            field = field+1 ;
                        else
                            if isfield(FileData,name{1})
                                FileData = rmfield(FileData,name{1}) ;
                            end
                        end
                    end
                    for name = {'FFTdX' 'FFTdY' 'FFTdZ' 'FFTRef' 'WinFFTdX' 'WinFFTdY' 'WinFFTdZ' 'WinFFTRef'}
                        if sum(strcmp(FileData.KeepProcessing,name{1}))>0
                            FileData = setfield(FileData,name{1},complex(zeros(nPt,nAvg,nT))) ;
                            wtbr = waitbar(field/nFields,wtbr,['INITIALISATION OF SIGNAL PROCESSING DATA : ',name{1}]) ; 
                            field = field+1 ;
                        else
                            if isfield(FileData,name{1})
                                FileData = rmfield(FileData,name{1}) ;
                            end
                        end
                    end 
                    for name = {'AvgdX' 'AvgdY' 'AvgdZ' 'AvgRef' 'AvgFFTdX' ...
                                'VardX' 'VardY' 'VardZ' 'VarRef' 'VarFFTdX'}
                        if sum(strcmp(FileData.KeepProcessing,name{1}))>0
                            FileData = setfield(FileData,name{1},zeros(nPt,nT)) ;
                            wtbr = waitbar(field/nFields,wtbr,['INITIALISATION OF SIGNAL PROCESSING DATA : ',name{1}]) ; 
                            field = field+1 ;
                        else
                            if isfield(FileData,name{1})
                                FileData = rmfield(FileData,name{1}) ;
                            end
                        end
                    end
                    for name = {'AvgFFTdY' 'AvgFFTdZ' 'AvgFFTRef' 'AvgWinFFTdX' 'AvgWinFFTdY' 'AvgWinFFTdZ' 'AvgWinFFTRef' ...
                                'VarFFTdY' 'VarFFTdZ' 'VarFFTRef' 'VarWinFFTdX' 'VarWinFFTdY' 'VarWinFFTdZ' 'VarWinFFTRef'}
                        if sum(strcmp(FileData.KeepProcessing,name{1}))>0
                            FileData = setfield(FileData,name{1},complex(zeros(nPt,nT))) ;
                            wtbr = waitbar(field/nFields,wtbr,['INITIALISATION OF SIGNAL PROCESSING DATA : ',name{1}]) ; 
                            field = field+1 ;
                        else
                            if isfield(FileData,name{1})
                                FileData = rmfield(FileData,name{1}) ;
                            end
                        end
                    end 
                    for name = {'ACdX' 'ACdY' 'ACdZ' 'ACRef' 'ASdX' 'CCdX' 'CCdY' 'CCdZ'}
                        if sum(strcmp(FileData.KeepProcessing,name{1}))>0
                            FileData = setfield(FileData,name{1},zeros(nPt,nAvg,nCorr)) ;
                            wtbr = waitbar(field/nFields,wtbr,['INITIALISATION OF SIGNAL PROCESSING DATA : ',name{1}]) ; 
                            field = field+1 ;
                        else
                            if isfield(FileData,name{1})
                                FileData = rmfield(FileData,name{1}) ;
                            end
                        end
                    end
                    for name = {'ASdY' 'ASdZ' 'ASRef' 'CSdX' 'CSdY' 'CSdZ' 'H1dX' 'H1dY' 'H1dZ' 'H2dX' 'H2dY' 'H2dZ'}
                        if sum(strcmp(FileData.KeepProcessing,name{1}))>0
                            FileData = setfield(FileData,name{1},complex(zeros(nPt,nAvg,nCorr))) ;
                            wtbr = waitbar(field/nFields,wtbr,['INITIALISATION OF SIGNAL PROCESSING DATA : ',name{1}]) ; 
                            field = field+1 ;
                        else
                            if isfield(FileData,name{1})
                                FileData = rmfield(FileData,name{1}) ;
                            end
                        end
                    end 
                    for name = {'AvgACdX' 'AvgACdY' 'AvgACdZ' 'AvgACRef' 'AvgCCdX' 'AvgCCdY' 'AvgCCdZ' 'CohdX' 'CohdY' 'CohdZ'...
                                'VarACdX' 'VarACdY' 'VarACdZ' 'VarACRef' 'VarCCdX' 'VarCCdY' 'VarCCdZ'}
                        if sum(strcmp(FileData.KeepProcessing,name{1}))>0
                            FileData = setfield(FileData,name{1},zeros(nPt,nCorr)) ;
                            wtbr = waitbar(field/nFields,wtbr,['INITIALISATION OF SIGNAL PROCESSING DATA : ',name{1}]) ; 
                            field = field+1 ;
                        else
                            if isfield(FileData,name{1})
                                FileData = rmfield(FileData,name{1}) ;
                            end
                        end
                    end
                    for name = {'AvgASdX' 'AvgASdY' 'AvgASdZ' 'AvgASRef'  'AvgCSdX' 'AvgCSdY' 'AvgCSdZ' 'AvgH1dX' 'AvgH1dY' 'AvgH1dZ' 'AvgH2dX' 'AvgH2dY' 'AvgH2dZ'...
                                'VarASdX' 'VarASdY' 'VarASdZ' 'VarASRef'  'VarCSdX' 'VarCSdY' 'VarCSdZ' 'VarH1dX' 'VarH1dY' 'VarH1dZ' 'VarH2dX' 'VarH2dY' 'VarH2dZ'}
                        if sum(strcmp(FileData.KeepProcessing,name{1}))>0
                            FileData = setfield(FileData,name{1},complex(zeros(nPt,nCorr))) ;
                            wtbr = waitbar(field/nFields,wtbr,['INITIALISATION OF SIGNAL PROCESSING DATA : ',name{1}]) ; 
                            field = field+1 ;
                        else
                            if isfield(FileData,name{1})
                                FileData = rmfield(FileData,name{1}) ;
                            end
                        end
                    end 
                    FileData
                toc
                delete(wtbr) ;
                display(['APPROXIMATE Data Size : ',num2str(getfield(whos('FileData'),'bytes')/1e9,2),'GB'])
        end
    end