%% my first gabor drift


%% clear the workspace
close all;
clearvars;
sca;
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
winSize = [0 0 924 668];   %[0 0 1024 768]


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

%----------------------------------------------------------------------
%                       Gabor information
%----------------------------------------------------------------------
% gabor size from visual angle
gaborDimPix = 50;  % gabor size in pixels
viewingDistance = 60; % subject distance to the screen
% gaborVisualAngle = 2;  % gabor visual angle
% screen_diagonal = sqrt(winRect(3).^2 + winRect(4).^2);
% gaborDimPix= visual_angle2pixel(gaborVisualAngle, screen_diagonal, viewingDistance, screenNumber);
% gaborDimPix = deg2pix(gaborVisualAngle,viewingDistance,screenXpixels,displaywidth);

% set individual parameter : physical and perceived angle
subIlluDegree = 45;
% xfactor gaborMoveSpeedPixel  in x axis   of gabor
% xgaborFactor = tan(subIlluDegree * pi/360);
% trajactary  xframe/yframe = tan(IllusionDegree)
yframe = [1:200];
xframe = yframe * tan(subIlluDegree*pi/360);


% % xfactor gaborMoveSpeedPixel  in x axis   of patch cue  it's in the middle of perceived gabor and physical gabor
% xcueFactor = xgaborFactor/2;

% gabor location from center in angle
gaborDistanceFromFixationDegree = 8;   % visual angle degree
gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegree,viewingDistance,screenXpixels,displaywidth);  %
% gaborDistanceFromFixation = visual_angle2pixel(gaborDistanceFromFixationDegree, screen_diagonal, viewingDistance, screenNumber);

% internal motion of gabor drift speed  frame
InternalDriftCyclesPerSecond = - 3; % 3 Hz  in lisi
InternalDriftCyclesPerFrame = InternalDriftCyclesPerSecond * 360;
InternalDriftPhaseIncrPerFrame = InternalDriftCyclesPerFrame/framerate; %degree per frame
% actual speed x = 1 framePerSec   y = x / xgaborFactor



% gaborExternalMotionDegreePerSec = 2;
% % gabor moving along a linear path of length:  in dva
% gaborExternalMotionLengthDegree = 2; % dva   trajactory is 3 degree of visual angle
% stimulusTime = gaborExternalMotionLengthDegree/gaborExternalMotionDegreePerSec;



% set texture parameters   Obvious parameters
orientation = 0;
contrast = 0.8;
aspectRatio = 1.0;
phase = 50;

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
subject_name = 'test';
trialNumber = 49;


% interval time between cue and gabor
intervalTimesMatSingle = [50 100 150 200 250 300 350]* 0.001;   % intervalTime second
intervalTimesMat = repmat(intervalTimesMatSingle,1,trialNumber/7);
intervalTimesIndex = randperm(length(intervalTimesMat));

responseVector = zeros(1, trialNumber);
% Make a vector to record the interval time for each trial
intervalTimesVector = zeros(1, trialNumber);
stimulusTime = 1;


%----------------------------------------------------------------------
%%%                         cue parameter
%----------------------------------------------------------------------
ycueFactor = 2 * rand(1,trialNumber); % yCueDistance scale of gabor distance

cueShowTime = 0.2;
% Make a vector to record the response for each trial
cueVerDisDegree =  0.5;  % negtive number means higher;   positive number means lower
cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);


%----------------------------------------------------------------------
%%%                         stimulus Recording
%----------------------------------------------------------------------

% %     % Recording by frame
%     vidObj = VideoWriter('garbordrift.avi');
%     vidObj.FrameRate = 60;



%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------


for trial = 1: trialNumber
    
    gaborMoveSpeedPixel = 1; % gabor move speed(pixal) per frame in x axis
    % in y axis - gaborMoveSpeedPixel / xgaborFactor
    
    %     % external motion of speed : gabor move liner path of length in degree of visual angle
    %     gaborExternalMotionDegreePerSec = 2;  % 2dva/sec external motion in Lisi
    %     gaborExternalMotionDegreePerFrame = gaborExternalMotionDegreePerSec/framerate;
    %     gaborExternalMotionPixelPerFrame = deg2pix(gaborExternalMotionDegreePerFrame,viewingDistance,screenXpixels,displaywidth);
    
    % If this is the first trial we present a start screen and wait for a
    % key-press
    if trial == 1
        DrawFormattedText(window, 'Press Any Key To Begin', 'center', 'center', blackcolor);
        Screen('Flip', window);
        KbStrokeWait;
    end
    
    
    for frame = 1: (stimulusTime * framerate)
        
        
        % define the tractory of gabor movement
        %         gaborLocation = CenterRectOnPointd(gaborrect, xCenter + gaborDistanceFromFixationPixel + ...
        %             gaborMoveSpeedPixel, yCenter - gaborMoveSpeedPixel/ xgaborFactor);
        %         cueLocation = CenterRectOnPointd(gaborrect, xCenter + gaborDistanceFromFixationPixel,  ...
        %             yCenter - gaborMoveSpeedPixel * ycueFactor(trialNumber));
        gaborLocation = CenterRectOnPointd(gaborrect, xCenter + gaborDistanceFromFixationPixel + ...
            xframe(frame), yCenter - yframe(frame));
        cueLocation = CenterRectOnPointd(gaborrect, xCenter + gaborDistanceFromFixationPixel,  ...
            yCenter - yframe(frame) + cueVerDisPix);
        
        Screen('DrawTextures', window, gabortex, [], gaborLocation, orientation, [], [], [], [],...
            kPsychDontDoRotation, propertiesMatFirst');
        
        % Randomise the phase of the Gabors and make a properties matrix
        propertiesMatFirst(1) = propertiesMatFirst(1) + InternalDriftPhaseIncrPerFrame;
        
        
        % Draw fixation
        Screen('DrawDots', window,[xCenter yCenter], 10, [255 255 255 255], [], 2);
        
        
        % Flip to the screen
        Screen('Flip',window);
        
        %----------------------------------------------------------------------
        %%%                         stimulus Recording
        %----------------------------------------------------------------------
%         %             % recording
%                     open(vidObj);
%                     currFrame = Screen('GetImage', window);
%                     writeVideo(vidObj,currFrame);
%         
        gaborMoveSpeedPixel = gaborMoveSpeedPixel + 1;
    end
    Screen('DrawDots', window,[xCenter yCenter], 10, [255 255 255 255], [], 2);
    Screen('Flip',window);
    
    % the interval time between
    intervalTimes = intervalTimesMat(intervalTimesIndex(trial));
    WaitSecs(intervalTimes);
    Screen('DrawDots', window,[xCenter yCenter], 10, [255 255 255 255], [], 2);
    
    % Draw the gabor
    Screen('DrawTextures', window, gabortex, [], cueLocation, orientation, [], [], [], [],...
        kPsychDontDoRotation, propertiesMatFirst');
    Screen('Flip',window);
    WaitSecs(cueShowTime);
    
    %----------------------------------------------------------------------
    %%%                         stimulus Recording
    %----------------------------------------------------------------------
    %             % recording
%                 open(vidObj);
%                 currFrame = Screen('GetImage', window);
%                 writeVideo(vidObj,currFrame);
%                 imageArray = Screen('GetImage', window, [200 264 874 544]);
%                 imageArray = [imageArray; {Screen('GetImage', window, [200 264 874 544])}];
    
    
    % Draw fixation after stimuli in buffer
    Screen('DrawDots', window,[xCenter yCenter], 10, [255 255 255 255], [], 2);
    % refresh the screen draw the buffer
    Screen('Flip',window);
    
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
    
    % Record the response
    responseVector(trial) = responseVector(trial) + response;
    TrialAll(trial) =  trial;
    intervalTimesVector(trial) = intervalTimes;
    WaitSecs(1);
end

%     close(vidObj);
% cueDistance = sqrt((gaborMovePhaseIncrPerFrame * (ycueFactor - 1)).^2 + (gaborMovePhaseIncrPerFrame * xgaborFactor).^2);

time = clock;
RespMat = [TrialAll; intervalTimesVector; responseVector]';
fileName = ['data/GaborDrift/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
save(fileName,'RespMat','trialNumber','InternalDriftCyclesPerSecond','gaborDistanceFromFixationDegree','gaborDimPix','viewingDistance','trialNumber');



%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;