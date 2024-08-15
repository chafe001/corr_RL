function [xPos, yPos] = xPairs_findChoiceXY(params, indx)

switch indx

    case 1 
        xPos = params.choice1_x;
        yPos = params.choice1_y;

    case 2
        xPos = params.choice2_x;
        yPos = params.choice2_y;

    otherwise
        error('unknown indx in xPairs_findChoiceXY')
end


bob = 1;

end