% make a circle grating
function [gaussring] = grating_circle(dotSizePix,gaussDim,ringRadius);

ringRadius = 50;
dotSizePix = 1000;
gaussDim = 300;

[ncols, nrows] = meshgrid(1:dotSizePix, 1:dotSizePix);
centerx = dotSizePix/2;
centery = dotSizePix/2;

gaussSigma = gaussDim / 6;
gaussring = zeros(dotSizePix,dotSizePix);
% r = sqrt(dotSizePix.^2+dotSizePix.^2);
% mask = r < (dotSizePix /2);% mask in circle is 1, ouside cicle is 0
for i=1:ringRadius
    iR = i;
    oR = i+gaussSigma;
    array2D = (nrows - centery).^2 + (ncols - centerx).^2;
    % oval
    % ringPixels = array2D >= iR^2 & array2D <= oR^2;
    % circle
    ringPixels = array2D >= iR^2 & array2D <= oR^2;
    gaussring = gaussring + ringPixels.*(1/(gaussSigma*sqrt(2*pi)))*exp(-((iR-gaussDim)/(2*gaussSigma))^2);
    
end


figure(1);
surf(gaussring);
axis tight;
shading interp;
% shading flat;
view(2);
colormap('gray');
end