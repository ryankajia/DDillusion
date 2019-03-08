% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
addpath '../../function';
% decide analysis which distance
mark = 1;

if mark == 1
    cd '../../data/GaborDrift/simplified2loca'
    % 0.5 dva
    sbjnames = {'huijiahan648'};
elseif mark ~= 1
    % 1.5 dva
    cd '../data/GaborDrift/illusionDegreeSpec/1.5dva'
    sbjnames = {'huijiahan2','kevin','marvin','mert2','shriff2','sunliwei3','liuchengwen','nate'};
end

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
    gaborDistanceFromFixationDegree = [5  7];
    Resp7dva = zeros(8,1);
    Resp10dva = zeros(8,1);
    % left 1   right 0
    % record the apparent motion from real path
    
    %     oritation = RespMat(:,3);
    %     oritation_left = strcmp('upperRight_leftward',oritation);
    %     oritation_right = strcmp('upperRight_rightward',oritation);
    %
    %     distance = RespMat(:,5);
    %     distance7 = strcmp('7',distance);
    %     distance10 = strcmp('10',distance);
    %     delay = RespMat(:,4);
    %     delay1 = strcmp('0',delay);
    %     delay2 = strcmp('50',delay);
    %     delay3 = strcmp('100',delay);
    %     delay4 = strcmp('150',delay);
    %     delay5 = strcmp('200',delay);
    %     delay6 = strcmp('250',delay);
    %     delay7 = strcmp('300',delay);
    %     delay8 = strcmp('350',delay);
    %
    %     Respdis7delay1 = sum(distance7 .* delay1 .* oritation_left);
    %     Respdis7delay2 = sum(distance7 .* delay2 .* oritation_left);
    %     Respdis7delay3 = sum(distance7 .* delay3 .* oritation_left);
    %     Respdis7delay4 = sum(distance7 .* delay4 .* oritation_left);
    %     Respdis7delay5 = sum(distance7 .* delay5 .* oritation_left);
    %     Respdis7delay6 = sum(distance7 .* delay6 .* oritation_left);
    %     Respdis7delay7 = sum(distance7 .* delay7 .* oritation_left);
    %     Respdis7delay8 = sum(distance7 .* delay8 .* oritation_left);
    
    
    
    
    
    for i = 1 : length(RespMat)
        
        if str2double(RespMat(i,5)) == 7
            
            for delay1 = 1 :length(intervalTimesMatSingle)
                
                if  str2double(RespMat(i,4)) == intervalTimesMatSingle(delay1)
                    
                    switch RespMat(i,3)
                        % left 1   right 0
                        % record the apparent motion from perceived path
                        case 'upperRight_leftward'
%                             b = 1
                            if  str2double(RespMat(i,6)) == 0
                                Resp7dva(delay1) = Resp7dva(delay1) + 1;
%                                 a = 2
                            end
                        case 'upperRight_rightward'
                            if  str2double(RespMat(i,6)) == 1
                                Resp7dva(delay1) = Resp7dva(delay1) + 1;
                                
                            end
                    end
                end
            end
        elseif str2double(RespMat(i,5)) == 10
            for delay2 = 1:length(intervalTimesMatSingle)
                if  str2double(RespMat(i,4)) == intervalTimesMatSingle(delay2)
                    
                    switch RespMat(i,3)
                        % left 1   right 0
                        % record the apparent motion from real path
                        case 'upperRight_leftward'
                            if  str2double(RespMat(i,6)) == 0
                                Resp10dva(delay2) = Resp10dva(delay2) + 1;
                            end
                        case 'upperRight_rightward'
                            if  str2double(RespMat(i,6)) == 1
                                Resp10dva(delay2) = Resp10dva(delay2) + 1;
                            end
                    end
                end
            end
        end
    end
end



trialNumPerCondition = length(RespMat)/(length(intervalTimesMatSingle)*length(gaborDistanceFromFixationDegree));
Resp7dvaPerc = Resp7dva/trialNumPerCondition;
Resp10dvaPerc = Resp10dva/trialNumPerCondition;


plot(intervalTimesMatSingle*1000,Resp7dvaPerc*100);
hold on;
plot(intervalTimesMatSingle*1000,Resp10dvaPerc*100);

%     hold on;
%     plot(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,'r','LineWidth',3);
%     % plot(meanReactionTime);
%
%
%     proporPerc_ste = ste(proporPerc,1);
%     % bar(1:length(intervalTimesMatSingle),mean(proporPerc,2),'r','BarWidth',0.2);
%     errorbar(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,proporPerc_ste*100,'r.');
%
    axis([-10 400 0 100]);
    legend('7dva','10dva')
    title('proportion of apparent motion from the end of perceived path(far)','FontSize',40);
    xlabel('interval time between illusion and test gabor(ms)','fontSize',30);
    ylabel({'proportion of apparent motion from the end of perceived path(%)';'  << more from physical      more from perceived  >> '},'FontSize',20);
%     legend(sbjnames,'Location','northeast')
    ax = gca;
    ax.FontSize = 20;
%
%     cd '../../../analysis'



