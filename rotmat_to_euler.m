% Converts a rotations matrix in Euler angels
%
% INPUT  - R - rotation matrtix of the frames
%          j1, j2, j3 - angels of the first three joints (arm)
% OUTPUT - wrist_rotations  - angle of the last three joints (wrist)
function [wrist_rotations] = rotmat_to_euler(R, j1, j2 , j3)
    Ra = trans_matrix(0, 0, 0, 0, j3, 0) * trans_matrix(0, 0, 0, 0, j2, 0) * trans_matrix(0, 0, 0, 0, 0, j1);
    Rw = R * inv(Ra(1:3, 1:3));

    if(Rw(3,3) == 1 || Rw(3,3) == -1)
        j5 = atan2(sqrt(1-Rw(3,3)^2),Rw(3,3));
        
        % In practice this could be set to the current position of the
        % joint
        j4 = 0; 
        
        j6 = atan2(Rw(2,1),Rw(1,1));
    else
        j5 = atan2(sqrt(1-Rw(3,3)^2),Rw(3,3));
        
        j4 = atan2(Rw(3,2),-Rw(3,1));
        
        j6 = atan2(Rw(2,3),Rw(1,3));
    end

    % Return
    wrist_rotations = [j4 j5 j6];
end