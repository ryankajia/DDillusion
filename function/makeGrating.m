
function [Grating_Matrix] = makeGrating(grating_dia,freq)

grating_dia = 100;  
contrast = 0.4 ;
sat = 0.1 ; %  saturation 
mean = 1;
freq = 0.4;
degree=0.45;
[x,y] = meshgrid(-grating_dia/2:grating_dia/2,-grating_dia/2:grating_dia/2);
r = sqrt(x.^2+y.^2);
mask = r<grating_dia/2;
gray(:,:,1) = (1-mask)*.5;
gray(:,:,2)=gray(:,:,1);
gray(:,:,3)=gray(:,:,1);
grating = zeros(size(x,1),size(x,2),3);
gray_inside(:,:,1) = mask*sat;
gray_inside(:,:,2)=gray_inside(:,:,1);
gray_inside(:,:,3)=gray_inside(:,:,1);
grating(:,:,1) = (mean+contrast*sin(freq*r)/2);%.*mask;
grating(:,:,1) = (grating(:,:,1) - min(min(min(grating(:,:,1))))).*mask;
grating = grating+gray_inside+gray;
Grating_Matrix = uint8(grating*255);

end
