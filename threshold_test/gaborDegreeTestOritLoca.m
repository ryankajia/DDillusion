%% my first gabor drift

% test degree illusion in  8 location across the visual field with
% corresponding oritation 

%% clear the workspace
close all;
clearvars;
sca;
%----------------------------------------------------------------------
%                      set up Psychtoolbox and skip  sync
%----------------------------------------------------------------------
name = input('>>>> Participant name (e.g.: AB):  ','s');
subject_name = name;
Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);
% oldEnableFlag=Screen('Preference', 'EmulateOldPTB', [1]);
HideCursor;
commandwindow;
addpath '../function';

%     Screen('Prefere nce','VisualDebugLevel',0); % warning triangle

% set up screens
screens = Screen('Screens');
screenNumber = max(screens);
blackColor = BlackIndex(screenNumber);
whiteColor = WhiteIndex(screenNumber);
grey = whiteColor/2;


% set the window size
winSize = [0 0 1024 768];   %[0 0 1024 768];


%----------------------------------------------------------------------
%                      open a screen
%----------------------------------------------------------------------

[window winRect] = PsychImaging('OpenWindow',screenNumber,grey,winSize);
[xCenter, yCenter] = RectCenter(winRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[displaywidth, ~] = Screen('DisplaySize', screenNumber);  %
Screen('TextSize', window, 40);
% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);
framerate = FrameRate(window);
viewingDistance = 60; % subject distance to the screen
%----------------------------------------------------------------------
%                       Gabor information
%----------------------------------------------------------------------

gabor = gaborParaSet(window,screenXpixels,displaywidth,viewingDistance,framerate);
orientationAll = [];

%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');


%----------------------------------------------------------------------
%%%                         Experiment loop parameter
%----------------------------------------------------------------------

% Experiment setup
trialNumber = 160;
blockNumber = 1;

subIlluDegreeStep = 2;
responseVector = []; %
TrialAll = [];
BlockAll = [];
conditionAll = [];
subIlluDegreeAll = [];
% randomized the different conditions 4 locations 8 directions
gaborMatSingle = {'upperRight_rightward','upperRight_leftward','upperLeft_rightward','upperLeft_leftward',...
    'lowerRight_rightward','lowerRight_leftward','lowerLeft_rightward','lowerLeft_leftward'};
% gaborMatSingle = {'lowerLeft_rightward'};

blockData = [];
k = 0;
factor = [1:length(gaborMatSingle)];
for i1 = 1:length(factor)
    k = k + 1;
    subData(k,:) = [factor(i1)];
end

blockData = repmat(subData,trialNumber/length(gaborMatSingle),1);
% random sequence of condition 
randSequ = [blockData(Shuffle(1:length(blockData)),:)];
% condition show in order 
% randSequ = blockData;

subIlluDegreeStart = 45;
% store each trial each location subIlluDegree in the matrix
subIlluDegree = zeros(length(gaborMatSingle),trialNumber/length(gaborMatSingle));
subIlluDegree(1:length(gaborMatSingle),1) = subIlluDegreeStart;

%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------


for block = 1: blockNumber
    
    
    for trial = 1:trialNumber
        % If this is the first trial we present a start screen and wait for a
        % key-press
        if trial == 1
            DrawFormattedText(window, 'Press Any Key To Begin', 'center', 'center', black);
            Screen('Flip', window);
            KbStrokeWait;
        end
        
       
        % in y axis - gaborMoveSpeedPixel / xgaborFactor
        gabor.InternalDriftPhaseIncrPerFrame = gabor.InternalDriftCyclesPerFrame/framerate;
        
         
        % set different condition parameters
        condition = string(gaborMatSingle(randSequ(trial)));
        [InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,...
            gaborfixationFactor,orientation] = conditionRand(condition);
        
        % to make a subIlluDegree matrix  row is  gaborMatSingle type
        % column is each trial result
        eachCondIlluDegreeTimes = sum(randSequ(1:trial) == randSequ(trial));
        
        if eachCondIlluDegreeTimes == 1
            subIlluDegreeNow = subIlluDegreeStart;
        else
            subIlluDegreeNow = subIlluDegree(randSequ(trial),eachCondIlluDegreeTimes);
        end 
            
%         subIlluDegree(find(TF)',trialIndex) = subIlluDegree(find(TF)',trialIndex-1);
%         TF = contains(gaborMatSingle,condition);
%         subIlluDegree(find(TF)',trialIndex) = subIlluDegree(find(TF)',trialIndex);
        
        yframe = [1:gabor.SpeedFrame:300];
        xframe = yframe * tan(subIlluDegreeNow*pi/180);

        
        
        
        for frame = 1: (gabor.stimulusTime * framerate)
            % define the tractory of gabor movement
            gaborLocation = CenterRectOnPointd(gabor.rect, xCenter + gaborfixationFactor * gabor.DistanceFromFixationPixel  ...
                + xframeFactor * xframe(frame), yCenter +  yframeFactor * yframe(frame));
            
            %         gaborLocation = CenterRectOnPointd(gaborrect, xCenter + gaborDistanceFromFixationPixel + ...
            %             xframe(frame), yCenter - yframe(frame));
            
            
            Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                kPsychDontDoRotation, gabor.propertiesMatFirst');
            
            % Randomise the phase of the Gabors and make a properties matrix
            gabor.propertiesMatFirst(1) = gabor.propertiesMatFirst(1) + InternalDriftPhaseIncrFactor * gabor.InternalDriftPhaseIncrPerFrame;
            
            
            % Draw fixation
            Screen('DrawDots', window,[xCenter yCenter], 10, [255 255 255 255], [], 2);
            
            
            % Flip to the screen
            Screen('Flip',window);
        end
        Screen('DrawDots', window,[xCenter yCenter], 10, [255 255 255 255], [], 2);
        Screen('Flip',window);
        
        % in rightward conditon respond left incre = -1; reight Incre = 1;
        % in leftward conditon respond left Incre = 1; right Incre = -1;
        
        % different condition means different directions
        internalPattern1 = "rightward";
        internalPattern2 = "leftward";
        iTF1 = contains(condition,internalPattern1);
        iTF2 = contains(condition,internalPattern2);
        
        if iTF1 == 1
            
            % Now we wait for a keyboard button signaling the observers response.
            % The left arrow key signals a "left" response and the right arrow key
            % a "right" response. You can also press escape if you want to exit the
            % program
            
            respToBeMade = true;
            while respToBeMade
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(leftKey)
                    response = 1;
                    subIlluDegreeIncre = - subIlluDegreeStep;
                    respToBeMade = false;
                elseif keyCode(rightKey)
                    response = 0;
                    subIlluDegreeIncre =  subIlluDegreeStep;
                    respToBeMade = false;
                end
            end
        elseif iTF2 == 1
            respToBeMade = true;
            while respToBeMade
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(leftKey)
                    response = 1;
                    subIlluDegreeIncre = subIlluDegreeStep;
                    respToBeMade = false;
                elseif keyCode(rightKey)
                    response = 0;
                    subIlluDegreeIncre = - subIlluDegreeStep;
                    respToBeMade = false;
                end
            end
        end
        


        
        % record condition        
        subIlluDegree(randSequ(trial),eachCondIlluDegreeTimes+1) = subIlluDegreeNow + subIlluDegreeIncre;
%         subIlluDegree(find(TF),trialIndex+1) =  subIlluDegree(find(TF),trialIndex) + subIlluDegreeIncre;
                                
        % Record the response
%         subIlluDegreeAll = [subIlluDegreeAll;subIlluDegree(find(TF),trialIndex)];
        responseVector = [responseVector;response];
        TrialAll =  [TrialAll; trial];
%         BlockAll =[BlockAll; block];
        conditionAll = [conditionAll;condition];
        WaitSecs(1);
        
        %     end
        % end
        
        time = clock;
        RespMat = [TrialAll  conditionAll responseVector];
        fileName = ['../data/ThresholdTest/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
        save(fileName,'RespMat','subIlluDegree','gabor','viewingDistance','trialNumber','blockNumber');
    end
end

plot(subIlluDegree');
meansubIlluDegree = mean(subIlluDegree(:,5:end),2);
meansubIlluDegree'
% plot(meansubIlluDegree);



%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;