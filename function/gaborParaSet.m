function gabor = gaborParaSet(window,screenXpixels,displaywidth,viewingDistance,framerate);

% set gabor parameters so use the same gabor in all the experiment
%----------------------------------------------------------------------
%                       Gabor information
%----------------------------------------------------------------------


% demo orientation = 0;   InternalDriftCyclesPerSecond = 3;
% gabor location from center in angle
% gabor.subIlluDegree = 48;
% gabor size from visual angle
% gabor.DimPix = 50;  % gabor size in pixels
% viewingDistance = 60; % subject distance to the screen
gabor.VisualAngle = 2;  % gabor visual angle
% screen_diagonal = sqrt(winRect(3).^2 + winRect(4).^2);
gabor.DimPix = round(deg2pix(gabor.VisualAngle,viewingDistance,screenXpixels,displaywidth));

% fixation move left 3 degree
gabor.fixationDegree = 3;
gabor.fixationPixel = round(deg2pix(gabor.fixationDegree,viewingDistance,screenXpixels,displaywidth));


% gabor location from center in angle
gabor.DistanceFromFixationDegree = 8;   % visual angle degree
gabor.DistanceFromFixationPixel = deg2pix(gabor.DistanceFromFixationDegree,viewingDistance,screenXpixels,displaywidth);  %

% internal motion of gabor drift speed  frame
gabor.InternalDriftCyclesPerSecond = 4; % 3 Hz  in lisi    0 in no illusion 4 in all the experiments
gabor.InternalDriftCyclesPerFrame = gabor.InternalDriftCyclesPerSecond * 360;
% InternalDriftPhaseIncrPerFrame = InternalDriftCyclesPerFrame/framerate; %degree per frame
% actual speed x = 1 framePerSec   y = x / xgaborFactor



% gaborExternalMotionDegreePerSec = 2;
% % gabor moving along a linear path of length:  in dva
% gaborExternalMotionLengthDegree = 2; % dva   trajactory is 3 degree of visual angle
% stimulusTime = gaborExternalMotionLengthDegree/gaborExternalMotionDegreePerSec;



% set texture parameters   Obvious parameters

gabor.contrast = 0.8;
gabor.aspectRatio = 1.0;
gabor.phase = 0;

% Spatial Frequency(Cycles Per Pixel)  gabor internal motion
% One Cycle = Grey-black-Grey-White-Grey i.e. One Black and One White Lobe
gabor.numCycles = 2;  % cycles of present gabor
gabor.freq = gabor.numCycles/gabor.DimPix; % per pixel how many cycles

% Sigma of Gussian
gabor.sigma = gabor.DimPix/7;

gabor.propertiesMatFirst = [gabor.phase, gabor.freq, gabor.sigma, gabor.contrast, gabor.aspectRatio, 0, 0, 0];

% Build a procedural gabor texture
gabor.backgroundOffset = [0.5 0.5 0.5 0.0];
gabor.disableNorm = 1;
gabor.preContrastMultiplier = 0.5;

[gabor.tex, gabor.rect] = CreateProceduralGabor(window, gabor.DimPix, gabor.DimPix, [],...
    gabor.backgroundOffset, gabor.disableNorm, gabor.preContrastMultiplier);

% gabor moving path length
gabor.pathLengthDegree = 3; % dva
gabor.pathLengthPixel = deg2pix(gabor.pathLengthDegree,viewingDistance,screenXpixels,displaywidth);
gabor.stimulusTime = gabor.pathLengthPixel/framerate; %1;   % length is 1 * 60 frame  60 pixel
% stimulusTime = 1;




% gabor moving speed
gabor.Speed = 2; % dva/sec
gabor.SpeedPixels = deg2pix(gabor.Speed,viewingDistance,screenXpixels,displaywidth);
gabor.SpeedFrame = gabor.SpeedPixels/framerate;

end