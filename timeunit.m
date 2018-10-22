% Author: TEAM FORWARD
% Instructor: Professor Yanfeng Shen
% Course: VG100 Intro to Engineering
% UNIVERSITY OF MICHIGAN - SHANGHAI JIAO TONG UNIVERSITY JOINT INSTITUTE
% Date: AUG 10 2016

% Change each time duration to its length & get beat of the music
function [beat,p]=timeunit(t)
    t0=t;
    for i=1:1:size(t,2)
        while t(i)<0.5 t(i)=t(i)*2; end
        while t(i)>=1.0 t(i)=t(i)/2; end
    end
    flag=1;
    while flag==1
    i=1;
    t=sort(t);
    flag=0;
        while i<size(t,2)
            j=t(i+1)/t(i)*12;
            if j<17 && j>=15
                t(1:i)=t(1:i)*4/3;
                flag=1;
            end
            if j>17 && j<=19
                t(i+1:size(t,2))=t(i+1:size(t,2))*2/3;
                flag=1;
            end
            i=i+1;
        end
    end
    tx=mean(t);
    beat=round(60/tx);
    p=round(8*(t0/(60/beat)));

    for i=1:1:size(t,2)
        switch p(i)
            case {1,2,4,8,16}
                p(i)=16/p(i);
            case {3,6,12}
                p(i)=16/p(i);
            case 5
                p(i)=4;
            case {7,9,10}
                p(i)=2;
            case {11,13}
                p(i)=4/3;
            case {14,15}
                p(i)=1;
            otherwise
                p(i)=1;
        end
    end
end
