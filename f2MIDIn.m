% Author: TEAM FORWARD
% Instructor: Professor Yanfeng Shen
% Course: VG100 Intro to Engineering
% UNIVERSITY OF MICHIGAN - SHANGHAI JIAO TONG UNIVERSITY JOINT INSTITUTE
% Date: AUG 10 2016

% change frequency to midi number
% F is an array of frequency
% note=0 is middleC(C4)
% 0=C,1=C#,2=D,3=D#,4=E,5=F,6=F#,7=G,8=G#,9=A,10=A#,11=B.
function note=f2MIDIn(F)
    n=length(F);
    MIDI=zeros(1,n);
    for i =1:n
        MIDI(i)=round(12*log2(F(i)/440)+69); % change into MIDI number
    end
    note=MIDI-60;
end