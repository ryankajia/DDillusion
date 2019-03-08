%% conversions
% converts visual angle 'deg' to pixels
% function [ouput1, output2] = my_function(input1,input2)
% ----------------------------------------------------------------------
% [ouput1, output2] = my_function(input1,input2)
% ---------------------------------------------------------------------
% Goal of the function:
% Explain here what the function actually does.
% ----------------------------------------------------------------------
% Input(s):
% input1: explain what is the first input and give an example.
% input2: explain what is the second input and give an example.
% ----------------------------------------------------------------------
% Output(s):
% output1: explain what is the first output and give an example.
% output2: explain what is the second output and give an example.
% ----------------------------------------------------------------------
% Function created by Xxxx Xxxxx (xx.xx@xx.com)
% Last update: XX / XX / 20XX
% Project: title of the project using this code
% Version: number of the version of the function
% ----------------------------------------------------------------------

    function pixels = deg2pix(deg,viewingDist,screenXpixels,displaywidth);  %[width, ~] = Screen('DisplaySize', screenNumber);
        if ~exist('viewingDist', 'var') || isempty(viewingDist)
            viewingDist = 60;
        end
        pixels = viewingDist*tan(deg*pi/180)/(displaywidth/(10*screenXpixels));
    end


%%% Marven function
%    function pixels = deg2pix(deg,conv)
%         pixels = conv.viewingDist*tan(deg*pi/180)/...
%             (conv.width/(10*conv.screenXpixels));
%     end