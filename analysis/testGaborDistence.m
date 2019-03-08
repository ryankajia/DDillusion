
addpath '../function';
cd '../data/GaborDrift/illusionDegreeSpec/0.5dva'

sbjnames = {'mert','huijiahan'};

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward','upperLeft_rightward','upperLeft_leftward',...
        'lowerRight_rightward' ,'lowerRight_leftward','lowerLeft_rightward','lowerLeft_leftward','catch_trial'};
    intervalTimesMatSingle = [0 50 100 150 200 250 300 350]* 0.001;
        
    [proporPerc(sbjnum,:),performance(sbjnum)] = RespMat2propor(RespMat,gaborMatSingle,intervalTimesMatSingle);
    
end


plot(intervalTimesMatSingle,proporPerc,'--o');
hold on;
% plot mean 
p = plot(intervalTimesMatSingle,mean(proporPerc,1)','r');

hold on;
% plot errorbar 
proporPerc_ste = ste(proporPerc,1);
e = errorbar(intervalTimesMatSingle,mean(proporPerc,1),proporPerc_ste,'r');
e.LineStyle = '-';
e.Marker = 'o';
e.LineWidth = 2;

% axis([0 400 0 100]);
title('apparent motion originate from perceived location','FontSize',30);
xlabel('interval time between illusion and test gabor (ms)','FontSize',25);
ylabel('proportion of apparent motion originate from perceived location (%)','FontSize',22);
% ax = gca;
% ax.FontSize = 13;
% legend({'test gabor 0.5 dva','test gabor 1.5 dva'},'Location','northeast','FontSize',30);
cd '../../../../analysis'