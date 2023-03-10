clc
clear

% Dimenstions of the links
dimensions = [ 0.9 1.3 2.5 1.25 1.25 1];

% Color of the poses
color = [0 0.4470 0.7410;
            0.8500 0.3250 0.0980;
            0.9290 0.6940 0.1250;
            0.4940 0.1840 0.5560;
            0.4660 0.6740 0.1880;
            0.3010 0.7450 0.9330;];
        
% Start pose joint space
start_rotation = [-2.0298    0.3508    1.1189    1.3695    0.4692    1.7958];

% Intermidiary pose joint space
intermidiat_rotation = start_rotation;
intermidiat_rotation(1) = intermidiat_rotation(1) + pi/4;
intermidiat_rotation(2) = intermidiat_rotation(2) - 1;
intermidiat_rotation(3) = intermidiat_rotation(3) - pi/50;
intermidiat_rotation(3) = intermidiat_rotation(3) + 0.5;

% End pose joint space
end_rotation = start_rotation;
end_rotation(1) = end_rotation(1) + pi;
end_rotation(5) = end_rotation(5) - 0.5;

% Start pose coordinate frame
start_pose = dk(dimensions, start_rotation)

% Intermidiary pose coordinate frame
intermidiat_pose = dk(dimensions, intermidiat_rotation)

% End pose coordinate frame
end_pose = dk(dimensions, end_rotation)

% Start, middle and end quaternion
start_q = eul2quat([start_pose(6) start_pose(5) start_pose(4)]);
inter_q = eul2quat([intermidiat_pose(6) intermidiat_pose(5) intermidiat_pose(4)]);
end_q = eul2quat([end_pose(6) end_pose(5) end_pose(4)]);

qs = quaternion(start_q);
qm = quaternion(inter_q);
qe = quaternion(end_q);

% Computations needed to generate the circle trajectory
v1 = intermidiat_pose(1:3) - start_pose(1:3);
v2 = end_pose(1:3) - intermidiat_pose(1:3);

N = cross(v1, v2);
N = N/sqrt(sum(N.^2));

p12 = start_pose(1:3) - intermidiat_pose(1:3);
p21 = intermidiat_pose(1:3) - start_pose(1:3); 
p23 = intermidiat_pose(1:3) - end_pose(1:3);
p32 = end_pose(1:3) - intermidiat_pose(1:3);
p31 = end_pose(1:3) - start_pose(1:3);
p13 = start_pose(1:3) - end_pose(1:3);

a = sqrt(sum(p23.^2))^2/(2*(sqrt(sum(cross(p12, p23).^2)))^2)*dot(p12, p13);
b = sqrt(sum(p13.^2))^2/(2*(sqrt(sum(cross(p12, p23).^2)))^2)*dot(p21, p23);
c = sqrt(sum(p12.^2))^2/(2*(sqrt(sum(cross(p12, p23).^2)))^2)*dot(p31, p32);

C = a*start_pose(1:3) + b*intermidiat_pose(1:3) + c*end_pose(1:3);
r = sqrt(sum((start_pose(1:3) - C).^2));

E = C - end_pose(1:3);
I = C - intermidiat_pose(1:3);
U = C - start_pose(1:3);

U_I_angle = acos(sum(U.*I)/(sqrt(sum(U.^2))*sqrt(sum(I.^2))));
I_E_angle = acos(sum(I.*E)/(sqrt(sum(I.^2))*sqrt(sum(E.^2))));
U_E_angle = U_I_angle + I_E_angle;

U = U/sqrt(sum(U.^2));
V = cross(N, U);

tangent = cross(E, N);
norm_tangent = norm(tangent);
tangent = tangent/norm_tangent;

point = end_pose(1:3) + tangent.*1.1;

% Variable along the trajectory
t = pi;
step = 0.1;
alpha = pi/2;

%  Keeping track of each rotations
rotation_matrix = [];
tcp_matrix = [];

figure('NumberTitle', 'off', 'Name', 'Trajectory preview');
hold on
% Start point
plot3(start_pose(1), start_pose(2), start_pose(3), 'r*');
% Intermidiat point
plot3(intermidiat_pose(1), intermidiat_pose(2), intermidiat_pose(3), 'b*');
% End point
plot3(end_pose(1), end_pose(2), end_pose(3), 'm*');
% Center point
plot3(C(1),C(2),C(3), 'g*');
% Tangent point
plot3(point(1),point(2),point(3), 'y*');

while t < pi + U_E_angle
    q = slerp(qs,qe,(t-pi)/U_E_angle);

    tcp_rotation = quat2eul(q);
    
    P = C + r*cos(t)*U + r*sin(t)*V;
    
    tcp = [P tcp_rotation(3) tcp_rotation(2) tcp_rotation(1)];
    tcp_matrix = [tcp_matrix; tcp];
    
    rotations = ik(dimensions, tcp);
    rotation_matrix = [rotation_matrix; rotations];
    
    hold on
    plot3(P(1), P(2), P(3),"k*");
    plot_points(pose_points(dimensions, rotations),color);
    grid;
    hold off
    
    t = t + step;
end
hold off
grid;

% Trajectory preview
figure('NumberTitle', 'off', 'Name', 'Joint evolution');
hold on 
plot(rotation_matrix(:,1))
plot(rotation_matrix(:,2))
plot(rotation_matrix(:,3))
plot(rotation_matrix(:,4))
plot(rotation_matrix(:,5))
plot(rotation_matrix(:,6))
hold off
grid;
xlabel('steps')
ylabel('rad')
title('Joint evolution');
legend('j1','j2','j3','j4','j5','j6')

% Position and rotation evolution
figure('NumberTitle', 'off', 'Name', 'Position and rotation evolution');
hold on 
plot(tcp_matrix(:,1))
plot(tcp_matrix(:,2))
plot(tcp_matrix(:,3))
plot(tcp_matrix(:,4))
plot(tcp_matrix(:,5))
plot(tcp_matrix(:,6))
hold off
grid;
xlabel('steps')
ylabel('rad/cm')
title('Joint evolution');
legend('x','y','z','rx','ry','rz')
