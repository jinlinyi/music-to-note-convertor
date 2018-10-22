% Author: TEAM FORWARD
% Instructor: Professor Yanfeng Shen
% Course: VG100 Intro to Engineering
% UNIVERSITY OF MICHIGAN - SHANGHAI JIAO TONG UNIVERSITY JOINT INSTITUTE
% Date: AUG 10 2016

% Check the wrong music note
function correction(fig);
    fcorrect=fopen('correct.txt','r+');
    fcurrent=fopen('current.txt','r+');
    fp1=fscanf(fcorrect,'%d',1);
    fp2=fscanf(fcurrent,'%d',1);
    fMIDI1=fscanf(fcorrect,'%d',1);
    fMIDI2=fscanf(fcurrent,'%d',1);
    x=0;y=0;k=1;
    axes(fig);
    while (~feof(fcorrect)) && (~feof(fcurrent))
        if mod(k,20)==0 x=0; y=y-10; end
        if (fp1 ~= fp2) || (fMIDI1 ~= fMIDI2)
            DrawRed(fMIDI1,x,y,16/fp1);
        end
        fp1=fscanf(fcorrect,'%d',1)
        fp2=fscanf(fcurrent,'%d',1)
        fMIDI1=fscanf(fcorrect,'%d',1)
        fMIDI2=fscanf(fcurrent,'%d',1)
        x=x+3;k=k+1;
    end
    fclose(fcorrect);
    fclose(fcurrent);
end