% Plotes in 3D space the pose of the manipulator
%
% INPUT  - points - points of each link in space
%          color - color of each link
function [] = plot_points(points, color)
    hold on;
    for j=2:length(points)
        line([points(j-1,1) points(j,1)],[points(j-1,2) points(j,2)],[points(j-1,3) points(j,3)],'Color',color(j-1,:));
    end
    hold off;
    xlabel('x')
    ylabel('y')
    zlabel('z')
    view(3);
    title('Pose')
    axis([-8 8 -8 8 0 8]);
    grid;
end