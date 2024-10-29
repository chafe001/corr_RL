function [xPos, yPos] = xPairs_findStimXY(params, indx)

ang = 2*pi/params.stimArraySize;  % angle between stimuli in radians

theta = (indx - 1) * ang;
xPos = cos(theta) * params.arrayRadius;
if abs(xPos) < 1e-6
   xPos = 0;
end

yPos = sin(theta) * params.arrayRadius;
if abs(yPos) < 1e-6
   yPos = 0;
end

bob = 1;

end