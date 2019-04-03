% find the center of a rectangle
% location is a matrix with 4 numbers 

function [x,y] = findcenter(location)
    x = (location(1) + location(3))/2;
    y = (location(2) + location(4))/2;
end