%  make a gaussian Dot
 

function     [dstRects,flash] = gaussianDot(dotSizePix,gaussDim,dotXpos,dotYpos,grey,white)


% Set the color of our dot to full green. Color is defined by red green
% and blue components (RGB). So we have three numbers which
% define our RGB values. The maximum number for each is 1 and the minimum
% 0. So, "full red" is [1 0 0]. "Full green" [0 1 0] and "full blue" [0 0
% 1]. Play around with these numbers and see the result.
% dotColor = [0 1 0];

% Determine a random X and Y position for our dot. NOTE: As dot position is
% randomised each time you run the script the output picture will show the
% dot in a different position. Similarly, when you run the script the
% position of the dot will be randomised each time. NOTE also, that if the
% dot is drawn at the edge of the screen some of it might not be visible.
% dotXpos = rand * screenXpixels;
% dotYpos = rand * screenYpixels;
% 
% 
% 

% 
% 
% % Make a gaussian aperture with the "alpha" channel

gaussSigma = gaussDim / 5;  %  standard deviation  big  3  middle 4  small 5
[xm, ym] = meshgrid(-gaussDim:gaussDim, -gaussDim:gaussDim);
% more in the center number more big means more white
gauss = exp(-(((xm .^2) + (ym .^2)) ./ (2 * gaussSigma^2)));   
r = sqrt(xm.^2+ym.^2);
mask = r < (dotSizePix /2);% mask in circle is 1, ouside cicle is 0


[s1, s2] = size(gauss);
% make channel 1  R channel  0.5    
flash = ones(s1, s2, 4) * grey;
% mask(:, :, 2) = white * (1 - gauss) * mask ;
flash(:,:,1) = 0; 
flash(:,:,3) = 0; 
% make channel 2  G channel  blured
flash(:, :, 2) = 0.9;  % (1 - gauss) means more to side number is more big 
flash(:,:,4) = white * gauss .* mask; 
% masktex = Screen('MakeTexture', window, flash);

dstRects = CenterRectOnPointd([0 0 s1, s2], dotXpos, dotYpos);

end

