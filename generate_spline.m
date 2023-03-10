% Generates points on the spline that passes through the ALL the given points 
%
% INPUT  - path_points - points through which the splien to pass through
% OUTPUT - points - points on the spline
function [points] = generate_spline(path_points)
    [no_points, c] = size(path_points);

    if mod(no_points,2) ~= 0
        middle_point = (path_points(int16(no_points/2+1),:)+path_points(int16(no_points/2),:))./2;
        path_points = [path_points(1:no_points/2+1,:); middle_point; path_points(no_points/2+1:end,:)]
    end

    [no_points, c] = size(path_points);

    first_half_path = path_points(1:no_points/2+1,:)
    second_half_path = path_points(no_points/2:end,:)

    spline_points_first = [];
    spline_points_first = [spline_points_first; generate_path_length(first_half_path)];

    second_half_path = flipud(second_half_path);

    spline_points_second = [];
    spline_points_second = [generate_path_length(second_half_path); spline_points_second];

    control_points = generate_control_points(first_half_path(end-1,:),0,0,0,first_half_path(end,:));
    spline_points_first = [spline_points_first; generate_spline_points(control_points)];

    points = [spline_points_first; flip(spline_points_second)];
end
