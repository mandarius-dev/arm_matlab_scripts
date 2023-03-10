% Inverse kinematics of a 6 DOF manipulator
%
% INPUT  - dimensions - structure of the manipulator
%          tcp - final position and rotations of the TCP  
% OUTPUT - rotations  - angle of each joint
function [rotations] = ik(dimensions, tcp)
    % Threshold to force a solution of the joint 2
    % If the position of the TCP is to close to the body only one solution
    % is valid
    tolerance_waist = 2.2;
    
    % Dimension of link 2
    l2 = dimensions(3);
    
    % Dimension of link 3 and 4
    l3 = dimensions(4) + dimensions(5);
    
    % Distance from ground to the second joint
    b_2 = dimensions(1) + dimensions(2);
    
    % Dimension of link 6
    l6 = dimensions(6);
   
    % Position of TCP
    px = tcp(1);
    py = tcp(2);
    pz = tcp(3);
    
    % Rotations of TCP
    x = tcp(4);
    y = tcp(5);
    z = tcp(6);

    % Rotation matrix of the transformation
    R = trans_matrix(0,0,0,0,0,z)*trans_matrix(0,0,0,0,y,0)*trans_matrix(0,0,0,x,0,0);
    R_inv = inv(R(1:3,1:3));
    R = R(1:3,1:3);

    % Wrist point
    wx = px - l6*R_inv(1,3);
    wy = py - l6*R_inv(2,3);
    wz = pz - l6*R_inv(3,3);

    % Distance to wrist point (horizontal)
    d_w = sqrt(wx^2+wy^2);
    % Height to wrist point (vertical)
    h_w = abs(wz-b_2);

    % Distance from origin(joint 2) to wrist point
    l = sqrt(d_w^2+h_w^2);

    % Computation of the first three joints (position)
    if(wx == 0 && wy == 0)
        j1 = 0;
        j2 = 0;
        j3 = 0;
    else
        j1 = atan2(wy,wx);
        
        if j1 < 0
            j1 = -pi - j1;
        else
            j1 = -pi - j1;
        end
 
        if(l2+l3 <= l)
            j3 = 0;
            alpha = acos(((l2+l3)^2+d_w^2-h_w^2)/(2*(l2+l3)*d_w));
            j2 = pi/2 - alpha;
        else
            alpha = acos((l^2+d_w^2-h_w^2)/(2*l*d_w));
            beta = acos((l2^2+l^2-l3^2)/(2*l2*l));

            alpha3 = acos((l2^2+l3^2-l^2)/(2*l2*l3));

            if(alpha + beta == pi/2)
                j2 = 0;
                j3 = pi - alpha3;
            else
                if(alpha == beta)
                    j2 = pi/2;
                    j3 = -pi + alpha3;
                else
                    j3 = pi - alpha3;
                    j2 = pi/2 - alpha - beta;
                    if wz < tolerance_waist 
                        j2 = pi/2 - alpha + beta;
                    end
                end
            end
        end
    end
    
    if(j2 > pi/2)
        j2 = pi-j2;
    end

    if(j1 == 0)
        j2 = -sign_joint(px,py)*j2;
    end

    if(j2 == 0 && j1 == 0)
        j3 = -sign_joint(px,py)*j3;
    end
    
    % Computations of the last three joints (rotation)
    wrist = rotmat_to_euler(R, j1, j2, j3);
    
    if(j3 == 0 && j2 == 0 && j1 == 0)
        wrist(3) = -sign_joint(px,py)*wrist(3);
    end

    % Return
    rotations = [j1 j2 j3 wrist];
end