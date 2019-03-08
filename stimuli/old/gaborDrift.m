%% my first gabor drift


%% clear the workspace
close all;
clearvars;
sca;

tic;

name = input('>>>> Participant name (e.g.: AB):  ','s');
%----------------------------------------------------------------------
%                      set up Psychtoolbox and skip  sync
%----------------------------------------------------------------------

Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);
% oldEnableFlag=Screen('Preference', 'EmulateOldPTB', [1]);
HideCursor;
commandwindow;
% add shared scripts to path
addpath('function');

%     Screen('Preference','VisualDebugLevel',1); % warning triangle

% set up screens
screens = Screen('Screens');
screenNumber = max(screens);
% Define black, white and grey
blackcolor = BlackIndex(screenNumber);
whitecolor = WhiteIndex(screenNumber);
grey = whitecolor/2;


% set the window size
winSize = [];   %[0 0 1024 768];


%----------------------------------------------------------------------
%                      open a screen
%----------------------------------------------------------------------

[window winRect] = PsychImaging('OpenWindow',screenNumber,grey,winSize);
[xCenter, yCenter] = RectCenter(winRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[displaywidth, ~] = Screen('DisplaySize', screenNumber);  %
% Set the text size
Screen('TextSize', window, 40);
framerate = FrameRate(window);
% test = input('Name of the subject:    ');
viewingDistance = 60; % subject distance to the screen

%----------------------------------------------------------------------
%                       Gabor information
%----------------------------------------------------------------------

% createGabor = setGaborParams(subIlluDegree,orientation,InternalDriftCyclesPerSecond);
% demo orientation = 0;   InternalDriftCyclesPerSecond = 3;
% gabor location from center in angle
subIlluDegree = 43;
% gabor size from visual angle
gaborDimPix = 50;  % gabor size in pixels
viewingDistance = 60; % subject distance to the screen
% gaborVisualAngle = 2;  % gabor visual angle
% screen_diagonal = sqrt(winRect(3).^2 + winRect(4).^2);
% gaborDimPix = round(deg2pix(gaborVisualAngle,viewingDistance,screenXpixels,displaywidth));

% fixation move left 3 degree
fixationDegree = 3;
fixationPixel = round(deg2pix(fixationDegree,viewingDistance,screenXpixels,displaywidth));


% gabor location from center in angle
gaborDistanceFromFixationDegree = 8;   % visual angle degree
gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegree,viewingDistance,screenXpixels,displaywidth);  %

% internal motion of gabor drift speed  frame
InternalDriftCyclesPerSecond = 4; % 3 Hz  in lisi
InternalDriftCyclesPerFrame = InternalDriftCyclesPerSecond * 360;
% InternalDriftPhaseIncrPerFrame = InternalDriftCyclesPerFrame/framerate; %degree per frame
% actual speed x = 1 framePerSec   y = x / xgaborFactor



% gaborExternalMotionDegreePerSec = 2;
% % gabor moving along a linear path of length:  in dva
% gaborExternalMotionLengthDegree = 2; % dva   trajactory is 3 degree of visual angle
% stimulusTime = gaborExternalMotionLengthDegree/gaborExternalMotionDegreePerSec;



% set texture parameters   Obvious parameters
orientation = 0; % subIlluDegree/2;
contrast = 0.8;
aspectRatio = 1.0;
phase = 0;

% Spatial Frequency(Cycles Per Pixel)  gabor internal motion
% One Cycle = Grey-black-Grey-White-Grey i.e. One Black and One White Lobe
numCycles = 2;  % cycles of present gabor
freq = numCycles/gaborDimPix; % per pixel how many cycles

% Sigma of Gussian
sigma = gaborDimPix/7;

propertiesMatFirst = [phase, freq, sigma, contrast, aspectRatio, 0, 0, 0];

% Build a procedural gabor texture
backgroundOffset = [0.5 0.5 0.5 0.0];
disableNorm = 1;
preContrastMultiplier = 0.5;

[gabortex, gaborrect] = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, [],...
    backgroundOffset, disableNorm, preContrastMultiplier);

% gabor moving path length
% pathLengthDegree = 2; % dva
% pathLengthPixel = deg2pix(pathLengthDegree,viewingDistance,screenXpixels,displaywidth);
% stimulusTime = pathLengthPixel/framerate; %1;   % length is 1 * 60 frame  60 pixel
stimulusTime = 1;


% gabor moving speed
% gaborSpeed = 2; % dva/sec
% gaborSpeedPixels = deg2pix(gaborSpeed,viewingDistance,screenXpixels,displaywidth);
% gaborSpeedFrame = gaborSpeedPixels/framerate;

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
%%%                         experiment loop parameter
%----------------------------------------------------------------------

% Experiment setup
% fprintf('subject_name is',);
subject_name = name;
trialNumber = 72; % have to triple times of 8 which is the number of the interval time and 9 conditions
blockNumber = 6;




responseVector = []; %
% Make a vector to record the interval time for each trial
intervalTimesVector = []; % reshape(zeros(trialNumber,blockNumber),[],1);
TrialAll = [];
BlockAll = [];
conditionAll = [];

% all the conditions 9
gaborMatSingle = {'upperRight_rightward','upperRight_leftward','upperLeft_rightward','upperLeft_leftward',...
    'lowerRight_rightward' ,'lowerRight_leftward','lowerLeft_rightward','lowerLeft_leftward','catch_trial'};

% interval time between cue and gabor
intervalTimesMatSingle = [0 50 100 150 200 250 300 350]* 0.001;   % intervalTime second


blockData = [];
k = 0;
factor1 = [1:9];
factor2 = [1:8];
for i1 = 1:length(factor1)
    for i2 = 1:length(factor2)
        k = k + 1;
        subData(k,:) = [factor1(i1), factor2(i2)];
    end
end
blockData = [subData(Shuffle(1:length(subData)),:)];
% blockData = subData;


%----------------------------------------------------------------------
%%%                         cue parameter
%----------------------------------------------------------------------
ycueFactor = 2 * rand(1,trialNumber); % yCueDistance scale of gabor distance

cueShowTime = 0.2;
% Make a vector to record the response for each trial
cueVerDisDegree =  0.5;  % negtive number means higher;   positive number means lower
cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);




%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------
t0 = GetSecs;

for block = 1:blockNumber
    % make sure driftPhase won't be negtive before setting
    %     InternalDriftPhaseIncrPerFrame = abs(InternalDriftPhaseIncrPerFrame);
    
    %     yframe = [1:gaborSpeedFrame:300];
    yframe = [1:300];
    xframe =  yframe * tan(subIlluDegree*pi/360);
    
    
    %----------------------------------------------------------------------
    %%%                         stimulus Recording
    %----------------------------------------------------------------------
    % Record the stimulus by frame
    rec = 0;   % Rec = 1 begin recording
    mov.name = 'doubledrift';
    mov.framerate = 60;
    mov.dir = cd;
    mov = recdisplay(rec,mov,'create');
    
    
    for trial = 1: trialNumber
        
        gaborMoveSpeedPixel = 1; % gabor move speed(pixal) per frame in x axis
        % in y axis - gaborMoveSpeedPixel / xgaborFactor
        InternalDriftPhaseIncrPerFrame = InternalDriftCyclesPerFrame/framerate;
        
        
        %     % external motion of speed : gabor move liner path of length in degree of visual angle
        %     gaborExternalMotionDegreePerSec = 2;  % 2dva/sec external motion in Lisi
        %     gaborExternalMotionDegreePerFrame = gaborExternalMotionDegreePerSec/framerate;
        %     gaborExternalMotionPixelPerFrame = deg2pix(gaborExternalMotionDegreePerFrame,viewingDistance,screenXpixels,displaywidth);
        
        % If this is the first trial we present a start screen and wait for a key-press
        if trial == 1
            DrawFormattedText(window, 'Press Any Key To Begin', 'center', 'center', blackcolor);
            %             fprintf(1,'\tBlock number: %2.0f\n',blockNumber);
            
            Screen('Flip', window);
            KbStrokeWait;
        end
        
        
        
        condition = string(gaborMatSingle(blockData(trial,1)));
        
        % InternalDriftPhaseIncrPerFrame > 0 internal drift leftward
        % InternalDriftPhaseIncrPerFrame < 0 internal drift rightward
        % cueVerDisPixFactor = 1  fixation upward
        % cueVerDisPixFactor = - 1 fixation downward
        % xframeFactor = 1  move path rightward along x axis
        % xframeFactor = - 1 gabor move path leftward along x axis
        % gaborfixationFactor = 1; fixation is in the right visual field
        % gaborfixationFactor = - 1; fixation is in the left visual field
        % yframeFactor = 1;   gabor move downward along y axis
        % yframeFactor = - 1; gabor move downward along y axis
        switch condition
            case 'upperRight_rightward'
                InternalDriftPhaseIncrPerFrame = - InternalDriftPhaseIncrPerFrame;
                xframeFactor = - 1 ;
                yframeFactor = - 1;
                cueVerDisPixFactor = - 1;
                gaborfixationFactor = 1;
                %                 orientation = 45;
            case {'upperRight_leftward'}
                InternalDriftPhaseIncrPerFrame = InternalDriftPhaseIncrPerFrame;
                xframeFactor = 1 ;
                yframeFactor = - 1;
                cueVerDisPixFactor =  - 1;
                gaborfixationFactor = 1;
                %                 orientation = - 45;
            case {'upperLeft_rightward'}
                InternalDriftPhaseIncrPerFrame = - InternalDriftPhaseIncrPerFrame;
                xframeFactor = - 1 ;
                yframeFactor = - 1;
                cueVerDisPixFactor = - 1;
                gaborfixationFactor = - 1;
                %                 orientation =   45;
            case {'upperLeft_leftward'}
                InternalDriftPhaseIncrPerFrame = InternalDriftPhaseIncrPerFrame;
                xframeFactor = 1 ;
                yframeFactor = - 1;
                cueVerDisPixFactor =  - 1;
                gaborfixationFactor = - 1;
                %                 orientation = - 45;
            case {'lowerRight_rightward'}
                InternalDriftPhaseIncrPerFrame = - InternalDriftPhaseIncrPerFrame;
                xframeFactor = - 1 ;
                yframeFactor = 1;
                cueVerDisPixFactor =  1;
                gaborfixationFactor =  1;
                %                 orientation = -45;
            case {'lowerRight_leftward'}
                InternalDriftPhaseIncrPerFrame =  InternalDriftPhaseIncrPerFrame;
                xframeFactor = 1 ;
                yframeFactor = 1;
                cueVerDisPixFactor =  1;
                gaborfixationFactor =  1;
                %                 orientation = 45;
            case {'lowerLeft_rightward'}
                InternalDriftPhaseIncrPerFrame =  - InternalDriftPhaseIncrPerFrame;
                xframeFactor =  - 1 ;
                yframeFactor = 1;
                cueVerDisPixFactor =  1;
                gaborfixationFactor =  - 1;
                %                 orientation =  - 45;
            case {'lowerLeft_leftward'}
                InternalDriftPhaseIncrPerFrame =  InternalDriftPhaseIncrPerFrame;
                xframeFactor =  1 ;
                yframeFactor = 1;
                cueVerDisPixFactor =  1;
                gaborfixationFactor =  - 1;
                %                 orientation = 45;
            case {'catch_trial'}
                % no internal motion of gabor
                InternalDriftPhaseIncrPerFrame = 0;
                xframeFactor =  1 ;
                yframeFactor =  1;
                cueVerDisPixFactor =  1;
                gaborfixationFactor =  - 1;
                
        end
        
        for frame = 1: (stimulusTime * framerate)
            
            %             if frame == 1
            %                 % define the tractory of gabor movement
            %                 %         gaborLocation = CenterRectOnPointd(gaborrect, xCenter + gaborDistanceFromFixationPixel + ...
            %                 %             gaborMoveSpeedPixel, yCenter - gaborMoveSpeedPixel/ xgaborFactor);
            %                 %         cueLocation = CenterRectOnPointd(gaborrect, xCenter + gaborDistanceFromFixationPixel,  ...
            %                 %             yCenter - gaborMoveSpeedPixel * ycueFactor(trialNumber));
            %                 gaborLocation = CenterRectOnPointd(gaborrect, xCenter + gaborDistanceFromFixationPixel  ...
            %                     , yCenter);
            %             else
            %                 gaborLocation = CenterRectOnPointd(gaborrect, xCenter + gaborDistanceFromFixationPixel  ...
            %                     + xframe(frame), yCenter - yframe(frame));
            %                 cueLocation = CenterRectOnPointd(gaborrect, xCenter + gaborDistanceFromFixationPixel,  ...
            %                     yCenter - yframe(frame) + cueVerDisPix);
            %             end
            
            
            gaborLocation = CenterRectOnPointd(gaborrect, xCenter + gaborfixationFactor * gaborDistanceFromFixationPixel  ...
                + xframeFactor * xframe(frame), yCenter +  yframeFactor * yframe(frame));
            cueLocation = CenterRectOnPointd(gaborrect, xCenter + gaborfixationFactor * gaborDistanceFromFixationPixel,  ...
                yCenter + yframeFactor * yframe(frame) + cueVerDisPixFactor * cueVerDisPix);
            
            
            %----------------------------------------------------------------------
            %%%                         stimulus Recording
            %----------------------------------------------------------------------
            % recording
            %             open(vidObj);
            %             currFrame = Screen('GetImage', window);
            %             writeVideo(vidObj,currFrame);
            
            Screen('DrawTextures', window, gabortex, [], gaborLocation, orientation, [], [], [], [],...
                kPsychDontDoRotation, propertiesMatFirst');
            
            % Randomise the phase of the Gabors and make a properties matrix
            propertiesMatFirst(1) = propertiesMatFirst(1) + InternalDriftPhaseIncrPerFrame;
            
            
            % Draw fixation
            Screen('DrawDots', window,[xCenter  yCenter], 10, [255 255 255 255], [], 2);
            
            
            % Flip to the screen
            Screen('Flip',window);
            
            % Record the stimulus by frame
            mov = recdisplay(rec,mov,'record',window);
            
            
            gaborMoveSpeedPixel = gaborMoveSpeedPixel + 1;
        end
        
        
        
        Screen('DrawDots', window,[xCenter  yCenter], 10, [255 255 255 255], [], 2);
        Screen('Flip',window);
        
        
        intervalTimes = intervalTimesMatSingle(blockData(trial,2));
        WaitSecs(intervalTimes);
        % stimulus recording
        mov = recdisplay(rec,mov,'record',window,intervalTimes);
        
        Screen('DrawDots', window,[xCenter  yCenter], 10, [255 255 255 255], [], 2);
        
        % Draw the cue gabor
        Screen('DrawTextures', window, gabortex, [], cueLocation, orientation, [], [], [], [],...
            kPsychDontDoRotation, propertiesMatFirst');
        Screen('Flip',window);
        WaitSecs(cueShowTime);
        
        
        %----------------------------------------------------------------------
        %%%                         stimulus Recording
        %----------------------------------------------------------------------
        
        
        % Record the stimulus by frame
        mov = recdisplay(rec,mov,'record',window,cueShowTime);
        
        % Draw fixation after stimuli in buffer
        Screen('DrawDots', window,[xCenter   yCenter], 10, [255 255 255 255], [], 2);
        % refresh the screen draw the buffer
        t1 = Screen('Flip',window);
        
        %----------------------------------------------------------------------
        %%%                         stimulus Recording
        %----------------------------------------------------------------------
        
        % Record the stimulus by frame
        mov = recdisplay(rec,mov,'record',window,1);
        
        
        
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
                respToBeMade = false;
            elseif keyCode(rightKey)
                response = 0;
                respToBeMade = false;
            end
        end
        
        %         Record the response
        responseVector = [responseVector;response];
        TrialAll =  [TrialAll; trial];
        BlockAll =[BlockAll; block];
        conditionAll = [conditionAll;condition];
        intervalTimesVector = [intervalTimesVector;intervalTimes];
        WaitSecs(1);
        
        %----------------------------------------------------------------------
        %%%                         stimulus Recording
        %----------------------------------------------------------------------
        
        
        %         open(vidObj);
        %         currFrame = Screen('GetImage', window);
        %         writeVideo(vidObj,currFrame);
        %         imageArray = Screen('GetImage', window, [200 264 874 544]);
        %         imageArray = [imageArray; {Screen('GetImage', window, [200 264 874 544])}];
        
        %     end
        
        % Record the stimulus by frame
        mov = recdisplay(rec,mov,'finalize');
        RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector responseVector];
    end
    %----------------------------------------------------------------------
    %                      save parameters files
    %----------------------------------------------------------------------
    %     time = clock;
    %     RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector  responseVector];
    %     fileName = ['data/GaborDrift/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
    %     save(fileName,'RespMat','subIlluDegree','intervalTimesVector','InternalDriftCyclesPerSecond','gaborDistanceFromFixationDegree','gaborDimPix','viewingDistance','trialNumber','blockNumber');
    
end

toc;
% close(vidObj);

%----------------------------------------------------------------------
%                      save parameters files
%----------------------------------------------------------------------
time = clock;
fileName = ['data/GaborDrift/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
save(fileName,'RespMat','subIlluDegree','intervalTimesVector','InternalDriftCyclesPerSecond','gaborDistanceFromFixationDegree','gaborDimPix','viewingDistance','trialNumber','blockNumber');


%----------------------------------------------------------------------
%                       catch trial performance
%----------------------------------------------------------------------


% ct_correct = 0;
% for trial = 1: size(RespMat,1)
%     conditionResp(trial) = str2num(RespMat(trial,3));   
%     if conditionResp(trial) == 'catch_trial';    
%     ct_correct = ct_correct + RespMat(Index,5);
%     end
%     
% end
% proportion = ct_correct/(size(RespMat,1)/8)
%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;

fprintf(1,'\n\nThis part of the experiment took %.0f min.',(toc)/60);
fprintf(1,'\n\nOK!\n');
