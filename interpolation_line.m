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
        
% Start and end pose in coordinate space
start_pose = [1.4829   -4.9999    4.0999   -1.5708   -0.0001    1.5708];
end_pose = [-3.5886   -3.7842    4.0999   -1.5708    1.0471    1.5708];

% Start and end quaternions
start_q = eul2quat([start_pose(6) start_pose(5) start_pose(4)]);
end_q = eul2quat([end_pose(6) end_pose(5) end_pose(4)]);

qs = quaternion(start_q);
qe = quaternion(end_q);

% Variable along the trajectory
t = 0;
% Delta between two points on the trajectory
step = 0.1;

%  Keeping track of each rotations
index = 1;
rotation_matrix = zeros(1/step,6);

% Extended point of the givem trajectory
line_v = end_pose(1:3) - start_pose(1:3);
line_v = line_v/norm(line_v);
tan_point = end_pose(1:3) + 1.5.*line_v;

% Plot trajectory preview
figure('NumberTitle', 'off', 'Name', 'Trajectory preview');
hold on;
plot3(tan_point(1),tan_point(2),tan_point(3),'y*');
while (t <= 1)
    q = slerp(qs,qe,t);
    [m, i, j, k] = parts(q);
    tcp_rotation = quat_2_eul([i, j, k, m]);
    
    x = (1 - t)*start_pose(1) + t*end_pose(1);
    y = (1 - t)*start_pose(2) + t*end_pose(2);
    z = (1 - t)*start_pose(3) + t*end_pose(3);
    
    tcp = [x y z tcp_rotation(1) tcp_rotation(2) tcp_rotation(3)];
    
    rotations = ik(dimensions, tcp);
    rotation_matrix(index,:) = rotations;
    
    hold on
    plot3(x, y, z,"k*");
    plot_points(pose_points(dimensions, rotations),color);
    hold off
    
    t = t + step;
    index = index + 1;
end
hold off;

% Plot joint evolution
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
