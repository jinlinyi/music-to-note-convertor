% Author: TEAM FORWARD
% Instructor: Professor Yanfeng Shen
% Course: VG100 Intro to Engineering
% UNIVERSITY OF MICHIGAN - SHANGHAI JIAO TONG UNIVERSITY JOINT INSTITUTE
% Date: AUG 10 2016

function myPlay(note, beats, beat)
    for i=1:length(note)
        k=note(i);
        if k<12
            note(i)=k;
        elseif 11<k<24
            note(i)=k+8;
        elseif 23<k<36
            note(i)=k+16;
        elseif 35<k<48
            note(i)=k+24;
        end
    end
    A4=440;
    pt=5000;
    p0=pt/1;
    octave1=A4/2^(9/12)*2.^((0:11)/12-1);
    octave2=A4/2^(9/12)*2.^((0:11)/12);
    octave3=A4/2^(9/12)*2.^((0:11)/12+1);
    octave4=A4/2^(9/12)*2.^((0:11)/12+2);
    map=[1 2 3 4 5 6 7 8 9 10 11 12];

    notemap=zeros(200,1);
    for i=1:4
        for j=1:12
            k=i*20+j;
            if i==1
                notemap(k)=octave1(map(j));
            elseif i==2
                notemap(k)=octave2(map(j));
            elseif i==3
                notemap(k)=octave3(map(j));
            elseif i==4
                notemap(k)=octave4(map(j));
            end
        end
    end
    disp(notemap);
    newnote=41+note;
    rhythm=beats./beat;
    pianowav=zeros((sum(rhythm)+4)*p0,1);
    d=4;
    Nd=5;
    a=1.5;
    b=4;
    for i=1:length(newnote)
        temp1=sin((1:1.2*rhythm(i)*p0)'/pt*2*pi*notemap(newnote(i))*(1:Nd))./(ones(length(1:1.2*rhythm(i)*p0),1)*d.^(1:Nd));
        temp1(:,2:Nd)=1/2*temp1(:,2:Nd);
        temp=sum(temp1,2).*betapdf((1/1.2/rhythm(i):1/1.2/rhythm(i):p0)'/p0,a-(newnote(i)-30)/200,b+(newnote(i)-30)/200).*...
            (1+1/8*sin((1/1.2/rhythm(i):1/1.2/rhythm(i):p0)'/p0*2*pi*2*exp(-(newnote(i)-100)/100))).*...
            (1+1/16*sin((1/1.2/rhythm(i):1/1.2/rhythm(i):p0)'/p0*2*pi*2*2*exp(-(newnote(i)-100)/100))).*(1+1/8*randn(1));
        index=sum(rhythm(1:(i-1)));
        pianowav((1+p0*index):(p0*index+length(temp)))=pianowav((1+p0*index):(p0*index+length(temp)))+temp;
    end
    pianowav=0.95*pianowav/max(abs(pianowav));
    length(pianowav)/pt;
    sound(pianowav,pt);
    audiowrite('myPlay_piano.wav',pianowav,pt);
end