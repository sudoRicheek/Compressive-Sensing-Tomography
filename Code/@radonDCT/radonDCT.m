function  res = radonDCT(theta,size,bins,angles)

res.adjoint = 0;
res.theta = theta;
res.size = size;
res.bins = bins;
res.angles = angles;

% Register this variable as a radonDCT class
res = class(res,'radonDCT');