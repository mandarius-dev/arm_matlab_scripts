% Homogenous transformation matrix with a given rotation and a given translation
%
% INPUT  - x, y, z - translation for x, y, z axis
%          rx, ry, rz - rotation for x, y, z axis
% OUTPUT - TR - homogenous transformation matrix
function [TR] = trans_matrix(x, y, z, rx, ry, rz)
    % Rotation around x
    Rx = [1 0      0;
          0 cos(rx) -sin(rx);
          0 sin(rx) cos(rx)];
    
    % Rotation around y
    Ry = [ cos(ry) 0 sin(ry);
           0      1 0;
          -sin(ry) 0 cos(ry)];
    
    % Rotation around z
    Rz = [cos(rz) -sin(rz) 0;
          sin(rz) cos(rz)  0;
          0      0       1];
    
    R = Rz*Ry*Rx;
    T = [x;y;z];
    
    % Return
    TR = [R T;[0 0 0 1]];
end