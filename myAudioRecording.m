% Author: TEAM FORWARD
% Instructor: Professor Yanfeng Shen
% Course: VG100 Intro to Engineering
% UNIVERSITY OF MICHIGAN - SHANGHAI JIAO TONG UNIVERSITY JOINT INSTITUTE
% Date: AUG 10 2016

function [recorder] = myAudioRecording(Fs,fig,durationSecs)
    if ~exist('durationSecs','var')
        durationSecs = 10;
    end
    N=Fs;
    durationSecs = durationSecs + 0.5;
    lastSampleIdx = 0;
    atTimSecs     = 0;
    recorder = audiorecorder(Fs,16,1);
    OUTPUTDATA.recorder = recorder;
    setappdata(0,'OUTPUTDATA',OUTPUTDATA);
    set(recorder,'TimerPeriod',1,'TimerFcn',@audioTimerCallback,'StopFcn',@stopF);
    recordblocking(recorder,durationSecs);
    function audioTimerCallback(hObject,~)
        samples  = getaudiodata(hObject);
        samplingTime  = 1;%s
        if length(samples)<lastSampleIdx+1+samplingTime*Fs
            return;
        end
        X = samples(lastSampleIdx+1:lastSampleIdx+samplingTime*Fs);
        Y = fft(X,N);
        t = (atTimSecs+1/Fs):1/Fs:(samplingTime+atTimSecs) ;
        axes(fig(2));
        plot(t,X);
        hold on;
        lastSampleIdx = lastSampleIdx + samplingTime*Fs;
        atTimSecs     = atTimSecs + samplingTime; 
    end
    function stopF(hObject,~)
        x=getaudiodata(hObject);
        t = (atTimSecs+1/Fs):1/Fs:length(x)/Fs;
        axes(fig(2));
        plot(t,x(lastSampleIdx+1:end));
        OUTPUTDATA.x=x;
        setappdata(0,'OUTPUTDATA',OUTPUTDATA);
    end
end
