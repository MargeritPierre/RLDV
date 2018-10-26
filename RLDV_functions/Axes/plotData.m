function handles = plotData(ToPlot,handlesIN) % PLOT DATA IN REAL TIME
    global Axes1 Axes2
    handles = handlesIN ;
    % Computing Frequency Vector
        nScans = length(ToPlot.Time) ;
        ToPlot.f = (0:nScans-1)/nScans*handles.Session.Rate ;
    if (~isempty(ToPlot.Data))
        for ax = [Axes1 Axes2]
            for line = ax.Children.'
                switch (line.Tag)
                    case 'Reference'
                        line.XData = ToPlot.Time ;%1:length(ToPlot.Time) ; %
                        line.YData = ToPlot.Data(:,1) ;
                    case 'Vibrometer'
                        line.XData = ToPlot.Time ;%1:length(ToPlot.Time) ; %
                        line.YData = ToPlot.Data(:,2) ;
                    case 'FFT_Reference'
                        line.XData = ToPlot.f ;
                        line.YData = abs(fft(ToPlot.Data(:,1))) ;
                    case 'FFT_Vibrometer'
                        line.XData = ToPlot.f ;
                        line.YData = abs(fft(ToPlot.Data(:,2))) ;
                    case 'AS_Vib'
                        line.XData = ToPlot.f ;
                        line.YData = abs(fft(conv(ToPlot.Data(:,2),ToPlot.Data(:,2),'same'))) ;
                    case 'AS_Ref'
                        line.XData = ToPlot.f ;
                        line.YData = abs(fft(conv(ToPlot.Data(:,1),ToPlot.Data(:,1),'same'))) ;
                    case 'CS_Vib_Ref'
                        line.XData = ToPlot.f ;
                        line.YData = abs(fft(conv(ToPlot.Data(:,2),ToPlot.Data(:,1),'same'))) ;
                    case 'CS_Ref_Vib'
                        line.XData = ToPlot.f ;
                        line.YData = abs(fft(conv(ToPlot.Data(:,1),ToPlot.Data(:,2),'same'))) ;
                    case 'H1_Vib_Ref'
                        line.XData = ToPlot.f ;
                        line.YData = abs(fft(conv(ToPlot.Data(:,2),ToPlot.Data(:,1),'same'))./fft(conv(ToPlot.Data(:,1),ToPlot.Data(:,1),'same'))) ;
                    case 'H2_Vib_Ref'
                        line.XData = ToPlot.f ;
                        line.YData = abs(fft(conv(ToPlot.Data(:,2),ToPlot.Data(:,2),'same'))./fft(conv(ToPlot.Data(:,1),ToPlot.Data(:,2),'same'))) ;
                    case 'Coherence_Vib_Ref'
                        line.XData = ToPlot.f ;
                        line.YData = abs((fft(conv(ToPlot.Data(:,2),ToPlot.Data(:,1),'same'))).^2./(fft(conv(ToPlot.Data(:,2),ToPlot.Data(:,2),'same')).*fft(conv(ToPlot.Data(:,1),ToPlot.Data(:,1),'same')))) ;
                    otherwise
                        line.XData = [] ;
                        line.YData = [] ;
                end
            end
        end
    end