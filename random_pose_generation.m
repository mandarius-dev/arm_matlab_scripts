clc
clear

% Physical limitations of the joints
joint_limits = [   -pi pi;
                 -pi/2 pi/2;
                 -2.57 2.57;
                   -pi pi;
                 -pi/2 pi/2;
                   -pi pi];

% Dimensions of the manipulator
dimensions = [ 0.9 1.3 2.5 1.25 1.25 1];
               
% Set of colors for the pose plot
color_dk = [0 0.4470 0.7410;
            0.8500 0.3250 0.0980;
            0.9290 0.6940 0.1250;
            0.4940 0.1840 0.5560;
            0.4660 0.6740 0.1880;
            0.3010 0.7450 0.9330;];
color_ik = [0 1 0;
            0 0 1;
            0 1 1;
            1 0 1;
            1 1 0;
            0 0 0];

% Number of poses to be generated
number_tests = 10;
% Sum of the errors for position and rotation
error_sum = zeros(1,length(joint_limits));
% Number of valid testes
valid_tests = 0;

% Control variable to show the valid poses
show_poses = 1;

% Do not show the poses if the test number is to big
if(number_tests > 50 && show_poses == 1)
    show_poses = 0;
end

% Generate the random poses
for i=1:number_tests
    % Random rotation between given limits
    rotations = zeros(1, length(joint_limits));
    for j=1:length(joint_limits)
        rot = (joint_limits(j,2) - joint_limits(j,1)) * rand(1,1) + joint_limits(j,1);
        rotations(j) = rot;
    end
    
    % Get the point in 3D space from the rotations 
    tcp = dk(dimensions, rotations);

    % Above ground level
    if tcp(3) >= 0
        valid_tests = valid_tests + 1;
        joints = ik(dimensions, tcp);

        points = pose_points(dimensions, rotations);
        points_ik = pose_points(dimensions, joints);
        
        aux_tcp  = dk(dimensions, joints);
        results = [[i 0 0 0 0 0]; rotations; joints; tcp; aux_tcp; tcp - aux_tcp];

        error_sum = error_sum + (tcp-aux_tcp).^2;
           
        if(show_poses)
            f = figure('NumberTitle','off','Name', ['Test: ', num2str(i)]);
            hold on;
            plot_points(points, color_dk);
            plot_points(points_ik, color_ik);
            grid;
            hold off;
        end
    end
end

% Mean square error
error_sum = error_sum ./ valid_tests;

% Bar graph to show the mean square error for each coordinate and orientation
figure('NumberTitle', 'off', 'Name', ['Number of valid tests: ', num2str(valid_tests)]);
x = categorical({'x', 'y', 'z', 'rx', 'ry', 'rz'});
bar(x, log(error_sum));
title('Mean square error of position and orientation in logaritmic scale');
grid;