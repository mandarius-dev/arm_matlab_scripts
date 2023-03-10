% Direct kinematics of a 6 DOF manipulator
%
% INPUT  - dimensions - structure of the manipulator
%          rotations  - angle of each joint
% OUTPUT - tcp - final position and rotations of the TCP  
function [tcp] = dk(dimentions, rotations)
    % Used for extracting last column
    init = [0 0 0 1]';
    
    % Translation and ratations matrixes
    T0 = trans_matrix(0,0,dimentions(1),0,0,0);
    T1 = trans_matrix(0,0,dimentions(2),0,0,rotations(1));
    T2 = trans_matrix(0,0,dimentions(3),0,rotations(2),0);
    T3 = trans_matrix(0,0,dimentions(4),0,rotations(3),0);
    T4 = trans_matrix(0,0,dimentions(5),0,0,rotations(4));
    T5 = trans_matrix(0,0,dimentions(6),0,rotations(5),0);
    T6 = trans_matrix(0,0,0,0,0,rotations(6));

    % Rotation matrix
    R = T6(1:3,1:3)*T5(1:3,1:3)*T4(1:3,1:3)*T3(1:3,1:3)*T2(1:3,1:3)*T1(1:3,1:3)*T0(1:3,1:3);

    % Initial position without rotation
    initial_position = T6*T5*T4*T3*T2*T1*T0*init;

    % Final position of TCP
    position = inv(R)*initial_position(1:3);
    
    % Rotation of TCP
    if(R(3,1) ~= -1 && R(3,1) ~= 1)
        y = -asin(R(3,1));
        x = atan2(R(3,2)/cos(y),R(3,3)/cos(y));
        z = atan2(R(2,1)/cos(y),R(1,1)/cos(y));
    else
        z = 0;
        if(R(3,1) == -1)
            y = pi/2;
            x = atan2(R(1,2),R(1,3));
        else
            y = -pi/2;
            x = atan2(-R(1,2),-R(1,3));
        end
    end
    
    % Return
    tcp = [position(1:3)' [x y z]];
end
