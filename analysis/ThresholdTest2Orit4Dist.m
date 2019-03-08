% ThresholdTest test 2 oritation and 4 difference of gabor distance from fixation
clear all;

% cd ../data/GaborDrift
sbjnames = {'k'};

% load(['data_trial20/' sbjnames{sbjnum} '.mat']);
addpath '../function';

cd '../data/ThresholdTest/simplified2loca'
% subjFiles = dir('huijiahan1*.mat');

gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};


for sbjnum = 1:length(sbjnames)
s1 = string(sbjnames(sbjnum)); 
s2 = '*.mat';
s3 = strcat(s1,s2);
Files = dir([s3]);
load ([Files.name]);



for i = 1:length(RespMat)    
    
    if RespMat(i,2) == 'upperRight_leftward'  &&  str2num(RespMat(i,3)) == 7  
        condiIndex = b = RespMat(:) == 'upperRight_leftward'  &&  a = str2double(RespMat(:,3)) == 7
        n = sum(double(cell2mat(condiIndex)))

        subIlluSize(1,n) = RespMat(i,5);
    elseif RespMat(i,2) == 'upperRight_leftward'  &&  str2num(RespMat(i,3)) == 10
        subIlluSize(2) = RespMat(i,5);
    elseif RespMat(i,2) == 'upperRight_rightward'  &&  str2num(RespMat(i,3)) == 7
        subIlluSize(3) = RespMat(i,5);
    elseif RespMat(i,2) == 'upperRight_rightward'  &&  str2num(RespMat(i,3)) == 10
        subIlluSize(4) = RespMat(i,5)   
    end
end


% first is upperRight_leftward  distance 7 & 10     upperRight_rightward  distance 7 & 10 
meanSubIlluDegree(:,sbjnum) = mean(subIlluSize(:,5:end),2);
% scatter(ones(1,8)*8,meanSubIlluDegree,'filled');

hold on;
end 
% legend(gaborMatSingle);
plot(subIlluSize');
legend ('upperRight_rightward with 7','upperRight_rightward with 10','upperRight-leftward with 9','upperRight-leftward with 10','upperRight-rightward with 7','upperRight-rightward with 8','upperRight-rightward with 9','upperRight-rightward with 10');
cd '../../../analysis'