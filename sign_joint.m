% Returns the sign of the the inputs 
% Only used in edge cases
%
% INPUT  - a, b - variables from which the sign is determine
% OUTPUT - sign_j  - sign determin
function [sign_j] = sign_joint(a, b)
    if(a ~= 0 && b ~= 0)
        sign_j = sign(a)*sign(b);
        return
    end

    if(a ~= 0 && b == 0)
        sign_j = sign(a);
        return;
    end

    if(a == 0 && b ~= 0)
        sign_j = sign(b);
        return;
    end
    
    if(a == 0 && b == 0)
        sign_j = 1;
        return;
    end
end