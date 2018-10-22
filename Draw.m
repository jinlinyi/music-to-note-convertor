% Author: TEAM FORWARD
% Instructor: Professor Yanfeng Shen
% Course: VG100 Intro to Engineering
% UNIVERSITY OF MICHIGAN - SHANGHAI JIAO TONG UNIVERSITY JOINT INSTITUTE
% Date: AUG 10 2016

% Draw music sheet
% note is the MIDI number of the note
% (x,y) is the coordination
% pace: 32 for 1/32 note, 16 for 1/16 note...
function Draw(note,x,y,pace)
    delta=1;length=3;
    note2='0';
    hold on;
    if note~=-Inf
        switch mod(note,12)
            case 0
                center=floor(note/12)*3.5;
            case 1
                center=floor(note/12)*3.5; note2='#';
            case 2
                center=floor(note/12)*3.5+0.5;
            case 3
                center=floor(note/12)*3.5+0.5; note2='#';
            case 4
                center=floor(note/12)*3.5+1;
            case 5
                center=floor(note/12)*3.5+1.5;
            case 6
                center=floor(note/12)*3.5+1.5; note2='#';
            case 7
                center=floor(note/12)*3.5+2;
            case 8
                center=floor(note/12)*3.5+2; note2='#';
            case 9
                center=floor(note/12)*3.5+2.5;
            case 10
                center=floor(note/12)*3.5+2.5; note2='#';
            case 11
                center=floor(note/12)*3.5+3;
        end
        center=center-3;
        if center<0 k=-1; else k=1; end
        if 16/pace==6 | 16/pace==3 | 16/pace==12
            plot(x+2.5,y+0.5*delta+floor(center)*delta,'.k');
            pace=pace*3/2;
        end
        t=linspace(0,2*pi,100);
        xt=(x+length/2)+0.5*delta*cos(t);
        yt=y+(center*delta)+0.4*delta*sin(t);
        if pace>2
            fill(xt,yt,[0 0 0]);
        else
            plot(xt,yt,'color','k','lineWidth',1);
        end
        for i=0:k:fix(center)
            plot([x+length/2-delta,x+length/2+delta],[y+i*delta,y+i*delta],'color','k');
        end
        if pace>1
            plot([x+length/2-0.5*k*delta,x+length/2-0.5*k*delta],[y+(center-k*3.5)*delta,y+center*delta],'color','k');
        end
        for i=1:1:log2(pace/4)
            for j=1:1:10
                t=linspace(0.7*delta*(j-1)/10,0.7*delta*j/10,10);
                xt=(x+length/2-0.5*k*delta)+t;
                yt=y+((center-k*(3.8-0.6*i))*delta)+3*k*t.*t;
                plot(xt,yt,'color','k','lineWidth',1);
            end
        end
    else
        switch pace
            case 1
                fill([x+length/2-0.5*delta,x+length/2-0.5*delta,x+length/2+0.5*delta,x+length/2+0.5*delta],[y,y-0.3*delta,y-0.3*delta,y],[0 0 0]);
            case 2
                fill([x+length/2-0.5*delta,x+length/2-0.5*delta,x+length/2+0.5*delta,x+length/2+0.5*delta],[y,y+0.3*delta,y+0.3*delta,y],[0 0 0]);
            case 4
                C=imread('3.jpg');
                image([x+1.2 x+1.8],[y+1.3 y-1.3],C);
            case {8,16,32}
                plot([x+length/2-(0.2+0.2*log2(pace/4))*delta,x+length/2+0.4*delta],[y-0.5*(1+log2(pace/4))*delta,y+1*delta],'color','k');
                t=linspace(0,2*pi,100);
                for i=1:1:log2(pace/4)
                    xt=(x+length/2+0.3*delta-i*0.3*delta)+0.25*delta*cos(t);yt=y+((1.4-0.7*i)*delta)+0.25*delta*sin(t);
                    fill(xt,yt,[0 0 0]);
                end
        end
    end

    for i=-2:1:2
        plot([x,x+length],[y+i*delta,y+i*delta],'color','k');
    end

    % sharp and flat notes
    if note2=='b'
        text(x+length/2-1.5*delta,y+(center+0.5)*delta,'$\flat$','Interpreter','Latex','Fontsize',22);
    else if note2=='#'
            text(x+length/2-1.5*delta,y+(center+0.5)*delta,'$\sharp$','Interpreter','Latex','Fontsize',22);
        end
    end
end