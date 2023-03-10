% Computes the point after each transformation
%
% INPUT  - joints - angle of each joint
%          dimensions - structure of the manipulator
% OUTPUT - points - points after each transformation
function [points] = pose_points(dimensions, joints)
    points = zeros(7,3);
    T = eye(4);
    
    T0 = trans_matrix(0,0,dimensions(1),0,0,0);  
    T = T0*T;
    points(2,:) = (inv(T(1:3,1:3))*T(1:3,4))';
    
    T1 = trans_matrix(0,0,dimensions(2),0,0,joints(1));
    T = T1*T;
    points(3,:) = (inv(T(1:3,1:3))*T(1:3,4))';
    
    T2 = trans_matrix(0,0,dimensions(3),0,joints(2),0);
    T = T2*T;
    points(4,:) = (inv(T(1:3,1:3))*T(1:3,4))';

    T3 = trans_matrix(0,0,dimensions(4),0,joints(3),0);
    T = T3*T;
    points(5,:) = (inv(T(1:3,1:3))*T(1:3,4))';

    T4 = trans_matrix(0,0,dimensions(5),0,0,joints(4));
    T = T4*T;
    points(6,:) = (inv(T(1:3,1:3))*T(1:3,4))';
    
    T5 = trans_matrix(0,0,dimensions(6),0,joints(5),0);
    T = T5*T;
    points(7,:) = (inv(T(1:3,1:3))*T(1:3,4))';
    
    % Last transformation is not needed in this case because it only
    % determins the rotation 
end