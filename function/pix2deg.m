% converts pixels into visual angle 'deg'
function degree = pix2deg(pix,viewingDist,screenXpixels,displaywidth)
if ~exist('viewingDist', 'var') || isempty(viewingDist)
    viewingDist = 60;
end
objS = 0.1 * displaywidth * (pix/screenXpixels);
degree = 2 * atand((objS/2)/viewingDist);
end


% function degree = pix2deg(pix,conv)
% objS = 0.1 * conv.width * (pix/conv.screenXpixels);
% degree = 2 * atand((objS/2)/conv.viewingDist);
% end

