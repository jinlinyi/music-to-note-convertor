% Author: TEAM FORWARD
% Instructor: Professor Yanfeng Shen
% Course: VG100 Intro to Engineering
% UNIVERSITY OF MICHIGAN - SHANGHAI JIAO TONG UNIVERSITY JOINT INSTITUTE
% Date: AUG 10 2016

% The main function to draw Five Line Staff
% MIDI is the MIDI number of the note
% (x,y),(x0,y0) is the coordination
% p is the length of each time duration
function [x0,y0,k]=DrawMain(x,y,k0,MIDI,p)
    x0=x;y0=y;k=k0;
    hold on;
    if x0==0
        C=imread('2.jpg');
        image([x0-3 x0-1],[y0+3 y0-3],C);
        for i=-2:1:2
            plot([x0-4,x0],[y0+i,y0+i],'color','k');
        end
    end
    Draw(MIDI,x0,y0,p);
    x0=x0+3;k=k+1;
    axis([x0-20 x0+20 y0-20 y0+20]);

    if mod(k,20)==0
        for j=-2:1:2
            plot([x0,x0+1.5],[y0+j,y0+j],'color','k');
        end
        plot([x0+1.5,x0+1.5],[y0-2,y0+2],'color','k');
        axis([x0-20 x0+20 y0-20 y0+20]);
        x0=0;
        y0=y0-10;
    end
end