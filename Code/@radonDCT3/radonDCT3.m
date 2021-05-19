function  res = radonDCT3(theta1,theta2,theta3,size,bins,angles)

res.adjoint = 0;
res.theta1 = theta1;
res.theta2 = theta2;
res.theta3 = theta3;
res.size = size;
res.bins = bins;
res.angles = angles;

% Register this variable as a radonDCT class
res = class(res,'radonDCT3');