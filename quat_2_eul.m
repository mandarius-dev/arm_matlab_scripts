% Transforms quaternions into Euler angels 
%
% INPUT  - q - vector with the values [i j k w]
% OUTPUT - angels - Euler angelsz
function [angels] = quat_2_eul(q)
    angels = zeros(1,3);

    qx = q(1);
    qy = q(2);
    qz = q(3);
    qw = q(4);
    
    angels(3) = atan2(2*(qx*qy+qw*qz), qw^2+qx^2-qy^2-qz^2);
    angels(2) = asin(-2*(qx*qz-qw*qy));
    angels(1) = atan2(2*(qy*qz+qw*qx), qw^2-qx^2-qy^2+qz^2);
end