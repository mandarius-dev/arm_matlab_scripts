% Creates a report from rog basg
clc
clear 

bag = rosbag('circle_path_5.bag');

gaz_pose = select(bag, 'Topic', '/gazebo/arm_scale_link_6');
gaz_pose_data = readMessages(gaz_pose, 'DataFormat', 'struct');

gen_pose = select(bag, 'Topic', '/current_pose');
gen_pose_data = readMessages(gen_pose, 'DataFormat', 'struct');

gen_pose_data_position = [];
gaz_pose_data_position = [];

for i=1:length(gen_pose_data)
    gen_pose_data_position = [gen_pose_data_position; gen_pose_data{i,1}.Position];
    gaz_pose_data_position = [gaz_pose_data_position; gaz_pose_data{i,1}.Position];
end

gen_pose_vec = [];
gaz_pose_vec = [];

for i=1:length(gen_pose_data)
    gen_pose_vec = [gen_pose_vec; [gen_pose_data_position(i).X gen_pose_data_position(i).Y gen_pose_data_position(i).Z]];
    gaz_pose_vec = [gaz_pose_vec; [gaz_pose_data_position(i).X gaz_pose_data_position(i).Y gaz_pose_data_position(i).Z]];
end

% For bags that has unwanted data at the end
gen_pose_vec(end-10:end,:) = [];
gaz_pose_vec(end-10:end,:) = [];

gen_pose_data_orientation = [];
gaz_pose_data_orientation = [];

for i=1:length(gen_pose_data)
    gen_pose_data_orientation = [gen_pose_data_orientation; gen_pose_data{i,1}.Orientation];
    gaz_pose_data_orientation = [gaz_pose_data_orientation; gaz_pose_data{i,1}.Orientation];
end

gen_orien_vec = [];
gaz_orien_vec = [];

for i=1:length(gen_pose_data)
    gen_orien_vec = [gen_orien_vec; [gen_pose_data_orientation(i).X gen_pose_data_orientation(i).Y gen_pose_data_orientation(i).Z]];
    gaz_orien_vec = [gaz_orien_vec; [gaz_pose_data_orientation(i).X gaz_pose_data_orientation(i).Y gaz_pose_data_orientation(i).Z gaz_pose_data_orientation(i).W]];
end

for i=1:length(gen_pose_data)
    gaz_orien_vec(i,1:3) = quat2eul(gaz_orien_vec(i,:));
end
gaz_orien_vec(:,4) = [];

x = immse(gen_pose_vec(:,1), gaz_pose_vec(:,1));
y = immse(gen_pose_vec(:,2), gaz_pose_vec(:,2));
z = immse(gen_pose_vec(:,3), gaz_pose_vec(:,3)-0.06);

mse = [x y z]

rx = immse(gen_orien_vec(:,1), gaz_orien_vec(:,1));
ry = immse(gen_orien_vec(:,2), gaz_orien_vec(:,2));
rz = immse(gen_orien_vec(:,3), gaz_orien_vec(:,3));

figure
subplot(2,2,1)
hold on
plot(gen_pose_vec(:,1))
plot(gaz_pose_vec(:,1),'--')
hold off
title('X', num2str(x,2))
legend('Generated path', 'Gazebo path', 'Location', 'best')
grid

subplot(2,2,2)
hold on
plot(gen_pose_vec(:,2))
plot(gaz_pose_vec(:,2),'--')
hold off
title('Y', num2str(y,2))
legend('Generated path', 'Gazebo path', 'Location', 'best')
grid

subplot(2,2,3)
hold on
plot(gen_pose_vec(:,3))
plot(gaz_pose_vec(:,3)-0.06,'--')
hold off
title('Z', num2str(z,2))
legend('Generated path', 'Gazebo path', 'Location', 'best')
grid

subplot(2,2,4)
hold on
plot3(gen_pose_vec(:,1), gen_pose_vec(:,2), gen_pose_vec(:,3),'b*')
plot3(gaz_pose_vec(:,1), gaz_pose_vec(:,2), gaz_pose_vec(:,3)-0.6,'r+')
hold off
view(3);
axis([-8 8 -8 8 0 8]);
grid
title('Points in space')
legend('Genrated path', 'Gazebo path', 'Location', 'best')