% ThresholdTest   test each location Illusion degree
clear all;

% cd ../data/GaborDrift
sbjnames = {'shriff'};

% load(['data_trial20/' sbjnames{sbjnum} '.mat']);
addpath '../function';

cd '../data/ThresholdTest'
% subjFiles = dir('huijiahan1*.mat');

gaborMatSingle = {'upperRight_rightward','upperRight_leftward','upperLeft_rightward','upperLeft_leftward',...
    'lowerRight_rightward','lowerRight_leftward','lowerLeft_rightward','lowerLeft_leftward'};

for sbjnum = 1:length(sbjnames)
s1 = string(sbjnames(sbjnum))  
s2 = '*.mat'
s3 = strcat(s1,s2);
Files = dir([s3]);
load ([Files.name]);

% load(['../data/ThresholdTest' sbjnames{sbjnum} '.mat']);
% load ([subjFiles.name]);
% plot(subIlluDegree','lineWidth',5);
meanSubIlluDegree = mean(subIlluDegree(:,5:end),2);
% scatter(ones(1,8)*8,meanSubIlluDegree,'filled');

hold on;
end 
% legend(gaborMatSingle);
plot(subIlluDegree');
% legend ('upperRight-rightward','upperRight-leftward','upperLeft-rightward','upperLeft-leftward',...
%     'lowerRight-rightward' ,'lowerRight-leftward','lowerLeft-rightward','lowerLeft-leftward');
% cd '../../analysis'