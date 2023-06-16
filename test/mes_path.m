% Simple MSE of test results
clc

full_path = [0.1416    0.0631    0.0783;
             0.1376    0.0586    0.0783;
             0.1534    0.0725    0.0789;
             0.1513    0.0671    0.0785;
             0.1454    0.0672    0.0790];
         
line_path = [0.1036    0.0946    0.0941;
             0.0992    0.0944    0.0925;
             0.1145    0.1117    0.0915;
             0.1036    0.1010    0.0925;
             0.0793    0.0761    0.0944];
         
spline_path = [0.1091    0.1319    0.0858;
               0.0891    0.1084    0.0857;
               0.1002    0.1231    0.0854;
               0.0708    0.0854    0.0876;
               0.0960    0.1174    0.0855];
           
circle_path = [0.1134    0.0958    0.0881;
               0.1263    0.1092    0.0868;
               0.1175    0.0993    0.0875;
               0.1232    0.1034    0.0870;
               0.1162    0.0977    0.0878];
           
avg_full = [mean(full_path(:,1)) mean(full_path(:,2)) mean(full_path(:,3))]
avg_line = [mean(line_path(:,1)) mean(line_path(:,2)) mean(line_path(:,3))]
avg_spline = [mean(spline_path(:,1)) mean(spline_path(:,2)) mean(spline_path(:,3))]
avg_circle = [mean(circle_path(:,1)) mean(circle_path(:,2)) mean(circle_path(:,3))]

total_mean = [mean([avg_full(1) avg_line(1) avg_spline(1) avg_circle(1)]) ...
              mean([avg_full(2) avg_line(2) avg_spline(2) avg_circle(2)]) ...
              mean([avg_full(3) avg_line(3) avg_spline(3) avg_circle(3)])] 
 
mean_line = mean(avg_line)
mean_spline = mean(avg_spline)
mean_circle = mean(avg_circle)
mean_full = mean(avg_full)
          
subplot(2,2,1)
hold on
plot(line_path(:,1))
plot(line_path(:,2))
plot(line_path(:,3))
hold off
grid
legend('X','Y','Z','Location', 'best')
title('Line test case')

subplot(2,2,2)
hold on
plot(spline_path(:,1))
plot(spline_path(:,2))
plot(spline_path(:,3))
hold off
grid
legend('X','Y','Z','Location', 'best')
title('Spline test case')

subplot(2,2,3)
hold on
plot(circle_path(:,1))
plot(circle_path(:,2))
plot(circle_path(:,3))
hold off
grid
legend('X','Y','Z','Location', 'best')
title('Circle test case')

subplot(2,2,4)
hold on
plot(full_path(:,1))
plot(full_path(:,2))
plot(full_path(:,3))
hold off
grid
legend('X','Y','Z','Location', 'best')
title('Test case with all trajectories')