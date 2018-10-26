function out = SignalProcessing(handles) % COMPUTE ALL THE USEFUL SIGNAL REPRESENTATIONS
    global FileData
    % Actual Point
        actPt = FileData.ActualPoint+1 ;
        actOr = FileData.ActualOrientation ;
    % Temporary output
        out = {} ;
    % WHICH Things has to be computed ?
        toCompute = FileData.KeepProcessing ;
        toCompute = regexprep(toCompute,'dX','') ;
        toCompute = regexprep(toCompute,'dY','') ;
        toCompute = regexprep(toCompute,'dZ','') ;
        toCompute = regexprep(toCompute,'Ref','') ;
        toCompute = unique(toCompute) ;
        compFFT = any(ismember(toCompute,{'AvgFFT','FFT'})) ;
        compWin = any(ismember(toCompute,{'AvgWin','Win'})) ;
        compWinFFT = any(ismember(toCompute,{'AvgWinFFT','WinFFT'})) ;
        compAC = any(ismember(toCompute,{'AvgAC','AC'})) ;
        compCC = any(ismember(toCompute,{'AvgCC','CC'})) ;
        compAS = any(ismember(toCompute,{'AvgAS','AS'})) ;
        compCS = any(ismember(toCompute,{'AvgCS','CS'})) ;
        compH1 = any(ismember(toCompute,{'AvgH1','H1'})) ;
        compH2 = any(ismember(toCompute,{'AvgH2','H2'})) ;
        compCoh = any(ismember(toCompute,{'AvgCoh','Coh'})) ;
    % FUTURE Switch in the XYZ Base
        % Infos
            nOr = size(FileData.Targets,3) ;
            nTotal = handles.SignalInfos.TotalNumberOfSamples ;
        % Measurements Post-Processing
            % Retrieve Measurements
            % transfer matrix (basis shift local to cartesian)
                P = squeeze(FileData.Targets(actPt,:,:)).' ;
            % Measurements in the targets
                Vv = squeeze(FileData.ThisPointMeasurements(:,2,:)).' ;
            % Shifting in cartesian coordinates
                if nOr>=3 % Inath Targets to get 3D components ?
                    VtoXYZ = @(dV)P\dV ;
                else
                    VtoXYZ = @(dV)P*dV.' ;
                end
        % Saving
            out.TotaldV(1,1:nTotal,:) = Vv.' ;
            if size(FileData.ThisPointMeasurements,3)>1 % More than one orientation(s) ?
                out.TotalRef(1:nTotal) = mean(FileData.ThisPointMeasurements(1:nTotal,1,:),3).' ;
            else
                out.TotalRef(1:nTotal) = FileData.ThisPointMeasurements(1:nTotal,1).' ;
            end
    % Low-Pass Filtering on Reference
        if 1==0
            Filter = fir1(1000,2/handles.SignalInfos.RealisationSamples,'high');
            out.TotalRef = conv(out.TotalRef,Filter,'same') ;
        end
    % Median Filtering Reference
        if 1==0
            out.TotalRef = out.TotalRef-median(out.TotalRef) ;
            %out.TotaldV = out.TotaldV-repmat(median(out.TotaldV,2),[1 nTotal 1]) ;
        end
    % Delete WaitSteady Samples
        WS = handles.SignalInfos.WaitSteadySamples ;
        Used = out.TotaldV(1,WS+1:end,:) ;
        UsedRef = out.TotalRef(WS+1:end) ;
    % Separate realisations
        Avg = handles.SignalInfos.Averages ;
        OL = handles.SignalInfos.OverlapSamples ;
        N = handles.SignalInfos.RealisationSamples ;
        out.dV = zeros(Avg,N,nOr) ;
        out.Ref = zeros(Avg,N) ;
        for a = 1:Avg
            realisationSamples = (1:N)+(a-1)*(N-OL) ;
            out.dV(a,:,:) = squeeze(Used(1,realisationSamples,:)) ;
            out.Ref(a,:) = UsedRef(realisationSamples) ;
        end
    % Time Average
        takeMedian = true ;
        % MEDIAN AVERAGING !!!!
            if takeMedian && Avg>2
                out.AvgdV = median(out.dV,1) ;
            else
                out.AvgdV = mean(out.dV,1) ;
            end
        out.VardV = var(out.dV,0,1) ;
        out.AvgRef = mean(out.Ref,1) ;
        out.VarRef = var(out.Ref,0,1) ;
    % FFT
        if compFFT
            % Realizations
                out.FFTdV = fft(out.dV,[],2) ;
                out.FFTRef = fft(out.Ref,[],2) ;
            % Averaged FFT
                out.AvgFFTdV = fft(out.AvgdV,[],2) ; %mean(out.FFTdV,1) ;
                out.AvgFFTRef = fft(out.AvgRef,[],2) ; %mean(out.FFTRef,1) ;
            % FFT Variance
                out.VarFFTdV = var(out.FFTdV,0,1) ;
                out.VarFFTRef = var(out.FFTRef,0,1) ;
        end
    % Windowed Signal (NOT SAVED)
        if compWin || compWinFFT || compAC || compCC || compAS || compCS || compH1 || compH2 || compCoh
            WIN = repmat(FileData.Window,[Avg 1 nOr]) ;
            WindV = out.dV.*WIN ;
            WinRef = out.Ref.*WIN(:,:,1) ;
        end
    % Windowed FFT
        if compWinFFT
            % Realizations
                out.WinFFTdV = fft(WindV,[],2) ;
                out.WinFFTRef = fft(WinRef,[],2) ;
            % Averaged and Windowed FFT
                out.AvgWinFFTdV = mean(out.WinFFTdV,1) ;
                out.AvgWinFFTRef = mean(out.WinFFTRef,1) ;
            % Windowed FFT Variance
                out.VarWinFFTdV = var(out.WinFFTdV,0,1) ;
                out.VarWinFFTRef = var(out.WinFFTRef,0,1) ;
        end
    % Auto-Correlations on Windowed Signal
        if compAC || compAS || compH1 || compH2 || compCoh
            out.ACdV = zeros(Avg,2*N-1,nOr) ;
            out.ACRef = zeros(Avg,2*N-1) ;
            for a = 1:Avg
                for or = 1:nOr
                    out.ACdV(a,:,or) = xcorr(WindV(a,:,or)) ;
                end
                out.ACRef(a,:) = xcorr(WinRef(a,:)) ;
            end
            % Averaged Auto-Correlations on Windowed Signal
                out.AvgACdV = mean(out.ACdV,1) ;
                out.AvgACRef = mean(out.ACRef,1) ;
            % Auto-Correlations Variance
                out.VarACdV = var(out.ACdV,0,1) ;
                out.VarACRef = var(out.ACRef,0,1) ;
        end
    % Auto-Spectrums on Windowed Signal
        if compAS || compH1 || compH2 || compCoh
            out.ASdV = fft(out.ACdV,[],2) ;
            out.ASRef = fft(out.ACRef,[],2) ;
            % Averaged Auto-Spectrums on Windowed Signal
                out.AvgASdV = mean(out.ASdV,1) ;
                out.AvgASRef = mean(out.ASRef,1) ;
            % Auto-Spectrums variance
                out.VarASdV = var(out.ASdV,0,1) ;
                out.VarASRef = var(out.ASRef,0,1) ;
        end
    % Cross-Correlations on Windowed Signal
        if compCC || compCS || compH1 || compH2 || compCoh
            out.CCdV = zeros(Avg,2*N-1,nOr) ;
            for a = 1:Avg
                for or = 1:nOr
                    out.CCdV(a,:,or) = xcorr(WindV(a,:,or),WinRef(a,:)) ;
                end
            end
            % Averaged Cross-Correlations on Windowed Signal
                out.AvgCCdV = mean(out.CCdV,1) ;
            % Cross-Correlations Variance
                out.VarCCdV = var(out.CCdV,0,1) ;
        end
    % Cross-Spectrums on Windowed Signal
        if compCS || compH1 || compH2 || compCoh
            out.CSdV = fft(out.CCdV,[],2) ;
            % Averaged Cross-Spectrums on Windowed Signal
                out.AvgCSdV = mean(out.CSdV,1) ;
            % Cross-Spectrums Variance
                out.VarCSdV = var(out.CSdV,0,1) ;
        end
    % Transfer functions H1
        if compH1 || compCoh
            out.H1dV = out.CSdV./repmat(out.ASRef,[1 1 nOr]) ;
            % Averaged Transfer functions H1
                out.AvgH1dV = out.AvgCSdV./repmat(out.AvgASRef,[1 1 nOr]) ;
            % Transfer functions H1 Variance
                out.VarH1dV = var(out.CSdV./repmat(out.ASRef,[1 1 nOr]),0,1) ;
        end
    % Transfer functions H2
        if compH2 || compCoh
            out.H2dV = out.ASdV./out.CSdV ;
            % Averaged Transfer functions H2
                out.AvgH2dV = out.AvgASdV./out.AvgCSdV ;
            % Transfer functions H2 variance
                out.VarH2dV = var(out.ASdV./out.CSdV,0,1) ;
        end
    % Coherence
        if compCoh
            out.CohdV = sqrt(abs(out.AvgH1dV./out.AvgH2dV)) ;
        end
    % CONVERT V -> XYZ
        for name = fieldnames(out)' 
            name = name{1} ;
            if ~isempty(regexp(name,'dV'))
                dV = getfield(out,name) ;
                sz = size(dV) ;
                dXYZ = zeros([sz(1:2),3]) ;
                for avg = 1:sz(1)
                    dVa = squeeze(dV(avg,:,:)) ;
                    dXYZ(avg,:,:) = VtoXYZ(dVa.').' ;
                end
                if ~isempty(regexp(name,'Var','once')) ; dXYZ = abs(dXYZ) ; end
                eval(['out.',name(1:end-2),'dX = dXYZ(:,:,1) ; ']) ;
                eval(['out.',name(1:end-2),'dY = dXYZ(:,:,2) ; ']) ;
                eval(['out.',name(1:end-2),'dZ = dXYZ(:,:,3) ; ']) ;
            end
        end
    % Normalize Coherence if Needed
        if compCoh
            out.CohdX = abs(out.CohdX)/max(abs(out.CohdX(:))) ;
            out.CohdY = abs(out.CohdY)/max(abs(out.CohdY(:))) ;
            out.CohdZ = abs(out.CohdZ)/max(abs(out.CohdZ(:))) ;
        end
toc
    % EXPORT IN FILEDATA
        for name = fieldnames(out)'
            % Is the field needs to be saved ?
                name = name{1} ;
            if sum(strcmp(FileData.KeepProcessing,name))>0
                sz = size(getfield(out,name)) ;
                str = repmat(':,',[1 sum(sz>1)]) ;
                str = str(1:end-1) ;
                dataSize = size(eval(['FileData.',name,'(actPt,',str,')'])) ;
                eval(['FileData.',name,'(actPt,',str,') = reshape(out.',name,',dataSize) ;']) ;
            end
        end
        display(['APPROXIMATE Data Size : ',num2str(getfield(whos('FileData'),'bytes')/1e9,2),'GB'])
toc












%% END OF THE S.P. FUNCTION 

    % FIGURE TO PLOT RESULTS (FOR DEGUB ONLY)
    if 1==0
        fig = figure ;
        mysubplot(4,4,1) ;
            title('Total measured Data (dV and Ref)')
            plot(FileData.TotalTime,out.TotaldV)
            plot(FileData.TotalTime,out.TotalRef)
        mysubplot(4,4,2) ;
            title('Realisations (dV)')
            plot(FileData.Time,out.dV(:,:,actOr))
            plot(FileData.Time,out.AvgdV(:,:,actOr),'k')
        mysubplot(4,4,3) ;
            title('Realisations (Ref)')
            plot(FileData.Time,out.Ref)
            plot(FileData.Time,out.AvgRef,'k')
        mysubplot(4,4,4) ;
            title('FFT Realisations (dV)')
            plot(FileData.Freq,abs(out.FFTdV(:,:,actOr)))
            plot(FileData.Freq,abs(out.AvgFFTdV(:,:,actOr)),'k')
            set(gca,'xscale','log','yscale','log','xlim',[1/FileData.Time(end) FileData.Freq(end)/2]) ;
        mysubplot(4,4,5) ;
            title('FFT Realisations (Ref)')
            plot(FileData.Freq,abs(out.FFTRef))
            plot(FileData.Freq,abs(out.AvgFFTRef),'k')
            set(gca,'xscale','log','yscale','log','xlim',[1/FileData.Time(end) FileData.Freq(end)/2]) ;
        mysubplot(4,4,6) ;
            title('FFT Realisations + WIN (dV)')
            plot(FileData.Freq,abs(out.WinFFTdV(:,:,actOr)))
            plot(FileData.Freq,abs(out.AvgWinFFTdV(:,:,actOr)),'k')
            set(gca,'xscale','log','yscale','log','xlim',[1/FileData.Time(end) FileData.Freq(end)/2]) ;
        mysubplot(4,4,7) ;
            title('FFT Realisations + WIN (Ref)')
            plot(FileData.Freq,abs(out.WinFFTRef))
            plot(FileData.Freq,abs(out.AvgWinFFTRef),'k')
            set(gca,'xscale','log','yscale','log','xlim',[1/FileData.Time(end) FileData.Freq(end)/2]) ;
        mysubplot(4,4,8) ;
            title('Auto-Correlations (dV)')
            plot(FileData.corrFreq,out.ACdV(:,:,actOr))
            plot(FileData.corrFreq,out.AvgACdV(:,:,actOr),'k')
        mysubplot(4,4,9) ;
            title('Auto-Correlations (Ref)')
            plot(FileData.corrFreq,out.ACRef)
            plot(FileData.corrFreq,out.AvgACRef,'k')
        mysubplot(4,4,10) ;
            title('Cross-Correlations (dV*Ref)')
            plot(FileData.corrFreq,out.CCdV(:,:,actOr))
            plot(FileData.corrFreq,out.AvgCCdV(:,:,actOr),'k')
        mysubplot(4,4,11) ;
            title('Auto-Spectrums (dV)')
            plot(FileData.corrFreq,abs(out.ASdV(:,:,actOr)))
            plot(FileData.corrFreq,abs(out.AvgASdV(:,:,actOr)),'k')
            set(gca,'xscale','log','yscale','log','xlim',[1/FileData.Time(end) FileData.Freq(end)/2]) ;
        mysubplot(4,4,12) ;
            title('Auto-Spectrums (Ref)')
            plot(FileData.corrFreq,abs(out.ASRef))
            plot(FileData.corrFreq,abs(out.AvgASRef),'k')
            set(gca,'xscale','log','yscale','log','xlim',[1/FileData.Time(end) FileData.Freq(end)/2]) ;
        mysubplot(4,4,13) ;
            title('Cross-Spectrums (dV*Ref)')
            plot(FileData.corrFreq,abs(out.CSdV(:,:,actOr)))
            plot(FileData.corrFreq,abs(out.AvgCSdV(:,:,actOr)),'k')
            set(gca,'xscale','log','yscale','log','xlim',[1/FileData.Time(end) FileData.Freq(end)/2]) ;
        mysubplot(4,4,14) ;
            title('Transfer functions H1')
            plot(FileData.corrFreq,abs(out.H1dV(:,:,actOr)))
            plot(FileData.corrFreq,abs(out.AvgH1dV(:,:,actOr)),'k')
            set(gca,'xscale','log','yscale','log','xlim',[1/FileData.Time(end) FileData.Freq(end)/2]) ;
        mysubplot(4,4,15) ;
            title('Transfer functions H2')
            plot(FileData.corrFreq,abs(out.H2dV(:,:,actOr)))
            plot(FileData.corrFreq,abs(out.AvgH2dV(:,:,actOr)),'k')
            set(gca,'xscale','log','yscale','log','xlim',[1/FileData.Time(end) FileData.Freq(end)/2]) ;
        mysubplot(4,4,16) ;
            title('Coherence')
            plot(FileData.corrFreq,abs(out.CohdV(:,:,actOr)),'k')
            set(gca,'xscale','log','xlim',[1/FileData.Time(end) FileData.Freq(end)/2],'ylim',[0 1]) ;
        axobj = findobj(fig,'type','axes') ;
        set(axobj,'fontsize',10) ;
    end