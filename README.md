# Industrial manipulator - MatLab Scripts
## Foreword
This is a repository that is a part of five that are meant to help in designing a six degree-of-freedom manipulator.
Repositories:

 1. Source Code Package
 2. 3D Model Spawner Package 
 3. **MatLab Scripts**
 4. Model of the arm
 5. User Interface in LabView

## Content 

In this repository there are a number of **MatLab** scripts that can be used in the design of a simple manipulator. It provides scripts that are able to generate trajectories and display then. Besides this, scripts that solve the Direct Kinematics and Inverse Kinematics are shown. 

The main scripts are as follows:

 - `interpolation_line.m` - will generate a line between two given poses, the pose should be expressed as a XYZ point and an orientation around all of the axis
 - `interpolation_cicle.m` - generates a circle trajectory that has a start and an end pose and passes through an intermediate point, the poses should be expressed in the same way as for the line interpolation
 - `interpolation_spline.m` - takes a series of poses and computes a smooth trajectory through all of those poses, the pose list should contain the position of the point and the orientation in Euler angels 

For each of the interpolations a joint evolution will be plotted in order see the non-linear nature of the some of articulation. 

All of the other scripts are used either to aid with the generation of the trajectories or to visualize the computed trajectories.

There are more details about each file inside then.

### Trajecories 
#### Line
<img src="https://github.com/mandarius-dev/arm_matlab_scripts/blob/main/media/line.png" width="500" >

#### Circle
<img src="https://github.com/mandarius-dev/arm_matlab_scripts/blob/main/media/circle.png" width="500" >

#### Spline
<img src="https://github.com/mandarius-dev/arm_matlab_scripts/blob/main/media/spline.png" width="500" >
