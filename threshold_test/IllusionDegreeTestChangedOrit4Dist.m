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
debug = input('>>>> debug? (e.g.: debug no press n  debug yes press y): ','s');
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
trialNumber = 60; % have to be divided by  8
blockNumber = 1;
if debug == 'n'
    subIlluDegreeStep = 2;
elseif debug == 'y'
    subIlluDegreeStep = 10;
end
responseVector = []; %
TrialAll = [];
BlockAll = [];
conditionAll = [];
subIlluDegreeAll = [];
gaborDistanceFromFixationDegreeAll = [];




% gaborMatSingle = {'lowerLeft_rightward'};

% gabor location from center in angle  but fixation move left 3 degree
xCenter = xCenter - gabor.fixationPixel;
yCenter = yCenter;

% no debug
if debug == 'n'
    gaborDistanceFromFixationDegree = [10];
    % randomized the different conditions 4 locations 8 directions
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};   % ,'upperRight_leftward'
    % debug
elseif debug == 'y'
    gaborDistanceFromFixationDegree = [10];   % visual angle degree
    gaborMatSingle = {'upperRight_rightward'};
end
gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegree,viewingDistance,screenXpixels,displaywidth);

conditionFreq = (length(gaborMatSingle)*length(gaborDistanceFromFixationDegree));
repeatFreq = trialNumber/conditionFreq;

k = 0;
factor1 = [1:length(gaborDistanceFromFixationDegree)]; % blockData 1
factor2 = [1:length(gaborMatSingle)]; % blockData 2
for i1 = 1:length(factor1)
    for i2 = 1:length(factor2)
        k = k + 1;
        subData(k,:) = [factor1(i1), factor2(i2)];
    end
end


blockData = repmat(subData,repeatFreq,1);
if debug == 'n'   %debug = 1 no debug
    % random seque nce of condition
    randSequ = [blockData(Shuffle(1:length(blockData)),:)];
elseif debug == 'y' % debug = 2  debug
    % condition show in order
    randSequ = blockData;
end

subIlluDegreeStart = 40;
% store each trial each location subIlluDegree in the matrix
subIlluDegree = zeros(conditionFreq,trialNumber/conditionFreq + 1);
subIlluDegree(1:conditionFreq,1) = subIlluDegreeStart;



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
        
        
        
        % to make a subIlluDegree matrix  row is  gaborMatSingle type with
        % one distance in gaborDistanceFromFixationDegree(row = 12)
        % column is each trial result
        % compare this type of trial in all the trials have been presented
        % here determine the subIlluDegree  order
        % first is gaborDistanceFromFixationDegree second is gaborMatSingle
        % 7 upperRight_rightward
        % 7 upperRight_leftward
        % 10 upperRight_rightward
        % 10 upperRight_leftward
        
        % blockData is in order and check each trial condition is in which
        % condition set the subIlluDegreeIndex as the same order as
        % blockData
        % 7dva rightward 7dva leftward    10 dva rightward 10dva leftward
        for q = 1:conditionFreq
            if randSequ(trial,:) == blockData(q,:)
                subIlluDegreeIndex = q;
            end
        end
        
        
        
        eachCondIlluDegreeTimes1 = double(randSequ(1:trial,:) == randSequ(trial,:));
        % count the frequency of this type of trial have been prensented
        eachCondIlluDegreeTimes = length(find(int8(sum(eachCondIlluDegreeTimes1,2) == 2) == 1));
        
        
        % subIlluDegreeIndex is in the same order as blockData
        % 5 'upperRight_rightward',  5 'upperRight_leftward'   7 'upperRight_rightward',  7 'upperRight_leftward'
        if eachCondIlluDegreeTimes == 1
            subIlluDegreeNow = subIlluDegreeStart;
        else
            subIlluDegreeNow = subIlluDegree(subIlluDegreeIndex,eachCondIlluDegreeTimes);
        end
        
        % compare randSequ with subData and determine each trial's
        % subIlluDegreeNow is in which condition in 12 condition
        % set different condition parameters
        condition = string(gaborMatSingle(randSequ(trial,2)));
        [InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,gaborfixationFactor,...
            orientation,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor] = conditionRandRotaChan(condition,subIlluDegreeNow);
        
        % the angle degree test is different from experiment the subject
        % have to judge whether they perceived left or right to the
        % vertical
        yframe = [1:gabor.SpeedFrame*cos(subIlluDegreeNow*pi/180):500];
        xframe = yframe * tan(subIlluDegreeNow*pi/180);
        
        
        
        for frame = 1: (gabor.stimulusTime * framerate)
            
            
            gaborDistanceFromFixationDegreeNow = gaborDistanceFromFixationDegree(randSequ(trial,1));
            gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegreeNow,viewingDistance,screenXpixels,displaywidth);
            
            % set the middle of the gabor path 7 or 10 dva away from the fixation
            % so the direction of gabor is crossed in the middle of the path
            gaborStartLocMoveXDegree =  (gabor.pathLengthDegree/2)* sin((subIlluDegreeNow/180)*pi);
            gaborStartLocMoveYDegree =  gabor.pathLengthDegree/2 * cos((subIlluDegreeNow/180)*pi);
            gaborStartLocMoveXPixel = deg2pix(gaborStartLocMoveXDegree,viewingDistance,screenXpixels,displaywidth);
            gaborStartLocMoveYPixel = deg2pix(gaborStartLocMoveYDegree,viewingDistance,screenXpixels,displaywidth);
            
            
            
            % define the tractory of gabor movement   start from xCenter + 7/10 dva +  move gabor's center to the same level of fixation
            gaborLocation = CenterRectOnPointd(gabor.rect, xCenter + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel ...
                + xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel+  yframeFactor * yframe(frame));
            
            
            
            Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                kPsychDontDoRotation, gabor.propertiesMatFirst');
            
            % Randomise the phase of the Gabors and make a properties matrix
            gabor.propertiesMatFirst(1) = gabor.propertiesMatFirst(1) + InternalDriftPhaseIncrFactor * gabor.InternalDriftPhaseIncrPerFrame;
            
            
            % Draw fixation
            Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
            
            
            % Flip to the screen
            Screen('Flip',window);
        end
        Screen('DrawDots', window,[xCenter,  yCenter], 10, [255 255 255 255], [], 2);
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
        
        
        
        % there is 2 distance of subIlluDegree
        %         if gaborDistanceFromFixationDegreeNow == 7
        % record condition
        subIlluDegree(subIlluDegreeIndex,eachCondIlluDegreeTimes+1) = subIlluDegreeNow + subIlluDegreeIncre;
        %         subIlluDegree(find(TF),trialIndex+1) =  subIlluDegree(find(TF),trialIndex) + subIlluDegreeIncre;
        
        % Record the response
        subIlluDegreeAll = [subIlluDegreeAll;subIlluDegree(subIlluDegreeIndex,eachCondIlluDegreeTimes+1)];
        responseVector = [responseVector;response];
        TrialAll =  [TrialAll; trial];
        gaborDistanceFromFixationDegreeAll = [gaborDistanceFromFixationDegreeAll;gaborDistanceFromFixationDegree(randSequ(trial,1))];
        conditionAll = [conditionAll;condition];
        WaitSecs(1);
        
    end
end
meansubIlluDegree = mean(subIlluDegree(:,15:end),2)';
time = clock;
RespMat = [TrialAll  conditionAll gaborDistanceFromFixationDegreeAll responseVector subIlluDegreeAll];
fileName = ['../data/ThresholdTest/orientChange/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
save(fileName,'RespMat','subIlluDegree','meansubIlluDegree','gabor','viewingDistance','trialNumber','blockNumber');



plot(subIlluDegree');
meansubIlluDegree
% plot(meansubIlluDegree);



%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;